__author__ = 'Administrator'
from models import Appuser, Apptouser, Doctor, Usertodoctor
from django.http import HttpResponse


def register(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    tel = request.POST.get("tel")
    addr = request.POST.get("addr")
    ac_list = Appuser.objects.all()
    for ac in ac_list:
        if ac.uname == name:
            return HttpResponse("the username is registered.")
        elif ac.utel == tel:
            return HttpResponse("the phone is registered.")
        else:
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
    username = request.POST.get("username")
    dname = request.POST.get("dname")
    date = request.POST.get("date")
    period = request.POST.get("period")
    hospital = request.POST.get("hospital")
    department = request.POST.get("department")
    if username and dname and date and period and hospital and department:
        aa = Apptouser.objects.get(docname=dname, date=date, period=period, ahospital=hospital, adepartment=department)
        aa.num -= 1
        aa.save()
        ab = Usertodoctor(username=username, udname=dname, ddate=date, dperiod=period, dhospital=hospital, ddepartment=department)
        ab.save()
        return HttpResponse("appointment success.")
    else:
        return HttpResponse("appoint failed.")


def usercheck(request):
    username = request.POST.get("username")
    if username:
        aa = Usertodoctor.objects.filter(username=username)
        return HttpResponse(aa)

