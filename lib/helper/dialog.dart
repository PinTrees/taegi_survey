import 'dart:convert';
import 'dart:ui';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:untitled2/AlertMainPage.dart';
import 'package:untitled2/xxx/PermitManagementPage.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';

import 'addressApi.dart';
import 'functions.dart';
import 'interfaceUI.dart';
import 'transition.dart';

class DialogT extends StatelessWidget {

  /// 고정값 변경 불가
  static var addressSize = 300.0;
  static var defaultSize = 100.0;
  static var defaultSize0 = 48.0;
  static var defaultSize1 = 68.0;
  static var defaultSize2 = 128.0;
  static var phoneNumSize = 128.0;

  static var dateSize = 200.0;

  static var areaSize = 128.0;
  static var useTypeSize = 128.0;
  static var descSize = 256.0;

  static var allSize = 2700.0;
  static ScrollController titleHorizontalScroll = new ScrollController();

  static Map<String, TextEditingController> textInputs = new Map();
  //static Map<String, FocusNode > textInputFocus = new Map();
  static Map<String, String> textOutput = new Map();
  static Map<String, bool> editInput = {};

  static dynamic dialogPm(BuildContext context, PermitManagement pN, { Function? saveFun, Color? color}) async {
    var height1 = 28.0;
    var widthAreaT = 150.0;
    var widthAddress = 550.0;
    var widthDateF = 50.0;

    bool aa = await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.15),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateS) {
              var jsonS = jsonEncode(pN);
              var j = jsonDecode(jsonS);
              PermitManagement p = PermitManagement.fromDatabase(j);
              var pYear = ' - ', pMonth = ' - ';

              if(p.getPermitAtsFirstNull() != null) {
                pYear = p.getPermitAtsFirstNull()!.year.toString();
                pMonth = p.getPermitAtsFirstNull()!.month.toString();
              }

              FunctionT.dialogRefresh = () async { setStateS(() {}); };

              return AlertDialog(
                backgroundColor: StyleT.white.withOpacity(0.9),
                elevation: 36,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400, width: 1.4),
                    borderRadius: BorderRadius.circular(8)),
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                title: Column(
                  children: [
                    Container(padding: EdgeInsets.all(12), child: Text('허가 관리 대장 문서', style: StyleT.titleStyle(bold: true))),
                    WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container( //width: 650,
                          child: TextButton(
                            onPressed: null,
                            style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container( width: widthDateF, alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text(pYear, style: StyleT.titleStyle(),),
                                            Text('년', style: StyleT.textStyle(),),
                                            Expanded(child: SizedBox()),
                                            WidgetT.dividVerticalLow(height: height1),
                                          ],
                                        ),
                                      ),
                                      Container( width: widthDateF, alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text(pMonth, style: StyleT.titleStyle(),),
                                            Text('월', style: StyleT.textStyle(),),
                                            Expanded(child: SizedBox()),
                                            WidgetT.dividVerticalLow(height: height1),
                                          ],
                                        ),
                                      ),
                                      ExcelGridEditor(isManager: true, width: 150,
                                        setData: (index, data) { p.managerUid = data; },
                                        text: '${SystemT.getManagerName(p.managerUid)}', label: '실무자', val: 'Test',),
                                      ExcelGridEditor( width: 150,
                                        setData: (index, data) { p.permitType = data; setStateS(() {}); },
                                        text: '${p.permitType}', label: '허가유형',
                                        val: p.permitType ?? '',),
                                      ExcelGridEditor(isArch: true, width: 150,
                                        setData: (index, data) { p.architectureOffice = data; },
                                        text: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', label: '건축사',
                                        val: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}',),
                                    ],
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  WidgetT.dividHorizontalLow(),
                                  Container( width: 650, height: height1,
                                    child: Row(
                                      children: [
                                        Expanded(child: ExcelGrid(label: '소재지'),),
                                        ExcelGridButton( icon: Icons.add,
                                          onPressed : () async {
                                            p.addresses.add(''); setStateS((){});
                                          },),
                                      ],
                                    ),
                                  ),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.addresses.length; i++)
                                    Container(
                                      height: height1, width: 650,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: ExcelGridEditor(isAddress: true, width: widthAddress - 28.7,
                                              setData: (index, data) { p.addresses[index!] = data; },
                                              text:  p.addresses[i], label: '소재지',
                                              val: p.addresses[i] ?? '', index: i,),
                                          ),
                                          ExcelGridButton( icon: Icons.delete,
                                            onPressed : () async {
                                              p.addresses.removeAt(i); setStateS((){});
                                            },),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),
                                  WidgetT.dividHorizontalLow(),

                                  ExcelGrid(label: '신청인', width: 650),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.clients.length; i++)
                                    Container(
                                      height: height1, width: 650,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ExcelGridEditor( width: 200,
                                            setData: (index, data) { p.clients[index!]['name'] = data; },
                                            text: p.clients[i]['name'], label: '신청인',
                                            val: p.clients[i]['name'] ?? '', index: i,),
                                          Expanded(
                                            child: ExcelGridEditor(
                                              setData: (index, data) { p.clients[index!]['phoneNumber'] = data; },
                                              text: p.clients[i]['phoneNumber'], label: '연락처',
                                              val: p.clients[i]['phoneNumber'] ?? '', index: i,),
                                          ),
                                          if(i == 0)
                                            ExcelGridButton( icon: Icons.add,
                                              onPressed: () async {
                                                p.clients.add({});  setStateS((){});
                                              }, ),
                                          if(i != 0)
                                            ExcelGridButton( icon: Icons.add,
                                              onPressed: () async {
                                                p.clients.removeAt(i);  setStateS((){});
                                              },),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:  8,),
                        Row( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: null,
                              style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container( width: 321,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: ExcelGrid(label: '허가면적', ),),
                                          ExcelGridButton( icon: Icons.add,
                                            onPressed: () async {
                                            p.area.add({}); setStateS(() {});
                                          },),
                                        ],
                                      ),
                                      WidgetT.dividHorizontalLow(),
                                      for(int i = 0; i < p.area.length; i++)
                                        Container(
                                          height: height1, width: 321,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ExcelGridEditor( width: 150,
                                                setData: (index, data) { p.area[index!]['type'] = data; },
                                                text: p.area[i]['type'] ?? '', label: '타입',
                                                val: p.area[i]['type'] ?? '', index: i,),
                                              Expanded(child: ExcelGridEditor(setData: (index, data) { p.area[index!]['area'] = data; },
                                                val: p.area[i]['area'] ?? '', width: widthAreaT,
                                                text: '${p.area[i]['area'] ?? ''} ㎡', label: '면적', index: i,),
                                              ),
                                              ExcelGridButton(onPressed: () async {
                                                p.area.removeAt(i); setStateS(() {});
                                              }, icon: Icons.delete),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width:  8,),
                            TextButton(
                              onPressed: null,
                              style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                              child: Container( width: 321,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: ExcelGrid(label: '용도', ),),
                                          ExcelGridButton(onPressed: () async {
                                            p.useType.add('');
                                            setStateS(() {});
                                          }, icon: Icons.add),
                                        ],
                                      ),
                                      WidgetT.dividHorizontalLow(),
                                      for(int i = 0; i < p.useType.length; i++)
                                        Container(
                                          height: height1,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(child: ExcelGridEditor(setData: (index, data) {
                                                p.useType[index!] = data;
                                              }, val: p.useType[i] ?? '', text: p.useType[i], label: '용도'),
                                              ),
                                              ExcelGridButton(onPressed: () async {
                                                p.useType.removeAt(i);
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:  8,),
                        Row( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: null,
                              style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                              child: Container( width: 321,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: WidgetT.excelGrid(label: '허가일', ),),
                                        ExcelGridButton(onPressed: () async {
                                          p.permitAts.add({});
                                          setStateS(() {});
                                        }, icon: Icons.add),
                                      ],
                                    ),
                                    WidgetT.dividHorizontalLow(),
                                    for(int i = 0; i < p.permitAts.length; i++)
                                      Container(
                                        height: height1, width: 325,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ExcelGridEditor(setData: (index, data) {
                                              p.permitAts[index!]['type'] = data;
                                            }, val: p.permitAts[i]['type'] ?? '', width: 125, text: p.permitAts[i]['type'] ?? '', label: '타입'),
                                            Expanded(child: ExcelGridEditor(setData: (index, data) {
                                              p.permitAts[index!]['date'] = data;
                                            }, val: p.permitAts[i]['date'] ?? '', isDate: true, text: p.permitAts[i]['date'] ?? '', label: '날짜'),
                                            ),
                                            ExcelGridButton(onPressed: () async {
                                              p.permitAts.removeAt(i);
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width:  8,),
                            TextButton(
                              onPressed: null,
                              style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                              child: Container( width: 321,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: ExcelGrid(label: '종료일', ),),
                                        ExcelGridButton(onPressed: () async {
                                          p.endAts.add({});
                                          setStateS(() {});
                                        }, icon: Icons.add),
                                      ],
                                    ),
                                    WidgetT.dividHorizontalLow(),
                                    for(int i = 0; i < p.endAts.length; i++)
                                      Container(
                                        height: height1, width: 325,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ExcelGridEditor(setData: (index, data) {
                                              p.endAts[index!]['type'] = data;
                                            }, val: p.endAts[i]['type'] ?? '', width: 125,  text: p.endAts[i]['type'] ?? '', label: '타입'),
                                            Expanded(child: ExcelGridEditor(setData: (index, data) {
                                              p.endAts[index!]['date'] = data;
                                            }, val: p.endAts[i]['date'] ?? '',  isDate: true, text: p.endAts[i]['date'] ?? '', label: '날짜'),
                                            ),
                                            ExcelGridButton(onPressed: () async {
                                              p.endAts.removeAt(i);
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:  8,),
                        TextButton(
                          onPressed: null,
                          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                          child: Container( width: 650,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ExcelGrid(label: '비고',),
                                WidgetT.dividHorizontalLow(),
                                ExcelGridEditor( multiLine: true, setData: (index, data) {
                                  p.desc = data;
                                }, val: p.desc ?? '', text: p.desc, label: ''),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
                  Column(
                    children: [
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
                                  style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
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
                                    if(saveFun != null) {
                                      await saveFun();
                                    }
                                    setStateS(() {});
                                    Navigator.pop(context);
                                  },
                                  style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentColor.withOpacity(0.5)),
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
                      ),
                    ],
                  )
                ],
              );
            },
          );
        });

    if(aa == null) aa = false;
    return aa;
  }
  static dynamic dialogInfoPm(BuildContext context, PermitManagement p, {bool isCreate=false,  Function? saveFun,  Function? setFun, Color? color}) async {
    if(isCreate) {
      p.addresses.add('');
      p.clients.add({});
      p.area.add({});
      p.useType.add('');
      p.permitAts.add({});
      p.endAts.add({});
    }

    var height1 = 28.0;
    var widthClientN = 200.0;
    var widthClientPN = 350.0;
    var widthUseType = 300.0;
    var widthAreaT = 125.0;
    var width150 = 150.0;
    var widthAddress = 550.0;
    var widthManager = 150.0;
    var widthDateD = 250.0;
    var widthDateF = 50.0;

    var pYear = ' - ', pMonth = ' - ';
    if(p.getPermitAtsFirstNull() != null) {
      pYear = p.getPermitAtsFirstNull()!.year.toString();
      pMonth = p.getPermitAtsFirstNull()!.month.toString();
    }

    bool aa = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
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
                        child: Text(isCreate ? '허가관리 대장 문서 (추가)' : '허가관리 대장 문서', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: StyleT.titleColor.withOpacity(0.7)))),
                    WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
                  ],
                ),
                content: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container( width: 650,
                            child: TextButton(
                              onPressed: null,
                              style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container( width: widthDateF, alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Expanded(child: SizedBox()),
                                              Text(pYear, style: StyleT.titleStyle(),),
                                              Text('년', style: StyleT.textStyle(),),
                                              Expanded(child: SizedBox()),
                                              WidgetT.dividVerticalLow(height: height1),
                                            ],
                                          ),
                                        ),
                                        Container( width: widthDateF, alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Expanded(child: SizedBox()),
                                              Text(pMonth, style: StyleT.titleStyle(),),
                                              Text('월', style: StyleT.textStyle(),),
                                              Expanded(child: SizedBox()),
                                              WidgetT.dividVerticalLow(height: height1),
                                            ],
                                          ),
                                        ),
                                        WidgetT.excelGridButton(fun: () async {
                                          if(setFun != null) await setFun();
                                        }, icon: Icons.calendar_month),
                                        WidgetT.excelGridEditor(context, isManager: true, setFun: () async {if(setFun != null) await setFun();setStateS(() {});},
                                            set: (index, data) {
                                              p.managerUid = data;
                                            }, key: 'ct.manager', label: '실무자', text: '${SystemT.getManagerName(p.managerUid)}', width: widthManager),
                                        WidgetT.excelGridEditor(context, setFun: () async {
                                          if(setFun != null) await setFun();
                                          setStateS(() {});
                                        }, set: (index, data) {
                                          p.permitType = data;
                                        }, val: p.permitType ?? '', width: 150, key: 'pm.permitType', text: p.permitType, label: '허가유형'),
                                        WidgetT.excelGridEditor(context, setFun: () async {
                                          if(setFun != null) await setFun();
                                          setStateS(() {});
                                        }, set: (index, data) {
                                          p.architectureOffice = data;
                                        }, val: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}',
                                            key: 'pm.architectureOffice', width: 193,
                                            text: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', label: '건축사', isArch: true),
                                      ],
                                    ),
                                    WidgetT.dividHorizontalLow(),
                                    for(int i = 0; i < p.addresses.length; i++)
                                      Container(
                                        height: height1,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(child: WidgetT.excelGridEditor(context, isAddress: true, setFun:
                                                () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                              p.addresses[index] = data;
                                            }, val: p.addresses[i] ?? '', key: '$i::pm.addresses', text: p.addresses[i], label: '소재지'),),
                                            if(i == 0)
                                              WidgetT.excelGridButton(fun: () async {
                                                p.addresses.add('');
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.add),
                                            if(i != 0)
                                              WidgetT.excelGridButton(fun: () async {
                                                p.addresses.removeAt(i);
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                          ],
                                        ),
                                      ),
                                    WidgetT.dividHorizontalLow(),

                                    WidgetT.excelGrid(label: '신청인', width: widthClientN + widthClientPN + 28.7),
                                    WidgetT.dividHorizontalLow(),
                                    for(int i = 0; i < p.clients.length; i++)
                                      Container(
                                        height: height1,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            WidgetT.excelGridEditor(context, setFun: () async {
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, set: (index, data) {
                                              p.clients[index]['name'] = data;
                                            }, val: p.clients[i]['name'] ?? '', width: widthClientN, key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                                            WidgetT.excelGridEditor(context, setFun: () async {
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, set: (index, data) {
                                              p.clients[index]['phoneNumber'] = data;
                                            }, val: p.clients[i]['phoneNumber'] ?? '', width: widthClientPN, key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                                            if(i == 0)
                                              WidgetT.excelGridButton(fun: () async {
                                                p.clients.add({});
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.add),
                                            if(i != 0)
                                              WidgetT.excelGridButton(fun: () async {
                                                p.clients.removeAt(i);
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                          ],
                                        ),
                                      ),
                                    WidgetT.dividHorizontalLow(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height:  8,),
                          Row( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container( width: 321,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: ExcelGrid(label: '허가면적', ),),
                                            ExcelGridButton( icon: Icons.add,
                                              onPressed: () async {
                                                p.area.add({}); setStateS(() {});
                                              },),
                                          ],
                                        ),
                                        WidgetT.dividHorizontalLow(),
                                        for(int i = 0; i < p.area.length; i++)
                                          Container(
                                            height: height1,
                                            alignment: Alignment.center,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                WidgetT.excelGridEditor(context, setFun: () async {
                                                  if(setFun != null) await setFun();
                                                  setStateS(() {});
                                                }, set: (index, data) {
                                                  p.area[index]['type'] = data;
                                                }, val: p.area[i]['type'] ?? '', width: width150, key: '$i::pm.area.type', text: p.area[i]['type'] ?? '', label: '타입'),
                                                Expanded(
                                                  child: WidgetT.excelGridEditor(context, setFun: () async {
                                                    if(setFun != null) await setFun();
                                                    setStateS(() {});
                                                  }, set: (index, data) {
                                                    p.area[index]['area'] = data;
                                                  }, val: p.area[i]['area'] ?? '', width: widthAreaT, key: '$i::pm.area.area', text: '${p.area[i]['area'] ?? ''} ㎡', label: '면적'),
                                                ),
                                                WidgetT.excelGridButton(fun: () async {
                                                  p.area.removeAt(i);
                                                  if(setFun != null) await setFun();
                                                  setStateS(() {});
                                                }, icon: Icons.delete),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width:  8,),
                              TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: Container( width: 321,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: ExcelGrid(label: '용도', ),),
                                            ExcelGridButton(onPressed: () async {
                                              p.useType.add('');
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          ],
                                        ),
                                        WidgetT.dividHorizontalLow(),
                                        for(int i = 0; i < p.useType.length; i++)
                                          Container(
                                            height: height1,
                                            alignment: Alignment.center,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: WidgetT.excelGridEditor(context, setFun: () async {
                                                    if(setFun != null) await setFun();
                                                    setStateS(() {});
                                                  }, set: (index, data) {
                                                    p.useType[index] = data;
                                                  }, val: p.useType[i] ?? '', key: '$i::pm.useType', text: p.useType[i], label: '용도'),
                                                ),
                                                 WidgetT.excelGridButton(fun: () async {
                                                  p.useType.removeAt(i);
                                                  if(setFun != null) await setFun();
                                                  setStateS(() {});
                                                }, icon: Icons.delete),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:  8,),
                          Row( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: Container( width: 321,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: WidgetT.excelGrid(label: '허가일', ),),
                                          ExcelGridButton(onPressed: () async {
                                            p.permitAts.add({});
                                            setStateS(() {});
                                          }, icon: Icons.add),
                                        ],
                                      ),
                                      WidgetT.dividHorizontalLow(),
                                      for(int i = 0; i < p.permitAts.length; i++)
                                        Container(
                                          height: height1,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              WidgetT.excelGridEditor(context, setFun: () async {
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, set: (index, data) {
                                                p.permitAts[index]['type'] = data;
                                              }, val: p.permitAts[i]['type'] ?? '', width: widthAreaT, key: '$i::pm.permitAts.type', text: p.permitAts[i]['type'] ?? '', label: '타입'),
                                              Expanded(child:  WidgetT.excelGridEditor(context, setFun: () async {
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, set: (index, data) {
                                                p.permitAts[index]['date'] = data;
                                              }, val: p.permitAts[i]['date'] ?? '', isDate: true, key: '$i::pm.permitAts.date', text: p.permitAts[i]['date'] ?? '', label: '날짜'),
                                              ),
                                               WidgetT.excelGridButton(fun: () async {
                                                p.permitAts.removeAt(i);
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width:  8,),
                              TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: Container( width: 321,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(child: ExcelGrid(label: '종료일', ),),
                                          ExcelGridButton(onPressed: () async {
                                            p.endAts.add({});
                                            setStateS(() {});
                                          }, icon: Icons.add),
                                        ],
                                      ),
                                      WidgetT.dividHorizontalLow(),
                                      for(int i = 0; i < p.endAts.length; i++)
                                        Container(
                                          height: height1,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              WidgetT.excelGridEditor(context, setFun: () async {
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, set: (index, data) {
                                                p.endAts[index]['type'] = data;
                                              }, val: p.endAts[i]['type'] ?? '', width: widthAreaT, key: '$i::pm.endAts.type', text: p.endAts[i]['type'] ?? '', label: '타입'),
                                              Expanded(
                                                child: WidgetT.excelGridEditor(context, setFun: () async {
                                                  if(setFun != null) await setFun();
                                                  setStateS(() {});
                                                }, set: (index, data) {
                                                  p.endAts[index]['date'] = data;
                                                }, val: p.endAts[i]['date'] ?? '', width: widthDateD, isDate: true, key: '$i::pm.endAts.date', text: p.endAts[i]['date'] ?? '', label: '날짜'),
                                              ),
                                              WidgetT.excelGridButton(fun: () async {
                                                p.endAts.removeAt(i);
                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:  8,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetT.excelGrid(label: '비고',),
                                      WidgetT.dividHorizontalLow(),
                                      WidgetT.excelGridEditor(context, multiLine: true, setFun: () async {
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.desc = data;
                                      }, val: p.desc ?? '', key: 'pm.desc', text: p.desc, label: ''),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                                if(saveFun != null) {
                                  await saveFun();
                                }
                                setStateS(() {});
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 8,
                                  color: isCreate ? StyleT.accentColor.withOpacity(0.5) : StyleT.accentLowColor.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  WidgetT.iconStyleMini(icon: Icons.save),
                                  Text(isCreate ? '저장하기' : '수정하기', style: StyleT.titleStyle(),),
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

 /* static dynamic dialogCt(BuildContext context, Contract p,
      { bool endVisible=false, Function? fun, Function(bool)? saveFun, Function? setFun,
        bool viewShort=false, Color? color}) async {

    p.addresses.add('');
    p.clients.add({});
    p.useType.add('');

    var height1 = 28.0;
    var widthPay = 200.0;
    var widthManager = 150.0;
    var widthAddress = 600.0;
    var widthDateF = 50.0;
    var widthClientN = 250.0;
    var widthClientPN = 350.0;

    var pYear = ' - ', pMonth = ' - ';
    if(p.getContractAtsFirst() != null) {
      pYear = p.getContractAtsFirst()!.year.toString();
      pMonth = p.getContractAtsFirst()!.month.toString();
    }

    bool aa = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
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
                title: Container(padding: EdgeInsets.all(12), child: Text('계약현황 문서 추가', style: StyleT.titleStyle(bold: true))),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded( //width: 550 + 28.7,
                              child: TextButton(
                                onPressed: null,
                                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container( width: widthDateF, alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Expanded(child: SizedBox()),
                                                Text(pYear, style: StyleT.titleStyle(),),
                                                Text('년', style: StyleT.textStyle(),),
                                                Expanded(child: SizedBox()),
                                                WidgetHub.dividVerticalLow(height: height1),
                                              ],
                                            ),
                                          ),
                                          Container( width: widthDateF, alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Expanded(child: SizedBox()),
                                                Text(pMonth, style: StyleT.titleStyle(),),
                                                Text('월', style: StyleT.textStyle(),),
                                                Expanded(child: SizedBox()),
                                                WidgetHub.dividVerticalLow(height: height1),
                                              ],
                                            ),
                                          ),
                                          excelGridButton(fun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, icon: Icons.calendar_month),
                                          excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              width: widthManager, alignment: Alignment.centerLeft, isManager: true,
                                              set: (index, data) {
                                                p.managerUid = data;
                                              }, key: 'ct.manager', text: '${SystemT.getManagerName(p.managerUid)}',
                                              label: '실무자'),
                                          excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                                p.landType = data;
                                              }, val: p.landType ?? '', width: 150,
                                              key: 'ct.landType', text: p.landType, label: '지목'),
                                        ],
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      WidgetHub.dividHorizontalLow(),
                                      Container( width: widthClientN + widthClientPN,
                                        child: Row(
                                          children: [
                                            Expanded(child: excelGrid(label: '소재지',)),
                                            excelGridButton(fun: () async {
                                              p.addresses.add('');
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          ],
                                        ),
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      for(int i = 0; i < p.addresses.length; i++)
                                        Container(
                                          height: height1, width: widthAddress,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: excelGridEditor(context, isAddress: true, width: widthAddress - 28,
                                                    setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                    set: (index, data) {
                                                      p.addresses[index] = data;
                                                    }, val: p.addresses[i] ?? '', key: '$i::ct.addresses',
                                                    text: p.addresses[i], label: '소재지'),
                                              ),
                                              excelGridButton(fun: () async {
                                                if(p.addresses.length <= 1) p.addresses[0] = '';
                                                else p.addresses.removeAt(i);

                                                if(setFun != null) await setFun();
                                                setStateS(() {});
                                              }, icon: Icons.delete),
                                            ],
                                          ),
                                        ),
                                      WidgetHub.dividHorizontalLow(),
                                      WidgetHub.dividHorizontalLow(),

                                      Container( width: widthClientN + widthClientPN,
                                        child: Row(
                                          children: [
                                            Expanded(child: excelGrid(label: '신청인',)),
                                            excelGridButton(fun: () async {
                                              p.clients.add({});
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          ],
                                        ),
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      for(int i = 0; i < p.clients.length; i++)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: height1, width: widthClientN + widthClientPN,
                                              alignment: Alignment.center,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded( flex: 3,
                                                    child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                        set: (index, data) {
                                                      p.clients[index]['name'] = data;
                                                    }, val: p.clients[i]['name'] ?? '',  key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                                                  ),
                                                  Expanded( flex: 7,
                                                    child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                        set: (index, data) {
                                                      p.clients[index]['phoneNumber'] = data;
                                                    }, val: p.clients[i]['phoneNumber'] ?? '', key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                                                  ),
                                                  excelGridButton(fun: () async {
                                                    p.clients.removeAt(i);
                                                    if(setFun != null) await setFun();
                                                    setStateS(() {});
                                                  }, icon: Icons.delete),
                                                ],
                                              ),
                                            ),
                                            WidgetHub.dividHorizontalLow(),
                                          ],
                                        ),

                                      WidgetHub.dividHorizontalLow(),
                                      excelGrid(label: '계약 정보', width: widthPay * 5 ),
                                      WidgetHub.dividHorizontalLow(),
                                      Row(
                                        children: [
                                          excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.downPayment = int.tryParse(data) ?? 0;
                                          }, val: (p.downPayment == 0) ? '' : p.downPayment.toString(), width: widthPay,
                                              key: 'ct.downPayment', text: StyleT.intNumberF(p.downPayment), label: '계약금'),
                                          excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.middlePayments.clear();
                                            for(var d in data.split('/'))
                                              p.middlePayments.add(int.tryParse(d.toString().trim()) ?? 0);
                                          }, val: p.getMiddlePaysToEdite(), width: widthPay * 2,
                                              key: 'ct.middlePayments', text: p.getMiddlePaysToString(),
                                              label: '중도금 ( / / )'),
                                          excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.balance = int.tryParse(data) ?? 0;
                                          }, val: (p.balance == 0) ? '' : p.balance.toString(), width: widthPay,
                                              key: 'ct.balance', text: StyleT.intNumberF(p.balance), label: '잔금'),
                                          excelGrid(width: widthPay, label: '총용역비용', text: '${StyleT.intNumberF(p.getAllPay())}'),
                                        ],
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      Row(
                                          children: [
                                            excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                isDropMenu: true, dropMenus: ['포함', '미포함'],
                                                set: (index, data) {
                                                  if(data == '포함') p.isVAT = true;
                                                  else p.isVAT = false;
                                                },
                                                key: 'ct.isVAT',
                                                width: widthPay,
                                                text: p.isVAT ? '포함' : '미포함',
                                                label: '부가세'),
                                            excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                width: widthPay * 2, alignment: Alignment.centerLeft,
                                                set: (index, data) {
                                                  p.thirdParty = data.split(',');
                                                }, val: p.thirdParty.join(','),
                                                key: 'ct.thirdParty', text: p.thirdParty.join(',  '), label: '타사업무내용 ( , , )'),
                                          ]
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      Row(
                                          children: [
                                            excelGrid(width: widthPay, label: '미수금', text: '- ${StyleT.intNumberF(p.getAllPay() - p.getAllCfPay())}'),
                                            excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                alignment: Alignment.centerLeft,
                                                set: (index, data) {
                                                  p.useType = data.split(',');
                                                }, val: p.useType.join(','), width: widthPay * 3,
                                                key: 'ct.useType', text: p.useType.join(',  '), label: '사업목적 ( , , )'),
                                          ]
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      Row(
                                        children: [
                                          excelGridEditor(context, isDate: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.contractAt = data ?? '';
                                          }, val: p.contractAt, width: widthPay,
                                              key: 'ct.contractAt', text: p.contractAt, label: '계약일'),
                                          excelGridEditor(context, isDate: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.takeAt = data ?? '';
                                          }, val: p.takeAt, width: widthPay,
                                              key: 'ct.takeAt', text: p.takeAt, label: '업무배당일'),
                                          excelGridEditor(context, isDate: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.applyAt = data ?? '';
                                          }, val: p.applyAt, width: widthPay,
                                              key: 'ct.applyAt', text: p.applyAt, label: '접수일'),
                                          excelGridEditor(context, isDate: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                              set: (index, data) {
                                            p.permitAt = data ?? '';
                                          }, val: p.permitAt, width: widthPay,
                                              key: 'ct.permitAt', text: p.permitAt, label: '허가일'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:  8,),
                        TextButton(
                          onPressed: null,
                          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                          child: Container( width: 1000,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: excelGrid(label: '입금 내역 정보',),),
                                    excelGridButton(fun: () async {
                                      p.confirmDeposits.add({});
                                      if(setFun != null) await setFun();
                                      setStateS(() {});
                                    }, icon: Icons.add),
                                  ],
                                ),
                                WidgetHub.dividHorizontalLow(),
                                for(int i = 0; i < p.confirmDeposits.length; i++)
                                  Row(
                                    children: [
                                      excelGridEditor(context, isDate: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          set: (index, data) {
                                            p.confirmDeposits[i]['date'] = data;
                                          }, val: p.confirmDeposits[i]['date'], width: 150,
                                          key: '$i::ct.confirmDeposits.date', text: p.confirmDeposits[i]['date'], label: '입금날짜'),
                                      excelGridEditor(context, isDropMenu: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          dropMenus: [ '-81', '-51', '카드결제', '기타' ],
                                          set: (index, data) {
                                            p.confirmDeposits[i]['account'] = data;
                                          }, val: p.confirmDeposits[i]['account'], width: 100,
                                          key: '$i::ct.confirmDeposits.account', text: p.confirmDeposits[i]['account'], label: '계좌'),
                                      excelGridEditor(context, isDropMenu: true, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          dropMenus: [ '계약금', '중도금', '잔금', '기타' ],
                                          set: (index, data) {
                                            p.confirmDeposits[i]['type'] = data;
                                          }, val: p.confirmDeposits[i]['type'], width: 100,
                                          key: '$i::ct.confirmDeposits.type', text: p.confirmDeposits[i]['type'], label: '분류'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          set: (index, data) {
                                            p.confirmDeposits[i]['balance'] = int.tryParse(data) ?? 0;
                                          }, val: p.confirmDeposits[i]['balance'].toString(), width: widthPay,
                                          key: '$i::ct.confirmDeposits.balance', text: StyleT.intNumberF(p.confirmDeposits[i]['balance']), label: '금액'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          set: (index, data) {
                                            p.confirmDeposits[i]['uid'] = data;
                                          }, val: p.confirmDeposits[i]['uid'], width: 150,
                                          key: '$i::ct.confirmDeposits.uid', text: p.confirmDeposits[i]['uid'], label: '입금자'),
                                      Expanded(
                                        child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                            set: (index, data) {
                                              p.confirmDeposits[i]['desc'] = data;
                                            }, val: p.confirmDeposits[i]['desc'],
                                            key: '$i::ct.confirmDeposits.desc', text: p.confirmDeposits[i]['desc'], label: '입금내용'),
                                      ),
                                      excelGridButton(fun: () async {
                                        p.confirmDeposits.removeAt(i);
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, icon: Icons.delete),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height:  8,),
                        TextButton(
                          onPressed: null,
                          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4,
                              color: color ?? Colors.white.withOpacity(0.5)),
                          child: Container(
                            width: 1000,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: excelGrid(label: '타사업무내용 및 특이사항',)),
                                    Expanded(child: excelGrid(label: '비고', )),
                                  ],
                                ),
                                WidgetHub.dividHorizontalLow(),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                            multiLine: true,
                                            set: (index, data) {
                                              p.thirdPartyDetails = data;
                                            }, val: p.thirdPartyDetails,
                                            key: 'ct.thirdPartyDetails', text: p.thirdPartyDetails, label: '내용'),
                                      ),
                                      Expanded(
                                        child: excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                            multiLine: true,
                                            set: (index, data) {
                                              p.desc = data;
                                            }, val: p.desc,
                                            key: 'ct.desc', text: p.desc, label: '내용'),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
                                  color: Colors.redAccent.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.cancel),
                                  Text('취소', style: StyleT.titleStyle(),),
                                  SizedBox(width: 12,),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 8,),
                        //Expanded(child:Container()),
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                if(saveFun != null) {
                                  await saveFun(false);
                                }
                                setStateS(() {});
                                Navigator.pop(context, true);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentColor.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.save),
                                  Text('저장하기', style: StyleT.titleStyle(),),
                                  SizedBox(width: 12,),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 8,),
                        //Expanded(child:Container()),
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                if(saveFun != null) {
                                  await saveFun(true);
                                }
                                setStateS(() {});
                                Navigator.pop(context, true);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentLowColor.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.save_as),
                                  Text('업무배당 자동 추가', style: StyleT.titleStyle(),),
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

  static dynamic dialogWm(BuildContext context, WorkManagement p,
      { bool endVisible=false, Function? fun, Function()? saveFun, Function? setFun,
        bool viewShort=false, Color? color}) async {

    p.addresses.add('');
    p.clients.add({});

    var height1 = 28.0;
    var widthDateAt = 200.0;
    var widthPay = 200.0;
    var widthAddress = 500.0;
    var widthClient = 350.0;
    var widthManager = 150.0;
    var widthDateF = 50.0;

    bool aa = await showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
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
                title: Container(padding: EdgeInsets.all(12), child: Text('업무관리 추가', style: StyleT.titleStyle(bold: true))),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: null,
                          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                          child:  Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: p.isSupplement ? Colors.red.withOpacity(0.03) : Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: height1,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container( width: widthDateF, alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text('${p.getTaskAt()!.year}', style: StyleT.titleStyle(),),
                                            Text('년', style: StyleT.textStyle(),),
                                            Expanded(child: SizedBox()),
                                            WidgetHub.dividVerticalLow(height: height1),
                                          ],
                                        ),
                                      ),
                                      Container( width: widthDateF, alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text('${p.getTaskAt()!.month}', style: StyleT.titleStyle(),),
                                            Text('월', style: StyleT.textStyle(),),
                                            Expanded(child: SizedBox()),
                                            WidgetHub.dividVerticalLow(height: height1),
                                          ],
                                        ),
                                      ),
                                      excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, width: widthManager,
                                          alignment: Alignment.centerLeft, isManager: true,
                                          set: (index, data) {
                                            p.managerUid = data;
                                            setStateS(() {});
                                          }, key: 'pm.manager', text: '${SystemT.getManagerName(p.managerUid)}',
                                          label: '실무자'),
                                    ],
                                  ),
                                ),
                                WidgetHub.dividHorizontalLow(),
                                WidgetHub.dividHorizontalLow(),
                                Container( width: 600,
                                  child: Row(
                                    children: [
                                      Expanded(child: excelGrid(label: '소재지'),),
                                      excelGridButton(fun: () async {
                                        p.addresses.add('');
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, icon: Icons.add),
                                    ],
                                  ),
                                ),
                                WidgetHub.dividHorizontalLow(),
                                for(int i = 0; i < p.addresses.length; i++)
                                  Container(
                                    height: height1, width: 600,
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: excelGridEditor(context, isAddress: true, width: widthAddress - 28.7,
                                              setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                                p.addresses[index] = data;
                                              }, val: p.addresses[i] ?? '', key: '$i::pm.addresses',
                                              text: p.addresses[i], label: '소재지'),
                                        ),
                                        excelGridButton(fun: () async {
                                          p.addresses.removeAt(i);
                                          if(setFun != null) await setFun();
                                          setStateS(() {});
                                        }, icon: Icons.delete),
                                      ],
                                    ),
                                  ),
                                WidgetHub.dividHorizontalLow(),
                                WidgetHub.dividHorizontalLow(),
                                Container( width: 600,
                                  child: Row(
                                    children: [
                                      Expanded(child: excelGrid(label: '신청인',)),
                                      excelGridButton(fun: () async {
                                        p.clients.add({});
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, icon: Icons.add),
                                    ],
                                  ),
                                ),
                                WidgetHub.dividHorizontalLow(),
                                for(int i = 0; i < p.clients.length; i++)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height1, width: 600,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded( flex: 3,
                                              child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                  set: (index, data) {
                                                    p.clients[index]['name'] = data;
                                                  }, val: p.clients[i]['name'] ?? '',  key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                                            ),
                                            Expanded( flex: 7,
                                              child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                                  set: (index, data) {
                                                    p.clients[index]['phoneNumber'] = data;
                                                  }, val: p.clients[i]['phoneNumber'] ?? '', key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                                            ),
                                            excelGridButton(fun: () async {
                                              p.clients.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                          ],
                                        ),
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                    ],
                                  ),
                                WidgetHub.dividHorizontalLow(),
                                excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                    alignment: Alignment.center,
                                    set: (index, data) {
                                      p.useType = data.split(',');
                                    }, val: p.useType.join(','), width: 600,
                                    key: 'ct.useType', text: p.useType.join(',  '), label: '사업목적 ( , , )'),
                                WidgetHub.dividHorizontalLow(),
                                WidgetHub.dividHorizontalLow(),
                                Container(
                                  height: height1,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                        p.workAts['survey'] = data;
                                      }, val: p.workAts['survey'] ?? '', width: widthDateAt, key: 'wm.workAts.survey', text: p.workAts['survey'], label: '측량일'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                        p.workAts['design'] = data;
                                      }, val: p.workAts['design'] ?? '', width: widthDateAt, key: 'wm.workAts.design', text: p.workAts['design'], label: '설계'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                        p.workAts['doc'] = data;
                                      }, val: p.workAts['doc'] ?? '', width: widthDateAt, key: 'wm.workAts.doc', text: p.workAts['doc'], label: '문서'),
                                    ],
                                  ),
                                ),
                                WidgetHub.dividHorizontalLow(),
                                Container(
                                  height: height1,
                                  alignment: Alignment.center,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                        p.workAts['survey_name'] = data;
                                      }, val: p.workAts['survey_name'] ?? '', width: widthDateAt, key: 'wm.workAts.survey_name',
                                          text: p.workAts['survey_name'], label: '측량자'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                        p.workAts['design_name'] = data;
                                      }, val: p.workAts['design_name'] ?? '', width: widthDateAt, key: 'wm.workAts.design_name',
                                          text: p.workAts['design_name'], label: '설계자'),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                        p.workAts['doc_name'] = data;
                                      }, val: p.workAts['doc_name'] ?? '', width: widthDateAt, key: 'wm.workAts.doc_name',
                                          text: p.workAts['doc_name'], label: '문서작성자'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        TextButton(
                          onPressed: null,
                          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
                          child:  Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: p.isSupplement ? Colors.red.withOpacity(0.03) : Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container( width: 600,
                                  child: Row(
                                    children: [
                                      Expanded(child: excelGrid(label: '업무 배당 마감일',)),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                          isDropMenu: true, dropMenus: ['필요', '없음'],
                                          set: (index, data) {
                                            if(data == '필요') p.isSupplement = true;
                                            else p.isSupplement = false;
                                          },
                                          key: 'ct.isVAT',
                                          width: widthPay,
                                          text: p.isSupplement ? '필요' : '없음',
                                          label: '보완'),
                                    ],
                                  ),
                                ),
                                WidgetHub.dividHorizontalLow(),
                                if(p.isSupplement)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetHub.dividHorizontalLow(),
                                      Container(
                                        height: height1,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                              p.supplementAt = data;
                                            }, val: p.supplementAt ?? '', width: widthDateAt, key: 'wm.supplementAt',
                                                text: p.supplementAt, label: '보완일'),
                                            excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                              p.supplementOverAt = data;
                                            }, val: p.supplementOverAt ?? '', width: widthDateAt, key: 'wm.supplementOverAt',
                                                text: p.supplementOverAt, label: '보완마감일'),
                                            Container( width: widthDateAt, alignment: Alignment.center,
                                              color: (p.getSupplementOverAmount() > -3 && p.getSupplementOverAmount() < 3) ?
                                              Colors.red.withOpacity(0.15) : null,
                                              child: (p.getSupplementOverAmount() > -3) ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감까지  ', style: StyleT.textStyle(),),
                                                  Text('${p.getSupplementOverAmount()}일', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetHub.dividVerticalLow(height: height1),
                                                ],
                                              ) : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감일  ', style: StyleT.textStyle(),),
                                                  Text('${p.getSupplementOverAmount().abs()}일 지남', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetHub.dividVerticalLow(height: height1),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      WidgetHub.dividHorizontalLow(),
                                      excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, multiLine: true, set: (index, data) {
                                        p.supplementDesc = data;
                                      }, val: p.supplementDesc ?? '', width: 600, key: 'wm.supplementDesc',
                                          text: p.supplementDesc, label: '보완내용'),
                                    ],
                                  ),
                                if(!p.isSupplement)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      WidgetHub.dividHorizontalLow(),
                                      Container(
                                        height: height1,
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                              p.taskAt = data;
                                            }, val: p.taskAt ?? '', width: widthDateAt, key: 'wm.taskAt', text: p.taskAt, label: '업무배당일'),
                                            excelGridEditor(context, setFun: () { if(setFun != null) setFun(); setStateS(() {}); }, isDate:true, set: (index, data) {
                                              p.taskOverAt = data;
                                            }, val: p.taskOverAt ?? '', width: widthDateAt, key: 'wm.taskOverAt', text: p.taskOverAt, label: '업무마감일'),
                                            Container( width: widthDateAt, alignment: Alignment.center,
                                              color: (p.getTaskOverAmount() > -3 && p.getTaskOverAmount() < 3) ?
                                              Colors.red.withOpacity(0.15) : null,
                                              child: (p.getTaskOverAmount() > -3) ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감까지  ', style: StyleT.textStyle(),),
                                                  Text('${p.getTaskOverAmount()}일', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetHub.dividVerticalLow(height: height1),
                                                ],
                                              ) : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감일  ', style: StyleT.textStyle(),),
                                                  Text('만료', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetHub.dividVerticalLow(height: height1),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
                                  color: Colors.redAccent.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.cancel),
                                  Text('취소', style: StyleT.titleStyle(),),
                                  SizedBox(width: 12,),
                                ],
                              )
                          ),
                        ),
                        SizedBox(width: 8,),
                        //Expanded(child:Container()),
                        Container( height: 28,
                          child: TextButton(
                              onPressed: () async {
                                if(saveFun != null) {
                                  await saveFun();
                                }
                                setStateS(() {});
                                Navigator.pop(context);
                              },
                              style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentColor.withOpacity(0.5)),
                              child: Row( mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.save),
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
*/
  static dynamic showAlertDl(BuildContext context, { String? title }) async {
    bool aa = await showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierColor: Colors.black.withOpacity(0.2),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.9),
            elevation: 36,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade400, width: 1.4),
                borderRadius: BorderRadius.circular(8)),
            titlePadding: EdgeInsets.zero,
            contentPadding:  EdgeInsets.all(18),
            title: Container(padding: EdgeInsets.all(18), child: Text('알림', style: StyleT.titleStyle(bold: true))),
            content: Text('\"$title.json\" 을(를) 시스템에 저장하시겠습니까?', style: StyleT.titleStyle()),
            actionsPadding: EdgeInsets.all(14),
            actions: <Widget>[
              Row(
                children: [
                  Container( height: 28,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
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
                  Expanded(child:Container()),
                  Container( height: 28,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentColor.withOpacity(0.5)),
                        child: Row( mainAxisSize: MainAxisSize.min,
                          children: [
                            WidgetT.iconStyleMini(icon: Icons.check_circle),
                            Text('확인', style: StyleT.titleStyle(),),
                            SizedBox(width: 12,),
                          ],
                        )
                    ),
                  ),
                ],
              )
            ],
          );
        });

    if(aa == null) aa = false;
    return aa;
  }
  static dynamic showAlertDlVersion(BuildContext context, { String? title, bool force=true }) async {
    bool aa = await showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.85),
            elevation: 4,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(0.0)),
            titlePadding: EdgeInsets.zero,
            contentPadding:  EdgeInsets.all(18),
            title: Container(padding: EdgeInsets.all(18), child: Text('중요 알림', style: StyleT.titleStyle(color: Colors.red, bold: true))),
            content: Text('현재 최신버전이 아닙니다.'
                '\n버전을 업데이트 해 주세요. (폴더를 복사)'
                '\nZ:태기측량/태기측량 시스템 프로그램/(버전코드)'
                '\n\n최신버전: ${SystemT.releaseVer}  현재버전: ${SystemT.currentVer}', style: StyleT.titleStyle()),
            actionsPadding: EdgeInsets.all(14),
            actions: <Widget>[
              Row(
                children: [
                  TextButton(
                    child: Text('취소', style: StyleT.titleStyle(bold: true),),
                    onPressed: () {
                      if(!force) {
                        Navigator.pop(context);
                        return;
                      }
                      appWindow.close();
                    },
                    style: StyleT.buttonStyleOutline(elevation: 0, color: Colors.redAccent.withOpacity(0.5) , strock: 1.4),
                  ),
                  Expanded(child:Container()),
                  TextButton(
                    child: Text('확인', style: StyleT.titleStyle(bold: true,),),
                    onPressed: () {
                      if(!force) {
                        Navigator.pop(context);
                        return;
                      }
                      appWindow.close();
                    },
                    style: StyleT.buttonStyleOutline(elevation: 0, color: Colors.blue.withOpacity(0.5) , strock: 1.4),
                  ),
                ],
              )
            ],
          );
        });

    if(aa == null) aa = false;
    return aa;
  }

  Widget build(context) {
    return Container();
  }
}


