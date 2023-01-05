/*
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:untitled2/ContractEditPage.dart';
import 'package:untitled2/EditeTemplatePage.dart';
import 'package:untitled2/xxx/PermitManagementInfoPage.dart';
import 'package:untitled2/xxx/PermitManagementPage.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';
import 'package:untitled2/SettingPage.dart';
import 'package:untitled2/WorkManagementEditPage.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:encrypt/encrypt.dart' as en;

import 'AlertMainPage.dart';
import 'ContractViewerPage.dart';
import 'PmEditePage.dart';
import 'helper/style.dart';

enum SearchPM {
  address('address', '주소'),
  client('client', '신청인'),
  manager('manager', '실무자');
  //undefined('undefined', '');

  const SearchPM(this.code, this.displayName);
  final String code;
  final String displayName;

  factory SearchPM.getByCode(String code){
    return SearchPM.values.firstWhere((value) => value.code == code,
        orElse: () => SearchPM.address);
  }

   dynamic getMenuList() {
    var a = [];
    for(var i in SearchPM.values)
      a.add(i.displayName);
    return a;
  }
}

class WorkManagementListViewerPage extends StatefulWidget {
  bool? isAlert = false;
  WorkManagementListViewerPage({ this.isAlert });
  @override
  State<WorkManagementListViewerPage> createState() => _WorkManagementListViewerPageState();
}
class _WorkManagementListViewerPageState extends State<WorkManagementListViewerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var verticalScroll = ScrollController();
  var horizontalScroll = ScrollController();
  var titleHorizontalScroll = ScrollController();

  TextEditingController searchInput = TextEditingController();

  DateTime? searchSelectYear;
  List<DateTime> searchYears = [
    DateTime(2010),
    DateTime(2011),
    DateTime(2012),
    DateTime(2013),
    DateTime(2014),
    DateTime(2015),
    DateTime(2016),
    DateTime(2017),
    DateTime(2018),
    DateTime(2019),
    DateTime(2020),
    DateTime(2021),
    DateTime(2022),
    DateTime(2023),
  ];

  int? searchSelectMonth;
  List<int> searchMonth = [ 1,2,3,4,5,6,7,8,9,10,11,12, ];

  var searchOption = SearchPM.address;
  var main;

  var infoPage;
  late WmCreatePage createPage;

  bool isConfirm = false;

  var sideViewType = '';

  var readStart = true;
  var selectIndexDrawer = 1;

  var isViewShort = false;

  Map<String, Widget> menuW = new Map();
  var selectMenu = 'main';

  /// 순서 변경 금지
  var sortMenu = [ '배당일 오름차순', '배당일 내림차순', '마감일' ];
  var selectSortMenu = '';

  /// search option
  bool isComplete = false;
  bool isNoneComplete = false;

  List<WorkManagement> list = [];
  WorkManagement? selectP;
  WorkManagement? replaceP;
  Manager? selectManager;

  @override
  void initState() {
    super.initState();
    SystemT.initPageValue();

    selectSortMenu = sortMenu.first;

    initWidgetMenu();
    horizontalScroll.addListener(() {
      titleHorizontalScroll.jumpTo(horizontalScroll.position.pixels);
    });
    list = SystemT.workManagements.values.toList();

    if(widget.isAlert != null)
      isConfirm = widget.isAlert!;

    search();
    refresh();
  }

  void initWidgetMenu() {
    menuW.clear();
    menuW['info'] = Column(
      children: [
        TextButton(
          onPressed: () async {
            refresh();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.refresh),
        ),
        TextButton(
          onPressed: () async {
            openMenu();
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:WidgetHub.iconStyleBig(icon: Icons.more_vert),
        ),
        TextButton(
          onPressed: () async {
            sideViewType = selectMenu = 'create';
            var jsonS = jsonEncode(selectP);
            var j = jsonDecode(jsonS);
            createPage = WmCreatePage(c: WorkManagement.fromDatabase(j), read: false, close: () {
              selectMenu = 'main';
              sideViewType = '';
              setState(() {});
            },);
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.create),
        ),
        TextButton(
          onPressed: () async {
            isViewShort = !isViewShort;
            refresh();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:  WidgetHub.iconStyleBig(icon: Icons.view_headline),
        ),
      ],
    );
    menuW['create'] = Column(
      children: [
        TextButton(
          onPressed: () async {
            refresh();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.refresh),
        ),
        TextButton(
          onPressed: () async {
            openMenu();
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:WidgetHub.iconStyleBig(icon: Icons.more_vert),
        ),
        TextButton(
          onPressed: () async {
            if((await WidgetHub.showAlertDl(context, title: createPage.c.addresses.first) as bool) == false) {
              WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
              return;
            }

            if(selectP != null) {
              print(createPage.c.id);
              await FirebaseT.postWorkManagementWithAES(createPage.c, createPage.c.id);
              //var index = SystemT.workManagements.indexOf(selectP!);
              //SystemT.workManagements[index] = createPage.c;
            }
            else {
              print(createPage.c.toJson());
              //await FirebaseT.pushWorkManagementWithAES(createPage.c);
              //SystemT.workManagements.insert(0, createPage.c);
            }

            selectP = null;
            selectMenu = 'main';
            sideViewType = '';

            search();
            refresh();
            WidgetHub.showSnackBar(context, text: '저장되었습니다.');
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.drive_folder_upload_rounded),
        ),

        */
