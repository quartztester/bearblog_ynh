import os

from django.conf import settings

# ADMINS mail an unconfigured relay -> errors crash; owner notified out-of-band
settings.ADMINS = ()

from django.contrib.auth import get_user_model

from blogs.models import Stylesheet

# Blog.save() copies 'default' stylesheet — upstream ships it only in the SaaS DB
Stylesheet.objects.get_or_create(identifier="default", title="Default", css="")

email = os.environ["BB_ADMIN_EMAIL"].strip().lower()
password = os.environ.get("BB_ADMIN_PASSWORD", "")
User = get_user_model()
user = User.objects.filter(email__iexact=email).first()
if not user and password:
    user = User.objects.create_user(username=email, email=email, password=password)
    print(f"Created blog owner account: {email}")

if user:
    # unlocks dashboards gated behind SaaS paid plans
    user.settings.upgraded = True
    user.settings.save()
