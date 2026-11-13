#!/bin/bash

# Standalone CPython runtime ($install_dir/python + .venv), rebuilt from requirements.txt on install/upgrade/restore (Django 6 needs Python >= 3.12, bookworm has 3.11).
_build_runtime() {
    ynh_setup_source --dest_dir="$install_dir"
    ynh_setup_source --source_id=cpython --dest_dir="$install_dir"

    # The relocated CPython build hardcodes CC=clang, which breaks any sdist build
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

# Blogs are routed by hostname, which needs a wildcard server block outside the app's nginx snippet.
_add_blogs_nginx() {
    ynh_config_add --template="nginx_blogs.conf" --destination="/etc/nginx/conf.d/$app-blogs.conf"
    ynh_systemctl --service=nginx --action=reload

    if ! openssl x509 -noout -text -in "/etc/yunohost/certs/$domain/crt.pem" | grep -q "\*\.$domain"; then
        ynh_print_warn "The certificate of $domain does not cover *.$domain - blog subdomains will trigger TLS warnings until a wildcard certificate is issued (see doc/ADMIN.md)"
    fi
}
