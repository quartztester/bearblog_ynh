#!/bin/bash

# standalone CPython in $install_dir/python + .venv, rebuilt on install/upgrade/restore (Django 6 needs py>=3.12, bookworm has 3.11)
_build_runtime() {
    ynh_setup_source --dest_dir="$install_dir"
    ynh_setup_source --source_id=cpython --dest_dir="$install_dir"

    # relocated CPython hardcodes CC=clang — sdist builds die with it
    ynh_exec_as_app env CC=gcc HOME="$install_dir" \
        bash -c "'$install_dir'/python/bin/python3 -m venv '$install_dir'/.venv && '$install_dir'/.venv/bin/pip install --quiet --no-cache-dir -r '$install_dir'/requirements.txt"

    chown -R "$app:www-data" "$install_dir"
}

_render_config() {
    ynh_config_add --template=".env" --destination="$install_dir/.env"
    chmod 600 "$install_dir/.env"
    chown "$app:$app" "$install_dir/.env"
}

_run_manage() {
    ynh_exec_as_app bash -c "cd '$install_dir' && .venv/bin/python manage.py $*"
}

# blog owner; password 600 file in data_dir; idempotent
_bootstrap_data() {
    local creds="$data_dir/admin_credentials.txt"
    if [ ! -f "$creds" ]; then
        echo "$(ynh_string_random --length=24)" > "$creds"
    fi
    chmod 600 "$creds"
    chown "$app:$app" "$creds"

    _run_manage "migrate --noinput"
    _run_manage "collectstatic --noinput --clear"
    # ynh_exec_as_app sudo strips env — pass vars via env
    ynh_exec_as_app env \
        BB_ADMIN_EMAIL="$(ynh_user_get_info --username="$admin" --key=mail)" \
        BB_ADMIN_PASSWORD="$(cat "$creds")" \
        bash -c "cd '$install_dir' && .venv/bin/python manage.py shell" < "$YNH_APP_BASEDIR/conf/bootstrap.py"
}

# hostname blog routing needs wildcard server outside app snippet; TLS = main domain cert, see doc/ADMIN.md
_add_blogs_nginx() {
    ynh_config_add --template="nginx_blogs.conf" --destination="/etc/nginx/conf.d/$app-blogs.conf"
    ynh_systemctl --service=nginx --action=reload

    if ! openssl x509 -noout -text -in "/etc/yunohost/certs/$domain/crt.pem" | grep -q "\*\.$domain"; then
        ynh_print_warn "The certificate of $domain does not cover *.$domain - blog subdomains will trigger TLS warnings until a wildcard certificate is issued (see doc/ADMIN.md)"
    fi
}

_remove_blogs_nginx() {
    ynh_safe_rm "/etc/nginx/conf.d/$app-blogs.conf"
    ynh_systemctl --service=nginx --action=reload
}
