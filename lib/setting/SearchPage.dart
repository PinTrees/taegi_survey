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

class SearchPage extends StatefulWidget {
  const SearchPage() : super();
  @override
  State<SearchPage> createState() => _SearchPageState();
}
class _SearchPageState extends State<SearchPage> {
  var loadText = '';
  var title = '문서 검색';

  TextEditingController searchInput = new TextEditingController();

  var pageView = [ 'main', 'info' ];
  var currentView = 'main';

  var menu = ['permit', 'contract', 'work'];
  var selectMenu = 'permit';

  List<PermitManagement> permits = [];
  List<Contract> contracts = [];
  List<WorkManagement> works = [];

  PermitManagement? selectP;

  @override
  void initState() {
    super.initState();
    initAsync();
  }
  void initAsync() async {
      setState(() {});
  }
  void search() async {
    permits.clear();
    contracts.clear();
    works.clear();

    List<PermitManagement>? permitsTmp = SystemT.permitManagementMaps.values.toList();
    var permitsAddress = await SystemT.searchPmWithAddress(searchInput.text, sort: permitsTmp.toList());
    var permitsClient = await SystemT.searchPmWithClient(searchInput.text, sort: permitsTmp.toList());

    permits.addAll(permitsAddress);
    permits.addAll(permitsClient);
    permits = permits.toSet().toList();

    List<Contract>? contractTmp = SystemT.contracts.values.toList();
    var contractAddress = await SystemT.searchCtWithAddress(searchInput.text, sort: contractTmp.toList());
    var contractClient = await SystemT.searchCtWithClient(searchInput.text, sort: contractTmp.toList());

    contracts.addAll(contractAddress);
    contracts.addAll(contractClient);
    contracts = contracts.toSet().toList();

    List<WorkManagement>? worksTmp = SystemT.workManagements.values.toList();
    var worksAddress = await SystemT.searchWmWithAddress(searchInput.text, sort: worksTmp.toList());
    var worksClient = await SystemT.searchWmWithClient(searchInput.text, sort: worksTmp.toList());

    works.addAll(worksAddress);
    works.addAll(worksClient);
    works = works.toSet().toList();

    setState(() {});
  }

