__author__ = 'Administrator'
#coding: utf-8
import smtplib
from email.mime.text import MIMEText
from email.header import Header
from models import Appuser
from django.http import JsonResponse


def getpad(request):
    name = request.POST.get("username")
    msg = MIMEText(_text='SMTP test', _charset='utf-8')
    from_addr = '1034019196@qq.com'
    password = 'yujianshen!'
    smtp_server = 'smtp.qq.com'
    to_addr = Appuser.objects.get(uname=name).umail

    server = smtplib.SMTP(smtp_server, 25)
    server.set_debuglevel(1)
    server.login(from_addr, password)
    server.sendmail(from_addr, to_addr, msg.as_string())
    server.quit()
    data = {'status': 'success'}
    return JsonResponse(data, safe=False)