from django.db import models

# Create your models here.


class Appuser(models.Model):
    uname = models.CharField(max_length=30)
    upad = models.CharField(max_length=30)
    uaddr = models.CharField(max_length=30)
    utel = models.CharField(max_length=30)

    def __unicode__(self):
        return self.uname


class Hospital(models.Model):
    hname = models.CharField(max_length=30)
    hpad = models.CharField(max_length=30)
    htel = models.CharField(max_length=30)

    def __unicode__(self):
        return self.hname


class Doctor(models.Model):
    dname = models.CharField(max_length=30)
    hospital = models.CharField(max_length=30)
    department = models.CharField(max_length=30)

    def __unicode__(self):
        return self.dname


class Apptouser(models.Model):
    docname = models.CharField(max_length=30)
    date = models.DateField()
    period = models.CharField(max_length=30)
    num = models.CharField(max_length=30)

    def __unicode__(self):
        return self.docname


class Usertodoctor(models.Model):
    username = models.CharField(max_length=30)
    udname = models.CharField(max_length=30)
    ddate = models.DateField()
    dperiod = models.CharField(max_length=30)

    def __unicode__(self):
        return self.username
