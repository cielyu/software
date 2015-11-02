"""cielyu URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.8/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Add an import:  from blog import urls as blog_urls
    2. Add a URL to urlpatterns:  url(r'^blog/', include(blog_urls))
"""
from django.conf.urls import include, url
from django.contrib import admin
from yuapp.user import login, register, searchdoctor, usercheck, appointment, getlist, getdepartment
from yuapp.hospital import hlogin, hregister, adddoctor, want, doctorcheck, hospitalcheck


urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
    url(r'^login/', login),
    url(r'^register/$', register),
    url(r'^searchdoctor/$', searchdoctor),
    url(r'^usercheck/$', usercheck),
    url(r'^appointment/$', appointment),
    url(r'^hlogin/$', hlogin),
    url(r'^hregister/$', hregister),
    url(r'^adddoctor/$', adddoctor),
    url(r'^want/$', want),
    url(r'^hospitalcheck/$', hospitalcheck),
    url(r'^doctorcheck/$', doctorcheck),
    url(r'^getlist/$', getlist),
    url(r'^getdepartment/$', getdepartment),
]
