# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0004_auto_20151101_1959'),
    ]

    operations = [
        migrations.CreateModel(
            name='Hospitallist',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('honame', models.CharField(max_length=30)),
            ],
        ),
    ]
