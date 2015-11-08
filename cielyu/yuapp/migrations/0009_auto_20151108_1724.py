# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0008_auto_20151108_1705'),
    ]

    operations = [
        migrations.AlterField(
            model_name='apptouser',
            name='date',
            field=models.DateTimeField(),
        ),
    ]
