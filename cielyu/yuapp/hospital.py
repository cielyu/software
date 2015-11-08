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
        name = request.POST.get("username")
        pad = request.POST.get("password")
        tel = request.POST.get("tel")
        ac_list = Hospital.objects.all()
        for ac in ac_list:
            if ac.hname == name:
                print name, pad, tel
                return render_to_response("cc.html")
        else:
            ho = Hospital(hname=name, hpad=pad, htel=tel)
            ho.save()
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
        name = request.POST.get("username")
        pad = request.POST.get("password")
        ac_list = Hospital.objects.all()
        for ac in ac_list:
            if ac.hname == name and ac.hpad == pad:
                print "a"
                return render_to_response("base.html")
        else:
            print "c"
            return render_to_response("c.html")


##########################################
#                                        #
#             增加医生资料               #
#                                        #
##########################################
def adddoctor(request):
    if request.method != 'POST':
        return render_to_response("adddoctor-1.html")
    else:
        name = request.POST.get("doctor")
        dh = request.POST.get("hospital")
        de = request.POST.get("department")
        aa_list = Doctor.objects.filter(hospital=dh, department=de)
        for aa in aa_list:
            if aa.dname == name:
                print 1
                return render_to_response("adddoctor-3.html")
        else:
            print 2
            d = Doctor(dname=name, hospital=dh, department=de)
            d.save()
            return render_to_response("adddcotor-2.html")



##########################################
#                                        #
#             增添可预约医生             #
#                                        #
##########################################
def want(request):
    if request.method != 'POST':
        return render_to_response("want.html")
    else:
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
                    return render_to_response("wantget.html")
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
    if request.method != 'POST':
        return render_to_response("department.html")
    else:
        hospital = request.POST.get("hospital")
        bb_list = Doctor.objects.filter(hospital=hospital)
        fp = open(r'E:\sever\software\cielyu\templates\department-1.html', 'r')
        t = template.Template(fp.read())
        html = t.render(template.Context({'bb_list': bb_list}))
        return HttpResponse(html)


##########################################
#                                        #
#             查看医生资料               #
#                                        #
##########################################
def hdoctor(request):
    hospital = request.POST.get("hospital")
    department = request.POST.get("department")
    aa_list = Doctor.objects.filter(hospital=hospital, department=department)
    fp = open(r'E:\sever\software\cielyu\templates\doctor.html', 'r')
    t = template.Template(fp.read())
    html = t.render(template.Context({'aa_list': aa_list}))
    return HttpResponse(html)


##########################################
#                                        #
#             查看医生预约               #
#                                        #
##########################################
def doctorcheck(request):
    if request.method != 'POST':
        return render_to_response("base.html")
    else:
        hospital = request.POST.get("hospital")
        department = request.POST.get("department")
        aa_list = Usertodoctor.objects.filter(dhospital=hospital, ddepartment=department)
        return render_to_response("check.html", aa_list)


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


def index(request):
    if request.method != 'POST':
        return render_to_response("base.html")
    else:
        return render_to_response("c.html")


def indexx(request):
    if request.method != 'POST':
        return render_to_response("want.html")
    else:
        pass


def adddepartment(request):
    if request.method != 'POST':
        return render_to_response("base.html")
    else:
        pass