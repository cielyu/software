# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0002_auto_20151015_1507'),
    ]

    operations = [
        migrations.AddField(
            model_name='appuser',
            name='isblack',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='usertodoctor',
            name='ugood',
            field=models.BooleanField(default=False),
        ),
    ]
