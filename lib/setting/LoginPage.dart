import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:http/http.dart' as http;
import 'package:local_notifier/local_notifier.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:system_tray/system_tray.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/PermitManagementInfoPage.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/SystemUploder.dart';

import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';
import '../PermitManagementPage.dart';
import '../page/Test.dart';

class LogInPage extends StatefulWidget {
  const LogInPage() : super();
  @override
  State<LogInPage> createState() => _LogInPageState();
}
class _LogInPageState extends State<LogInPage> {
  TextEditingController emailInput = new TextEditingController();
  TextEditingController passwordInput = new TextEditingController();
  var menus = ['변석현', '임주홍', '최인환', '함재현', '임기택', '김우빈', '이병낙', '통합'];
  var menuTs = ['대표', '이사', '실장', '과장', '대리', '주임', '사원', '통합'];
  var currentMenu = null;

  @override
  void initState() {
    super.initState();
    initAsync();
  }
  void initAsync() async {
    setState(() {});
  }

  Widget main() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container( width: 500,
          child: TextButton(
            onPressed: () async {
            },
            style: StyleT.buttonStyleOutline(padding: 0, strock: 2, elevation: 0,
                color: StyleT.accentLowColor.withOpacity(1)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                customButton: Container(height: 48, alignment: Alignment.center,
                  child: TextButton(
                    onPressed: null,
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: SizedBox()),
                        Container(
                          padding: EdgeInsets.only(top: 6, bottom: 6),
                          child: Text('${currentMenu ?? '로그인 선택'}', style: StyleT.hintStyle(bold: true, size: 16, accent: true),),
                        ),
                        Expanded(child: SizedBox()),
                        WidgetHub.iconStyleMini(icon: Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                items: menuTs.map((item) => DropdownMenuItem<dynamic>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: StyleT.titleStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                )).toList(),
                onChanged: (value) async {
                  currentMenu = value;
                  setState(() {});
                },
                itemHeight: 32,
                itemPadding: const EdgeInsets.only(left: 16, right: 16),
                dropdownWidth: 501.4,
                dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
                dropdownDecoration: BoxDecoration(
                  border: Border.all(
                    width: 1.7,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.white.withOpacity(0.95),
                ),
                dropdownElevation: 0,
                offset: const Offset(-0.7, 0),
              ),
            ),
          ),
        ),

        SizedBox(height: 8,),
        /*
     Container(
          width: 500,
          child: TextFormField(
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            textInputAction: TextInputAction.none,
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () {},
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(
                      color: SystemStyle.accentLowColor, width: 2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                    color: SystemStyle.accentColor, width: 2),),
              filled: true,
              fillColor: SystemStyle.accentColor.withOpacity(0.07),
              //suffixIcon: Icon(Icons.keyboard),
              hintText: 'EMAIL ADDRESS',
              hintStyle: SystemStyle.hintStyle(size: 16),
              contentPadding: EdgeInsets.all(8),
            ),
            controller: emailInput,
          ),
        ),*/
        Container(
          height: 48, width: 500,
          child: TextFormField(
            maxLines: 1,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            textInputAction: TextInputAction.none,
            keyboardType: TextInputType.text,
            onEditingComplete: () {},
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(
                      color: StyleT.accentLowColor, width: 2)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: BorderSide(
                    color: StyleT.accentColor, width: 2),),
              filled: true,
              fillColor: StyleT.accentColor.withOpacity(0.07),
              //suffixIcon: Icon(Icons.keyboard),
              hintText: 'PASSWORD',
              hintStyle: StyleT.hintStyle(size: 16),
              contentPadding: EdgeInsets.all(8),
            ),
            controller: passwordInput,
          ),
        ),
        SizedBox(height: 18,),
        TextButton(
          onPressed: () async {
            try {
              var id = '';
              if(currentMenu == null) {
                await WidgetHub.showSnackBar(context, text: '로그인 계정을 선택해 주세요',);
                return;
              }

              if(currentMenu == menuTs[0] || currentMenu == menus[0])
                id = 'taegi_0@taegi.com';
              if(currentMenu == menuTs[1] || currentMenu == menus[1])
                id = 'taegi_1@taegi.com';
              if(currentMenu == menuTs[2] || currentMenu == menus[2])
                id = 'taegi_2@taegi.com';
              if(currentMenu == menuTs[3] || currentMenu == menus[3])
                id = 'taegi_3@taegi.com';
              if(currentMenu == menuTs[4] || currentMenu == menus[4])
                id = 'taegi_4@taegi.com';
              if(currentMenu == menuTs[5] || currentMenu == menus[5])
                id = 'taegi_5@taegi.com';
              if(currentMenu == menuTs[6] || currentMenu == menus[6])
                id = 'taegi_6@taegi.com';
              if(currentMenu == menuTs[7] || currentMenu == menus[7])
                id = 'taegi_survey@taegi.com';

              UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: id,
                password: passwordInput.text,
              );
              var currentUser = FirebaseAuth.instance.currentUser;
              print(currentUser?.email);

              if(currentUser != null) {
                //await FirebaseAuth.instance.currentUser?.updatePassword('12345678');
                //await FirebaseAuth.instance.currentUser?.updateEmail('taegi_0@taegi.com');
                await WidgetHub.showSnackBar(context, text: '로그인 성공',);
                Navigator.pop(context, true);
              }
            } on FirebaseAuthException catch (e) {
              await WidgetHub.showSnackBar(context, text: '이메일 또는 패스워드를 잘못 입력했습니다. 다시 확인해주세요.',);
              if (e.code == 'user-not-found') {
                print('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                print('Wrong password provided for that user.');
              }
            }
          },
          style: StyleT.buttonStyleOutline(padding: 0, strock: 2,
              color: StyleT.accentColor),
          child: Container( width: 500, height: 48, alignment: Alignment.center,
              child: Text('로그인', style: StyleT.hintStyle(bold: true, size: 16, accent: true),)),
        ),
        SizedBox(height: 8,),
        Text('email : taegi_survey@taegi.com', style: StyleT.hintStyle(bold: false, size: 14),),
        Text('passw : 12345678', style: StyleT.hintStyle(bold: false, size: 14),),
        //taegi_survey@taegi.com
        //12345678
        SizedBox(height: 128,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WindowBorder(
        color: Colors.black.withOpacity(0.8),
        width: 0.6,
        child: Column(
          children: [
            AppTitleBar(title: '', back: false),
            Expanded(
              child: Container(
                  child: main(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
