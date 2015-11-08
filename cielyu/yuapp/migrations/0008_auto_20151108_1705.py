# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0007_auto_20151108_1538'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='apptouser',
            name='period',
        ),
        migrations.RemoveField(
            model_name='usertodoctor',
            name='dperiod',
        ),
    ]
