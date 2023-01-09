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
import 'package:untitled2/helper/databaseNAS.dart';
import 'package:untitled2/xxx/PermitManagementInfoPage.dart';
import 'package:untitled2/SystemUploder.dart';

import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';
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

  dynamic dialogInfoPm(BuildContext context,) async {
    if(SystemT.settingS == null) {
      WidgetT.showSnackBar(context, text: '기본정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
      return;
    }

    var jsonS = jsonEncode(SystemT.settingS.toJson());
    var j = jsonDecode(jsonS);
    var p = SettingS.fromDatabase(j);

    bool? aa = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.15),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateS) {
              return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 36,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400, width: 1.4),
                    borderRadius: BorderRadius.circular(8)),
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                title:  Column(
                  children: [
                    Container(padding: EdgeInsets.all(12),
                        child: Text('시스템 기본 설정', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: StyleT.titleColor.withOpacity(0.7)))),
                    WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
                  ],
                ),
                content: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      width: 650,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: null,
                            style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: Colors.white.withOpacity(0.5)),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.aligoAPIKey = data;
                                      }, val: p.aligoAPIKey ?? '', key: 'settingS.aligoAPIKey', text: p.aligoAPIKey, label: '알리고 API Key'),
                                      ),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.aligoServerUrl = data;
                                      }, val: p.aligoServerUrl ?? '', key: 'settingS.aligoServerUrl', text: p.aligoServerUrl, label: '알리고 API URL'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:  8,),
                          TextButton(
                            onPressed: null,
                            style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: Colors.white.withOpacity(0.5)),
                            child: Container(
                              child: Column(
                                children: [
                                  Row (
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.appId = data;
                                      }, val: p.appId ?? '', key: 'settingS.appId', text: p.appId, label: '앱 ID'),
                                      ),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.databaseKey = data;
                                      }, val: p.databaseKey ?? '', key: 'settingS.databaseKey', text: p.databaseKey, label: '데이터베이스 API Key'),
                                      ),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.projectId = data;
                                      }, val: p.projectId ?? '', key: 'settingS.projectId', text: p.projectId, label: '프로젝트 ID'),
                                      ),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.messagingSenderId = data;
                                      }, val: p.messagingSenderId ?? '', key: 'settingS.messagingSenderId', text: p.messagingSenderId, label: '메시지 수신 ID'),
                                      ),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.authDomain = data;
                                      }, val: p.authDomain ?? '', key: 'settingS.authDomain', text: p.authDomain, label: '서버 인증 도메인'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:  8,),
                          TextButton(
                            onPressed: null,
                            style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: Colors.white.withOpacity(0.5)),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.databaseNas = data;
                                      }, val: p.databaseNas ?? '', key: 'settingS.databaseNas', text: p.databaseNas, label: 'NAS 공용 서버 주소'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
                  Container(
                    padding: EdgeInsets.all(12),
                    child:
                    Row(
                      children: [
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 8,
                                  color: Colors.redAccent.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  WidgetT.iconStyleMini(icon: Icons.cancel),
                                  Text('취소', style: StyleT.titleStyle(),),
                                  SizedBox(width: 12,),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width:  8,),
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                SystemT.settingS = p;
                                setStateS(() {});
                                await NAS.saveReference(p);
                                WidgetT.showSnackBar(context, text: '기초정보 저장완료');
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 8,
                                  color: StyleT.accentColor.withOpacity(0.5) ),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  WidgetT.iconStyleMini(icon: Icons.save),
                                  Text('저장하기', style: StyleT.titleStyle(),),
                                  SizedBox(width: 12,),
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        });

    if(aa == null) aa = false;
    return aa;
  }

  Widget main() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: SizedBox()),
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
                        WidgetT.iconStyleMini(icon: Icons.arrow_drop_down),
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
                await WidgetT.showSnackBar(context, text: '로그인 계정을 선택해 주세요',);
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
                await WidgetT.showSnackBar(context, text: '로그인 성공',);
                Navigator.pop(context, true);
              }
            } on FirebaseAuthException catch (e) {
              await WidgetT.showSnackBar(context, text: '이메일 또는 패스워드를 잘못 입력했습니다. 다시 확인해주세요.',);
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
        Expanded(child: SizedBox()),
        Row(
          children: [
            Container( height: 32, margin: EdgeInsets.all(12),
              child: TextButton(
                  onPressed: () async {
                    dialogInfoPm(context);
                  },
                  style: StyleT.buttonStyleOutline(padding: 8, strock: 1.4, elevation: 8,
                      color: StyleT.accentLowColor.withOpacity(0.5)),
                  child: Row( mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetT.iconStyleMini(icon: Icons.settings, size: 16),
                      SizedBox(width: 4,),
                      Text('시스템설정', style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                    ],
                  )
              ),
            ),
          ],
        )
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
