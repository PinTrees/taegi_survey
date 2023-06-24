import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemControl.dart';

class AligoAPI {
  static dynamic sendMessage() async {
    var url = 'https://apis.aligo.in/send/';
    var qr = {
      'key': SystemT.settingS.aligoAPIKey,
      'user_id': 'byon369',
      'sender': '01082993944',
      'receiver': '01052906121',
      'msg': '안녕하세요. 알리고 문자 연동 테스트 발신입니다. API TEST SEND',
      'title': 'API TEST 입니다',
      'testmode_yn': 'Y',
    };
    try {
      http.Response r = await http.post(Uri.parse(url + ''), headers: {
        "accept": "application/json",
      }, body: qr, );
      print(r.statusCode);
      print(r.headers);
      print(r.body);
      var rr = jsonDecode(r.body);
      print(rr);

      if(rr['result_code'] == '1')
        return true;
      else return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
  static dynamic getMessageCount() async {
    var url = 'https://apis.aligo.in/remain:443/';
    var qr = {
      'key': SystemT.settingS.aligoAPIKey,
      'user_id': 'byon369',
    };
    try {
      http.Response r = await http.post(Uri.parse(url + ''), headers: {
        "accept": "application/json",
      }, body: qr, );
      print(r.statusCode);
      print(r.headers);
      //print(r.body);
      var rr = jsonDecode(r.body);
      print(rr);
    } catch (e) {
      print(e);
    }
  }
}
