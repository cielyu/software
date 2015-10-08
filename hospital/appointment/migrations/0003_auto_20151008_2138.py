# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('appointment', '0002_auto_20151008_2130'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='appuser',
            name='Unum',
        ),
        migrations.RemoveField(
            model_name='detail',
            name='num',
        ),
        migrations.RemoveField(
            model_name='doctor',
            name='Dnum',
        ),
    ]