  Widget main() {
    if (currentView == 'main')
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 88,),
          Container(
            width: 580,
            child: Row(
              children: [
                Expanded(child: TextFormField(
                  maxLines: 1,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onEditingComplete: () {
                    currentView = pageView[1];
                    search();
                  },
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
                    suffixIcon: Icon(Icons.keyboard),
                    hintText: '',
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  ),
                  controller: searchInput,
                ),),
                TextButton(
                  onPressed: () {

                  },
                  style: StyleT.buttonStyleNone(
                      padding: 0, color: StyleT.accentColor),
                  child: WidgetT.iconStyleBig(icon: Icons.search, size: 48),
                )
              ],
            ),
          ),
          ListView(
            padding: EdgeInsets.all(18),
            shrinkWrap: true,
            children: [],
          ),
        ],
      );
    else {
      var widthMenu = 200.0;
      List<Widget> list = [];
      if(selectMenu == 'permit') {
        for(var p in permits) {
          var w = WidgetT.pmRowExcelWidget(context, p, fun: () async {
          }, color: selectP == p ? StyleT.accentLowColor.withOpacity(0.5) : null, );
          list.add(w);
          list.add(SizedBox(height: 12,));
        }
      }
      else if(selectMenu == menu[1]) {
        for(var p in contracts) {
          var w = WidgetT.ctRowShortWidget(context, p, fun: () async {
          }, color: selectP == p ? StyleT.accentLowColor.withOpacity(0.5) : null, );
          list.add(w);
          list.add(SizedBox(height: 12,));
        }
      }
      else if(selectMenu == menu[2]) {
        for(var p in works) {
          var w = WidgetT.wmRowShortWidget(context, p, fun: () async {
          }, color: selectP == p ? StyleT.accentLowColor.withOpacity(0.5) : null, );
          list.add(w);
          list.add(SizedBox(height: 12,));
        }
      }

      return Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0, top: 0, right: 0,
            child: Column(
              children: [
                Container(
                  child:Row(
                    children: [
                      TextButton(
                        onPressed: () {
                        },
                        style: StyleT.buttonStyleNone(
                            padding: 0, color: StyleT.accentColor),
                        child: WidgetT.iconStyleBig(icon: Icons.search, size: 48),
                      ),
                      Expanded(child: TextFormField(
                        maxLines: 1,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        onEditingComplete: () async {
                          search();
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: BorderSide(
                                  color: StyleT.accentLowColor, width: 0.01)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: BorderSide(
                                color: StyleT.accentColor, width: 0.01),),
                          filled: true,
                          fillColor: Colors.transparent, //SystemStyle.accentColor.withOpacity(0.07),
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          suffixIcon: Icon(Icons.keyboard),
                          hintText: '',
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                        ),
                        controller: searchInput,
                      ),),
                      TextButton(
                        onPressed: () {

                        },
                        style: StyleT.buttonStyleNone(
                            padding: 0, color: StyleT.accentColor),
                        child: WidgetT.iconStyleBig(icon: Icons.search, size: 48),
                      ),
                    ],
                  ),
                ),
                WidgetT.dividHorizontalLow(),
                Container(
                  height: 36,
                  child:Row(
                    children: [
                      Container( width: 100,
                        child: TextButton(
                            onPressed: () {
                            },
                            style: StyleT.buttonStyleNone(
                              padding: 18,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('통합', style: StyleT.titleStyle(),),
                              ],
                            )
                        ),
                      ),
                      WidgetT.dividVerticalLow(),
                      Container( width: widthMenu,
                        child: TextButton(
                            onPressed: () {
                              selectMenu = menu[0];
                              setState(() {});
                            },
                            style: StyleT.buttonStyleNone(
                              padding: 12,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetT.iconStyleMiddle(icon: Icons.manage_search,),
                                Text('허가관리문서  ', style: StyleT.titleStyle(),),
                                Text('${permits.length}건', style: StyleT.textStyle(),),
                              ],
                            )
                        ),
                      ),
                      WidgetT.dividVerticalLow(),
                      Container( width: widthMenu,
                        child: TextButton(
                            onPressed: () {
                              selectMenu = menu[1];
                              setState(() {});
                            },
                            style: StyleT.buttonStyleNone(
                              padding: 12,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetT.iconStyleMiddle(icon: Icons.currency_exchange,),
                                Text('업무배당문서  ', style: StyleT.titleStyle(),),
                                Text('${contracts.length}건', style: StyleT.textStyle(),),
                              ],
                            )
                        ),
                      ),
                      WidgetT.dividVerticalLow(),
                      Container( width: widthMenu,
                        child: TextButton(
                            onPressed: () {
                              selectMenu = menu[2];
                              setState(() {});
                            },
                            style: StyleT.buttonStyleNone(
                              padding: 12,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                WidgetT.iconStyleMiddle(icon: Icons.engineering,),
                                Text('계약현황  ', style: StyleT.titleStyle(),),
                                Text('${works.length}건', style: StyleT.textStyle(),),
                              ],
                            )
                        ),
                      ),
                      WidgetT.dividVerticalLow(),
                    ],
                  ),
                ),
                Container(width: double.maxFinite, height: 1.4, color: Colors.grey.shade400,),
              ],
            ),
          ),
          Positioned(
            left: 0, top: 86, right: 0, bottom: 0,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.all(12),
                children: list,
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body:  WindowBorder(
        color: Colors.black.withOpacity(0.8),
        width: 0.6,
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
                      child: WidgetT.iconStyleBig(icon: Icons.arrow_back)),
                ],
              ),
            ),
            Container(height: double.maxFinite, width: 1, color: Colors.grey.shade400,),
            Expanded(
              child: Column(
                children: [
                  AppTitleBar(title: title, back: false),
                  Expanded(
                    child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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