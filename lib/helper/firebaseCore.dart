import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as en;
import 'package:untitled2/helper/security.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';

class FirebaseT {
  static const _databaseURL = 'https://taegi-survey-default-rtdb.firebaseio.com';

  static dynamic getWindowsVersion() async {
    http.Response response = await http.get(Uri.parse("$_databaseURL/version/windows/current.json"),);
    Map<dynamic, dynamic> data = json.decode(response.body);
    return data['release'];
  }

  /// 건설 회사 목록 추가
  static dynamic pushArchitectureOffice(ArchitectureOffice data) async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.post(Uri.parse("$_databaseURL/template/architecture-office/list.json?auth=$idC"),
        body: json.encode(data.toJson()));
  }
  static dynamic getArchitectureOfficeAll() async {
    http.Response response = await http.get(Uri.parse("$_databaseURL/template/architecture-office/list.json"),);
    Map<dynamic, dynamic> list = json.decode(response.body);
    List<ArchitectureOffice> data = [];
    for(int i = 0; i < list.length; i++) {
      var tmp = list.values.elementAt(i);
      tmp['id'] = list.keys.elementAt(i);
      data.add(ArchitectureOffice.fromDatabase(tmp));
    }
    return data;
  }

  /// 암호화 키 추가
  static dynamic pushSecurityKey() async {
    await http.patch(Uri.parse("$_databaseURL/setting/securityKey.json"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    await http.post(Uri.parse("$_databaseURL/setting/securityKey/list.json"),
        body: json.encode({ 'key': 'J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y' }));
  }
  static dynamic getSecurityKey() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    http.Response response = await http.get(Uri.parse("$_databaseURL/setting/securityKey.json?auth=$idC"),);
    var j = json.decode(response.body);
    SecurityKeys data;
    data = SecurityKeys.fromDatabase(j);
    return data;
  }

  /// 실무자 추가
  static dynamic pushManager(Manager data) async {
    await http.patch(Uri.parse("$_databaseURL/manager.json"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    await http.post(Uri.parse("$_databaseURL/manager/list.json"),
        body: json.encode(data.toJson()));
  }
  static dynamic getManagerAll() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    http.Response response = await http.get(Uri.parse("$_databaseURL/manager/list.json?auth=$idC"),);
    Map<dynamic, dynamic> list = json.decode(response.body);
    List<Manager> data = [];
    for(int i = 0; i < list.length; i++) {
      var tmp = list.values.elementAt(i);
      tmp['id'] = list.keys.elementAt(i);
      data.add(Manager.fromDatabase(tmp));
    }
    return data;
  }
  static dynamic getManagerPassWord() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    var user = FirebaseAuth.instance.currentUser;
    print(user?.uid);
    http.Response response = await http.get(Uri.parse("$_databaseURL/managers/${user?.uid}.json?auth=$idC"),);
    Map<dynamic, dynamic> data = json.decode(response.body);
    return data['password'].toString();
  }
  static dynamic getManger() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    var user = FirebaseAuth.instance.currentUser;
    print(user?.uid);
    http.Response response = await http.get(Uri.parse("$_databaseURL/managers/${user?.uid}.json?auth=$idC"),);
    Map<dynamic, dynamic> data = json.decode(response.body);

    SystemT.currentManager = data;
    return data;
  }



  /// 허가 관리 목록 추가
  static dynamic pushPermitManagement(PermitManagement data) async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.post(Uri.parse("$_databaseURL/permit-management/list.json?auth=$idC"),
        body: json.encode(data.toJson()));
  }

  static dynamic pushPermitManagementWithAES(dynamic data) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);

    list.add('-NI4ujaycSizu0Tx5cYA');
    //var k = list.removeLast(); print(k);
    print(list.join());

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/permit-management.json?auth=$idC"),
        body: json.encode({
          'securityCount': { ".sv": {"increment": 1}}
        }));
    data.id = DateTime.now().microsecondsSinceEpoch.toString();
    print(data.id);
    await http.put(Uri.parse("$_databaseURL/permit-management/security/${data.id}.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic putPermitManagementWithAES(dynamic data, String id) async {
    if(SystemT.versionCheck() == false) return;

    var j = data.toJson();
    var jsonString = jsonEncode(j);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);

    list.add('-NI4ujaycSizu0Tx5cYA');
    //var k = list.removeLast(); print(k);
    print(list.join());
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/permit-management/security/$id.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic getPermitManagementAll_Security() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    http.Response response = await http.get(Uri.parse("$_databaseURL/permit-management/security.json?auth=$idC"),);
    Map<dynamic, dynamic> list = json.decode(response.body);
    List<PermitManagement> data = [];
    for(int i = 0; i < list.length; i++) {
      var tmp = list.values.elementAt(i);
      var tList = tmp['data'] as List ?? [];
      var sKey = tList.removeLast();

      var ssKey = SystemT.securityKeys.getKey(sKey);

      final key = en.Key.fromUtf8(ssKey);
      final iv1 = en.IV.fromLength(16);
      final encrypter = en.Encrypter(en.AES(key));
      var a = encrypter.decrypt64(tList.join(''), iv: iv1);

      var j = jsonDecode(a);
      j['id'] = list.keys.elementAt(i);

      data.add(PermitManagement.fromDatabase(j));
    }
    print('download server data - length: ${data.length}');

    var downloadLength = response.contentLength! * 50;
    await http.patch(Uri.parse("$_databaseURL/system/usage/${SystemT.getServerDateId()}.json"),
        body: json.encode({
          'download': { ".sv": {"increment": downloadLength}}
        }));
    return data.reversed.toList();
  }

  static dynamic pushContractWithAES(dynamic data) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/contract.json?auth=$idC"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    data.id = DateTime.now().microsecondsSinceEpoch.toString();
    await http.put(Uri.parse("$_databaseURL/contract/list/${data.id}.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic pushContractWithAESAndWm(dynamic data) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/contract.json?auth=$idC"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    data.id = DateTime.now().microsecondsSinceEpoch.toString();
    await http.put(Uri.parse("$_databaseURL/contract/list/${data.id}.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));


    var work = WorkManagement.fromDatabase({});
    var contract = Contract.fromDatabase(jsonDecode(jsonString));
    work.addresses = contract.addresses;
    work.clients = contract.clients;
    work.managerUid = contract.managerUid;
    work.useType = contract.useType;
    work.id =data.id;

    await pushWorkManagementWithAESID(work);
    SystemT.workManagements[work.id] = work;
  }
  static dynamic postContractWithAES(dynamic data, String id) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');

    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/contract/list/$id.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic getContractAll_Security() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    http.Response response = await http.get(Uri.parse("$_databaseURL/contract/list.json?auth=$idC"),);
    Map<dynamic, dynamic> list = json.decode(response.body);
    List<Contract> data = [];
    for(int i = 0; i < list.length; i++) {
      var tmp = list.values.elementAt(i);
      var tList = tmp['data'] as List ?? [];
      var sKey = tList.removeLast();

      var ssKey = SystemT.securityKeys.getKey(sKey);

      final key = en.Key.fromUtf8(ssKey);
      final iv1 = en.IV.fromLength(16);
      final encrypter = en.Encrypter(en.AES(key));
      var a = encrypter.decrypt64(tList.join(''), iv: iv1);

      var j = jsonDecode(a);
      j['id'] = list.keys.elementAt(i);

      data.add(Contract.fromDatabase(j));
    }
    print('download server data - length: ${data.length}');


    var downloadLength = response.contentLength! * 50;
    await http.patch(Uri.parse("$_databaseURL/system/usage/${SystemT.getServerDateId()}.json"),
        body: json.encode({
          'download': { ".sv": {"increment": downloadLength}}
        }));
    return data.reversed.toList();
  }

  static Future<int> getServerUsage() async {
    http.Response response = await http.get(Uri.parse("$_databaseURL/system/usage/${SystemT.getServerDateId()}.json"),);
    Map<dynamic, dynamic> data = json.decode(response.body);
    int download = data['download'] ?? 0;
    return download.toInt();
  }

  /// work
  static dynamic postWorkManagementWithAES(dynamic data, String id) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');

    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/work-management/list/$id.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
    SystemT.workManagements[data.id] = data;
  }
  static dynamic pushWorkManagementWithAES(dynamic data) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/work-management.json?auth=$idC"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    data.id = DateTime.now().microsecondsSinceEpoch.toString();
    await http.put(Uri.parse("$_databaseURL/work-management/list/${data.id}.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic pushWorkManagementWithAESID(dynamic data) async {
    if(SystemT.versionCheck() == false) return;

    var dataJson = data.toJson();
    var jsonString = jsonEncode(dataJson);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.patch(Uri.parse("$_databaseURL/work-management.json?auth=$idC"),
        body: json.encode({
          'count': { ".sv": {"increment": 1}}
        }));
    await http.put(Uri.parse("$_databaseURL/work-management/list/${data.id}.json?auth=$idC"),
        body: json.encode({ 'data': list as List, }));
  }
  static dynamic getWorkManagementAll_Security() async {
    var idC = await FirebaseAuth.instance.currentUser?.getIdToken();
    http.Response response = await http.get(Uri.parse("$_databaseURL/work-management/list.json?auth=$idC"),);
    List<WorkManagement> data = [];

    if(json.decode(response.body) == null) return data;

    Map<dynamic, dynamic> list = json.decode(response.body);
    for(int i = 0; i < list.length; i++) {
      var tmp = list.values.elementAt(i);
      var tList = tmp['data'] as List ?? [];
      var sKey = tList.removeLast();

      var ssKey = SystemT.securityKeys.getKey(sKey);

      final key = en.Key.fromUtf8(ssKey);
      final iv1 = en.IV.fromLength(16);
      final encrypter = en.Encrypter(en.AES(key));
      var a = encrypter.decrypt64(tList.join(''), iv: iv1);

      var j = jsonDecode(a);
      j['id'] = list.keys.elementAt(i);

      data.add(WorkManagement.fromDatabase(j));
    }
    print('download server data - length: ${data.length}');

    var downloadLength = response.contentLength! * 50;
    await http.patch(Uri.parse("$_databaseURL/system/usage/${SystemT.getServerDateId()}.json"),
        body: json.encode({
          'download': { ".sv": {"increment": downloadLength}}
        }));
    return data.reversed.toList();
  }



  static dynamic saveAllCtWithNAS(List<Contract> data, { String? id='2022_12' }) async {
    var jsonString = jsonEncode(data);
    print(jsonString);

    final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');


    var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
    var current = '';
    for(var c in security.characters) {
      current += c;
      length--;
      if(length <= 0) {
        length = 128;
        list.add(current);
        current = '';
      }
    }
    if(current != '')
      list.add(current);
    list.add('-NI4ujaycSizu0Tx5cYA');

    var a = File('${SystemT.serverPath}/contract/$id.tgs');
    await a.writeAsString('$security');
    var b = File('${SystemT.serverPath}/contract/${id}_o.json');
    await b.writeAsString('$jsonString');
  }
}

class FirebaseNTT {
  static const _databaseURL = 'https://taegi-survey-default-rtdb.firebaseio.com';

  static dynamic spacarniasdcweijncd() async {
    http.Response response = await http.get(Uri.parse("$_databaseURL/system/sc.json"),);
    var j = json.decode(response.body);
    return j;
  }
  static dynamic lccdskasdcawnfqlncljacd({String spascdnand='', String lcasodncjqwnls=''}) async {
    var a = lcasodncjqwnls!.split(spascdnand);
    return a;
  }
  static dynamic kyasdnvalksdnvknsvmmvav({List<dynamic>? lcdasoinkasdvnk, String kyasnvljnlasljdlnvkasd=''}) async {
    if(lcdasoinkasdvnk == null) return;

    final skey = en.Key.fromUtf8(lcdasoinkasdvnk.last);
    final siv = en.IV.fromLength(16);
    final sencrypter = en.Encrypter(en.AES(skey));
    var a = sencrypter.decrypt64(kyasnvljnlasljdlnvkasd + '', iv: siv);

    final skey2 = en.Key.fromUtf8(lcdasoinkasdvnk.first);
    final siv2 = en.IV.fromLength(16);
    final sencrypter2 = en.Encrypter(en.AES(skey2));
    var a2 = sencrypter2.decrypt64(a, iv: siv2);

    return json.decode(a2);
  }
  static dynamic orasklnasldvnlksanksadcjn({Map<dynamic, dynamic>? kyasvjsadnvlkn, String oranlsjdavbjasbdlknaskdc=''}) async {
    if(kyasvjsadnvlkn == null) return;

    final skey = en.Key.fromUtf8(kyasvjsadnvlkn['lock']);
    final siv = en.IV.fromLength(16);
    final sencrypter = en.Encrypter(en.AES(skey));
    var a = sencrypter.decrypt64(oranlsjdavbjasbdlknaskdc + '==', iv: siv);

    final skey2 = en.Key.fromUtf8(kyasvjsadnvlkn['key']);
    final siv2 = en.IV.fromLength(16);
    final sencrypter2 = en.Encrypter(en.AES(skey2));
    var a2 = sencrypter2.decrypt64(a, iv: siv2);

    return json.decode(a2);
  }
}

class FirebaseSSE {
  static const _databaseURL = 'https://taegi-survey-default-rtdb.firebaseio.com';
  static StreamSubscription<SSEModel>? subscribePmToSSE;
  static StreamSubscription<SSEModel>? subscribeWmToSSE;
  static StreamSubscription<SSEModel>? subscribeCtToSSE;

  static dynamic subscribePermitManagementSSE() async {
    try{
      var idC = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(subscribePmToSSE != null) {
        await subscribePmToSSE!.cancel();
        subscribePmToSSE = null;
        SSEClient.unsubscribeFromSSE();
      }

      subscribePmToSSE = await SSEClient.subscribeToSSE(
          url: '$_databaseURL/permit-management/security.json?auth=$idC',
          header: {
            "Cookie":
            'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
            'Content-Type': 'application/json',
          }).listen((event) {
        print('SSE.Event.PM: ' + event.event!);
        if(event.data != null) {
          if(event.event == 'keep-alive') return;

          var data = jsonDecode(event.data!);
          var path = data['path'].toString().replaceAll('/', '');
          if(path == '') {
            var dataMaps = data['data'] as Map;
            for(int i = 0; i < dataMaps.length; i++) {
              var d = dataMaps.values.elementAt(i);
              var k = dataMaps.keys.elementAt(i);

              var tList = d['data'] as List ?? [];
              var json = SecurityT.securityT(tList, k);
              SystemT.permitManagementMaps[k] = PermitManagement.fromDatabase(json);
            }
            print('sever sent event data length: ${dataMaps.length}');
          }
          else {
            var dataO = data['data'];
            var tList = dataO['data'] as List ?? [];
            var json = SecurityT.securityT(tList, path);
            SystemT.permitManagementMaps[path] = PermitManagement.fromDatabase(json);
            print('sever sent event data length: 1');
          }
          print('all PM data length: ${SystemT.permitManagementMaps.length}');
        }
      });
    } catch(e) {
      print(e);
    }
  }
  static dynamic subscribeWorkManagementSSE() async {
    try{
      var idC = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(subscribeWmToSSE != null) {
        await subscribeWmToSSE!.cancel();
        subscribeWmToSSE = null;
        SSEClient.unsubscribeFromSSE();
      }

      subscribeWmToSSE = await SSEClient.subscribeToSSE(
          url: '$_databaseURL/work-management/list.json?auth=$idC',
          header: {
            "Cookie":
            'jwt=eyJhbGciOiJIUzI1NiIInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZS6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
            'Content-Type': 'application/json',
          }).listen((event) {
        print('SSE.Event.WM: ' + event.event!);
        if(event.data != null) {
          if(event.event == 'keep-alive') return;

          var data = jsonDecode(event.data!);
          var path = data['path'].toString().replaceAll('/', '');

          if(path == '') {
            var dataMaps = data['data'] as Map;
            for(int i = 0; i < dataMaps.length; i++) {
              var d = dataMaps.values.elementAt(i);
              var k = dataMaps.keys.elementAt(i);

              var tList = d['data'] as List ?? [];
              var json = SecurityT.securityT(tList, k);
              SystemT.workManagements[k] = WorkManagement.fromDatabase(json);
            }
            print('sever sent event data length: ${dataMaps.length}');
          }
          else {
            var dataO = data['data'];
            var tList = dataO['data'] as List ?? [];
            var json = SecurityT.securityT(tList, path);
            SystemT.workManagements[path] = WorkManagement.fromDatabase(json);
            print('sever sent event data length: 1');
          }
          print('all WM data length: ${SystemT.workManagements.length}');
        }
      });
    } catch(e) {
      print(e);
    }
  }
  static dynamic subscribeContractSSE() async {
    try{
      var idC = await FirebaseAuth.instance.currentUser?.getIdToken();

      if(subscribeCtToSSE != null) {
        await subscribeCtToSSE!.cancel();
        subscribeCtToSSE = null;
        SSEClient.unsubscribeFromSSE();
      }

      subscribeCtToSSE = await SSEClient.subscribeToSSE(
          url: '$_databaseURL/contract/list.json?auth=$idC',
          header: {
            "Cookie":
            'jwt=eyJhbGciOiJIUzI1NiIsIR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6nRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
            'Content-Type': 'application/json',
          }).listen((event) {
        print('SSE.Event.Ct: ' +  event.event!);
        if(event.data != null) {
          if(event.event == 'keep-alive') return;

          var data = jsonDecode(event.data!);
          var path = data['path'].toString().replaceAll('/', '');
          if(path == '') {
            var dataMaps = data['data'] as Map;
            for(int i = 0; i < dataMaps.length; i++) {
              var d = dataMaps.values.elementAt(i);
              var k = dataMaps.keys.elementAt(i);

              var tList = d['data'] as List ?? [];
              var json = SecurityT.securityT(tList, k);
              SystemT.contracts[k] = Contract.fromDatabase(json);
            }
            print('sever sent event data length: ${dataMaps.length}');
          }
          else {
            var dataO = data['data'];
            if(dataO == null) {
              SystemT.contracts.remove(path);
              print('SSE.Data.Ct: Delete');
            }
            else {
              var tList = dataO['data'] as List ?? [];
              var json = SecurityT.securityT(tList, path);
              SystemT.contracts[path] = Contract.fromDatabase(json);
              print('sever sent event data length: 1');
            }
          }
          print('all PM data length: ${SystemT.contracts.length}');
        }
      });
    } catch(e) {
      print(e);
    }
  }
}