class ExcelGrid extends StatelessWidget {
  double? width, height;
  String? label, text;
  bool disabled;

  ExcelGrid({ this.disabled=false, this.width, this.height, this.label, this.text }) {}

  @override
  Widget build(BuildContext context) {
    return Container( width: width, height: 28, alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: SizedBox()),
          Text('$label  ', style: StyleT.textStyle(),),
          Text('${text ?? ''}', style: StyleT.titleStyle(),),
          Expanded(child: SizedBox()),

          if(!disabled)
            WidgetT.dividVerticalLow(height: height),
        ],
      ),
    );
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }
}

class ExcelGridEditor extends StatefulWidget {
  double? width, height;
  String? label, text, hint, val;
  List<String>? dropMenus = [];

  Alignment? alignment = Alignment.center;

  Function(int?, dynamic?)? setData;
  //Function? refresh;

  int? index;

  bool multiLine = false;
  bool isDate, isArch, isDropMenu, isManager, isAddress;
  bool isEdit = false;
  TextEditingController textInputs = TextEditingController();

  ExcelGridEditor({
    /// size data
    this.width, this.height,
    this.alignment,
    /// functions data
    this.setData, //this.refresh,

    this.index,
    /// string data
    this.val, this.hint, this.label, this.text,
    this.dropMenus,

    this.multiLine=false,
    /// bool data
    this.isDate=false, this.isArch=false, this.isDropMenu=false, this.isManager=false, this.isAddress=false
  }) {
  }

