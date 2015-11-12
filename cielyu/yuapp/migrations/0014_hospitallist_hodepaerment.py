# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0013_remove_apptouser_num'),
    ]

    operations = [
        migrations.AddField(
            model_name='hospitallist',
            name='hodepaerment',
            field=models.CharField(max_length=30, null=True),
        ),
    ]
