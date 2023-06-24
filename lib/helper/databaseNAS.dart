import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as en;
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/security.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';

class NAS {
  static var serverPath = 'Z:\\태기측량\\공용\\1.작업\\taegi_system_server';
  static var c = 'Z:\\태기측량';
  static var keyAES = 'J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y';

  static dynamic getReference(BuildContext context) async {
    try {
      var path = '${serverPath}/setting/';
      if(!Directory(c).existsSync()) print('Error');

      Directory exDir = await Directory(path).create(recursive: true);

      var a = File( path + 'referenceO.json');
      var jsonString = await a.readAsString();
      var json = jsonDecode(jsonString);
      var s = SettingS.fromDatabase(json);
      return s;
    } catch (e) {
      print(e);
      var jsonString = await DefaultAssetBundle.of(context).loadString('assets/lock/reference.lock',);
      var json = jsonDecode(jsonString);
      var s = SettingS.fromDatabase(json);
      return s;
    }
  }
  static dynamic saveReference(SettingS data,) async {
    var jsonString = jsonEncode(data);
    print(jsonString);

    final key = en.Key.fromUtf8(keyAES);
    final iv = en.IV.fromLength(16);
    final encrypter = en.Encrypter(en.AES(key));
    var security = encrypter.encrypt(jsonString, iv: iv).base64;
    print('암호화 된값: ${security}');

    var path = '${serverPath}/setting/';
    Directory exDir = await Directory(path).create(recursive: true);

    var a = File( path + 'reference.tgs');
    await a.writeAsString('$security');
    var b = File( path + 'referenceO.json');
    await b.writeAsString('$jsonString');

  }
}