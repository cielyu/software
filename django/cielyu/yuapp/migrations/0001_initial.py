# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Apptouser',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('docname', models.CharField(max_length=30)),
                ('date', models.DateField()),
                ('period', models.CharField(max_length=30)),
                ('num', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Appuser',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('uname', models.CharField(max_length=30)),
                ('upad', models.CharField(max_length=30)),
                ('uaddr', models.CharField(max_length=30)),
                ('utel', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Doctor',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('dname', models.CharField(max_length=30)),
                ('hospital', models.CharField(max_length=30)),
                ('department', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Hospital',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('hname', models.CharField(max_length=30)),
                ('hpad', models.CharField(max_length=30)),
                ('htel', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Usertodoctor',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('username', models.CharField(max_length=30)),
                ('udname', models.CharField(max_length=30)),
                ('ddate', models.DateField()),
                ('dperiod', models.CharField(max_length=30)),
            ],
        ),
    ]
