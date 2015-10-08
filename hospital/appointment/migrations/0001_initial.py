# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='AppUser',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('Unum', models.CharField(max_length=30)),
                ('Uname', models.CharField(max_length=30)),
                ('Utel', models.CharField(max_length=30)),
                ('Uaddress', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Detail',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('num', models.CharField(max_length=30)),
                ('date', models.DateField()),
                ('period', models.CharField(max_length=30)),
                ('people', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Doctor',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('Dnum', models.CharField(max_length=30)),
                ('Dname', models.CharField(max_length=30)),
                ('Dbelong', models.CharField(max_length=30)),
                ('Ddepartment', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='DoctorToUser',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, auto_created=True, primary_key=True)),
                ('Anum', models.CharField(max_length=30)),
                ('dname', models.CharField(max_length=30)),
                ('date', models.DateField()),
                ('period', models.CharField(max_length=30)),
                ('pname', models.CharField(max_length=30)),
            ],
        ),
        migrations.AddField(
            model_name='detail',
            name='Dname',
            field=models.ForeignKey(to='appointment.Doctor'),
        ),
    ]
