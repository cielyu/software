# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0010_auto_20151108_1821'),
    ]

    operations = [
        migrations.AlterField(
            model_name='apptouser',
            name='date',
            field=models.FloatField(max_length=30),
        ),
        migrations.AlterField(
            model_name='usertodoctor',
            name='ddate',
            field=models.FloatField(max_length=30),
        ),
    ]
