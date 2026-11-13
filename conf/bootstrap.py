import os

from django.conf import settings

# Admin errors would try to mail an unconfigured relay; the portal owner is notified out-of-band
settings.ADMINS = ()

from django.contrib.auth import get_user_model

from blogs.models import Stylesheet

# Blog.save() copies the 'default' stylesheet; upstream ships it only in the SaaS database
Stylesheet.objects.get_or_create(identifier="default", title="Default", css="")

email = os.environ["BB_ADMIN_EMAIL"].strip().lower()
password = os.environ.get("BB_ADMIN_PASSWORD", "")
User = get_user_model()
user = User.objects.filter(email__iexact=email).first()
if not user and password:
    user = User.objects.create_user(username=email, email=email, password=password)
    print(f"Created blog owner account: {email}")

if user:
    # Unlocks blog dashboards normally gated behind the SaaS paid plans
    user.settings.upgraded = True
    user.settings.save()
