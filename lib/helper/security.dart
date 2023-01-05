import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as en;
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';

class SecurityT {
  static dynamic securityT(List<dynamic> tList, String k) {
      var sKey = tList.removeLast();
      var ssKey = SystemT.securityKeys.getKey(sKey);

      final key = en.Key.fromUtf8(ssKey);
      final iv1 = en.IV.fromLength(16);
      final encrypter = en.Encrypter(en.AES(key));
      var a = encrypter.decrypt64(tList.join(''), iv: iv1);

      var j = jsonDecode(a);
      j['id'] = k;
      return j;
  }
}