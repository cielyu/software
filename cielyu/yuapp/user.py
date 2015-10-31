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
    return JsonResponse({'status': 'success'}, safe=False)


def login(request):
    print "ok"
    if request.method != 'POST':
        print "not post"
        return HttpResponse("get")
    else:
        print "post"
        name = request.POST.get("name")
        print name
        pad = request.POST.get("password")
        print pad
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
    name = request.POST.get("doctorname", "")
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


