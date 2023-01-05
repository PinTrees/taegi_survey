import 'package:encrypt/encrypt.dart' as en;
import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';

import 'helper/style.dart';

class SystemUploadPage extends StatefulWidget {
  const SystemUploadPage();
  @override
  State<SystemUploadPage> createState() => _SystemUploadPageState();
}
class _SystemUploadPageState extends State<SystemUploadPage> {
  var verticalScroll = new ScrollController();
  var horizontalScroll = new ScrollController();

  ScrollController scrollController = new ScrollController();
  late List<List<dynamic>> data;

  void initState() {
    super.initState();
    initAsync();
  }
  void initAsync() async {
    data = await SystemT.readCSV(context);
    setState(() {});

    //print(data.toString());

    print (data.first.length);

    var list = [];
    for(int i = 0; i < data.length; i++) {
      var csvRow = data[i];
      var json = {};

      json['managerUid'] = SystemT.getManagerKey(csvRow[3].toString().trim());
      json['address'] = csvRow[6].toString().trim();
      json['clientName'] = csvRow[4].toString().trim();
      json['clientPhoneNumber'] = csvRow[5].toString().trim();
      json['clients'] = [{
        'name': json['clientName'],
        'phoneNumber': json['clientPhoneNumber'],
      }];

      json['architectureOffice'] = csvRow[12].toString().trim();
      json['useType'] = csvRow[7].toString().split('\n');

      var area = [];
      for(var a in csvRow[8].toString().split('\n')) {
        var type = a.split(':').first.trim();
        var areaTmp = a.split(':').last.replaceAll('㎡', '').trim();
        var tmp = {'type': type, 'area': areaTmp,};
        area.add(tmp);
      }
      json['area'] = area;

      var permitAts = [];
      for(var a in csvRow[9].toString().split('\n')) {
        var type = a.split(':').first.trim();
        var date = a.split(':').last.replaceAll(' ', '').trim();
        var tmp = {'type': type, 'date': date,};
        permitAts.add(tmp);
      }
      json['permitAts'] = permitAts;
      json['permitAt'] = permitAts.first['date'];

      var endAts = [];
      for(var a in csvRow[10].toString().split('\n')) {
        var type = a.split(':').first.trim();
        var date = a.split(':').last.replaceAll(' ', '').trim();
        var tmp = {'type': type, 'date': date,};
        endAts.add(tmp);
      }
      json['endAts'] = endAts;

      json['addresses'] = [ json['address'] ];
      json['permitType'] = csvRow[11].toString().trim();
      json['desc'] =  (csvRow[13].toString().replaceAll('-', '').trim() + '\n\n' + csvRow[14].toString().trim()).trim();

      list.add(json);
    }
    //print(list.toString());

    List<PermitManagement> permit = [];
    for(var t in list) {
      permit.add(PermitManagement.fromDatabase(t));
    }
    for(var t in permit) {
      await Future.delayed(const Duration(milliseconds: 256), () {});

      var data = t;
      var json = data.toJson();
      var jsonString = jsonEncode(json);
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

      //await FirebaseT.pushPermitManagementWithAES(list);
      //await FirebaseT.pushPermitManagement(data);

      print('성공적으로 서버에 데이터 추가됨');
    }
  }

  Widget a() {
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: AdaptiveScrollbar(
          controller: verticalScroll,
          width: 8,
          sliderSpacing: EdgeInsets.zero,
          child: AdaptiveScrollbar(
              controller: horizontalScroll,
              width: 12,
              position: ScrollbarPosition.bottom,
              sliderSpacing: EdgeInsets.zero,
              underSpacing: EdgeInsets.only(bottom: 12),
              child: SingleChildScrollView(
                controller: horizontalScroll,
                scrollDirection: Axis.horizontal,
                child: Container(
                    width: 1000,
                    child: Column(
                      children: [
                      ],
                    ),
                ),
              ))),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('허가 관리 목록 추가'),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: a(),
      ),
    );
  }
}

