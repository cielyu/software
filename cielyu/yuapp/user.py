__author__ = 'Administrator'
from models import Appuser, Apptouser, Doctor, Usertodoctor
from django.http import HttpResponse, JsonResponse
from django.core import serializers


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
    #print "ok"
    if request.method != 'POST':
        #print "not post"
        return HttpResponse("get")
    else:
        #print "post"
        name = request.POST.get("name")
        #print name
        pad = request.POST.get("password")
        #print pad
        ac_list = Appuser.objects.all()
        for ac in ac_list:
            if ac.uname == name and ac.upad == pad:
                data = {'status': 'success'}
                return JsonResponse(data, safe=False)
        data = {'status': 'failed'}
        #return HttpResponse(json.dumps(data), content_type="application/json")
        #return HttpResponse("user's name or password is wrong.")
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
        aa = Apptouser.objects.get(docname=dname, date=date, period=period, ahospital=hospital, adepartment=department)
        aa.num -= 1
        aa.save()
        ab = Usertodoctor(username=username, udname=dname, ddate=date, dperiod=period, dhospital=hospital, ddepartment=department)
        ab.save()
        return JsonResponse({'status': 'success'}, safe=False)
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
    return JsonResponse({'status': 'success'}, safe=False)
