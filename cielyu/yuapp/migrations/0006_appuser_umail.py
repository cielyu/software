# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0005_hospitallist'),
    ]

    operations = [
        migrations.AddField(
            model_name='appuser',
            name='umail',
            field=models.CharField(max_length=30, null=True),
        ),
    ]
