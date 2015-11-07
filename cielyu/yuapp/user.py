# -*- coding:utf-8 -*-
__author__ = 'Administrator'
from models import Appuser, Apptouser, Doctor, Usertodoctor, Hospital, Hospitallist
from django.http import HttpResponse, JsonResponse
from django.core import serializers
import datetime
from django.shortcuts import render_to_response
from django.contrib import sessions
##########################################
#                                        #
#    the file is for user                #
#                                        #
##########################################


##########################################
#                                        #
#             注册                       #
#                                        #
##########################################
def register(request):
    if request.method != 'POST':
        return JsonResponse(data={'status': 'failed'}, safe=False)
    else:
        name = request.POST.get("name")
        pad = request.POST.get("password")
        tel = request.POST.get("tel")
        addr = request.POST.get("addr")
        mail = request.POST.get("mail")
        ac_list = Appuser.objects.all()
        for ac in ac_list:
            if ac.uname == name or ac.utel == tel:
                return JsonResponse({'status': 'failed'}, safe=False)
        user = Appuser(uname=name, upad=pad, uaddr=addr, utel=tel, isblack=False, udate=datetime.datetime.now(), umail=mail)
        user.save()
        return JsonResponse({'status': 'success'}, safe=False)


##########################################
#                                        #
#             登陆                       #
#                                        #
##########################################
def login(request):
    if request.method != 'POST':
        return JsonResponse(data={'status': 'failed'}, safe=False)
    else:
        name = request.POST.get("name")
        pad = request.POST.get("password")
        ac_list = Appuser.objects.all()
        for ac in ac_list:
            if ac.uname == name and ac.upad == pad:
                cc = Appuser.objects.get(uname=name, upad=pad)
                if cc.isblack == '1':
                    if (datetime.datetime.now()-cc.udate).days >= 7:
                        cc = Appuser(uname=name, upad=pad).update(isblack='0')
                        cc.save()
                        data = {'status': 'success', 'black ': 'False'}
                        return JsonResponse(data, safe=False)
                    else:
                        aa = (datetime.datetime.now()-cc.udate).days
                        ab = str(aa)
                        data = {'status': 'success', 'black': 'True', 'day': ab}
                        return JsonResponse(data, safe=False)
                else:
                    data = {'status': 'success', 'black ': 'False'}
                    return JsonResponse(data, safe=False)
        data = {'status': 'failed'}
        return JsonResponse(data, safe=False)


##########################################
#                                        #
#             查看个人资料               #
#                                        #
##########################################
def checkdata(request):
    if request.method != 'POST':
        return JsonResponse(data={'status': 'failed'}, safe=False)
    else:
        username = request.POST.get("username")
        password = request.POST.get("password")
        aa = Appuser.objects.get(uname=username, upad=password)
        data = {'name': aa.uname, 'pad': aa.upad, 'tel': aa.utel, 'address': aa.uaddr}
        return JsonResponse(data, safe=False)


##########################################
#                                        #
#             修改个人资料               #
#                                        #
##########################################
def modify(request):
    if request.method != 'POST':
        return JsonResponse(data={'status': 'failed'}, safe=False)
    else:
        username = request.POST.get("username")
        password = request.POST.get("password")
        newpad = request.POST.get("newpassword")
        newtel = request.POST.get("newnumber")
        newaddr = request.POST.get("newaddress")
        aa = Appuser.objects.get(uname=username, upad=password)
        if newpad:
            aa.upad = newpad
            aa.save()
        if newtel:
            aa.utel = newtel
            aa.save()
        if newaddr:
            aa.uaddr = newaddr
            aa.save()
        data = {'status': 'success'}
        return JsonResponse(data, safe=False)


##########################################
#                                        #
#      查看医院该部门有什么医生          #
#                                        #
##########################################
def searchdoctor(request):
    dhospital = request.POST.get("hospital", "")
    ddepartment = request.POST.get("department", "")
    if dhospital and ddepartment:
        #aa = serializers.serialize("json", Doctor.objects.filter(hospital=dhospital, department=ddepartment))
        # HttpResponse(aa)
        aa = []
        bb = Doctor.objects.filter(hospital=dhospital, department=ddepartment)
        for b in bb:
            aa.append(b.dname)
            return JsonResponse(aa, safe=False)
    else:
        return JsonResponse({'status': 'failed'}, safe=False)


##########################################
#                                        #
#             进行预约医生操作           #
#                                        #
##########################################
def appointment(request):
    username = request.POST.get("username")
    dname = request.POST.get("doctorname")
    date = request.POST.get("date")
    period = request.POST.get("period")
    hospital = request.POST.get("hospital")
    department = request.POST.get("department")
    if username and dname and date and period and hospital and department:
        ac = Appuser.objects.get(uname=username)
        if ac.isblack == '0':
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


##########################################
#                                        #
#             查看预约状况               #
#                                        #
##########################################
def usercheck(request):
    username = request.POST.get("username")
    if username:
        aa = serializers.serialize("json", Usertodoctor.objects.filter(username=username))
        return HttpResponse(aa)


#def document(request):
#    name = request.POST.get("username")
#    pad = request.POST.get("password")
#    if name and pad:
#        aa = Appuser.objects.get(uname=name, upad=pad)
#        ab = aa.toJSON()
#        return HttpResponse(ab)
#    else:
#        data = {'status': 'failed'}
#        return JsonResponse(data, safe=False)


#def revise(request):
#    name = request.POST.get("username")
#    pad = request.POST.get("password")
#    tel = request.POST.get("tel")
#    addr = request.POST.get("addr")
#    nname = request.POST.get("newname")
#    npad = request.POST.get("newpad")
#    ntel = request.POST.get("newtel")
#    naddr = request.POST.get("newaddr")
#    aa = Appuser.objects.get(uname=name, upad=pad, utel=tel, uaddr=addr).update(uname=nname, upad=npad, utel=ntel, uaddr=naddr)
#    aa.save()
#    return JsonResponse({'status': 'success'}, safe=False)

##########################################
#                                        #
#             查看医院                   #
#                                        #
##########################################
def getlist(request):
    #aa = serializers.serialize("json", Hospitallist.objects.all())
    aa = []
    bb = Hospital.objects.all()
    for b in bb:
       # map(lambda x: aa.setdefault(b.hname), b.hname)
        aa.append(b.hname)
    return JsonResponse(aa, safe=False)


##########################################
#                                        #
#         查看医院部门资料               #
#                                        #
##########################################
def getdepartment(request):
    name = request.POST.get("hospital")
    aa = []
    bb = Doctor.objects.filter(hospital=name)
    for b in bb:
        #map(lambda x: aa.setdefault(b.department), b.department)
        aa.append(b.department)
    return JsonResponse(aa, safe=False)


