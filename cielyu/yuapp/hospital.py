# -*- coding:utf-8 -*-
__author__ = 'Administrator'
from models import Hospital, Apptouser, Doctor, Usertodoctor, Appuser
from django.http import HttpResponse, JsonResponse, HttpResponseRedirect
import datetime
from django.core import serializers
from django import template
from django.shortcuts import render_to_response


##########################################
#                                        #
#             注册医院资料               #
#                                        #
##########################################
def hregister(request):
    if request.method != 'POST':
        return render_to_response("cc.html")
    else:
    #name = request.POST.get("username")
    #pad = request.POST.get("password")
    #tel = request.POST.get("tel")
    #while not name.strip() and not pad.strip():
    #ac_list = Hospital.objects.all()
    #for ac in ac_list:
    #    if ac.hname == name:
    #        print name, pad, tel
    #        return JsonResponse({'status': 'failed'}, safe=False)
    #else:
        #ho = Hospital(hname=name, hpad=pad, htel=tel)
        #ho.save()
        return render_to_response("ccc.html")


##########################################
#                                        #
#             医院登陆                   #
#                                        #
##########################################
def hlogin(request):
    if request.method != 'POST':
        return render_to_response("c.html")
    else:
        name = request.POST.get("name")
        pad = request.POST.get("password")
        while not name.strip() and not pad.strip():
            ac_list = Hospital.objects.all()
            for ac in ac_list:
                if ac.hname == name and ac.hpad == pad:
                    return JsonResponse({'status': 'success'}, safe=False)
                else:
                    return JsonResponse({'status': 'failed'}, safe=False)
        else:
            return render_to_response("start.html")


##########################################
#                                        #
#             增加医生资料               #
#                                        #
##########################################
def adddoctor(request):
    name = request.POST.get("name")
    dh = request.POST.get("hospital")
    de = request.POST.get("department")
    while not name.strip() and not dh.strip() and not de.strip():
        d = Doctor(dname=name, hospital=dh, department=de)
        d.save()
        return JsonResponse({'status': 'success'}, safe=False)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


##########################################
#                                        #
#             增添可预约医生             #
#                                        #
##########################################
def want(request):
    name = request.POST.get("doctor")
    hospital = request.POST.get("hospital")
    department = request.POST.get("department")
    date = request.POST.get("date")
    period = request.POST.get("period")
    if name and date and period and hospital and department:
        ac_list = Doctor.objects.all()
        for ac in ac_list:
            if ac.dname == name and ac.hospital == hospital and ac.department == department:
                aa = Apptouser(docname=name, date=date, period=period, num=50,ahospital=hospital,adepartment=department)
                aa.save()
                return JsonResponse({'status': 'success'}, safe=False)
            else:
                return JsonResponse({'status': 'failed'}, safe=False)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


##########################################
#                                        #
#         查看医院资料                   #
#                                        #
##########################################
def hospitalcheck(request):
    hospital = request.POST.get("hospital")
    if hospital:
        aa = serializers.serialize("json", Usertodoctor.objects.filter(dhospital=hospital, date=datetime.date.today))
        return HttpResponse(aa)


##########################################
#                                        #
#             查看医生预约               #
#                                        #
##########################################
def doctorcheck(request):
    hospital = request.POST.get("hospital")
    name = request.POST.get("doctor")
    department = request.POST.get("department")
    if hospital and name and department:
        aa = serializers.serialize("json", Usertodoctor.objects.filter(dhospital=hospital,udname=name,date=datetime.date.today,ddepartment=department))
        return HttpResponse(aa)


##########################################
#                                        #
#         记录预约是否完成               #
#                                        #
##########################################
def badappointment(request):
    hospital = request.POST.get("hospital")
    department = request.POST.get("hospital")
    dname = request.POST.get("doctor")
    date = request.POST.get("date")
    period = request.POST.get("period")
    name = request.POST.get("username")
    aa = Usertodoctor.objects.get(username=name, udname=dname, dhospital=hospital, ddepartment=department, ddate=date, dperiod=period).update(ugood=False)
    aa.save()
    cc = Appuser.objects.get(uname=name)
    bc = cc.udate
    ab = Usertodoctor.objects.filter(username=name, ugood=False, date_range=(bc, datetime.datetime.now())).count()
    if ab >= 3:
        bb = Apptouser.objects.get(uname=name).update(isblack=True)
        bb.save()
    data = {'status': 'success'}
    return JsonResponse(data, safe=False)
