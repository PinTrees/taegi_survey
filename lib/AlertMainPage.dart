import 'dart:convert';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';

class AlertMainPage extends StatefulWidget {
  List<PermitManagement> permits = [];
  AlertMainPage({ required this.permits});
  @override
  State<AlertMainPage> createState() => _AlertMainPageState();
}

class _AlertMainPageState extends State<AlertMainPage> {

  TextEditingController searchInput = new TextEditingController();

  var verticalScroll = new ScrollController();
  var horizontalScroll = new ScrollController();
  var titleHorizontalScroll = new ScrollController();


  var manager = [];
  var selectManager;

  var list = [];

  @override
  void initState() {
    super.initState();

    list = widget.permits.toList();
    manager = SystemControl.managers;

    horizontalScroll.addListener(() {
      titleHorizontalScroll.jumpTo(horizontalScroll.position.pixels);
    });
    initAsync();
  }
  void initAsync() async {
    setState(() {});
  }


  Widget main() {
    List<Widget> permitManagementW = [];
    for(var p in list) {
      var w = WidgetHub.pmRowWidget(context, p, endVisible: true);
      permitManagementW.add(w);
    }
    return ScrollConfiguration(
      behavior: MyCustomScrollBehavior(),
      child: AdaptiveScrollbar(
          controller: verticalScroll,
          width: 18,
          sliderSpacing: EdgeInsets.zero,
          sliderDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: StyleT.accentLowColor,
          ),
          sliderActiveDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color:  StyleT.accentLowColor,
          ),
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
                    width: WidgetHub.allSize,
                    color: StyleT.backgroundColor,
                    child: ListView(
                      controller: verticalScroll,
                      children: [
                        for(var p in permitManagementW)
                          p,
                        Container(height: 48,),
                      ],
                    )
                ),
              ))),
    );
  }
  void search() {
    if(selectManager != null) {
      list.clear();

      for(var p in widget.permits) {
        if(p.managerUid == selectManager.id)
          list.add(p);
      }
    } else {
      list = widget.permits.toList();
    }
    setState(() {});
  }

  Widget alertList() {
    List<Widget> listW = [];
    for(int i = 0; i < widget.permits.length; i++) {
      var p = widget.permits[i];

      List<Widget> endDateW = [];
      for(var _p in p.endAts) {
        var dS = _p['date'].replaceAll('.', '-');
        DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();

        int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
        difference = difference.abs();

        endDateW.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade500,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_p['type']}', style: StyleT.titleStyle(),),
                      SizedBox(width: 8,),
                      Text('${StyleT.dateTimeFormat(dD)}', style: StyleT.titleStyle(),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2,),
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  ),
                  child: Text('${difference}일', style: StyleT.titleStyle(color: Colors.white),),
                ),
              ),
            ],
          )
        );
      }

      var w = Container(
        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: TextButton(
          onPressed: () {
            openMenu(context, p);
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
            minimumSize: Size.zero,
            padding: EdgeInsets.fromLTRB(12, 18, 12, 18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.address, style: StyleT.titleStyle(),),
                    SizedBox(height: 8,),
                    Text('실무자: ${SystemControl.getManagerName(p.managerUid)}\n' + '신청인: ${p.clientName} : ${p.clientPhoneNumber}'.replaceAll('\n', ''), style: StyleT.titleStyle(),),
                    SizedBox(height: 8,),
                    Text('종료 예정일', style: StyleT.titleStyle(bold: true),),
                    SizedBox(height: 4,),
                    Wrap(
                      spacing: 8, runSpacing: 4,
                      children: [
                        for(var w in endDateW)
                          w,
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      listW.add(w);
    }
    return Column(
      children: [
        for(var w in listW)
          w,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Container(
        child: Column(
          children: [
            AppTitleBar(title: '종료 예정 허가 알림', back: false),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: 0, right: 0, top: 76, bottom: 0,
                    child:  main(),
                  ),
                  Positioned(
                    left: 0, right: 0, top: 0,
                    child: Material(
                      elevation: 8,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            color: StyleT.backgroundLowColor,
                            child: Column( mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 28,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          hint: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '실무자 선택',
                                                  style: StyleT.titleStyle(),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: manager.map((item) => DropdownMenuItem<dynamic>(
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
                                          buttonWidth: 100,
                                          buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                          buttonDecoration: StyleT.dropButtonStyle(),
                                          buttonElevation: 0,
                                          itemHeight: 32,
                                          itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                          dropdownMaxHeight: 512,
                                          dropdownWidth: 100,
                                          dropdownPadding: null,
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.grey.shade50,
                                          ),
                                          dropdownElevation: 16,
                                          scrollbarRadius: const Radius.circular(40),
                                          scrollbarThickness: 6,
                                          scrollbarAlwaysShow: true,
                                          offset: const Offset(0, 0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Container(
                                      height: 28,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                          isExpanded: true,
                                          hint: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '정렬 방식',
                                                  style: StyleT.titleStyle(),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: manager.map((item) => DropdownMenuItem<dynamic>(
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
                                            setState(() {
                                              selectManager = value;
                                              ///
                                            });
                                          },
                                          icon: selectManager != null ? SizedBox(
                                            width: 28,
                                            child: TextButton(
                                              onPressed: () {
                                                selectManager = null;
                                                setState(() {});
                                                ///
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
                                          buttonWidth: 100,
                                          buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                          buttonDecoration: StyleT.dropButtonStyle(),
                                          buttonElevation: 0,
                                          itemHeight: 32,
                                          itemPadding: const EdgeInsets.only(left: 12, right: 12),
                                          dropdownMaxHeight: 512,
                                          dropdownWidth: 100,
                                          dropdownPadding: null,
                                          dropdownDecoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.grey.shade50,
                                          ),
                                          dropdownElevation: 16,
                                          scrollbarRadius: const Radius.circular(40),
                                          scrollbarThickness: 6,
                                          scrollbarAlwaysShow: true,
                                          offset: const Offset(0, 0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Expanded(
                                        child:Container(
                                          height: 30,
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: TextFormField(
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            textInputAction: TextInputAction.newline,
                                            keyboardType: TextInputType.multiline,
                                            onChanged: (text) {
                                            },
                                            decoration: WidgetHub.textInputDecoration(hintText: '검색어 입력'),
                                            controller: searchInput,
                                          ),
                                        )
                                    ),
                                    SizedBox(width: 8,),
                                    SizedBox(
                                      height: 28, width: 28,
                                      child: TextButton(
                                        onPressed: () async {
                                        },
                                        style: StyleT.buttonStyleNone(padding: 0),
                                        child: Icon(Icons.search, size: 18, color: Colors.blueAccent,),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    SizedBox(
                                      height: 28,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: StyleT.buttonStyleNone(padding: 8, color: StyleT.accentLowColor),
                                        child: Row(
                                          children: [
                                            Icon(Icons.add_alert, color: Colors.white, size: 14,),
                                            SizedBox(width: 8,),
                                            Text(
                                              '알림 +${widget.permits.length}',
                                              style: TextStyle(color: StyleT.titleColor, fontWeight: FontWeight.normal, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    /*
                            SizedBox(
                              height: 28, width: 28,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  appWindow.hide();
                                  SystemControl.alert = true;
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                                ),
                                child: Icon(Icons.close, color: Colors.white, size: 14,),
                              ),
                            )
                             */
                                  ],
                                ),
                              ],
                            ),
                          ),
                          WidgetHub.pmRowTitleBar(titleHorizontalScroll, backgroundColor: StyleT.backgroundLowColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}

void openMenu(BuildContext context, PermitManagement p) {
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0)),

          titlePadding: EdgeInsets.all(0),
          title: Container(
            color: Colors.grey.shade300, padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                new Text("허가 목록 자세히", style: StyleT.titleStyle(),),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text("${p.address}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("실무자: ${SystemControl.getManagerName(p.managerUid)}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("신청인: ", style: StyleT.titleStyle(), ),
              new Text("${p.clients}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("용도: ", style: StyleT.titleStyle(), ),
              new Text("${p.useType}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("허가 면적 ", style: StyleT.titleStyle(), ),
              new Text("${p.area}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("허가일 ", style: StyleT.titleStyle(), ),
              new Text("${p.permitAts}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("종료일 ", style: StyleT.titleStyle(), ),
              new Text("${p.endAts}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("허가유형: ${p.permitType}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("건축사: ${(p.architectureOffice).replaceAll('\n', '')}", style: StyleT.titleStyle(), ),
              SizedBox(height: 12,),
              new Text("비고", style: StyleT.titleStyle(), ),
              new Text("${p.desc}", style: StyleT.titleStyle(), ),
            ],
          ),
          actions: <Widget>[
            new TextButton(
              child: new Text("확인", style: StyleT.titleStyle(bold: true)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}
