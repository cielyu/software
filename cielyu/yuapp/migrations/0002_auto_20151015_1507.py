# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='apptouser',
            name='adepartment',
            field=models.CharField(max_length=30, null=True),
        ),
        migrations.AddField(
            model_name='apptouser',
            name='ahospital',
            field=models.CharField(max_length=30, null=True),
        ),
        migrations.AddField(
            model_name='usertodoctor',
            name='ddepartment',
            field=models.CharField(max_length=30, null=True),
        ),
        migrations.AddField(
            model_name='usertodoctor',
            name='dhospital',
            field=models.CharField(max_length=30, null=True),
        ),
    ]
