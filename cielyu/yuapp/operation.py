__author__ = 'Administrator'
from django.http import HttpResponse
from models import Appuser, Hospital, Apptouser, Doctor, Usertodoctor

#user's register and login
def register(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    tel = request.POST.get("tel")
    addr = request.POST.get("addr")
    user = Appuser(uname=name, upad=pad, uaddr=addr, utel=tel)
    user.save()
    return HttpResponse("register success.")


def login(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    ac_list = Appuser.objects.all()
    for ac in ac_list:
        if ac.uname == name and ac.upad == pad:
            return HttpResponse("login success.")
        else:
            return HttpResponse("user's name or password is wrong.")


#hospital's register and login
def hregister(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    tel = request.POST.get("tel")
    ho = Hospital(hname=name, hpad=pad, htel=tel)
    ho.save()
    return HttpResponse("hosptial register success.")


def hlogin(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    ac_list = Hospital.objects.all()
    for ac in ac_list:
        if ac.hname == name and ac.hpad == pad:
            return HttpResponse("login success.")
        else:
            return HttpResponse("hospital's name or password is wrong.")


def adddoctor(request):
    name = request.POST.get("name")
    dh = request.POST.get("hospital")
    de = request.POST.get("department")
    d = Doctor(dname=name, hospital=dh, department=de)
    d.save()
    return HttpResponse("add doctor success.")


def searchdoctor(request):
    name = request.POST.get("name", "")
    dhospital = request.POST.get("hospital", "")
    ddepartment = request.POST.get("department", "")
    ac_list = Doctor.objects.all()
    if dhospital and ddepartment:
        if not name:
            for ac in ac_list:
                if ac.hospital == dhospital and ac.department == ddepartment:
                    return HttpResponse(ac)
        else:
            for ac in ac_list:
                if ac.hospital == dhospital and ac.department == ddepartment and ac.dname == name:
                    return HttpResponse(ac)
    elif name:
        if not dhospital and not ddepartment:
            for ac in ac_list:
                if ac.dname == name:
                    return HttpResponse(ac)
    else:
        return HttpResponse("the doctor is not found.")


def appointment(request):
    dname = request.POST.get("dname")
    date = request.POST.get("date")
    period = request.POST.get("period")
    pass


def usercheck(request):
    pass


def hospitalcheck(request):
    pass

