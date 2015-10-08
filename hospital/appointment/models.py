from django.db import models
# Create your models here.


class AppUser(models.Model):
    Uname = models.CharField(max_length=30)
    Utel = models.CharField(max_length=30)
    Uaddress = models.CharField(max_length=30)

    def __unicode__(self):
        return self.Uname


class Doctor(models.Model):
    Dname = models.CharField(max_length=30)
    Dbelong = models.CharField(max_length=30)
    Ddepartment = models.CharField(max_length=30)

    def __unicode__(self):
        return self.Dname


class Detail(models.Model):
    Dname = models.ForeignKey(Doctor)
    date = models.DateField()
    period = models.CharField(max_length=30)
    people = models.CharField(max_length=30)


class DoctorToUser(models.Model):
    Anum = models.CharField(max_length=30)
    dname = models.CharField(max_length=30)
    date = models.DateField()
    period = models.CharField(max_length=30)
    pname = models.CharField(max_length=30)
