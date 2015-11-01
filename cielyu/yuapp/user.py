__author__ = 'Administrator'
from models import Appuser, Apptouser, Doctor, Usertodoctor
from django.http import HttpResponse, JsonResponse
from django.core import serializers
import datetime


def register(request):
    name = request.POST.get("name")
    pad = request.POST.get("password")
    tel = request.POST.get("tel")
    addr = request.POST.get("addr")
    ac_list = Appuser.objects.all()
    for ac in ac_list:
        if ac.uname == name or ac.utel == tel:
            return JsonResponse({'status': 'failed'}, safe=False)
    user = Appuser(uname=name, upad=pad, uaddr=addr, utel=tel)
    user.save()
    for ac in ac_list:
        if ac.uname == name and ac.utel == tel and ac.upad == pad and ac.uaddr == addr:
            return JsonResponse({'status': 'success'}, safe=False)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


def login(request):
    if request.method != 'POST':
        return HttpResponse("get")
    else:
        name = request.POST.get("name")
        pad = request.POST.get("password")
        ac_list = Appuser.objects.all()
        for ac in ac_list:
            if ac.uname == name and ac.upad == pad:
                cc = Appuser.objects.get(uname=name, upad=pad)
                if cc.isblack is True:
                    if datetime.datetime.now()-cc.udate > 7:
                        cc.isblack = False
                        cc.save()
                    else:
                        data = {'status': 'success', 'black': 'True'}
                        return JsonResponse(data, safe=False)
                else:
                    data = {'status': 'success', 'black ': 'False'}
                    return JsonResponse(data, safe=False)
        data = {'status': 'failed'}
        return JsonResponse(data, safe=False)


def searchdoctor(request):
    dhospital = request.POST.get("hospital", "")
    ddepartment = request.POST.get("department", "")
    if dhospital and ddepartment:
        aa = serializers.serialize("json", Doctor.objects.filter(hospital=dhospital, department=ddepartment))
        return HttpResponse(aa)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


def appointment(request):
    username = request.POST.get("username")
    dname = request.POST.get("doctorname")
    date = request.POST.get("date")
    period = request.POST.get("period")
    hospital = request.POST.get("hospital")
    department = request.POST.get("department")
    if username and dname and date and period and hospital and department:
        ac = Appuser.objects.get(uname=username)
        if ac.isblack is False:
            aa = Apptouser.objects.get(docname=dname, date=date, period=period, ahospital=hospital, adepartment=department)
            aa.num -= 1
            aa.save()
            ab = Usertodoctor(username=username, udname=dname, ddate=date, dperiod=period, dhospital=hospital, ddepartment=department)
            ab.save()
            return JsonResponse({'status': 'success'}, safe=False)
        else:
            return JsonResponse({'status': 'failed'}, safe=False)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


def usercheck(request):
    username = request.POST.get("username")
    if username:
        aa = serializers.serialize("json", Usertodoctor.objects.filter(username=username))
        return HttpResponse(aa)


def document(request):
    name = request.POST.get("username")
    pad = request.POST.get("password")
    if name and pad:
        aa = Appuser.objects.get(uname=name, upad=pad)
        ab = aa.toJSON()
        return HttpResponse(ab)
    else:
        data = {'status': 'failed'}
        return JsonResponse(data, safe=False)


def revise(request):
    name = request.POST.get("username")
    pad = request.POST.get("password")
    tel = request.POST.get("tel")
    addr = request.POST.get("addr")
    nname = request.POST.get("newname")
    npad = request.POST.get("newpad")
    ntel = request.POST.get("newtel")
    naddr = request.POST.get("newaddr")
    aa = Appuser.objects.get(uname=name, upad=pad, utel=tel, uaddr=addr).update(uname=nname, upad=npad, utel=ntel, uaddr=naddr)
    aa.save()
    return JsonResponse({'status': 'success'}, safe=False)
