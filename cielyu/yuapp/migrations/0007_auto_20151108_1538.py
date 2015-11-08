# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0006_appuser_umail'),
    ]

    operations = [
        migrations.AlterField(
            model_name='usertodoctor',
            name='ddate',
            field=models.DateTimeField(),
        ),
    ]
