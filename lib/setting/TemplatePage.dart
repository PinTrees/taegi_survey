import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:http/http.dart' as http;
import 'package:local_notifier/local_notifier.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:system_tray/system_tray.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/xxx/PermitManagementInfoPage.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';
import 'package:untitled2/SystemUploder.dart';

import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';
import '../xxx/PermitManagementPage.dart';
import '../page/Test.dart';

class EditTPage extends StatefulWidget {
  const EditTPage({Key? key}) : super(key: key);
  @override
  State<EditTPage> createState() => _EditTPageState();
}
class _EditTPageState extends State<EditTPage> {
  var loadText = '';
  var selectMenu = 'A';
  var menus = ['M', 'A', 'T'];

  var title = '건축회사 정보';

  TextEditingController nameInput = new TextEditingController();
  TextEditingController phoneNumberInput = new TextEditingController();
  TextEditingController descInput = new TextEditingController();

  TextEditingController mngNameInput = new TextEditingController();
  TextEditingController mngTypeInput = new TextEditingController();
  TextEditingController mngPhoneNumberInput = new TextEditingController();

  @override
  void initState() {
    super.initState();
    initAsync();
  }
  String titleString() {
    if(selectMenu == 'M') {
      return '실무자 정보';
    }
    else if(selectMenu == 'A') {
      return '건축회사 정보';
    }
    return '기초 정보';
  }
  void initAsync() async {
      setState(() {});
  }

  Widget main() {
    if(selectMenu == 'M') {
      List<Widget> widgetW = [];
      for(var t in SystemT.managers) {
        var w = Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextButton(
            onPressed: () {

            },
            style: StyleT.buttonStyleOutline(elevation: 18, strock: 1.4, color: Colors.white.withOpacity(0.5)),
            child: Container(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name, style: StyleT.titleBigStyle(),),
                  Text(t.phoneNumber, style: StyleT.titleStyle(),),
                  Text(t.id, style: StyleT.textStyle(),),
                ],
              ),
            ),
          ),
        );
        Text(t.name, style: StyleT.titleStyle(),);
        widgetW.add(w);
      }

      return ListView(
        padding: EdgeInsets.all(18),
        children: [
          Text('실무자 추가', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
          SizedBox(height: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 360,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WidgetT.textInputField(mngNameInput, height: 36, hintText: '담당자 이름 입력'),
                          WidgetT.textInputField(mngTypeInput, height: 36, hintText: '담당자 직책 입력'),
                          WidgetT.textInputField(mngPhoneNumberInput, height: 36, hintText: '담당자 연락처 입력'),
                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            var check = false;
                            if(mngNameInput.text == '') check = true;
                            if(mngTypeInput.text == '') check = true;
                            if(mngPhoneNumberInput.text == '') check = true;
                            if(check) {
                              return;
                            }

                            var data = Manager.fromDatabase({
                              'name': mngNameInput.text, 'type': mngTypeInput.text, 'phoneNumber': mngPhoneNumberInput.text,
                            });
                            await FirebaseT.pushManager(data);
                            mngNameInput.clear();
                            mngTypeInput.clear();
                            mngPhoneNumberInput.clear();

                            SystemT.managers.insert(0, data);

                            setState(() {});
                          },
                          style: StyleT.buttonStyleNone( elevation: 8, color: StyleT.backgroundColor),
                          child: SizedBox( height: 55,
                              child: Icon(Icons.group_add, size: 20, color: StyleT.accentColor,)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24,),
          Text('실무자 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
          SizedBox(height: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetW,
          ),

          SizedBox(height: 8,),
        ],
      );
    }
    else if(selectMenu == 'A') {
      List<Widget> widgetW = [];
      for(var t in SystemT.architectureOffices) {
        var w = Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextButton(
            onPressed: () {

            },
            style: StyleT.buttonStyleOutline(elevation: 18, strock: 1.4, color: Colors.white.withOpacity(0.5)),
            child: Container(
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.name, style: StyleT.titleBigStyle(),),
                  Text(t.phoneNumber, style: StyleT.titleStyle(),),
                  Text(t.id, style: StyleT.textStyle(),),
                ],
              ),
            ),
          ),
        );
        Text(t.name, style: StyleT.titleStyle(),);
        widgetW.add(w);
      }

      return ListView(
        padding: EdgeInsets.all(18),
        children: [
          Text('건축회사 추가', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
          SizedBox(height: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 360,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WidgetT.textInputField(nameInput, height: 36,  hintText: '건설회사 입력'),
                          WidgetT.textInputField(phoneNumberInput,  height: 36, hintText: '연락처 입력'),
                          WidgetT.textInputField(descInput,  height: 36, hintText: '자세한 정보'),
                        ],
                      ),
                    ),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () async {
                            var check = false;
                            if(nameInput.text == '') check = true;
                            if(phoneNumberInput.text == '') check = true;
                            if(descInput.text == '') check = true;
                            if(check) {
                              return;
                            }

                            var data = ArchitectureOffice.fromDatabase({
                              'phoneNumber': phoneNumberInput.text,
                              'name': nameInput.text,
                              'desc': descInput.text,
                            });
                            await FirebaseT.pushArchitectureOffice(data);
                            phoneNumberInput.clear();
                            nameInput.clear();
                            descInput.clear();

                            SystemT.architectureOffices.insert(0, data);
                            setState(() {});
                          },
                          style: StyleT.buttonStyleOutline( strock: 1.4, elevation: 8, color: StyleT.backgroundColor),
                          child: SizedBox( height: 55,
                              child: Icon(Icons.add_home_work, size: 20, color: StyleT.accentColor,)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24,),
          Text('건축회사 목록', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
          SizedBox(height: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetW,
          ),

          SizedBox(height: 8,),
        ],
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  WindowBorder(
        color: Colors.black.withOpacity(0.8),
        width: 0.6,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppTitleBar(back: false, title: '태기측량 시스템 프로그램',),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleNone(padding: 0, elevation: 0, strock: 1.4,),
                              child: WidgetT.iconStyleBig(icon: Icons.arrow_back)),
                          TextButton(
                              onPressed: () {
                                selectMenu = 'M';
                                setState(() {});
                              },
                              style: StyleT.buttonStyleNone(padding: 0, color: (selectMenu == 'M') ? StyleT.accentLowColor.withOpacity(0.5) : Colors.transparent),
                              child: Row(
                                children: [
                                  WidgetT.iconStyleBig(icon: Icons.manage_accounts),
                                  SizedBox(width: 0,),
                                  Text( '실무자', style:StyleT.titleBigStyle(),),
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                selectMenu = 'A';
                                setState(() {});
                              },
                              style: StyleT.buttonStyleNone(padding: 0, color: (selectMenu == 'A') ? StyleT.accentLowColor.withOpacity(0.5) : Colors.transparent),
                              child: Row(
                                children: [
                                  WidgetT.iconStyleBig(icon: Icons.apartment,),
                                  SizedBox(width: 0,),
                                  Text( '건설 회사', style:StyleT.titleBigStyle(),),
                                ],
                              )),
                          TextButton(
                              onPressed: () {},
                              style: StyleT.buttonStyleNone(padding: 0),
                              child: Row(
                                children: [
                                  WidgetT.iconStyleBig(icon: Icons.code),
                                  SizedBox(width: 0,),
                                  Text( '개발 타입', style:StyleT.titleBigStyle(),),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 18,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 18,),
                                Text(titleString(), style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),),
                              ],
                            ),
                            Expanded(child: main()),
                         ],
                        )
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
      ),
      );
  }
}