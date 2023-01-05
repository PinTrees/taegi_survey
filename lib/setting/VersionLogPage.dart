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

class VersionLogPage extends StatefulWidget {
  const VersionLogPage() : super();
  @override
  State<VersionLogPage> createState() => _VersionLogPageState();
}
class _VersionLogPageState extends State<VersionLogPage> {
  var loadText = '';
  var selectMenu = 'A';
  var menus = ['M', 'A', 'T'];

  var title = 'Version Change log   (Beta)';

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
    return  ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: ListView(
        padding: EdgeInsets.all(18),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.1.0+beta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2023. 01. 04', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            '\n             - 실무자 페이지에서 데이터 수정시 수정전 데이터가 표시되던 오류가 해결됨'
                            '\n             - 관리자 페이지에서 데이터 수정시 수정전 데이터가 표시되던 오류가 해결됨'
                            '\n             - 업무배당 화면에서 문서추가가 불가능하던 오류가 해결됨'
                            '\n             - 계약현황 화면에서 문서수정이 불가능하던 오류가 해결됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 실무자 개인페이지 변경'
                            '\n             - 기존 관리자 시스템 일부 공유'
                            '\n             - 자신의 업무 현황을 확인 및 편집 가능'
                            '\n             - 접근방식 - 로그인 (패스워드: 12345678)'
                            '\n             - 정렬방식 관리자 페이지와 동일 (실무자 정렬 없음)'
                            '\n             - 우측 하단에 알림 표시'
                            '\nUpdate: 허가관리'
                            '\n             - 데이터가 미 입력된 문서에 대해 처리하지 않음으로 변경 (더이상 종료임박에 표시되지 않음)'
                            '\n             - 추후 미입력 데이터만 모아보는 화면 추가예정'
                            '\nUpdate: 업무배당'
                            '\n             - 데이터가 미 입력된 문서에 대해 처리하지 않음으로 변경 (더이상 업무마감에 표시되지 않음)'
                            '\n             - 업무배당 수정시 보완여부 수정 가능'
                            '\n             - 각 업무별 실무자 추가 가능 (추후 실무자 선택방식으로 변경 - 드롭다운)'
                            '\nUpdate: 관리자 페이지'
                            '\n             - 오류 또는 실수로 추가된 문서에 대한 삭제 방법 제공 (문서삭제가능)'
                            '\nUpdate: 기존 페이지 삭제예정 (구 화면)'
                            '\n             - 실무자 페이지에서 구 화면으로 이동하는 버튼 제거됨'
                            '\nUpdate: 전반적 인터페이스 통일화'
                            '\nUpdate: 코드 최적화'
                            '\nUpdate: GitHub 코드 추가됨 (0.1.0+beta)'
                            '\n             - https://github.com/PinTrees/taegi_survey'

                            '\n\n기타'
                            '\n베타버전으로 출시'
                            '\nWindowsApp 안전성 낮음'
                          , style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.9+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2023. 01. 03', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 실무자 개인페이지 추가'
                            '\n             - 기존 입력 시스템 공유'
                            '\n             - 자신의 업무 현황을 확인 및 편집 가능'
                            '\n             - 접근방식 - 로그인 (패스워드: 12345678)'
                            '\n             - 허가종료일 문서, 업무마감일 문서, 계약문서 확인가능'
                            '\n             - 전체 데이터 접근만 가능'
                            '\n             - 정렬방식 개발중'
                            '\nUpdate: 허가관리대장 문서 편집 방식 변경됨'
                            '\n             - 일부 UI 변경됨'
                            '\nUpdate: 관리자 페이지 추가'
                            '\n             - 전체 목록 확인가능'
                            '\n             - 문서 추가 가능'
                            '\nUpdate: 기존 페이지 삭제예정 (구메뉴)'
                            '\n             - 전체 목록 확인가능'
                            '\n             - 문서 추가 가능'
                            '\nUpdate: 전반적 인터페이스 통일화'
                            '\n             - 라운드 형식으로 변경됨'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음'
                          , style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.8+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 29', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            '\nFix: 허가관리대장 - 새로고침 시 서버연결이 설정되지 않던 오류 해결됨 (추후 구독 방식으로 변경예정)'
                            '\nFix: 달력을 통한 데이터 입력시 현재 입력된 주소부터 표시되도록 수정됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 계약현황 - 데이터 추가 시스템 변경됨'
                            '\n             - 기존 주소검색 시스템 개선 (기초 주소 데이터 추가)'
                            '\n             - 주소 입력시 도로명 주소 검색 추가됨 (행정안전부 API)'
                            '\n             - 산지 검색이 원활하지 않아 카카오 API로 변경예정'
                            '\n             - 업무배당관리 문서 동시 추가 가능 (공유데이터, 소재지, 신청인, 실무자, 사업목적)'
                            '\n             - 팝업창 디자인 변경됨'

                            '\nUpdate: 전반적 인터페이스 통일화'
                            '\n             - 안정버전 추가됨 (업데이트 필수에서 권장으로 변경)'

                            '\n\n기타'
                            '\nbuild key 변경됨'
                            '\nWindowsApp 안전성 낮음'
                          , style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.7+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 28', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                        //'\nFix: 서버 데이터 로딩 후 화면이 표시되지 않는 오류가 해결됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 인증 기능 추가됨'
                            '\n             - 개발용 간편 로그인 기능 추가'

                            '\nUpdate: 계약현황 - 데이터 수정 시스템 변경됨'
                            '\n             - 자세히보기 UI 변경됨 (구메뉴 삭제됨)'
                            '\n             - 소재지 수정 시 자동 완성기능 추가'
                            '\n             - 중도금, 타사업무, 사업목적 입력 방식 변경됨'
                            '\n             - 실무자 선택 방식 변경됨'
                            '\n             - 정산 완료 이미지 변경됨'
                            '\n             - 총 문서 개수 표시 (우측 상단)'

                            '\nUpdate: 전반적 인터페이스 통일화'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.6+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 27', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            //'\nFix: 서버 데이터 로딩 후 화면이 표시되지 않는 오류가 해결됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 인증 기능 추가됨'
                            '\n             - 인증 되지 않은 시스템에서 요청하는 모든 접근 차단됨 (0.0.6+dev 이상 버전만 사용 가능)'

                            '\nUpdate: 허가관리대장 - 데이터 입력 시스템 변경됨'
                            '\n             - 구메뉴 삭제됨'

                            '\nUpdate: 전반적 인터페이스 통일화'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.5+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 26', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            '\nFix: 서버 데이터 로딩 후 화면이 표시되지 않는 오류가 해결됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 허가관리대장 - 데이터를 수정할 수 있는 방법이 변경됨. (좌측 슬라이드 메뉴 삭제 예정)'
                            '\n             - 날짜 입력 시, 달력이 표시되는 버튼이 추가됨.'
                            '\n             - 자세히 보기 UI가 그리드 형식으로 변경됨.'
                            '\n             - 총 검색 문서 개수표시 기능 추가됨 (좌측 상단)'

                            '\nUpdate: 업무관리대장 - 데이터를 수정할 수 있는 방법이 변경됨. (좌측 슬라이드 메뉴 삭제 예정)'
                            '\n             - 날짜 입력 시, 달력이 표시되는 버튼이 추가됨.'
                            '\n             - 자세히 보기 UI가 그리드 형식으로 변경됨.'

                            '\nUpdate: 전반적 인터페이스 통일화'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.4+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 23', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            '\nFix: 계약현황의 0이하 금액이 비정상적으로 표시되던 현상 수정됨'
                            '\nFix: 계약현황 신규 문서 추가 시 금액입력 시스템이 원활하게 돌아가도록 수정됨'

                            '\n\n기능 및 UI 업데이트'
                            '\nUpdate: 통합검색 시스템 추가됨 (모든 데이터들에 대한 모든 필드 통합 검색)'
                            '\n             - 허가, 계약, 업무배당 관련한 모든 데이터를 통합 검색 가능'

                            '\nUpdate: 최신버전 이하 버전에서 데이터 추가 및 수정이 불가능하도록 변경됨 (서버 안전성)'
                            '\nUpdate: 업무배당관리 보완 시스템 추가 및 UI 변경'
                            '\nUpdate: 계약현황 - 정산이 완료된 계약 비활성화 및 색상 표기 수정'
                            '\nUpdate: 계약현황 - 미수금 화면에 표시'
                            '\nUpdate: 전반적 인터페이스 통일화'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('0.0.3+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                        Text('2022. 12. 22', style: StyleT.textStyle(),),
                      ],
                    ),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('버그 수정'
                            '\nFix: 허가관리대장 문서 추가 시 수정한 문서가 표시되지 않는 오류가 해결됨'
                            '\nFix: 기초정보입력 화면이 정상적으로 표시되지 않던 오류 수정됨'
                            '\n\n기능 업데이트'
                            '\nUpdate: 허가관리대장 정렬방식 변경됨 (모든 정렬 형태 허용) [허가일 오름차순, 내림차순]'
                            '\nUpdate: 허가관리대장 정렬시 미기입 데이터 처리방식 변경 (후순위 처리)'

                            '\n\nUI/UX 업데이트'
                            '\nUpdate: 허가관리대장 기본 뷰어가 그리드 형식으로 변경됨'
                            '\nUpdate: 허가관리대장 종료 30일 이내의 목록의 남은 일 수 표시'

                            '\n\n기타'
                            '\nWindowsApp 안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('0.0.2+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                      Text('2022. 12. 21', style: StyleT.textStyle(),),
                    ],
                  ),  SizedBox(width: 36,),
                  SizedBox(width: 8,),
                  Column(
                    children: [
                      Text('Fix: 업무관리대장 문서 수정 시 신규 문서로 추가되는 오류 수정됨'
                          '\nFix: 허가관리대장 문서 추가 시 수정버튼이 표시되는 오류 수정됨'
                          '\nFix: 기초정보입력 화면이 정상적으로 표시되지 않던 오류 수정됨'
                          '\nNew: 업무관리대장 정렬 및 검색 방식이 변경됨'
                          '\nNew: 버전확인 기능 추가됨'

                          '\n버전코드 활성화 됨 (개발 버전)'
                          '\n앱 아이콘 변경됨'
                          '\n안전성 낮음', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                    ],
                  )
                ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('0.0.1+dev', style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),),
                    SizedBox(width: 36,),
                    SizedBox(width: 8,),
                    Column(
                      children: [
                        Text('개발 버전 출시됨', style: TextStyle(fontSize: 11, color: StyleT.titleColor, fontWeight: FontWeight.w300),),
                      ],
                    )
                  ]
              ),
              SizedBox(height: 8,),
              WidgetHub.dividHorizontalLow(),
            ],
          ),
          SizedBox(height: 8,),
        ],
      ),
    );
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
                      width: 48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleNone(padding: 0, elevation: 0, strock: 1.4,),
                              child: WidgetHub.iconStyleBig(icon: Icons.arrow_back)),
                        ],
                      ),
                    ),
                    Container(height: double.maxFinite, width: 1, color: Colors.grey.shade400,),
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
                                Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),),
                              ],
                            ),
                            SizedBox(height: 12,),
                            Container(width: double.maxFinite, height: 1, color: Colors.grey.shade400,),
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