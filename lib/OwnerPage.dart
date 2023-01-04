import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:untitled2/ContractViewerPage.dart';
import 'package:untitled2/EditeTemplatePage.dart';
import 'package:untitled2/PermitManagementInfoPage.dart';
import 'package:untitled2/PermitManagementPage.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/SettingPage.dart';
import 'package:untitled2/WorkManagementPage.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:untitled2/setting/VersionLogPage.dart';

import 'AlertMainPage.dart';
import 'PmEditePage.dart';
import 'helper/style.dart';
import 'setting/SearchPage.dart';

enum SearchPM {
  address('address', '주소'),
  client('client', '신청인');
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

class OwnerPage extends StatefulWidget {
  bool? isAlert = false;
  OwnerPage({ this.isAlert });
  @override
  State<OwnerPage> createState() => _OwnerPageState();
}
class _OwnerPageState extends State<OwnerPage> {
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

  PermitManagement? selectP, replaceP, createP;
  WorkManagement? selectW, replaceW, createW;
  Contract? selectC, replaceC, createC;

  var infoPage;
  late PmCreatePage createPage;

  bool isEndAts = false;
  var readStart = true;

  Map<String, Widget> menuW = new Map();
  var selectMenu = 'main';

  List<PermitManagement> listP = [];
  List<Contract> listC = [];
  List<WorkManagement> listW = [];

  List<PermitManagement> listMP = [];
  List<Contract> listMC = [];
  List<WorkManagement> listMW = [];
  
  Manager? selectManager;

  ////
  late String? serverPath = 'Z:\\태기측량\\공용\\1.작업\\taegi_system_server';
  var sortMenu = [ '허가일 오름차순', '허가일 내림차순',];
  var selectSortMenu = '';
  var sortMenu1 = [ '배당일 오름차순', '배당일 내림차순',];
  var selectSortMenu1 = '';
  var sortMenu2 = [ '계약일 오름차순', '계약일 내림차순',];
  var selectSortMenu2 = '';


  var menu1 = [ '허가관리', '업무배당', '계약정보'];
  var selectMenu1 = '허가관리';

  var menu1_1 = [ '전체', '종료임박',];
  var selectMenu1_1 = '종료임박';

  var menu1_2 = [ '전체', '업무마감임박', '보완필요', '미배정'];
  var selectMenu1_2 = '업무마감임박';

  var menu1_3 = [ '전체', '정산완료', '미정산',];
  var selectMenu1_3 = '전체';

  @override
  void initState() {
    super.initState();

    selectSortMenu = sortMenu.first;
    selectSortMenu1 = sortMenu1.first;
    selectSortMenu2 = sortMenu2.first;
    initWidgetMenu();
    //horizontalScroll.addListener(() {
    //  titleHorizontalScroll.jumpTo(horizontalScroll.position.pixels);
    //});
    listP = SystemControl.permitManagements.toList();

    if(widget.isAlert != null)
      isEndAts = widget.isAlert!;
    initAsync();

    search();
  }
  void initAsync() async {
    var tmpP = SystemControl.permitManagements.toList();
    var tmpC = SystemControl.contracts.toList();
    var tmpW = SystemControl.workManagements.toList();

    var name = SystemControl.currentManager['name'];
    listMP = tmpP.toList();
    listMC = tmpC.toList();
    listMW = tmpW.toList();

    listP = listMP.toList();
    listC = listMC.toList();
    listW = listMW.toList();

    search();
  }

