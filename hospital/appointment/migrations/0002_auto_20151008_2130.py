# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('appointment', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='appuser',
            name='Unum',
            field=models.CharField(unique=True, max_length=30),
        ),
        migrations.AlterField(
            model_name='detail',
            name='num',
            field=models.CharField(unique=True, max_length=30),
        ),
        migrations.AlterField(
            model_name='doctor',
            name='Dnum',
            field=models.CharField(unique=True, max_length=30),
        ),
    ]