  @override
  ExcelGridEditorState createState() => ExcelGridEditorState(
    width: width, height: height, label: label, text: text, hint: hint, val: val, dropMenus: dropMenus, alignment: alignment,
    setData: setData, index: index,
    isArch: isArch, isManager: isManager, isAddress: isAddress, isDate: isDate, isDropMenu: isDropMenu, multiLine: multiLine,
  );
}
class ExcelGridEditorState extends State<ExcelGridEditor> {
  double? width, height;
  String? label, text, hint, val;
  List<String>? dropMenus = [];

  Alignment? alignment = Alignment.center;

  Function(int?, dynamic?)? setData;
  //Function? refresh;

  int? index;

  bool multiLine = false;
  bool isDate, isArch, isDropMenu, isManager, isAddress;
  bool isEdit = false;
  TextEditingController textInputs = TextEditingController();

  ExcelGridEditorState({
    /// size data
    this.width, this.height,
    this.alignment,
    /// functions data
    this.setData, //this.refresh,

    this.index,
    /// string data
    this.val, this.hint, this.label, this.text,
    this.dropMenus,
    /// bool data
    this.multiLine=false, this.isDate=false, this.isArch=false, this.isDropMenu=false, this.isManager=false, this.isAddress=false
  }) {
    if(index == null) index = 0;
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build (BuildContext context,) {
    if(isEdit == true) {
      Widget w = Container(
        width: width, height: multiLine ? null : 28,
        child: TextFormField(
          autofocus: true,
          maxLines: multiLine ? null : 1,
          textInputAction: multiLine ? TextInputAction.newline : TextInputAction.search,
          keyboardType: multiLine ? TextInputType.multiline : TextInputType.none,
          onEditingComplete: () async {
            var data = textInputs.text; textInputs.clear();
            isEdit = false;
            if(setData != null) await setData!(index, data);
            await FunctionT.funDialogRefresh();
          },
          decoration: WidgetT.textInputDecoration( hintText: hint, round: 4,
              backColor: Colors.white.withOpacity(0.5)),
          controller: textInputs,
        ),
      );
      return Focus(
        onFocusChange: (hasFocus) async {
          if(!hasFocus) {
            var data = textInputs.text; textInputs.clear();
            isEdit = false;

            if(setData != null) await setData!(index, data);
            await FunctionT.funDialogRefresh();
            setState(() {});
            setState(() {});
            setState(() {});
            setState(() {});
            setState(() {});
          }
        },
        child: w,
      );
    }

    List<DropdownMenuItem<dynamic>>? dropItems = [];
    if(isManager) {
      dropItems = SystemT.managers.map((item) => DropdownMenuItem<dynamic>(
        value: item.id,
        child: Text(item.name.toString(), style: StyleT.titleStyle(), overflow: TextOverflow.ellipsis,),
      )).toList();
    }
    else if(isDropMenu) {
      dropItems = dropMenus?.map((item) => DropdownMenuItem<dynamic>(
        value: item,
        child: Text(item.toString(), style: StyleT.titleStyle(), overflow: TextOverflow.ellipsis,),
      )).toList();
    }

    if(isManager || isDropMenu) {
      return Container(
        height: 28,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            customButton: Container( width: width, height: multiLine ? null : 28, alignment: Alignment.center,
              child: TextButton(
                onPressed: null,
                style: StyleT.buttonStyleNone(padding: 0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: SizedBox()),
                    Text('$label  ', style: StyleT.textStyle(),),
                    Container(
                      padding: EdgeInsets.only(top: 6, bottom: 6),
                      child: Text('${text ?? '' }', style: StyleT.titleStyle(),),
                    ),
                    Expanded(child: SizedBox()),
                    WidgetT.dividVerticalLow(height: height),
                  ],
                ),
              ),
            ),
            items: dropItems,
            onChanged: (value) async {
              if(setData != null) await setData!(index, value);
              await FunctionT.funDialogRefresh();
            },
            itemHeight: 28,
            itemPadding: const EdgeInsets.only(left: 16, right: 16),
            dropdownWidth: width,
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
            offset: const Offset(0, 0),
          ),
        ),
      );
    }

    return Container(
      width: width, height: multiLine ? null : 28, alignment: alignment,
      child: TextButton(
        onPressed: () async {
          isEdit = true;
          textInputs.text = val ?? '';
          await FunctionT.funDialogRefresh();
        },
        style: StyleT.buttonStyleNone(padding: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: ExcelGrid(label: label, text: text, disabled: true,),),
            if(isDate!) ExcelCalenderButton(val: val, setData: setData, index: index,),
            //if(isArch) ExcelArchTectureButton(val: val, setData: setData, index: index,),
            if(isAddress)
              Container(  width: 28, height: 28,
                child: TextButton(
                    onPressed: () async {
                      var address = await WidgetT.addressSearchDl(context, textController: textInputs);
                      if(address != null) {
                        if(setData != null) await setData!(index, address);
                      }
                      await FunctionT.funDialogRefresh();
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: WidgetT.iconStyleMini(icon: Icons.content_paste_search)
                ),
              ),
            WidgetT.dividVerticalLow(height: height),
          ],
        ),
      ),
    );
  }
}