/*
        TextButton(
          onPressed: () async {
          },
          style: SystemStyle.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.create),
        ),
        *//*

        TextButton(
          onPressed: () async {
            isViewShort = !isViewShort;
            refresh();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:  WidgetHub.iconStyleBig(icon: Icons.view_headline),
        ),
      ],
    );
    menuW['main'] = Column(
      children: [
        TextButton(
          onPressed: () async {
            WidgetHub.loadingBottomSheet(context);
            await SystemT.update();
            Navigator.pop(context);
            search();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.refresh),
        ),
        TextButton(
          onPressed: () async {
            openMenu();
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:WidgetHub.iconStyleBig(icon: Icons.more_vert),
        ),
        TextButton(
          onPressed: () async {
            sideView('create');
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.create_new_folder),
        ),
        TextButton(
          onPressed: () async {
            isViewShort = !isViewShort;
            refresh();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:  WidgetHub.iconStyleBig(icon: Icons.view_headline),
        ),
        TextButton(
          onPressed: () async {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()),);
            //QuickNotify.notify(
            //  title: '얼마 남지 않은 허가가 있어요!',
            //  content: '시스템을 열어 확인해 주세요!',
            //);
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.settings_suggest),
        ),
        TextButton(
          onPressed: () async {
            _scaffoldKey.currentState?.openDrawer();
            //QuickNotify.notify(
            //  title: '얼마 남지 않은 허가가 있어요!',
            //  content: '시스템을 열어 확인해 주세요!',
            //);
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.sim_card_download),
        ),
        SizedBox(height: 18,),
        TextButton(
          onPressed: () async {
            WidgetHub.openPageWithFade(context, PermitManagementListViewerPage(), first: true);
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:  WidgetHub.iconStyleBig(icon: Icons.manage_search),
        ),
        TextButton(
          onPressed: () async {
            WidgetHub.openPageWithFade(context, ContractListViewerPage(), first: true);
          },
          style: StyleT.buttonStyleNone(padding: 0,),
          child:  WidgetHub.iconStyleBig(icon: Icons.currency_exchange),
        ),
        TextButton(
          onPressed: () async {
          },
          style: StyleT.buttonStyleNone(padding: 0,  color: StyleT.accentLowColor.withOpacity(0.5)),
          child:  WidgetHub.iconStyleBig(icon: Icons.engineering),
        ),
      ],
    );
  }

  void saveEditDate() async {
    if(replaceP == null) return;

    if((await WidgetHub.showAlertDl(context, title: replaceP!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(replaceP != null) {
      print(replaceP!.id);
      await FirebaseT.postWorkManagementWithAES(replaceP, replaceP!.id);
      //var index = SystemT.workManagements.indexOf(selectP!);
      //SystemT.workManagements[index] = replaceP!;
    }

    selectP = replaceP = null;
    selectMenu = 'main';
    sideViewType = '';

    search();
    refresh();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
  }

  Widget getSideView() {
    if(sideViewType == 'info') {
      return Container(width: 360,
          child: Column(
            children: [ Expanded(child: infoPage!), ],
          )
      );
    } else if(sideViewType == 'create') {
      return Container(
          height: double.maxFinite, width: 360,
          child: Column(
            children: [ Expanded(child: createPage), ],
          )
      );
    }
    return SizedBox();
  }
  void sideView(String type, { WorkManagement? p }) {
    sideViewType = type;

    if(sideViewType == 'info') {
      selectMenu = 'info';
      selectP = p!;
      infoPage = WmInfoPage(c: p!, read: true, close: () {
        sideViewType = '';
        selectMenu = 'main';
        selectP = null;
        refresh();
      },);
      infoPage!.createState();
    }
    else if(sideViewType == 'create') {
      selectP = null;
      selectMenu = 'create';
      var a = WorkManagement.fromDatabase({});
      createPage = WmCreatePage(c: a!, read: false, close: () {
        selectMenu = 'main';
        sideViewType = '';
        setState(() {});
      },);
    }


    refresh();
  }
  void refresh() {
    List<Widget> permitManagementW = [];
    for(var p in list) {
      Widget w = SizedBox();
      var backColor =  selectP == p ? StyleT.accentLowColor.withOpacity(0.5) : null;

      w = WidgetHub.wmRowShortWidget(context, p,
          fun: () async {
            selectP = p;
            var jsonS = jsonEncode(p);
            var j = jsonDecode(jsonS);
            replaceP = WorkManagement.fromDatabase(j);

            sideView('info', p: p);
          },
          color: backColor, endVisible: isConfirm, moreFun: () {
            selectP = p; refresh();
          });
      if(selectP == p) {
        w = WidgetHub.wmRowEditeWidget(context, replaceP!, saveFun: saveEditDate,
            fun: () async {sideView('info', p: p);},
            color: backColor, endVisible: isConfirm, moreFun: () {
              selectP = p; refresh();
            }, setFun: () { refresh(); setState(() {}); });
      }
      permitManagementW.add(w);
    }
    main = ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: Container(
        color: Colors.transparent,
        child: ListView.builder(
            controller: verticalScroll,
            padding: EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 18),
            itemCount: permitManagementW.length,
            itemBuilder: (BuildContext ctx, int idx) {
              if(idx >= permitManagementW.length) {}
              return Column(
                children: [
                  permitManagementW[idx],
                  Divider(height: 12, color: Colors.transparent,),
                ],
              );
            }
        ),
      ),
    );
    setState(() {});
  }

  void search({ String? address, String? manager, String? client }) async {
    List<WorkManagement> tmpList = SystemT.workManagements.values.toList();

    if(isConfirm) {
      tmpList = await SystemT.searchWmSortTaskOverAtOnly(tmpList);
    }

    if(searchSelectYear != null) {
      tmpList = await SystemT.searchWmWithYear(searchSelectYear!.year.toString(), sort: tmpList);
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemT.searchWmWithMonth(searchSelectMonth.toString(), sort: tmpList);
    }

    if(address != null) {
      tmpList = await SystemT.searchWmWithAddress(address, sort: tmpList);
    }
    if(manager != null) {
      tmpList = await SystemT.searchWmWithManager(manager, sort: tmpList);
    }
    if(client != null) {
      tmpList = await SystemT.searchWmWithClient(client, sort: tmpList);
    }

    if(selectSortMenu == sortMenu.first) {
      tmpList = await SystemT.searchWmSortF(tmpList,);
    }
    else if(selectSortMenu == sortMenu[1]) {
      tmpList = await SystemT.searchWmSortF(tmpList, dsss: true);
    }
    else if(selectSortMenu == sortMenu[2]) {
      tmpList = await SystemT.searchWmSortTaskOverAt(tmpList,);
    }

    list = tmpList.toList();
    refresh();
  }
  void openMenu() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0)),

            titlePadding: EdgeInsets.all(0),
            title: Container(
              color: Colors.grey.shade300, padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text("시스템 관리자 설정", style: StyleT.titleStyle(),),
                ],
              ),
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  child: Text("허가 관리 목록 추가", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    WidgetHub.openPageWithFade(context, PermitManagementPage());
                  },
                ),
                SizedBox(height: 12,),
                TextButton(
                  child: Text("이용자 추가 (테스트)", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 12,),
                TextButton(
                  child: Text("테스트", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("알람 주기 1분", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    SystemT.alertDuDefault = 60;
                    SystemT.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("알람 주기 1초", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    SystemT.alertDuDefault = 1;
                    SystemT.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("알람 주기 1시간", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    SystemT.alertDuDefault = 3600;
                    SystemT.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Nas 데이터 저장", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () async {
                  },
                ),
                TextButton(
                  child: Text("Nas 데이터 확인", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () async {
                    var a = File('${SystemT.serverPath}/contract/2022_12.tgs');
                    var ss = await a.readAsStringSync();
                    print(ss);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("확인", style: StyleT.titleStyle(bold: true)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
         body: WindowBorder(
           color: Colors.black.withOpacity(0.8),
           width: 0.6,
           child: Row(
             children: [
               Stack(
                 children: [
                   SizedBox(width: 48, child: menuW[selectMenu],),
                   Positioned(
                     bottom: 0,
                       child: Column(
                         children: [
                           TextButton(
                             onPressed: () async {
                               isConfirm = !isConfirm;
                               WidgetHub.showSnackBar(context, text: '종료일이 가까운 목록을 표시합니다.');
                               search();
                             },
                             style: StyleT.buttonStyleNone(padding: 0,
                             color: isConfirm ? StyleT.accentColor.withOpacity(0.5) : Colors.transparent),
                             child: WidgetHub.iconStyleBig(icon: Icons.timelapse, color: Colors.redAccent),
                           ),
                           TextButton(
                             onPressed: () async {
                               StyleT.initBrihtsty();
                               refresh();
                             },
                             style: StyleT.buttonStyleNone(padding: 0),
                             child: WidgetHub.iconStyleBig(icon: Icons.dark_mode),
                           ),
                         ],
                       ),
                   )
                 ],
               ),
               getSideView(),
               Container(width: 1.3, height: double.maxFinite, color: Colors.grey.shade400,),
               Expanded(
                 flex: 7,
                 child: Column(
                   children: [
                     AppTitleBar(title: '  태기측량 시스템 프로그램', back: false),
                     //Container(width: double.maxFinite, height: 1.3, color: Colors.grey.shade400,),
                     Expanded(
                       child: Stack(
                         children: [
                           Positioned(
                             top: 0, left: 0, right: 0, bottom: 0,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Container(
                                   padding: EdgeInsets.only(left: 12),
                                   child: Text(
                                     '업무 배당 관리',
                                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                                   ),
                                 ),
                                 Container(
                                   color: Colors.transparent,
                                   child: Column(
                                     mainAxisSize: MainAxisSize.min,
                                     children: [
                                       SizedBox(height: 4,),
                                       Row(
                                         children: [
                                           SizedBox(width: 12,),

                                           Row(
                                             children: [
                                               Container(
                                                 height: 36,
                                                 child: DropdownButtonHideUnderline(
                                                   child: DropdownButton2(
                                                     isExpanded: true,
                                                     hint: Row(
                                                       children: const [
                                                         Icon(
                                                           Icons.list,
                                                           size: 16,
                                                           color: Colors.yellow,
                                                         ),
                                                         SizedBox(
                                                           width: 4,
                                                         ),
                                                         Expanded(
                                                           child: Text(
                                                             'Select Item',
                                                             style: TextStyle(
                                                               fontSize: 14,
                                                               fontWeight: FontWeight.bold,
                                                               color: Colors.yellow,
                                                             ),
                                                             overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     items: sortMenu.map((item) => DropdownMenuItem<dynamic>(
                                                       value: item,
                                                       child: Text(
                                                         item,
                                                         style: StyleT.titleStyle(),
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                     ))
                                                         .toList(),
                                                     value: selectSortMenu,
                                                     onChanged: (value) {
                                                       setState(() {
                                                         selectSortMenu = value;
                                                         search();
                                                       });
                                                     },
                                                     icon: const Icon(
                                                       Icons.expand_more,
                                                     ),
                                                     iconSize: 14,
                                                     iconEnabledColor: StyleT.textColor,
                                                     iconDisabledColor: Colors.grey,
                                                     buttonHeight: 50,
                                                     buttonWidth: 128,
                                                     dropdownWidth: 128,
                                                     buttonPadding: const EdgeInsets.only(left: 8, right: 8),
                                                     buttonDecoration: StyleT.dropButtonStyle(),
                                                     buttonElevation: 0,
                                                     itemHeight: 32,
                                                     itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                                     dropdownMaxHeight: 200,
                                                     dropdownPadding: null,
                                                     dropdownDecoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(8),
                                                       color: Colors.grey.shade50,
                                                     ),
                                                     dropdownElevation: 16,
                                                     scrollbarRadius: const Radius.circular(8),
                                                     scrollbarThickness: 6,
                                                     scrollbarAlwaysShow: true,
                                                     offset: const Offset(0, 0),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 4,),
                                               Container(
                                                 height: 36,
                                                 child: DropdownButtonHideUnderline(
                                                   child: DropdownButton2(
                                                     isExpanded: true,
                                                     hint: Row(
                                                       children: const [
                                                         Icon(
                                                           Icons.list,
                                                           size: 16,
                                                           color: Colors.yellow,
                                                         ),
                                                         SizedBox(
                                                           width: 4,
                                                         ),
                                                         Expanded(
                                                           child: Text(
                                                             'Select Item',
                                                             style: TextStyle(
                                                               fontSize: 14,
                                                               fontWeight: FontWeight.bold,
                                                               color: Colors.yellow,
                                                             ),
                                                             overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     items: SearchPM.values.map((item) => DropdownMenuItem<dynamic>(
                                                       value: item,
                                                       child: Text(
                                                         item.displayName,
                                                         style: StyleT.titleStyle(),
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                     ))
                                                         .toList(),
                                                     value: searchOption,
                                                     onChanged: (value) {
                                                       setState(() {
                                                         searchOption = value;
                                                         search();
                                                       });
                                                     },
                                                     icon: const Icon(
                                                       Icons.expand_more,
                                                     ),
                                                     iconSize: 14,
                                                     iconEnabledColor: StyleT.textColor,
                                                     iconDisabledColor: Colors.grey,
                                                     buttonHeight: 50,
                                                     buttonWidth: 75,
                                                     dropdownWidth: 75,
                                                     buttonPadding: const EdgeInsets.only(left: 8, right: 8),
                                                     buttonDecoration: StyleT.dropButtonStyle(),
                                                     buttonElevation: 0,
                                                     itemHeight: 32,
                                                     itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                                     dropdownMaxHeight: 200,
                                                     dropdownPadding: null,
                                                     dropdownDecoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(8),
                                                       color: Colors.grey.shade50,
                                                     ),
                                                     dropdownElevation: 16,
                                                     scrollbarRadius: const Radius.circular(8),
                                                     scrollbarThickness: 6,
                                                     scrollbarAlwaysShow: true,
                                                     offset: const Offset(0, 0),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 8,),
                                               SizedBox(
                                                 height: 28, width: 28,
                                                 child: TextButton(
                                                   onPressed: () async {
                                                     isComplete = !isComplete;
                                                     search();
                                                   },
                                                   style: StyleT.buttonStyleNone(padding: 0),
                                                   child: WidgetHub.iconStyleMini(icon: Icons.task_alt, accent: isComplete),
                                                 ),
                                               ),
                                             ],
                                           ),
                                     
                                           SizedBox(width: 8,),
                                           Expanded(
                                               child:Container(
                                                 height: 36,
                                                 margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                 child: TextFormField(
                                                   maxLines: 1,
                                                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                   textInputAction: TextInputAction.newline,
                                                   keyboardType: TextInputType.multiline,
                                                   onChanged: (text) {
                                                     if(searchOption == SearchPM.address)
                                                       search(address: text);
                                                     if(searchOption == SearchPM.manager)
                                                       search(manager: text);
                                                     if(searchOption == SearchPM.client)
                                                       search(client: text);
                                                   },
                                                   decoration: WidgetHub.textInputDecoration(hintText: '검색어 입력'),
                                                   controller: searchInput,
                                                 ),
                                               )
                                           ),

                                           /// 상단 오른쪽 메뉴
                                           SizedBox(width: 8,),
                                           SizedBox(
                                             height: 28, width: 28,
                                             child: TextButton(
                                               onPressed: () async {
                                                 search();
                                               },
                                               style: StyleT.buttonStyleNone(padding: 0),
                                               child: Icon(Icons.search, size: 18, color: Colors.blueAccent,),
                                             ),
                                           ),
                                           SizedBox(width: 8,),
                                         ],
                                       ),
                                       SizedBox(height: 12,),
                                       //Container(height: 1, width: double.maxFinite, color: Colors.grey.shade400,),
                                       //Container(height: 1, color: SystemStyle.titleColor,),
                                     ],
                                   ),
                                 ),
                                 WidgetHub.dividHorizontalLow(),
                                 Row(
                                   children: [
                                     for(var y in searchYears)
                                       Expanded(
                                         child: Row(
                                           children: [
                                             Expanded(child: TextButton(
                                               onPressed: () {
                                                 if (searchSelectYear == y)
                                                   searchSelectYear = null;
                                                 else
                                                   searchSelectYear = y;

                                                 search();
                                               },
                                               style: StyleT.buttonStyleNone(padding: 12,
                                               color:(searchSelectYear == y) ? StyleT.accentColor.withOpacity(0.5) : Colors.transparent),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Text('${y.year}년', style: StyleT.titleStyle()),
                                                 ],
                                               ),
                                             ),),
                                             WidgetHub.dividViertical(height: 24),
                                           ],
                                         ),
                                       ),
                                     TextButton(
                                       onPressed: () {
                                         searchSelectYear = null;
                                         search();
                                       },
                                       style: StyleT.buttonStyleNone(color: Colors.redAccent.withOpacity(0.15) , padding: 12),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text('-', style: StyleT.titleStyle()),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                                 WidgetHub.dividHorizontalLow(),
                                 Row(
                                   children: [
                                     for(var y in searchMonth)
                                       Expanded(
                                         child: Row(
                                           children: [
                                             Expanded(child: TextButton(
                                               onPressed: () {
                                                 if (searchSelectMonth == y)
                                                   searchSelectMonth = null;
                                                 else
                                                   searchSelectMonth = y;
                                                 search();
                                               },
                                               style: StyleT.buttonStyleNone(padding: 12,
                                                   color:(searchSelectMonth == y) ? StyleT.accentColor.withOpacity(0.5) : Colors.transparent),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                 children: [
                                                   Text('${y}월', style: StyleT.titleStyle()),
                                                 ],
                                               ),
                                             ),),
                                             WidgetHub.dividViertical(height: 24),
                                           ],
                                         ),
                                       ),
                                     TextButton(
                                       onPressed: () {
                                         searchSelectMonth = null;
                                         search();
                                       },
                                       style: StyleT.buttonStyleNone(color: Colors.redAccent.withOpacity(0.15) , padding: 12),
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text('-', style: StyleT.titleStyle()),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),

                                 Container(width: double.maxFinite, height: 1.3, color: Colors.grey.shade400,),
                                 Expanded(child: main ?? SizedBox()),
                               ],
                             )
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),
       );
  }
}
*/
