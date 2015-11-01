from django.db import models
import json
# Create your models here.


class Appuser(models.Model):
    uname = models.CharField(max_length=30)
    upad = models.CharField(max_length=30)
    uaddr = models.CharField(max_length=30)
    utel = models.CharField(max_length=30)
    isblack = models.BooleanField(default=False)
    udate = models.DateTimeField(null=True, auto_now=True)

    def __unicode__(self):
        return self.uname

    def toJSON(self):
        return json.dumps(dict([(attr, getattr(self, attr))for attr in [f.name for f in self._meta.fields]]))


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

    def toJSON(self):
        return json.dumps(dict([(attr, getattr(self, attr))for attr in [f.name for f in self._meta.fields]]))


class Apptouser(models.Model):
    docname = models.CharField(max_length=30)
    date = models.DateField()
    period = models.CharField(max_length=30)
    num = models.CharField(max_length=30)
    ahospital = models.CharField(null=True, max_length=30)
    adepartment = models.CharField(null=True, max_length=30)

    def __unicode__(self):
        return self.docname

    def toJSON(self):
        return json.dumps(dict([(attr, getattr(self, attr))for attr in [f.name for f in self._meta.fields]]))


class Usertodoctor(models.Model):
    username = models.CharField(max_length=30)
    udname = models.CharField(max_length=30)
    ddate = models.DateField()
    dperiod = models.CharField(max_length=30)
    dhospital = models.CharField(null=True, max_length=30)
    ddepartment = models.CharField(null=True, max_length=30)
    ugood = models.BooleanField(default=True)

    def __unicode__(self):
        return self.username

    def toJSON(self):
        return json.dumps(dict([(attr, getattr(self, attr))for attr in [f.name for f in self._meta.fields]]))


class Hospitallist(models.Model):
    honame = models.CharField(max_length=30)

    def __unicode__(self):
        return self.honame

    def toJSON(self):
        return json.dumps(dict([(attr, getattr(self, attr))for attr in [f.name for f in self._meta.fields]]))
