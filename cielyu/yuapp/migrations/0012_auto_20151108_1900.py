# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0011_auto_20151108_1844'),
    ]

    operations = [
        migrations.AlterField(
            model_name='hospital',
            name='hname',
            field=models.TextField(max_length=30),
        ),
    ]
