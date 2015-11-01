# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0003_auto_20151101_1427'),
    ]

    operations = [
        migrations.AddField(
            model_name='appuser',
            name='udate',
            field=models.DateTimeField(auto_now=True, null=True),
        ),
        migrations.AlterField(
            model_name='usertodoctor',
            name='ugood',
            field=models.BooleanField(default=True),
        ),
    ]
