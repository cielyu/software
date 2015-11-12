# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('yuapp', '0014_hospitallist_hodepaerment'),
    ]

    operations = [
        migrations.RenameField(
            model_name='hospitallist',
            old_name='hodepaerment',
            new_name='hodepartment',
        ),
    ]