class ExcelGridButton extends StatelessWidget {
  IconData? icon;
  double? width, height;
  String? label, text;
  Function? onPressed;

  ExcelGridButton({this.onPressed, this.icon, this.width, this.height, this.label, this.text }) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox( height: 28,
      child: TextButton(
        onPressed: () async {
          if(onPressed != null) await onPressed!();
        },
        style: StyleT.buttonStyleNone(padding: 0),
        child: Container(alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon != null)
                WidgetT.iconStyleMini(icon: icon),
              if(label != null)
                Text('$label  ', style: StyleT.titleStyle(),),
              if(text != null)
                Text('$text', style: StyleT.titleStyle(),),
              WidgetT.dividVerticalLow(),
            ],
          ),
        ),
      ),
    );
  }
}
class ExcelCalenderButton extends StatelessWidget {
  String? val;
  Function(int?, dynamic?)? setData;
  int? index;

  ExcelCalenderButton({ this.index, this.val, this.setData }) {}

  @override
  Widget build(BuildContext context) {
    return Container( width: 28, height: 28,
      child: TextButton(
          onPressed: () async {
            var dS = val?.replaceAll('.', '-') ?? '';
            DateTime? dD = DateTime.tryParse(dS);
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: dD ?? DateTime.now(), //get today's date
                firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101)
            );
            if(pickedDate == null) return;

            var dateString = DateFormat('yyyy.MM.dd').format(pickedDate);
            if(setData != null) await setData!(index, dateString);
            await FunctionT.funDialogRefresh();
          },
          style: StyleT.buttonStyleNone(padding: 0),
          child: WidgetT.iconStyleMini(icon: Icons.calendar_month)
      ),
    );
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }
}
class ExcelArchTectureButton extends StatelessWidget {
  double? width;
  String? val;
  Function(int?, dynamic?)? setData;
  int? index;

  ExcelArchTectureButton({ this.width, this.index, this.val, this.setData }) {}

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 28, width: 28,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Container( width: 28, height: 28, alignment: Alignment.center,
            child: TextButton(
              onPressed: null,
              style: StyleT.buttonStyleNone(padding: 0),
              child: WidgetT.iconStyleMini(icon: Icons.more_vert),
            ),
          ),
          items: SystemT.architectureOffices.map((item) => DropdownMenuItem<dynamic>(
            value: item.id,
            child: Text(
              item.name.toString(),
              style: StyleT.titleStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
          onChanged: (value) async {
            if(setData != null) await setData!(index, value);
            await FunctionT.funDialogRefresh();

          },
          itemHeight: 28,
          itemPadding: const EdgeInsets.only(left: 16, right: 16),
          dropdownWidth: width,
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
          offset: Offset((width! * -1.0 + 28.7), 0),
        ),
      ),
    );
    // TODO: implement createRenderObject
    throw UnimplementedError();
  }
}