  void initWidgetMenu() {
    menuW.clear();
    menuW['main'] = Column(
      children: [
        TextButton(
          onPressed: () async {
            WidgetHub.loadingBottomSheet(context);
            await SystemControl.update();
            Navigator.pop(context);

            search();
            setState(() {});
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetHub.iconStyleBig(icon: Icons.refresh),
        ),
        TextButton(
          onPressed: () async {
            WidgetHub.openPageWithFade(context, SearchPage());
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:WidgetHub.iconStyleBig(icon: Icons.search),
        ),
        TextButton(
          onPressed: () async {
            WidgetHub.openPageWithFade(context, PermitManagementListViewerPage());
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child:  WidgetHub.iconStyleBig(icon: Icons.open_with),
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
      ],
    );
  }

  Widget getSideView() {
   /* if(sideViewType == 'infoP') {
      return Container(width: 360, color: Colors.transparent,
          child: Column(
            children: [
              WidgetHub.pmRowExcelEditeWidget(context, replaceP!, saveFun: saveEditDate,
              fun: () async {sideView('info', p: replaceP);},
              color: SystemStyle.backgroundColor.withOpacity(0.5), setFun: () { refresh(); setState(() {}); }),
            ],
          )
      );
    } else if(sideViewType == 'create') {
       return Container(width: 360,
          child: Column(
            children: [ Expanded(child: createPage), ],
          )
      );
    }*/
    return SizedBox();
  }
  void saveEditDate() async {
    if(replaceP == null) return;

    if((await WidgetHub.showAlertDl(context, title: replaceP!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(replaceP != null) {
      print(replaceP!.id);
      await FirebaseT.putPermitManagementWithAES(replaceP, replaceP!.id);
      var index = SystemControl.permitManagements.indexOf(selectP!);
      SystemControl.permitManagements[index] = replaceP!;
    }

    selectP = replaceP = null;
    selectMenu = 'main';

    search();
    refresh();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
    WidgetHub.clear();
  }
  void saveEditDataW() async {
    if(replaceW == null) return;

    if((await WidgetHub.showAlertDl(context, title: replaceW!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(replaceW != null) {
      print(replaceW!.id);
      await FirebaseT.postWorkManagementWithAES(replaceW, replaceW!.id);
      var index = SystemControl.workManagements.indexOf(selectW!);
      selectW!.fromDatabase(replaceW!.toJson());
      //SystemControl.workManagements[index] = replaceW!;
    }

    selectW = replaceW = null;
    selectMenu = 'main';

    search();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
    WidgetHub.clear();
  }

  void saveNewDateP() async {
    if(createP == null) return;

    print('save new doc try');
    if((await WidgetHub.showAlertDl(context, title: createP!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(createP != null) {
      await FirebaseT.pushPermitManagementWithAES(createP);
      SystemControl.permitManagements.insert(0, createP!);
    }

    selectP = createP = null;
    selectMenu = 'main';

    search();
    refresh();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
    WidgetHub.clear();
  }
  void saveNewDateW() async {
    if(createW == null) return;

    print('save new doc try');
    if((await WidgetHub.showAlertDl(context, title: createW!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(createW != null) {
      await FirebaseT.pushWorkManagementWithAES(createW);
      SystemControl.workManagements.insert(0, createW!);
    }

    selectW = createW = null;
    selectMenu = 'main';

    search();
    refresh();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
    WidgetHub.clear();
  }
  void saveNewDateC(bool isWork) async {
    if(createC == null) return;

    print('save new doc try');
    if((await WidgetHub.showAlertDl(context, title: createC!.addresses.first) as bool) == false) {
      WidgetHub.showSnackBar(context, text: '저장이 취소되었습니다.');
      return;
    }

    if(createP != null) {
      if(!isWork) {
        await FirebaseT.pushContractWithAES(createC);
      } else {
        await FirebaseT.pushContractWithAESAndWm(createC);
      }
      SystemControl.contracts.insert(0, createC!);
    }
    selectC = createC = null;
    selectMenu = 'main';

    search();
    refresh();
    WidgetHub.showSnackBar(context, text: '저장되었습니다.');
    WidgetHub.clear();
  }

  void refresh() {
    List<Widget> childrenW = [];
    Widget countW = SizedBox();
    List<Widget> childrenWC = [];

    if(selectMenu1 == menu1[0]) {
      childrenW.clear();
      countW = Text('허가관리 ${listP.length}건', style: StyleT.textStyleBig(bold: true),);
      for(var p in listP) {
        Widget w = SizedBox();
        var backColor =  selectP == p ? StyleT.accentLowColor.withOpacity(0.5) : StyleT.backgroundColor.withOpacity(0.5);
        w = WidgetHub.pmRowExcelWidget(context, p, color: backColor,
          fun: () async {
            WidgetHub.clear();

            selectP = p;
            var jsonS = jsonEncode(p);
            var j = jsonDecode(jsonS);
            replaceP = PermitManagement.fromDatabase(j);
            refresh();
          },);
        if(selectP == p) {
          w = Stack(
            children: [
              //WidgetHub.pmRowExcelWidget(context, p, color: SystemStyle.accentLowColor.withOpacity(0.1),),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: WidgetHub.pmRowExcelEditeWidget(
                    context, replaceP!, saveFun: saveEditDate,
                    fun: () async {
                      refresh();
                    },
                    color: StyleT.accentLowColor.withOpacity(0.5), setFun: () {
                  refresh();
                  setState(() {});
                }),
              )
            ],
          );
        }
        childrenW.add(w);
      }
    }

    if(selectMenu1 == menu1[1]) {
      childrenW.clear();
      countW = Text('업무배당 ${listW.length}건', style: StyleT.textStyleBig(bold: true),);
      for(int i = 0; i < listW.length; i++) {
        var p = listW[i];
        var backColor =  selectW == p ? StyleT.accentLowColor.withOpacity(0.5) : StyleT.backgroundColor.withOpacity(0.5);
        Widget w =  WidgetHub.wmRowShortWidget(context, p,
            fun: () async {
              var jsonS = jsonEncode(p);
              var j = jsonDecode(jsonS);
              replaceW = WorkManagement.fromDatabase(j);
              selectW = p;
              refresh();
            },
            color: backColor, endVisible: false, moreFun: () {
              selectW = p; refresh();
            });

        if(selectW == p) {
          w = WidgetHub.wmRowEditeWidget(context, replaceW!, saveFun: saveEditDataW,
              fun: () async { refresh(); },
              color: backColor, endVisible: false, setFun: () { refresh(); setState(() {}); });
        }
        childrenW.add(w);
      }
    }
    if(selectMenu1 == menu1[2]) {
      childrenW.clear();
      countW = Text('계약문서 ${listW.length}건', style: StyleT.textStyleBig(bold: true),);
      for(var p in listC) {
        var backColor =  selectC == p ? StyleT.accentLowColor.withOpacity(0.5) : StyleT.backgroundColor.withOpacity(0.5);
        Widget w =  WidgetHub.ctRowShortWidget(context, p,
            fun: () async {
              selectC = p;
              var jsonS = jsonEncode(p);
              var j = jsonDecode(jsonS);
              replaceC = Contract.fromDatabase(j);

              refresh();
            },
            color: backColor, endVisible: false, moreFun: () {
              selectC = p; refresh();
            });
        if(selectC == p) {
          w = WidgetHub.ctRowExcelEditorWidget(
            context, replaceC!, color: backColor, endVisible: true,
            saveFun: saveEditDate,
            setFun: () {
              setState(() {}); refresh();
            },
            fun: () async {
              //sideView('info', p: p);
            },
            closeFun: () {
              replaceP = selectP = null; refresh();
            },
          );
        }
        childrenW.add(w);
      }
    }

    main = ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: AdaptiveScrollbar(
            controller: verticalScroll,
            width: 0.1,
            sliderSpacing: EdgeInsets.zero,
            sliderDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: StyleT.accentLowColor,
            ),
            sliderActiveDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color:  StyleT.accentLowColor,
            ),
            sliderDefaultColor: Colors.transparent,
            child: AdaptiveScrollbar(
                controller: horizontalScroll,
                width: 18,
                position: ScrollbarPosition.bottom,
                sliderSpacing: EdgeInsets.zero,
                sliderDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: StyleT.accentLowColor,
                ),
                sliderActiveDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color:  StyleT.accentLowColor,
                ),
                underSpacing: EdgeInsets.only(bottom: 28),
                child: SingleChildScrollView(
                  controller: horizontalScroll,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 1300,
                    padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    child: ListView(
                      controller: verticalScroll,
                      children: [
                        SizedBox(height: 8,),
                        if(selectMenu1 == menu1[0])
                          Row(
                            children: [
                              for(var m in menu1_1)
                                Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: TextButton(
                                    onPressed: () {
                                      selectMenu1_1 = m;
                                      searchP();
                                    },
                                    style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4, color: selectMenu1_1 == m ? StyleT.accentColor.withOpacity(0.5) : StyleT.white.withOpacity(0.5) ),
                                    child:   Container( alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(m, style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                                    ),
                                  ),
                                ),
                              Container( alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: countW
                              ),
                            ],
                          ),

                        if(selectMenu1 == menu1[1])
                          Row(
                            children: [
                              for(var m in menu1_2)
                                Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: TextButton(
                                    onPressed: () {
                                      selectMenu1_2 = m;
                                      searchW();
                                    },
                                    style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4, color: selectMenu1_2 == m ? StyleT.accentColor.withOpacity(0.5) : StyleT.white.withOpacity(0.5) ),
                                    child:   Container( alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(m, style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                                    ),
                                  ),
                                ),
                              Container( alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: countW
                              ),
                            ],
                          ),

                        if(selectMenu1 == menu1[2])
                          Row(
                            children: [
                              for(var m in menu1_3)
                                Container(
                                  padding: EdgeInsets.only(right: 8),
                                  child: TextButton(
                                    onPressed: () {
                                      selectMenu1_3 = m;
                                      search();
                                    },
                                    style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4, color: selectMenu1_3 == m ? StyleT.accentColor.withOpacity(0.5) : StyleT.white.withOpacity(0.5) ),
                                    child:   Container( alignment: Alignment.center,
                                      padding: EdgeInsets.all(8),
                                      child: Text(m, style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                                    ),
                                  ),
                                ),
                              Container( alignment: Alignment.center,
                                  padding: EdgeInsets.all(8),
                                  child: countW
                              ),
                            ],
                          ),

                        SizedBox(height: 8,),
                        Container(
                          width: 1300,
                          color: Colors.transparent,
                          padding: EdgeInsets.only(right: 18),
                          child: Column(
                            children: [
                              for(var w in childrenW)
                                Container( padding: EdgeInsets.only(bottom: 8),
                                  child: w,
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 18,),
                      ],
                    ),
                  ),
                ))),
      );
    setState(() {});
  }

  void searchP() async {
    List<PermitManagement>? tmpList = listMP.toList();

    if(selectMenu1_1 == menu1_1[1]) {
      tmpList = await SystemControl.getPermitEndAtsList(30, sort: tmpList.toList());
    }

    if(selectManager != null) {
      tmpList = await SystemControl.searchPmWithManager(selectManager!.name, sort: tmpList);
    }
    if(searchSelectYear != null) {
      print(searchSelectYear);
      tmpList = await SystemControl.searchPmWithYear(searchSelectYear!.year.toString(), sort: tmpList) ?? [];
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemControl.searchPmWithMonth(searchSelectMonth!.toString(), sort: tmpList) ?? [];
    }

    if(searchOption == SearchPM.address) {
      SystemControl.searchAddress = searchInput.text;
      tmpList = await SystemControl.searchPmWithAddress(searchInput.text, sort: tmpList!.toList());
    }
    else if(searchOption == SearchPM.client) {
      tmpList = await SystemControl.searchPmWithClient(searchInput.text, sort: tmpList!.toList());
    }

    if(selectSortMenu == sortMenu.first) {
      tmpList = await SystemControl.searchPmSortF(tmpList,);
    }
    else if(selectSortMenu == sortMenu[1]) {
      tmpList = await SystemControl.searchPmSortF(tmpList, dsss: true);
    }

    listP = tmpList!.toList();


    refresh();
    setState(() {});
  }
  void searchW() async {
    List<WorkManagement>? tmpList = listMW.toList();

    if(selectMenu1_2 == menu1_2[1]) {
      tmpList = await SystemControl.searchWmSortTaskOverAtOnly(tmpList);
    }
    if(selectMenu1_2 == menu1_2[2]) {
      tmpList = await SystemControl.searchWmSortIsSum(tmpList);
    }
    if(selectMenu1_2 == menu1_2[3]) {
      tmpList =  await SystemControl.searchWmSortNullManager(tmpList);
    }

/*
    if(searchSelectYear != null) {
      print(tmpList!.length);
      tmpList = await SystemControl.searchPmWithYear(searchSelectYear!.year.toString(), sort: tmpList) ?? [];
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemControl.searchPmWithMonth(searchSelectMonth!.toString(), sort: tmpList) ?? [];
    }

    if(searchOption == SearchPM.address) {
      SystemControl.searchAddress = searchInput.text;
      tmpList = await SystemControl.searchPmWithAddress(searchInput.text, sort: tmpList!.toList());
    }
    else if(searchOption == SearchPM.client) {
      tmpList = await SystemControl.searchPmWithClient(searchInput.text, sort: tmpList!.toList());
    }

    if(selectSortMenu == sortMenu.first) {
      tmpList = await SystemControl.searchPmSortF(tmpList,);
    }
    else if(selectSortMenu == sortMenu[1]) {
      tmpList = await SystemControl.searchPmSortF(tmpList, dsss: true);
    }*/


    if(selectManager != null) {
      tmpList = await SystemControl.searchWmWithManager(selectManager!.name, sort: tmpList);
    }
    if(searchSelectYear != null) {
      print(tmpList!.length);
      tmpList = await SystemControl.searchWmWithYear(searchSelectYear!.year.toString(), sort: tmpList) ?? [];
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemControl.searchWmWithMonth(searchSelectMonth!.toString(), sort: tmpList) ?? [];
    }

    if(searchOption == SearchPM.address) {
      SystemControl.searchAddress = searchInput.text;
      tmpList = await SystemControl.searchWmWithAddress(searchInput.text, sort: tmpList!.toList());
    }
    else if(searchOption == SearchPM.client) {
      tmpList = await SystemControl.searchWmWithClient(searchInput.text, sort: tmpList!.toList());
    }

    if(selectSortMenu1 == sortMenu1.first) {
      tmpList = await SystemControl.searchWmSortF(tmpList,);
    }
    else if(selectSortMenu1 == sortMenu1[1]) {
      tmpList = await SystemControl.searchWmSortF(tmpList, dsss: true);
    }

    listW = tmpList!.toList();

    refresh();
    setState(() {});
  }
  void searchC() async {
    List<Contract>? tmpList = listMC.toList();

    if(selectMenu1_3 == menu1_3[1]) {
      tmpList = await SystemControl.searchCtWithComplete(sort: tmpList);
    }
    if(selectMenu1_3 == menu1_3[2]) {
      tmpList = await SystemControl.searchCtWithConfirm(sort: tmpList);
    }

/*
    if(searchSelectYear != null) {
      print(tmpList!.length);
      tmpList = await SystemControl.searchPmWithYear(searchSelectYear!.year.toString(), sort: tmpList) ?? [];
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemControl.searchPmWithMonth(searchSelectMonth!.toString(), sort: tmpList) ?? [];
    }

    if(searchOption == SearchPM.address) {
      SystemControl.searchAddress = searchInput.text;
      tmpList = await SystemControl.searchPmWithAddress(searchInput.text, sort: tmpList!.toList());
    }
    else if(searchOption == SearchPM.client) {
      tmpList = await SystemControl.searchPmWithClient(searchInput.text, sort: tmpList!.toList());
    }

    if(selectSortMenu == sortMenu.first) {
      tmpList = await SystemControl.searchPmSortF(tmpList,);
    }
    else if(selectSortMenu == sortMenu[1]) {
      tmpList = await SystemControl.searchPmSortF(tmpList, dsss: true);
    }*/

    if(selectManager != null) {
      tmpList = await SystemControl.searchCtWithManager(selectManager!.name, sort: tmpList);
    }
    if(searchSelectYear != null) {
      tmpList = await SystemControl.searchCtWithYear(searchSelectYear!.year.toString(), sort: tmpList) ?? [];
    }
    if(searchSelectMonth != null) {
      tmpList = await SystemControl.searchCtWithMonth(searchSelectMonth!.toString(), sort: tmpList) ?? [];
    }

    if(searchOption == SearchPM.address) {
      SystemControl.searchAddress = searchInput.text;
      //tmpList = await SystemControl.searchCtWithAddress(searchInput.text, sort: tmpList!.toList());
    }
    else if(searchOption == SearchPM.client) {
      //tmpList = await SystemControl.searchCtWithClient(searchInput.text, sort: tmpList!.toList());
    }

    if(selectSortMenu2 == sortMenu2.first) {
      tmpList = await SystemControl.searchCtSortF(tmpList,);
    }
    else if(selectSortMenu2 == sortMenu2[1]) {
      tmpList = await SystemControl.searchCtSortF(tmpList, dsss: true);
    }

    listC = tmpList!.toList();

    refresh();
    setState(() {});
  }
  void clearPage() {
    selectP = replaceP = createP = null;
    selectC = replaceC = createC = null;
    selectW = replaceW = createW = null;

    //searchSelectYear = searchSelectMonth = null;
  }

  void search() async {
    //clearPage();

    var tmpP = SystemControl.permitManagements.toList();
    var tmpC = SystemControl.contracts.toList();
    var tmpW = SystemControl.workManagements.toList();

    listMP = tmpP.toList();
    listMC = tmpC.toList();
    listMW = tmpW.toList();

    listP = listMP.toList();
    listC = listMC.toList();
    listW = listMW.toList();

    if (selectMenu1 == menu1[0])
      searchP();
    else if (selectMenu1 == menu1[1])
      searchW();
    else if (selectMenu1 == menu1[2])
      searchC();

    refresh();
    setState(() {});
  }
  void create() async {
    if (selectMenu1 == menu1[0]) {
      createP = PermitManagement.fromDatabase({});
      await WidgetHub.pmCreateExcelEditeWidgetDl(context, createP!, saveFun: saveNewDateP!);
    }
    else if (selectMenu1 == menu1[1]) {
      createW = WorkManagement.fromDatabase({});
      await WidgetHub.wmCreateExcelEditeWidgetDl(context, createW!, saveFun: saveNewDateW!);
    }
    else if (selectMenu1 == menu1[2]) {
      createC = Contract.fromDatabase({});
      await WidgetHub.ctCreateExcelEditeWidgetDl(context, createC!, saveFun: saveNewDateC!);
    }
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
                    SystemControl.alertDuDefault = 60;
                    SystemControl.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("알람 주기 1초", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    SystemControl.alertDuDefault = 1;
                    SystemControl.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("알람 주기 1시간", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () {
                    SystemControl.alertDuDefault = 3600;
                    SystemControl.alertDu = 0;
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("윈도우 경로 설정", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () async {
                    serverPath = await FilePicker.platform.getDirectoryPath();
                    if (serverPath == null) {
                      print('aaaaaaaaaaaaaa');
                      // User canceled the picker
                    }
                    print(serverPath);
                  },
                ),
                TextButton(
                  child: Text("윈도우 파일 저장", style: StyleT.titleStyle(), ),
                  style: StyleT.buttonStyleOutline(),
                  onPressed: () async {
                    var a = File('$serverPath/output-file.txt');
                    await a.writeAsString('dddddddddddddddddddddddd');
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
                               await SystemControl.updateServerUsage();
                               setState(() {});
                             },
                             style: StyleT.buttonStyleNone(padding: 6),
                             child: Column(
                               children: [
                                 SizedBox(height: 8,),
                                 WidgetHub.iconStyleBig(icon: Icons.dns, size: 24),
                                 SizedBox(height: 4,),
                                 Stack(
                                   children: [
                                     Container(width: 36, height: 3, color: Colors.grey,),
                                     Container(width: 36 * SystemControl.serverUsage, height: 3, color: Colors.red,),
                                   ],
                                 ),
                                 SizedBox(height: 8,),
                               ],
                             ),
                           ),
                           TextButton(
                             onPressed: () async {
                               isEndAts = !isEndAts;
                               WidgetHub.showSnackBar(context, text: '종료일이 가까운 목록을 표시합니다.');
                               search();
                             },
                             style: StyleT.buttonStyleNone(padding: 0,
                             color: isEndAts ? StyleT.accentColor.withOpacity(0.5) : Colors.transparent),
                             child: Column(
                               children: [
                                 WidgetHub.iconStyleBig(icon: Icons.timelapse, color: Colors.redAccent, size: 48),
                               ],
                             ),
                           ),
                           TextButton(
                             onPressed: () async {
                               await WidgetHub.showSnackBar(context);
                             },
                             style: StyleT.buttonStyleNone(padding: 0),
                             child: WidgetHub.iconStyleBig(icon: Icons.dark_mode),
                           ),
                           TextButton(
                             onPressed: () async {
                                WidgetHub.openPageWithFade(context, VersionLogPage());
                             },
                             style: StyleT.buttonStyleNone(padding: 0,
                                color: !(SystemControl.versionCheck() == 0) ? Colors.redAccent.withOpacity(0.15) : Colors.transparent),
                             child: SizedBox( width: 48, height: 36,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   WidgetHub.iconStyleMini(icon: Icons.history, size: 18),
                                  
                                   if((SystemControl.versionCheck() == 0))
                                     Text('최신', style: TextStyle(fontSize: 9, color: StyleT.titleColor),),
                                   if(!(SystemControl.versionCheck() == 0))
                                     Text('Update', style: TextStyle(fontSize: 9, color: StyleT.titleColor),),
                                 ],
                               ),
                             )
                     
                           ),
                         ],
                       ),
                   )
                 ],
               ),
               Container(width: 2, height: double.maxFinite, color: Colors.grey.shade400,),
               Expanded(
                 child: Column(
                   children: [
                     AppTitleBar(title: '  태기측량 시스템 프로그램', back: false),
                     SizedBox(height: 4,),
                     Expanded(
                       child: Row(
                         children: [
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(  crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [
                                     SizedBox(width: 12,),
                                     Text('관리자 페이지',
                                       style: TextStyle(fontSize: 24, color: StyleT.textColor.withOpacity(0.7), fontWeight: FontWeight.w700),
                                     ),
                                     SizedBox(width: 12,),
                                     Text(SystemControl.currentManager['name'] ?? '',
                                       style: TextStyle(fontSize: 18, color: StyleT.titleColor.withOpacity(0.7), fontWeight: FontWeight.w900),
                                     ),
                                     SizedBox(width: 28,),
                                     Row(
                                       children: [
                                         for(var m in menu1)
                                           Container(
                                             padding: EdgeInsets.only(right: 8),
                                             child: TextButton(
                                               onPressed: () {
                                                 selectMenu1 = m;
                                                 search();
                                               },
                                               style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4, color: selectMenu1 == m ? StyleT.accentColor.withOpacity(0.5) : StyleT.white.withOpacity(0.5) ),
                                               child:   Container( alignment: Alignment.center,
                                                 padding: EdgeInsets.all(8),
                                                 child: Text(m, style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                                               ),
                                             ),
                                           ),


                                         SizedBox(width: 36,),
                                         Container(
                                           padding: EdgeInsets.only(right: 8),
                                           child: TextButton(
                                             onPressed: () {
                                               create();
                                             },
                                             style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4, color: StyleT.accentLowColor.withOpacity(0.5) ),
                                             child:   Container( alignment: Alignment.center,
                                               padding: EdgeInsets.all(0),
                                               child: Row(
                                                 children: [
                                                   WidgetHub.iconStyleMini(icon: Icons.create_new_folder,),
                                                   Text('문서추가', style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
                                                   SizedBox(width: 8,),
                                                 ],
                                               ),
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ],
                                 ),
                                 SizedBox(height: 4,),
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
                                               if(selectMenu1 == menu1[0])
                                                 Container(
                                                   height: 32,
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
                                                         selectSortMenu = value;
                                                         search();
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
                                                       dropdownDecoration: StyleT.dropDownStyle(),
                                                       dropdownElevation: 16,
                                                       scrollbarRadius: const Radius.circular(8),
                                                       scrollbarThickness: 6,
                                                       scrollbarAlwaysShow: true,
                                                       offset: const Offset(0, -4),
                                                     ),
                                                   ),
                                                 ),
                                               if(selectMenu1 == menu1[1])
                                                 Container(
                                                   height: 32,
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
                                                       items: sortMenu1.map((item) => DropdownMenuItem<dynamic>(
                                                         value: item,
                                                         child: Text(
                                                           item,
                                                           style: StyleT.titleStyle(),
                                                           overflow: TextOverflow.ellipsis,
                                                         ),
                                                       ))
                                                           .toList(),
                                                       value: selectSortMenu1,
                                                       onChanged: (value) {
                                                         selectSortMenu1 = value;
                                                         search();
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
                                                       dropdownDecoration: StyleT.dropDownStyle(),
                                                       dropdownElevation: 16,
                                                       scrollbarRadius: const Radius.circular(8),
                                                       scrollbarThickness: 6,
                                                       scrollbarAlwaysShow: true,
                                                       offset: const Offset(0, -4),
                                                     ),
                                                   ),
                                                 ),
                                               if(selectMenu1 == menu1[2])
                                                 Container(
                                                   height: 32,
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
                                                       items: sortMenu2.map((item) => DropdownMenuItem<dynamic>(
                                                         value: item,
                                                         child: Text(
                                                           item,
                                                           style: StyleT.titleStyle(),
                                                           overflow: TextOverflow.ellipsis,
                                                         ),
                                                       ))
                                                           .toList(),
                                                       value: selectSortMenu2,
                                                       onChanged: (value) {
                                                         selectSortMenu2 = value;
                                                         search();
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
                                                       dropdownDecoration: StyleT.dropDownStyle(),
                                                       dropdownElevation: 16,
                                                       scrollbarRadius: const Radius.circular(8),
                                                       scrollbarThickness: 6,
                                                       scrollbarAlwaysShow: true,
                                                       offset: const Offset(0, -4),
                                                     ),
                                                   ),
                                                 ),

                                               SizedBox(width: 4,),
                                               Container(
                                                 height: 32,
                                                 child: DropdownButtonHideUnderline(
                                                   child: DropdownButton2(
                                                     isExpanded: true,
                                                     hint: Row(
                                                       children: [
                                                         Expanded(
                                                           child: Text(
                                                             '실무자',
                                                             style: StyleT.titleStyle(),
                                                             overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     items: SystemControl.managers.map((item) => DropdownMenuItem<dynamic>(
                                                       value: item,
                                                       child: Text(
                                                         item.name,
                                                         style: StyleT.titleStyle(),
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                     ))
                                                         .toList(),
                                                     value: selectManager,
                                                     onChanged: (value) {
                                                       selectManager = value;
                                                       search();
                                                     },
                                                     icon: selectManager != null ? SizedBox(
                                                       width: 28,
                                                       child: TextButton(
                                                         onPressed: () {
                                                           selectManager = null;
                                                           search();
                                                         },
                                                         child: Icon(
                                                           Icons.close, color: Colors.red,
                                                         ),
                                                       ),
                                                     ) : Padding(
                                                       padding: const EdgeInsets.only(right: 4),
                                                       child: Icon(Icons.expand_more,),
                                                     ),
                                                     iconSize: 14,
                                                     iconEnabledColor: StyleT.textColor,
                                                     iconDisabledColor: Colors.grey,
                                                     buttonHeight: 50,
                                                     buttonWidth: 80,
                                                     dropdownWidth: 80,
                                                     buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                                     buttonDecoration: StyleT.dropButtonStyle(),
                                                     buttonElevation: 0,
                                                     itemHeight: 32,
                                                     itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                                     dropdownMaxHeight: 512,
                                                     dropdownPadding: null,

                                                     dropdownDecoration: StyleT.dropDownStyle(),
                                                     dropdownElevation: 16,

                                                     scrollbarRadius: const Radius.circular(40),
                                                     scrollbarThickness: 6,
                                                     scrollbarAlwaysShow: true,
                                                     offset: const Offset(0, -4),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 4,),
                                               Container(
                                                 height: 32,
                                                 child: DropdownButtonHideUnderline(
                                                   child: DropdownButton2(
                                                     isExpanded: true,
                                                     hint: Row(
                                                       children: [
                                                         Expanded(
                                                           child: Text(
                                                             '년도',
                                                             style: StyleT.titleStyle(),
                                                             overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     items: searchYears.map((item) => DropdownMenuItem<dynamic>(
                                                       value: item,
                                                       child: Text(
                                                         item.year.toString() + '년',
                                                         style: StyleT.titleStyle(),
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                     ))
                                                         .toList(),
                                                     value: searchSelectYear,
                                                     onChanged: (value) {
                                                       setState(() {
                                                         searchSelectYear = value;
                                                         search();
                                                       });
                                                     },
                                                     icon: searchSelectYear != null ? SizedBox(
                                                       width: 28,
                                                       child: TextButton(
                                                         onPressed: () {
                                                           searchSelectYear = null;
                                                           setState(() {});
                                                           search();
                                                         },
                                                         child: WidgetHub.iconStyleMini(icon: Icons.cancel)
                                                       ),
                                                     ) : Padding(
                                                       padding: const EdgeInsets.only(right: 4),
                                                       child: Icon(Icons.expand_more,),
                                                     ),
                                                     iconSize: 14,
                                                     iconEnabledColor: StyleT.textColor,
                                                     iconDisabledColor: Colors.grey,
                                                     buttonHeight: 50,
                                                     buttonWidth: 80,
                                                     dropdownWidth: 80,
                                                     buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                                     buttonDecoration: StyleT.dropButtonStyle(),
                                                     buttonElevation: 0,
                                                     itemHeight: 32,
                                                     itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                                     dropdownMaxHeight: 512,
                                                     dropdownPadding: null,
                                                     dropdownDecoration: StyleT.dropDownStyle(),
                                                     dropdownElevation: 16,
                                                     scrollbarRadius: const Radius.circular(40),
                                                     scrollbarThickness: 6,
                                                     scrollbarAlwaysShow: true,
                                                     offset: const Offset(0, 0),
                                                   ),
                                                 ),
                                               ),
                                               SizedBox(width: 4),
                                               Container(
                                                 height: 32,
                                                 child: DropdownButtonHideUnderline(
                                                   child: DropdownButton2(
                                                     isExpanded: true,
                                                     hint: Row(
                                                       children: [
                                                         Expanded(
                                                           child: Text(
                                                             '월 검색',
                                                             style: StyleT.titleStyle(),
                                                             overflow: TextOverflow.ellipsis,
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                     items: searchMonth.map((item) => DropdownMenuItem<dynamic>(
                                                       value: item,
                                                       child: Text(
                                                         item.toString() + '월',
                                                         style: StyleT.titleStyle(),
                                                         overflow: TextOverflow.ellipsis,
                                                       ),
                                                     )).toList(),
                                                     value: searchSelectMonth,
                                                     onChanged: (value) {
                                                       setState(() {
                                                         searchSelectMonth = value;
                                                         search();
                                                       });
                                                     },
                                                     icon: searchSelectMonth != null ? SizedBox(
                                                       width: 28,
                                                       child: TextButton(
                                                         onPressed: () {
                                                           searchSelectMonth = null;
                                                           setState(() {});
                                                           search();
                                                         },
                                                         child: Icon(
                                                           Icons.close, color: Colors.red,
                                                         ),
                                                       ),
                                                     ) : Padding(padding: const EdgeInsets.only(right: 4), child: Icon(Icons.expand_more,),),
                                                     iconSize: 14,
                                                     iconEnabledColor: StyleT.textColor,
                                                     iconDisabledColor: Colors.grey,
                                                     buttonHeight: 50,
                                                     buttonWidth: 70,
                                                     dropdownWidth: 70,
                                                     buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                                     buttonDecoration: StyleT.dropButtonStyle(),
                                                     buttonElevation: 0,
                                                     itemHeight: 32,
                                                     itemPadding: const EdgeInsets.only(left: 12, right: 0),
                                                     dropdownMaxHeight: 512,
                                                     dropdownPadding: null,
                                                     dropdownDecoration: StyleT.dropDownStyle(),
                                                     dropdownElevation: 16,
                                                     scrollbarRadius: const Radius.circular(40),
                                                     scrollbarThickness: 6,
                                                     scrollbarAlwaysShow: true,
                                                     offset: const Offset(0, 0),
                                                   ),
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
                                                     search();
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
                                           //SizedBox(width: 8,),
                                           SizedBox(width: 8,),
                                         ],
                                       ),
                                       SizedBox(height: 8,),
                                     ],
                                   ),
                                 ),
                                 Container(width: double.maxFinite, height: 2, color: Colors.grey.shade400,),
                                 Expanded(child: main ?? SizedBox()),
                               ],
                             ),
                           ),
                           getSideView(),
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
