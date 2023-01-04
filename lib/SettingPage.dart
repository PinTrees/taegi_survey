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
import 'package:untitled2/PermitManagementInfoPage.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/SystemUploder.dart';

import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';
import 'PermitManagementPage.dart';
import 'page/Test.dart';
import 'setting/TemplatePage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);
  @override
  State<SettingPage> createState() => _SettingPageState();
}
class _SettingPageState extends State<SettingPage> {
  var loadText = '';

  @override
  void initState() {
    super.initState();
    initAsync();
  }
  void initAsync() async {
      setState(() {});
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
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: StyleT.buttonStyleNone(padding: 0, elevation: 0, strock: 1.4,),
                          child: WidgetHub.iconStyleBig(icon: Icons.arrow_back)),
                      SizedBox(height: 18,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(80),
                            child: Container(
                              width: 120, height: 120, color: StyleT.accentLowColor.withOpacity(0.5),
                              child: Image.asset('assets/taegi_icon.png', fit: BoxFit.cover,),
                            ),
                          ),
                          SizedBox(width: 18,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( 'TaeGi Survey', style: TextStyle(fontSize: 32),),
                              Text( '관리자 계정', style: TextStyle(fontSize: 12, color: StyleT.textColor),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 24,),
                      SizedBox(height: 24,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 18),
                          width: double.maxFinite, height: double.maxFinite,
                          //color: SystemStyle.white.withOpacity(0.5),
                          child: Wrap(
                            spacing: 18, runSpacing: 18,
                            alignment: WrapAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.manage_accounts_outlined),
                                        SizedBox(width: 12,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('실무자 관리', style: StyleT.titleBigStyle(),),
                                            Text('실무자 추가, 정보 수정, 권한 설정', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.sync_sharp),
                                        SizedBox(width: 12,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('업데이트 확인', style: StyleT.titleBigStyle(),),
                                            Text('시스템 업데이트 확인 및 진행', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),

                              TextButton(
                                  onPressed: () {
                                    //Navigator.pop(context);
                                    WidgetHub.openPageWithFade(context, EditTPage(), time: 0);
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.auto_fix_high),
                                        SizedBox(width: 12,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('기초 정보', style: StyleT.titleBigStyle(),),
                                            Text('기초 삽입 정보 수정', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.campaign),
                                        SizedBox(width: 12,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('공지사항', style: StyleT.titleBigStyle(),),
                                            Text('시스템 개선 및 변경사항 확인', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),

                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.notification_add),
                                        SizedBox(width: 12,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('알림설정', style: StyleT.titleBigStyle(),),
                                            Text('알림 주기 및 내용 설정', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.lock),
                                        SizedBox(width: 8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('보안 정보', style: StyleT.titleBigStyle(),),
                                            Text('시스템 운영에 필요한 보안 정보', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.error),
                                        SizedBox(width: 8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('오류 정보', style: StyleT.titleBigStyle(),),
                                            Text('시스템 오류 확인, 검색', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.supervised_user_circle),
                                        SizedBox(width: 8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('사용방법', style: StyleT.titleBigStyle(),),
                                            Text('시스템 사용정보', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LicensePage()),);
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.qr_code_2),
                                        SizedBox(width: 8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('라이선스', style: StyleT.titleBigStyle(),),
                                            Text('시스템 개발에 사용된 라이선스', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                              TextButton(
                                  onPressed: () {
                                  },
                                  style: StyleT.buttonStyleOutline(elevation: 0, strock: 1.4, color: StyleT.white.withOpacity(0.5)),
                                  child: Container(
                                    width: 230, height: 64,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WidgetHub.iconStyleBigLarge(icon: Icons.search),
                                        SizedBox(width: 8,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('검색', style: StyleT.titleBigStyle(),),
                                            Text('시스템에 기록된 모든 파일을 검색', style: StyleT.textStyleBig(),),
                                          ],)
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        '$loadText',
                        style: StyleT.titleBigStyle(),
                      ),
                      SizedBox(height: 8,),
                      SizedBox(width: 512, height: 2, child: LinearProgressIndicator(minHeight: 2,)),
                    ],
                  )
                ),
              )
            ],
          ),
      ),
      );
  }
}