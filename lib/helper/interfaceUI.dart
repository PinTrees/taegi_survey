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
import 'aligoApi.dart';
import 'firebaseCore.dart';
import 'transition.dart';

class WidgetT extends StatelessWidget {

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

  static dynamic clear() {
    for(var ti in textInputs.values) {
      ti.clear(); ti.dispose();
    }
    textInputs.clear();
    editInput.clear();
  }
  static dynamic buttonWrap(String text, Function fun, bool edit, {String? k, Function()? setFun,
    Function(int, dynamic)? set, double? width, String hint='...', int? expand, String? val}) {
    if(k != null) {
      if(editInput[k] == true) {
        if(textInputs[k] == null)
          textInputs[k] = new TextEditingController();

        Widget w = Container(
          width: width, height: 36,
          child: TextFormField(
            //focusNode: textInputFocus[k!],
            autofocus: true,
            maxLines: 1,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.none,
            onEditingComplete: () async {
              textOutput[k] = textInputs[k]!.text; textInputs[k]!.clear();
              editInput[k] = false;
              var data = textOutput[k];

              var i = int.tryParse(k.split('::').first) ?? 0;
              if(set != null) await set(i, data);
              if(setFun != null) await setFun();
            },
            decoration: WidgetT.textInputDecoration( hintText: hint, round: 4),
            controller: textInputs[k],
          ),
        );

        if(width == null) {
          w = Expanded(child: w);
        }

        return Focus(
          onFocusChange: (hasFocus) async {
            if(!hasFocus) {
              textOutput[k] = textInputs[k]!.text; textInputs[k]!.clear();
              editInput[k] = false;
              var data = textOutput[k];
              //textInputFocus[k]?.requestFocus();

              var i = int.tryParse(k.split('::').first) ?? 0;
              if(set != null) await set(i, data);
              if(setFun != null) await setFun();
            }
          },
          child: Row(
            mainAxisSize: width == null ? MainAxisSize.max : MainAxisSize.min,
            children: [
              w,
            ],
          ),
        );
      }
    }

    Widget w = Focus(
      onFocusChange: (hasFocus) async {
        if(hasFocus) {
          if(k != null){
            editInput.clear();
            editInput[k!] = true;

            if(textInputs[k!] == null) textInputs[k!] = new TextEditingController();
            //if(textInputFocus[k!] == null) textInputFocus[k!] = new FocusNode();
            textInputs[k!]!.text = val ?? '';
          }
          if(setFun != null) await setFun();
        }
      },
      child: TextButton(
          onPressed: () async {
            if(k != null){
              editInput.clear();
              editInput[k!] = true;

              if(textInputs[k!] == null) textInputs[k!] = new TextEditingController();
              textInputs[k!]!.text = val ?? '';
            }
            if(setFun != null) await setFun();
          },
          style: StyleT.buttonStyleOutline(strock: 0.1, color: StyleT.accentLowColor.withOpacity(0.5),
              padding: 0, elevation: 0),
          child: SizedBox(
            width: width, height: 36,
            child: Row( mainAxisSize: width == null ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text( '$text', style: StyleT.titleStyle(),),
                ),
                if(!edit)
                  SizedBox(
                    height: 24, width: 24,
                    child: TextButton(
                      onPressed: () async {
                        if(fun != null) await fun();
                        if(setFun != null) await setFun();
                      },
                      style: StyleT.buttonStyleNone(padding: 0, elevation: 0),
                      child: Icon(Icons.close, color: Colors.redAccent, size: 12,),
                    ),
                  ),
              ],
            ),
          )
      ),
    );
    if(width == null) {
      w = Expanded(child: w);
    }

    return Row(
      mainAxisSize: width == null ? MainAxisSize.max : MainAxisSize.min,
      children: [
        w,
      ],
    );
  }
  static dynamic buttonAdd({Function? fun}) {
    return SizedBox( height: 36, width: 36,
      child: TextButton(
        onPressed: () async {
          if(fun != null) await fun();
        },
        style: StyleT.buttonStyleNone(padding: 0, color: StyleT.accentColor.withOpacity(0.5)),
        child: Icon(Icons.add, color: StyleT.textColor,),
      ),
    );
  }

  static dynamic pmRowTitleBar(ScrollController controller, { Color? backgroundColor }) {
    var titleStyle = StyleT.titleStyle();
    var titleMenus = [
      '허가년도', '허가월', '실무자', '신청인', '연락처', '소재지', '용도', '허가면적', '허가일', '종료일', '허가유형', '건축사', '준공일', '진행 및 특이사항', '비고',
    ];
    var titleSize = [
      defaultSize1, defaultSize0, defaultSize, defaultSize, phoneNumSize, addressSize, useTypeSize, areaSize, dateSize, dateSize,
      defaultSize, defaultSize2, defaultSize2, descSize, defaultSize,
    ];

    List<Widget> titleW = [];
    for(int i = 0; i < titleMenus.length; i++) {
      Widget w = Container(alignment: Alignment.center, width: titleSize[i], child: Text(titleMenus[i], style: titleStyle,),);
      titleW.add(w);
      titleW.add(WidgetT.dividViertical(color: Colors.transparent),);
    }

    return Column(
      children: [
        //Container(height: 1, width: double.maxFinite, color: Colors.black,),
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          child: Container(
            width: allSize,
            color: backgroundColor ?? StyleT.white,
            height: 32,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for(var w in titleW)
                  w,
              ],
            ),
          ),
        ),
      ],
    );
  }
  static dynamic pmRowWidget(BuildContext context, PermitManagement p, { bool endVisible=false, Function? fun, bool viewShort=false, Color? color}) {
    var dateString = p.permitAts.first['date'].replaceAll('.', '-');
    DateTime? date = DateTime.tryParse(dateString) ?? DateTime.now();
    List<Widget> pDateAtsW = [];
    for(var _p in p.permitAts) {
      var dS = _p['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
      pDateAtsW.add( Container( padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
            children: [
              SizedBox( height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: StyleT.buttonStyleOutline(elevation: 0, color: StyleT.backgroundColor, padding: 8, strock: 1.4),
                  child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
                ),
              ),
              SizedBox(width: 8,),
              Text(StyleT.dateFormat(dD), style: StyleT.titleStyle(),),
            ],
          ),
      )
      );
    }

    List<Widget> eDateAtsW = [];
    for(var _p in p.endAts) {
      var dS = _p['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();

      int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
      difference = difference.abs();

      Widget w = Container( padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: [
            SizedBox( height: 24,
              child: TextButton(
                onPressed: () {},
                style: StyleT.buttonStyleOutline(elevation: 0, color: StyleT.backgroundColor, padding: 8, strock: 1.4),
                child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
              ),
            ),
            SizedBox(width: 8,),
            Text(StyleT.dateFormat(dD), style: StyleT.titleStyle(),),
            SizedBox(width: 8,),
            if(endVisible)
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: StyleT.buttonStyleOutline(elevation: 0, color: Colors.redAccent.withOpacity(0.5),
                      padding: 8, strock: 0),
                  child: Text('${difference}일', style: StyleT.titleStyle(color: Colors.white),),
                ),
              ),
          ],
        ),
      );

      if(DateTime.tryParse(dS) == null)
        w =  Container( padding: EdgeInsets.only(top: 2, bottom: 2),
          child: Row(
            children: [
              SizedBox( height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: StyleT.buttonStyleOutline(elevation: 0, color: StyleT.backgroundColor, padding: 8, strock: 1.4),
                  child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
                ),
              ),
              SizedBox(width: 8,),
              Text(' - ', style: StyleT.titleStyle(),),
              SizedBox(width: 8,),
              if(endVisible)
                SizedBox(
                  height: 24,
                  child: TextButton(
                    onPressed: () {},
                    style: StyleT.buttonStyleOutline(elevation: 0, color: Colors.redAccent.withOpacity(0.5),
                        padding: 8, strock: 0),
                    child: Text('- 일', style: StyleT.titleStyle(color: Colors.white),),
                  ),
                ),
            ],
          ),
        );

      eDateAtsW.add(w);
    }

    String clientName = '', clientPN = '', address = '';
    if(p.clients.length > 0) {
      clientName = p.clients.elementAt(0)['name'];
      clientPN = p.clients.elementAt(0)['phoneNumber'];
    }
    if(p.addresses.length > 0) address = p.addresses.first;
    else address = p.address;

    var maxline = viewShort ? 1 : 10;

    return TextButton(
      onPressed: () {
        if(fun!= null)
        fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(alignment: Alignment.center, width:defaultSize1, child: Text('${date!.year}', style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize0, child: Text('${date!.month}', style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize, child: Text(SystemT.getManagerName(p.managerUid), style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize, child: Text(clientName, maxLines: maxline,  style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width: phoneNumSize, child: Text(clientPN, maxLines: maxline, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width: addressSize,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Expanded(child: Text(address, maxLines: maxline, style: StyleT.titleStyle(),)),
                      SizedBox(
                        height: 24, width: 24,
                        child: TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black12,
                            minimumSize: Size.zero, padding: EdgeInsets.all(0),
                          ),
                          child: Icon(Icons.new_label, color: Colors.white, size: 12,),
                        ),
                      ),
                      SizedBox(width: 8,),
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  alignment: Alignment.center,width: useTypeSize,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for(var a in p.useType)
                        Text(a, style: StyleT.titleStyle(),)
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width: areaSize,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(var a in p.area)
                        Text(a['type'] + ': ' + a['area'] + '㎡', style: StyleT.titleStyle(),)
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                alignment: Alignment.center,width: dateSize,
                child: Row(
                  children: [
                    SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for(var w in pDateAtsW)
                          w,
                      ],
                    ),
                  ],
                ),
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                alignment: Alignment.center,width: dateSize,
                child: Row(
                  children: [
                    SizedBox(width: 8,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for(var w in eDateAtsW)
                          w,
                      ],
                    ),
                  ],
                ),
              ),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize, child: Text(p.permitType, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize2,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Expanded(child: Text(SystemT.getArchitectureOfficeName(p.architectureOffice), style: StyleT.titleStyle(),)),
                      SizedBox(
                        height: 24, width: 24,
                        child: TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black12,
                            minimumSize: Size.zero, padding: EdgeInsets.all(0),
                          ),
                          child: Icon(Icons.call, color: Colors.white, size: 12,),
                        ),
                      ),
                      SizedBox(width: 8,),
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              SizedBox(width: defaultSize2,),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:descSize, child: Text(p.desc, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize,),
            ],
          ),
        ),
      ),
    );
  }
  static dynamic pmRowShortWidget(BuildContext context, PermitManagement p, { bool endVisible=false, Function? fun, String? search, Color? color }) {
    var dateString = p.permitAts.first['date'].replaceAll('.', '-');
    DateTime? date = DateTime.tryParse(dateString) ?? DateTime.now();
    List<Widget> pDateAtsW = [];
    for(var _p in p.permitAts) {
      var dS = _p['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
      pDateAtsW.add( Container( padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: [
            SizedBox( height: 24,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black12,
                  minimumSize: Size.zero, padding: EdgeInsets.all(4),
                ),
                child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
              ),
            ),
            SizedBox(width: 8,),
            Text(StyleT.dateFormat(dD), style: StyleT.titleStyle(),),
          ],
        ),
      )
      );
    }

    List<Widget> eDateAtsW = [];
    for(var _p in p.endAts) {
      var dS = _p['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();

      int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
      difference = difference.abs();

      eDateAtsW.add( Container( padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: [
            SizedBox( height: 24,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black12,
                  minimumSize: Size.zero, padding: EdgeInsets.all(4),
                ),
                child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
              ),
            ),
            SizedBox(width: 8,),
            Text(StyleT.dateFormat(dD), style: StyleT.titleStyle(),),
            if(endVisible)
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
        ),
      )
      );
    }

    var maxline = 1;

    Widget searchW = SizedBox();
    searchW = Text(p.address, maxLines: maxline, style: StyleT.titleStyle(),);

    if(search != null) {
      search = search.trim();
      if(search != '') {
        var adsss = p.address.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.address, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = RichText(
            text: TextSpan(
              style: StyleT.titleStyle(),
              children: textList,
            ),
          );
        }
      }
    }

    return TextButton(
      onPressed: () {
        if(fun!= null)
          fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? StyleT.white.withOpacity(0.5)),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(alignment: Alignment.center, width:defaultSize1, child: Text('${date!.year}', style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize0, child: Text('${date!.month}', style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize, child: Text(SystemT.getManagerName(p.managerUid), style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width:defaultSize, child: Text(p.clientName, maxLines: maxline,  style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width: phoneNumSize, child: Text(p.clientPhoneNumber, maxLines: maxline, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center,width: addressSize,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Expanded(child: searchW),
                      SizedBox(
                        height: 24, width: 24,
                        child: TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black12,
                            minimumSize: Size.zero, padding: EdgeInsets.all(0),
                          ),
                          child: Icon(Icons.new_label, color: Colors.white, size: 12,),
                        ),
                      ),
                      SizedBox(width: 8,),
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                  alignment: Alignment.center,width: useTypeSize,
                  child: Text(p.useType.first, maxLines: maxline, style: StyleT.titleStyle(),)
              ),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width: areaSize,
                  child: Text(p.area.first['type'] + ': ' + p.area.first['area'] + '㎡', style: StyleT.titleStyle(),)
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                alignment: Alignment.center,width: dateSize,
                child: pDateAtsW.first
              ),
              WidgetT.dividViertical(),
              Container( padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                alignment: Alignment.center,width: dateSize,
                child: eDateAtsW.first
              ),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize, child: Text(p.permitType, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize2,
                  child: Row(
                    children: [
                      SizedBox(width: 8,),
                      Expanded(child: Text(SystemT.getArchitectureOfficeName(p.architectureOffice), maxLines: maxline, style: StyleT.titleStyle(),)),
                      SizedBox(
                        height: 24, width: 24,
                        child: TextButton(
                          onPressed: () {
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black12,
                            minimumSize: Size.zero, padding: EdgeInsets.all(0),
                          ),
                          child: Icon(Icons.call, color: Colors.white, size: 12,),
                        ),
                      ),
                      SizedBox(width: 8,),
                    ],
                  )
              ),
              WidgetT.dividViertical(),
              SizedBox(width: defaultSize2,),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:descSize, child: Text(p.desc, maxLines: maxline, style: StyleT.titleStyle(),)),
              WidgetT.dividViertical(),
              Container(alignment: Alignment.center, width:defaultSize,),
            ],
          ),
        ),
      ),
    );
  }
  static dynamic pmRowExcelWidget(BuildContext context, PermitManagement p,
      { bool endVisible=false, Function? fun, bool viewShort=false, Color? color}) {
    var height1 = 28.0;
    var widthDateAt = 200.0;
    var widthClient = 350.0;
    var widthAddress = 350.0;
    var widthManager = 150.0;

    var widthDateT = 100.0;
    var widthDateD = 250.0;
    var widthDateF = 50.0;

    List<Widget> pDateAtsW = [];
    for(var _p in p.permitAts) {
      if(_p['date'] != '') continue;
      var dS = _p['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
      pDateAtsW.add( Container( padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          children: [
            SizedBox( height: 24,
              child: TextButton(
                onPressed: () {},
                style: StyleT.buttonStyleOutline(elevation: 0, color: StyleT.backgroundColor, padding: 8, strock: 1.4),
                child: Text(_p['type'], style: StyleT.textStyle(bold: true),),
              ),
            ),
            SizedBox(width: 8,),
            Text(StyleT.dateFormat(dD), style: StyleT.titleStyle(),),
          ],
        ),
      )
      );
    }

    List<Widget> eDateAtsW = [];
    for(var a in p.endAts) {
      if(a['date'] == '') continue;
      var dS = a['date'].replaceAll('.', '-');
      DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();

      int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
      //difference = difference.abs();

      Widget w = Container( width:  widthDateD,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(a['type'], style: StyleT.titleStyle(),),
                  SizedBox(width: 8,),
                  Text(a['date'], style: StyleT.titleStyle(),)
                ],
              ),
            ),
            WidgetT.dividVerticalLow(height: height1),
          ],
        ),
      );

      if(DateTime.tryParse(dS) != null) {
        if(difference > -31 && difference < 5) {
          w = Container( width:  widthDateD,
            color: Colors.red.withOpacity(0.15),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(a['type'], style: StyleT.titleStyle(),),
                      SizedBox(width: 8,),
                      Text(a['date'], style: StyleT.titleStyle(),),
                      SizedBox(width: 18,),
                      Text('종료까지 ', style: StyleT.textStyle(),),
                      Text('${difference.abs()}일', style: StyleT.titleStyle(),)
                    ],
                  ),
                ),
                WidgetT.dividVerticalLow(height: height1),
              ],
            ),
          );
        }
      }

      eDateAtsW.add(w);
    }

    var search = '';
    Widget searchW = SizedBox();
    searchW = Text(p.addresses.first, maxLines: 1, style: StyleT.titleStyle(),);
    if(SystemT.searchAddress != null) {
      search = SystemT.searchAddress.trim();
      if(search != '') {
        var adsss = p.addresses.first.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.addresses.first, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = RichText(
            text: TextSpan(
              style: StyleT.titleStyle(),
              children: textList,
            ),
          );
        }
      }
    }

    var pYear = ' - ', pMonth = ' - ';
    if(p.getPermitAtsFirstNull() != null) {
      pYear = p.getPermitAtsFirstNull()!.year.toString();
      pMonth = p.getPermitAtsFirstNull()!.month.toString();
    }

    return TextButton(
      onPressed: () {
        if(fun!= null)
          fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
      child: Container(
        child: Column(
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
                Row(
                  children: [
                    Container(  width: widthManager, alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('실무자  ', style: StyleT.textStyle(),),
                                Text('${SystemT.getManagerName(p.managerUid)}    ', style: StyleT.titleStyle(),),
                              ],
                            ),
                          ),
                          WidgetT.dividVerticalLow(height: height1),
                        ],
                      ),
                    ),
                    Container(width: widthClient, height: height1, alignment: Alignment.center,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('신청인  ', style: StyleT.textStyle(),),
                                Text('${p.clients.first['name']}  ', style: StyleT.titleStyle(),),
                                Text('${p.clients.first['phoneNumber'].toString().split('\n').first}', style: StyleT.titleStyle(),),
                              ],
                            ),
                          ),
                          WidgetT.dividVerticalLow(height: height1),
                        ],
                      ),
                    ),
                  ],
                ),

                Container( width: widthAddress, alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(child: SizedBox()),
                      Text('소재지  ', style: StyleT.textStyle(),),
                      searchW,
                      Expanded(child: SizedBox()),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
                Container( height: height1, width:  150, alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('허가유형  ', style: StyleT.textStyle(),),
                            Text('${p.permitType}', style: StyleT.titleStyle(),),
                          ],
                        ),
                      ),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
                Container( height: height1, width:  150, alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('건축사  ', style: StyleT.textStyle(),),
                            Text('${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', style: StyleT.titleStyle(),),
                          ],
                        ),
                      ),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
              ],
            ),
            WidgetT.dividHorizontalLow(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container( width: 600,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('용도  ', style: StyleT.textStyle(),),
                            for(var a in p.useType)
                              Text('$a,   ', style: StyleT.titleStyle(),),
                          ],
                        ),
                      ),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
                Container( width:  650,
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('허가면적  ', style: StyleT.textStyle(),),
                            for(var a in p.area)
                              Text('${a['type']}: ${a['area']}㎡,   ', style: StyleT.titleStyle(),),
                          ],
                        ),
                      ),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
              ],
            ),
            WidgetT.dividHorizontalLow(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height1, width: widthDateT, alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(child: SizedBox()),
                      Text('허가일', style: StyleT.textStyle(),),
                      Expanded(child: SizedBox()),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
                for(var a in p.permitAts)
                  excelGrid(label: a['type'], text: a['date'], width: widthDateD)
              ],
            ),
            WidgetT.dividHorizontalLow(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height1, width: widthDateT, alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(child: SizedBox()),
                      Text('종료일', style: StyleT.textStyle(),),
                      Expanded(child: SizedBox()),
                      WidgetT.dividVerticalLow(height: height1),
                    ],
                  ),
                ),
                for(var w in eDateAtsW)
                  w,
              ],
            ),
          ],
        ),
      ),
    );
  }
  static dynamic pmRowExcelEditeWidget(BuildContext context, PermitManagement p,
      { bool endVisible=false, Function? fun, Function? saveFun,  Function? setFun,
        bool viewShort=false, Color? color}) {
    var height1 = 28.0;
    var widthClientN = 200.0;
    var widthClientPN = 350.0;
    var widthUseType = 300.0;
    var widthAreaT = 150.0;
    var widthAddress = 550.0;
    var widthManager = 150.0;
    var widthDateD = 250.0;
    var widthDateF = 50.0;

    String clientName = '', clientPN = '', address = '';
    if(p.clients.length > 0) {
      clientName = p.clients.elementAt(0)['name'];
      clientPN = p.clients.elementAt(0)['phoneNumber'];
    }
    if(p.addresses.length > 0) address = p.addresses.first;
    else address = p.address;

    var search = '';
    Widget searchW = SizedBox();
    searchW = Text(p.addresses.first, maxLines: 1, style: StyleT.titleStyle(),);
    if(SystemT.searchAddress != null) {
      search = SystemT.searchAddress.trim();
      if(search != '') {
        var adsss = p.addresses.first.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.addresses.first, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = RichText(
            text: TextSpan(
              style: StyleT.titleStyle(),
              children: textList,
            ),
          );
        }
      }
    }

    var pYear = ' - ', pMonth = ' - ';
    if(p.getPermitAtsFirstNull() != null) {
      pYear = p.getPermitAtsFirstNull()!.year.toString();
      pMonth = p.getPermitAtsFirstNull()!.month.toString();
    }

    return Column( crossAxisAlignment: CrossAxisAlignment.start,
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
                      excelGridButton(fun: () async {
                        if(setFun != null) await setFun();
                      }, icon: Icons.calendar_month),
                      excelGridEditor(context,setFun: setFun, width: widthManager,
                          alignment: Alignment.centerLeft, isManager: true,
                          set: (index, data) {
                            p.managerUid = data;
                          }, key: 'pm.manager', text: '${SystemT.getManagerName(p.managerUid)}',
                          label: '실무자'),
                      excelGridEditor(context, setFun: setFun, set: (index, data) {
                        p.permitType = data;
                      }, val: p.permitType ?? '', width: 150, key: 'pm.permitType', text: p.permitType, label: '허가유형'),
                      excelGridEditor(context, setFun: setFun, set: (index, data) {
                        p.architectureOffice = data;
                      }, val: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', width: 150, key: 'pm.architectureOffice',
                          text: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', label: '건축사', isArch: true),
                    ],
                  ),
                  WidgetT.dividHorizontalLow(),
                  WidgetT.dividHorizontalLow(),
                  Container( width: 650, height: height1,
                    child: Row(
                        children: [
                          Expanded(child: excelGrid(label: '소재지'),),
                          excelGridButton(fun: () async {
                            p.addresses.add('');
                            if(setFun != null) await setFun();
                          }, icon: Icons.add),
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
                            child: excelGridEditor(context, isAddress: true, width: widthAddress - 28.7,
                                setFun: setFun, set: (index, data) {
                                  p.addresses[index] = data;
                                }, val: p.addresses[i] ?? '', key: '$i::pm.addresses',
                                text: p.addresses[i], label: '소재지'),
                          ),
                          excelGridButton(fun: () async {
                            p.addresses.removeAt(i);
                            if(setFun != null) await setFun();
                          }, icon: Icons.delete),
                        ],
                      ),
                    ),
                  WidgetT.dividHorizontalLow(),
                  WidgetT.dividHorizontalLow(),

                  excelGrid(label: '신청인', width: 650),
                  WidgetT.dividHorizontalLow(),
                  for(int i = 0; i < p.clients.length; i++)
                    Container(
                      height: height1, width: 650,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          excelGridEditor(context, setFun: setFun, set: (index, data) {
                            p.clients[index]['name'] = data;
                          }, val: p.clients[i]['name'] ?? '', width: 200, key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                         Expanded(
                             child: excelGridEditor(context, setFun: setFun, set: (index, data) {
                               p.clients[index]['phoneNumber'] = data;
                             }, val: p.clients[i]['phoneNumber'] ?? '',  key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                         ),
                          if(i == 0)
                            excelGridButton(fun: () async {
                              p.clients.add({});
                              if(setFun != null) await setFun();
                            }, icon: Icons.add),
                          if(i != 0)
                            excelGridButton(fun: () async {
                              p.clients.removeAt(i);
                              if(setFun != null) await setFun();
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
                          Expanded(child: excelGrid(label: '허가면적', ),),
                          excelGridButton(fun: () async {
                            p.area.add({});
                            if(setFun != null) await setFun();
                          }, icon: Icons.add),
                        ],
                      ),
                      WidgetT.dividHorizontalLow(),
                      Wrap(
                        children: [
                          for(int i = 0; i < p.area.length; i++)
                            Container(
                              height: height1,
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  excelGridEditor(context, setFun: setFun, set: (index, data) {
                                    p.area[index]['type'] = data;
                                  }, val: p.area[i]['type'] ?? '', width: 150, key: '$i::pm.area.type', text: p.area[i]['type'] ?? '', label: '타입'),
                                  Expanded(child:    excelGridEditor(context, setFun: setFun, set: (index, data) {
                                    p.area[index]['area'] = data;
                                  }, val: p.area[i]['area'] ?? '', width: widthAreaT, key: '$i::pm.area.area', text: '${p.area[i]['area'] ?? ''} ㎡', label: '면적'),
                                  ),
                                  excelGridButton(fun: () async {
                                    p.area.removeAt(i);
                                    if(setFun != null) await setFun();
                                  }, icon: Icons.delete),
                                ],
                              ),
                            ),
                        ],
                      )
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
                          Expanded(child: excelGrid(label: '용도', ),),
                          excelGridButton(fun: () async {
                            p.useType.add('');
                            if(setFun != null) await setFun();
                          }, icon: Icons.add),
                        ],
                      ),
                      WidgetT.dividHorizontalLow(),
                      Wrap(
                        children: [
                          for(int i = 0; i < p.useType.length; i++)
                            Container(
                              height: height1,
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child:   excelGridEditor(context, setFun: setFun, set: (index, data) {
                                    p.useType[index] = data;
                                  }, val: p.useType[i] ?? '', key: '$i::pm.useType', text: p.useType[i], label: '용도'),
                                  ),
                                  excelGridButton(fun: () async {
                                    p.useType.removeAt(i);
                                    if(setFun != null) await setFun();
                                  }, icon: Icons.delete),
                                ],
                              ),
                            ),
                        ],
                      )
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
                          Expanded(child: excelGrid(label: '허가일', ),),
                          excelGridButton(fun: () async {
                            p.permitAts.add({});
                            if(setFun != null) await setFun();
                          }, icon: Icons.add),
                      ],
                    ),
                    WidgetT.dividHorizontalLow(),
                    Wrap(
                      children: [
                        for(int i = 0; i < p.permitAts.length; i++)
                          Container(
                            height: height1, width: 325,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                excelGridEditor(context, setFun: setFun, set: (index, data) {
                                  p.permitAts[index]['type'] = data;
                                }, val: p.permitAts[i]['type'] ?? '', width: 125, key: '$i::pm.permitAts.type', text: p.permitAts[i]['type'] ?? '', label: '타입'),
                                Expanded(child: excelGridEditor(context, setFun: setFun, set: (index, data) {
                                  p.permitAts[index]['date'] = data;
                                }, val: p.permitAts[i]['date'] ?? '', isDate: true, key: '$i::pm.permitAts.date', text: p.permitAts[i]['date'] ?? '', label: '날짜'),
                                ),
                                excelGridButton(fun: () async {
                                  p.permitAts.removeAt(i);
                                  if(setFun != null) await setFun();
                                }, icon: Icons.delete),
                              ],
                            ),
                          ),
                      ],
                    )
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
                        Expanded(child: excelGrid(label: '종료일', ),),
                        excelGridButton(fun: () async {
                          p.endAts.add({});
                          if(setFun != null) await setFun();
                        }, icon: Icons.add),
                      ],
                    ),
                    WidgetT.dividHorizontalLow(),
                    Wrap(
                      children: [
                        for(int i = 0; i < p.endAts.length; i++)
                          Container(
                            height: height1, width: 325,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                excelGridEditor(context, setFun: setFun, set: (index, data) {
                                  p.endAts[index]['type'] = data;
                                }, val: p.endAts[i]['type'] ?? '', width: 125, key: '$i::pm.endAts.type', text: p.endAts[i]['type'] ?? '', label: '타입'),
                                Expanded(child:      excelGridEditor(context, setFun: setFun, set: (index, data) {
                                  p.endAts[index]['date'] = data;
                                }, val: p.endAts[i]['date'] ?? '',  isDate: true, key: '$i::pm.endAts.date', text: p.endAts[i]['date'] ?? '', label: '날짜'),
                                ),
                                excelGridButton(fun: () async {
                                  p.endAts.removeAt(i);
                                  if(setFun != null) await setFun();
                                }, icon: Icons.delete),
                              ],
                            ),
                          ),
                      ],
                    )
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
                excelGrid(label: '비고',),
                WidgetT.dividHorizontalLow(),
                excelGridEditor(context, multiLine: true, setFun: setFun, set: (index, data) {
                  p.desc = data;
                }, val: p.desc ?? '', key: 'pm.desc', text: p.desc, label: ''),
              ],
            ),
          ),
        ),
        SizedBox(height:  8,),
        Row(
          children: [
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    if((await WidgetT.showAlertDl(context, title: p.addresses.first) as bool) == false) {
                      WidgetT.showSnackBar(context, text: '저장이 취소되었습니다.');
                      return;
                    }
                    //if(closeFun != null) await closeFun();
                  },
                  style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
                      color: Colors.redAccent.withOpacity(0.7)),
                  child: Row( mainAxisSize: MainAxisSize.min,
                    children: [
                      iconStyleMini(icon: Icons.delete),
                      Text('삭제', style: StyleT.titleStyle(),),
                      SizedBox(width: 12,),
                    ],
                  )
              ),
            ),
            SizedBox(width:  8,),
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    //if(closeFun != null) await closeFun();
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
            SizedBox(width:  8,),
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    if(saveFun != null)
                      saveFun();
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
        )
      ],
    );
  }


  static dynamic pmCreateExcelEditeWidgetDl(BuildContext context, PermitManagement p,
      { bool endVisible=false, Function? fun, Function? saveFun,  Function? setFun,
        bool viewShort=false, Color? color}) async {

    p.addresses.add('');
    p.clients.add({});
    p.area.add({});
    p.useType.add('');
    p.permitAts.add({});
    p.endAts.add({});

    var height1 = 28.0;
    var widthClientN = 200.0;
    var widthClientPN = 350.0;
    var widthUseType = 300.0;
    var widthAreaT = 150.0;
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
                title: Container(padding: EdgeInsets.all(12), child: Text('허가 관리 대장 문서 추가', style: StyleT.titleStyle(bold: true))),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container( width: 550 + 28.7,
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
                                      excelGridButton(fun: () async {
                                        if(setFun != null) await setFun();
                                      }, icon: Icons.calendar_month),
                                      excelGridEditorButton(fun: () async {
                                        var manager = await showBTManagerList(context);
                                        p.managerUid = manager.id;
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, label: '실무자', text: '${SystemT.getManagerName(p.managerUid)}', width: widthManager),
                                      excelGridEditor(context, setFun: () async {
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.permitType = data;
                                      }, val: p.permitType ?? '', width: 150, key: 'pm.permitType', text: p.permitType, label: '허가유형'),
                                      excelGridEditor(context, setFun: () async {
                                        if(setFun != null) await setFun();
                                        setStateS(() {});
                                      }, set: (index, data) {
                                        p.architectureOffice = data;
                                      }, val: '${SystemT.getArchitectureOfficeName(p.architectureOffice).toString().replaceAll('\n', ' ')}', width: 150, key: 'pm.architectureOffice',
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
                                          excelGridEditor(context, setFun:
                                              () { if(setFun != null) setFun(); setStateS(() {}); }, set: (index, data) {
                                            p.addresses[index] = data;
                                          }, val: p.addresses[i] ?? '', width: widthAddress, key: '$i::wm.workAts.doc', text: p.addresses[i], label: '소재지'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.addresses.add('');
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
                                              p.addresses.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),

                                  excelGrid(label: '신청인', width: widthClientN + widthClientPN + 28.7),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.clients.length; i++)
                                    Container(
                                      height: height1,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                             setStateS(() {});
                                          }, set: (index, data) {
                                            p.clients[index]['name'] = data;
                                          }, val: p.clients[i]['name'] ?? '', width: widthClientN, key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.clients[index]['phoneNumber'] = data;
                                          }, val: p.clients[i]['phoneNumber'] ?? '', width: widthClientPN, key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.clients.add({});
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
                                              p.clients.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),

                                  excelGrid(label: '용도', width: widthAreaT + widthAreaT + 28.7),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.useType.length; i++)
                                    Container(
                                      height: height1,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.useType[index] = data;
                                          }, val: p.useType[i] ?? '', width: widthUseType, key: '$i::pm.useType', text: p.useType[i], label: '용도'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.useType.add('');
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
                                              p.useType.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),

                                  excelGrid(label: '허가면적', width: widthAreaT + widthAreaT + 28.7),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.area.length; i++)
                                    Container(
                                      height: height1,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.area[index]['type'] = data;
                                          }, val: p.area[i]['type'] ?? '', width: widthAreaT, key: '$i::pm.area.type', text: p.area[i]['type'] ?? '', label: '타입'),
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.area[index]['area'] = data;
                                          }, val: p.area[i]['area'] ?? '', width: widthAreaT, key: '$i::pm.area.area', text: '${p.area[i]['area'] ?? ''} ㎡', label: '면적'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.area.add({});
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
                                              p.area.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),

                                  excelGrid(label: '허가일', width: widthAreaT + widthDateD + 28.7),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.permitAts.length; i++)
                                    Container(
                                      height: height1,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.permitAts[index]['type'] = data;
                                          }, val: p.permitAts[i]['type'] ?? '', width: widthAreaT, key: '$i::pm.permitAts.type', text: p.permitAts[i]['type'] ?? '', label: '타입'),
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.permitAts[index]['date'] = data;
                                          }, val: p.permitAts[i]['date'] ?? '', width: widthDateD, isDate: true, key: '$i::pm.permitAts.date', text: p.permitAts[i]['date'] ?? '', label: '날짜'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.permitAts.add({});
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
                                              p.permitAts.removeAt(i);
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.delete),
                                        ],
                                      ),
                                    ),
                                  WidgetT.dividHorizontalLow(),

                                  excelGrid(label: '종료일', width: widthAreaT + widthDateD + 28.7),
                                  WidgetT.dividHorizontalLow(),
                                  for(int i = 0; i < p.endAts.length; i++)
                                    Container(
                                      height: height1,
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.endAts[index]['type'] = data;
                                          }, val: p.endAts[i]['type'] ?? '', width: widthAreaT, key: '$i::pm.endAts.type', text: p.endAts[i]['type'] ?? '', label: '타입'),
                                          excelGridEditor(context, setFun: () async {
                                            if(setFun != null) await setFun();
                                            setStateS(() {});
                                          }, set: (index, data) {
                                            p.endAts[index]['date'] = data;
                                          }, val: p.endAts[i]['date'] ?? '', width: widthDateD, isDate: true, key: '$i::pm.endAts.date', text: p.endAts[i]['date'] ?? '', label: '날짜'),
                                          if(i == 0)
                                            excelGridButton(fun: () async {
                                              p.endAts.add({});
                                              if(setFun != null) await setFun();
                                              setStateS(() {});
                                            }, icon: Icons.add),
                                          if(i != 0)
                                            excelGridButton(fun: () async {
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
                                    excelGrid(label: '비고',),
                                    WidgetT.dividHorizontalLow(),
                                    excelGridEditor(context, multiLine: true, setFun: () async {
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
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
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
                                  iconStyleMini(icon: Icons.cancel),
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

  static dynamic ctRowWidget(BuildContext context, Contract p, { bool endVisible=false, Function? moreFun, Function? fun, bool viewShort=false, Color? color}) {

    var search = '';
    Widget searchW = SizedBox();
    searchW = Text(p.addresses.first, maxLines: 1, style: StyleT.titleStyle(),);
    if(SystemT.searchAddress != null) {
      search = SystemT.searchAddress.trim();
      if(search != '') {
        var adsss = p.addresses.first.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.addresses.first, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = RichText(
            text: TextSpan(
              style: StyleT.titleStyle(),
              children: textList,
            ),
          );
        }
      }
    }

    return TextButton(
      onPressed: () {
        if(fun!= null)
          fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                searchW,
                                SizedBox(width: 8,),
                                Text('지목 ', style: StyleT.textStyle(),),
                                Text('${p.landType}', style: StyleT.titleStyle(),),
                              ],
                            ),
                            SizedBox(height: 4,),
                            Container(alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text('실무자  ', style: StyleT.textStyle(),),
                                    Text('${SystemT.getManagerName(p.managerUid)}    ', style: StyleT.titleStyle(),),
                                    Text('신청인  ', style: StyleT.textStyle(),),
                                    Text('${p.clients.first['name']}  ', style: StyleT.titleStyle(),),
                                    Text('연락처  ', style: StyleT.textStyle(),),
                                    Text('${p.clients.first['phoneNumber']}', style: StyleT.titleStyle(),),
                                  ],
                                )),
                            SizedBox(height: 4,),
                            Container(alignment: Alignment.centerLeft, width:addressSize,
                                child: Row(
                                  children: [
                                    Text('사업목적  ', style: StyleT.textStyle(),),
                                    for(var s in p.useType)
                                    Text('$s,  ', style: StyleT.titleStyle(),),
                                  ],
                                )),
                            SizedBox(height: 2,),
                            Wrap(
                              //mainAxisSize: MainAxisSize.max,
                              spacing: 20, runSpacing: 2,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('총용역비용  ', style: StyleT.textStyle(),),
                                    Text('${StyleT.intNumberF(p.getAllCfPay())} / ${StyleT.intNumberF(p.getAllPay())}', style: StyleT.titleStyle(),),
                                    SizedBox(width: 4,),
                                    if(p.getAllCfPay() >= p.getAllPay())
                                      iconStyleMini(icon: Icons.check, size: 14, accent: true),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('계약금  ', style: StyleT.textStyle(),),
                                    Text('${StyleT.intNumberF(p.getCfDownPay())} / ${StyleT.intNumberF(p.downPayment)}', style: StyleT.titleStyle(),),
                                    SizedBox(width: 4,),
                                    if(p.getCfDownPay() >= p.downPayment)
                                      iconStyleMini(icon: Icons.check, size: 14, accent: true),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('중도금  ', style: StyleT.textStyle(),),
                                    Text('${StyleT.intNumberF(p.getCfMiddlePay())} / ${StyleT.intNumberF(p.middlePayment)}', style: StyleT.titleStyle(),),
                                    SizedBox(width: 4,),
                                    if(p.getCfMiddlePay() >= p.middlePayment)
                                      iconStyleMini(icon: Icons.check, size: 14, accent: true),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('잔금  ', style: StyleT.textStyle(),),
                                    Text('${StyleT.intNumberF(p.getCfBalance())} / ${StyleT.intNumberF(p.balance)}', style: StyleT.titleStyle(),),
                                    SizedBox(width: 4,),
                                    if(p.getCfBalance() >= p.balance)
                                      iconStyleMini(icon: Icons.check, size: 14, accent: true),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 4,),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Wrap(
                            //mainAxisSize: MainAxisSize.max,
                            runSpacing: 4,
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.task_alt, size: 14, accent: p.isContract()),
                                  SizedBox(width: 4,),
                                  Text('계약  ', style: StyleT.textStyle(),),
                                  Text('${p.contractAt}', style: StyleT.titleStyle(),),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.task_alt, size: 14, accent: p.isManaged()),
                                  SizedBox(width: 4,),
                                  Text('배당  ', style: StyleT.textStyle(),),
                                  Text('${p.takeAt}', style: StyleT.titleStyle(),),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.task_alt, size: 14 , accent: p.isApplied()),
                                  SizedBox(width: 4,),
                                  Text('접수  ', style: StyleT.textStyle(),),
                                  Text('${p.applyAt}', style: StyleT.titleStyle(),),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  iconStyleMini(icon: Icons.task_alt, size: 14 , accent: p.isPermitted()),
                                  SizedBox(width: 4,),
                                  Text('허가  ', style: StyleT.textStyle(),),
                                  Text('${p.permitAt}', style: StyleT.titleStyle(),),
                                ],
                              ),
                            ],
                          ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                if(moreFun != null)
                  await moreFun();
              },
              style: StyleT.buttonStyleNone(padding: 0, elevation: 0),
              child: iconStyleMini(icon: Icons.expand_more),
            )
          ],
        ),
      ),
    );
  }
  static dynamic ctRowShortWidget(BuildContext context, Contract p, { bool endVisible=false, Function? moreFun, Function? fun, bool viewShort=false, Color? color}) {
    var search = '';
    Widget searchW = SizedBox();
    searchW = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('주소 ', style: StyleT.textStyle(),),
        Text(p.addresses.first, maxLines: 1, style: StyleT.titleStyle(),),
      ],);
    if(SystemT.searchAddress != null) {
      search = SystemT.searchAddress.trim();
      if(search != '') {
        var adsss = p.addresses.first.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.addresses.first, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('주소 ', style: StyleT.textStyle(),),
              RichText(
                text: TextSpan(
                  style: StyleT.titleStyle(),
                  children: textList,
                ),
              ),
            ],
          );
        }
      }
    }

    var height1 = 28.0;
    var widthDateAt = 200.0;
    var widthPay = 200.0;
    var widthClient = 350.0;
    var widthManager = 150.0;
    var widthAddress = 300.0;
    var widthLand = 100.0;
    var widthDateF = 50.0;

    return TextButton(
      onPressed: () {
        if(fun!= null)
          fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
      child: Stack(
        children: [
          Container(
            color: (p.getAllCfPay() >= p.getAllPay()) ? Colors.black.withOpacity(0.1) : Colors.redAccent.withOpacity(0.00) ,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                  Text("${p.getContractAtsFirst()!.year}", style: StyleT.titleStyle(),),
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
                                  Text("${p.getContractAtsFirst()!.month}", style: StyleT.titleStyle(),),
                                  Text('월', style: StyleT.textStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                            Container( width: widthManager, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('실무자  ', style: StyleT.textStyle(),),
                                  Text('${SystemT.getManagerName(p.managerUid)}    ', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                            Container(  width: widthClient, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('신청인  ', style: StyleT.textStyle(),),
                                  Text('${p.clients.first['name']}  ', style: StyleT.titleStyle(),),
                                  Text('${p.clients.first['phoneNumber']}', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                            Container( width: widthAddress, alignment: Alignment.center,
                              child: searchW,
                            ),
                            WidgetT.dividVerticalLow(height: height1),
                            Container( width: widthLand, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('지목 ', style: StyleT.textStyle(),),
                                  Text('${p.landType}', style: StyleT.titleStyle(),),
                                ],
                              ),
                            ),
                            WidgetT.dividVerticalLow(height: height1),

                            Container(  width: widthPay, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('사업목적  ', style: StyleT.textStyle(),),
                                  Text('${p.useType.first},  ', style: StyleT.titleStyle(),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WidgetT.dividHorizontalLow(),
                          Container(
                            //color: (p.getAllCfPay() >= p.getAllPay()) ? Colors.green.withOpacity(0.14) : Colors.redAccent.withOpacity(0.14) ,
                            height: height1,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container( width: widthPay, alignment: Alignment.center,
                                  //color: (p.getCfDownPay() >= p.downPayment) ? Colors.green.withOpacity(0.14) : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('계약금  ', style: StyleT.textStyle(),),
                                      Text('${StyleT.intNumberF(p.getCfDownPay())} / ${StyleT.intNumberF(p.downPayment)}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                if(p.middlePayment > 0)
                                  Container( width: widthPay, alignment: Alignment.center,
                                    color: (p.getCfMiddlePay() >= p.middlePayment) ? Colors.green.withOpacity(0.14) : null,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(child: SizedBox()),
                                        Text('중도금  ', style: StyleT.textStyle(),),
                                        Text('${StyleT.intNumberF(p.getCfMiddlePay())} / ${StyleT.intNumberF(p.middlePayment)}', style: StyleT.titleStyle(),),
                                        Expanded(child: SizedBox()),
                                        WidgetT.dividVerticalLow(height: height1),
                                      ],
                                    ),
                                  ),
                                Container(  width: widthPay, alignment: Alignment.center,
                                  //color: (p.getCfBalance() >= p.balance) ? Colors.green.withOpacity(0.14) : null,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('잔금  ', style: StyleT.textStyle(),),
                                      Text('${StyleT.intNumberF(p.getCfBalance())} / ${StyleT.intNumberF(p.balance)}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                Container( width: widthPay, alignment: Alignment.center,
                                  color: (p.getAllCfPay() >= p.getAllPay()) ? Colors.green.withOpacity(0.14) : Colors.redAccent.withOpacity(0.14) ,
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('총용역비용  ', style: StyleT.textStyle(),),
                                      Text('${StyleT.intNumberF(p.getAllCfPay())} / ${StyleT.intNumberF(p.getAllPay())}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                Container( width: widthPay, alignment: Alignment.center,
                                  color: (p.getAllCfPay() >= p.getAllPay()) ? Colors.green.withOpacity(0.14) : Colors.redAccent.withOpacity(0.14) ,
                                  child:  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('미수금  ', style: StyleT.textStyle(),),
                                      Text('- ${StyleT.intNumberF(p.getAllPay() - p.getAllCfPay())}', style: StyleT.titleStyle(),),
                                    ],
                                  ),
                                ),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WidgetT.dividHorizontalLow(),
                          Container(
                            height: height1,
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(  width: widthDateAt, alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('계약  ', style: StyleT.textStyle(),),
                                      Text('${p.contractAt}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                Container( width: widthDateAt, alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('배당  ', style: StyleT.textStyle(),),
                                      Text('${p.takeAt}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                Container( width: widthDateAt, alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Text('접수  ', style: StyleT.textStyle(),),
                                      Text('${p.applyAt}', style: StyleT.titleStyle(),),
                                      Expanded(child: SizedBox()),
                                      WidgetT.dividVerticalLow(height: height1),
                                    ],
                                  ),
                                ),
                                Container( width: widthDateAt, alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('허가  ', style: StyleT.textStyle(),),
                                      Text('${p.permitAt}', style: StyleT.titleStyle(),),
                                    ],
                                  ),
                                ),
                                WidgetT.dividVerticalLow(height: height1),
                                Container( alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 18,),
                                      Text('타사업무  ', style: StyleT.textStyle(),),
                                      Text('${p.thirdParty.join(',  ')}', style: StyleT.titleStyle(),),
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
              ],
            ),
          ),
          if((p.getAllCfPay() >= p.getAllPay()))
          //if(false)
            Positioned(
              left: 18, top: 4, bottom: 4,
              child: Image.asset('assets/stamp_3.png', fit: BoxFit.contain, color: Colors.deepPurple.withOpacity(0.35),),
            )
        ],
      ),
    );
  }
  static dynamic ctRowExcelEditorWidget(BuildContext context, Contract p, { bool endVisible=false,
    Function? closeFun, Function? setFun, Function? saveFun, Function? fun, bool viewShort=false, Color? color}) {

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

    if(p.clients.length <= 0) p.clients.add({});
    if(p.addresses.length <= 0) p.clients.add('');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                          excelGridButton(fun: () async {
                            if(setFun != null) await setFun();
                          }, icon: Icons.calendar_month),
                          excelGridEditor(context,setFun: setFun, width: widthManager,
                              alignment: Alignment.centerLeft, isManager: true,
                              set: (index, data) {
                                p.managerUid = data;
                              }, key: 'ct.manager', text: '${SystemT.getManagerName(p.managerUid)}',
                              label: '실무자'),
                          excelGridEditor(context,setFun: setFun,
                              set: (index, data) {
                                p.landType = data;
                              }, val: p.landType ?? '', width: 150,
                              key: 'ct.landType', text: p.landType, label: '지목'),
                        ],
                      ),
                      WidgetT.dividHorizontalLow(),
                      WidgetT.dividHorizontalLow(),
                      Container( width: widthClientN + widthClientPN,
                        child: Row(
                          children: [
                            Expanded(child: excelGrid(label: '소재지',)),
                            excelGridButton(fun: () async {
                              p.addresses.add('');
                              if(setFun != null) await setFun();
                            }, icon: Icons.add),
                          ],
                        ),
                      ),
                      WidgetT.dividHorizontalLow(),
                      for(int i = 0; i < p.addresses.length; i++)
                        Container(
                          height: height1, width: widthAddress,
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: excelGridEditor(context, isAddress: true, width: widthAddress - 28.7,
                                    setFun: setFun, set: (index, data) {
                                  p.addresses[index] = data;
                                }, val: p.addresses[i] ?? '', key: '$i::ct.addresses',
                                    text: p.addresses[i], label: '소재지'),
                              ),
                              excelGridButton(fun: () async {
                                if(p.addresses.length <= 1) p.addresses[0] = '';
                                else p.addresses.removeAt(i);

                                if(setFun != null) await setFun();
                              }, icon: Icons.delete),
                            ],
                          ),
                        ),
                      WidgetT.dividHorizontalLow(),
                      WidgetT.dividHorizontalLow(),

                      Container( width: widthClientN + widthClientPN,
                        child: Row(
                          children: [
                            Expanded(child: excelGrid(label: '신청인',)),
                            excelGridButton(fun: () async {
                              p.clients.add({});
                              if(setFun != null) await setFun();
                            }, icon: Icons.add),
                          ],
                        ),
                      ),
                      WidgetT.dividHorizontalLow(),
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
                                    child: excelGridEditor(context, setFun: setFun, set: (index, data) {
                                      p.clients[index]['name'] = data;
                                    }, val: p.clients[i]['name'] ?? '',  key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                                  ),
                                  Expanded( flex: 7,
                                    child: excelGridEditor(context, setFun: setFun, set: (index, data) {
                                      p.clients[index]['phoneNumber'] = data;
                                    }, val: p.clients[i]['phoneNumber'] ?? '', key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                                  ),
                                  excelGridButton(fun: () async {
                                    p.clients.removeAt(i);
                                    if(setFun != null) await setFun();
                                  }, icon: Icons.delete),
                                ],
                              ),
                            ),
                            WidgetT.dividHorizontalLow(),
                          ],
                        ),

                      WidgetT.dividHorizontalLow(),
                      excelGrid(label: '계약 정보', width: widthPay * 5 ),
                      WidgetT.dividHorizontalLow(),
                      Row(
                        children: [
                          excelGridEditor(context, setFun: setFun, set: (index, data) {
                            p.downPayment = int.tryParse(data) ?? 0;
                          }, val: (p.downPayment == 0) ? '' : p.downPayment.toString(), width: widthPay,
                              key: 'ct.downPayment', text: StyleT.intNumberF(p.downPayment), label: '계약금'),
                          excelGridEditor(context, setFun: setFun, set: (index, data) {
                            p.middlePayments.clear();
                            for(var d in data.split('/'))
                              p.middlePayments.add(int.tryParse(d.toString().trim()) ?? 0);
                          }, val: p.getMiddlePaysToEdite(), width: widthPay * 2,
                              key: 'ct.middlePayments', text: p.getMiddlePaysToString(),
                              label: '중도금 ( / / )'),
                          excelGridEditor(context, setFun: setFun, set: (index, data) {
                            p.balance = int.tryParse(data) ?? 0;
                          }, val: (p.balance == 0) ? '' : p.balance.toString(), width: widthPay,
                              key: 'ct.balance', text: StyleT.intNumberF(p.balance), label: '잔금'),
                          excelGrid(width: widthPay, label: '총용역비용', text: '${StyleT.intNumberF(p.getAllPay())}'),
                          excelGrid(width: widthPay, label: '미수금', text: '- ${StyleT.intNumberF(p.getAllPay() - p.getAllCfPay())}'),
                        ],
                      ),
                      WidgetT.dividHorizontalLow(),
                      Row(
                          children: [
                            excelGridEditor(context, setFun: setFun,
                                isDropMenu: true, dropMenus: ['포함', '미포함'],
                                set: (index, data) {
                                  if(data == '포함') p.isVAT = true;
                                  else p.isVAT = false;
                                },
                                key: 'ct.isVAT',
                                width: widthPay,
                                text: p.isVAT ? '포함' : '미포함',
                                label: '부가세'),
                            excelGridEditor(context,setFun: setFun, width: widthPay * 2,
                                alignment: Alignment.centerLeft,
                                set: (index, data) {
                                  p.thirdParty = data.split(',');
                                }, val: p.thirdParty.join(','),
                                key: 'ct.thirdParty', text: p.thirdParty.join(',  '), label: '타사업무내용 ( , , )'),
                            excelGridEditor(context,setFun: setFun,
                                alignment: Alignment.centerLeft,
                                set: (index, data) {
                                  p.useType = data.split(',');
                                }, val: p.useType.join(','), width: widthPay * 3,
                                key: 'ct.useType', text: p.useType.join(',  '), label: '사업목적 ( , , )'),
                          ]
                      ),
                      WidgetT.dividHorizontalLow(),
                      Row(
                        children: [
                          excelGridEditor(context, isDate: true, setFun: setFun, set: (index, data) {
                            p.contractAt = data ?? '';
                          }, val: p.contractAt, width: widthPay,
                              key: 'ct.contractAt', text: p.contractAt, label: '계약일'),
                          excelGridEditor(context, isDate: true, setFun: setFun, set: (index, data) {
                            p.takeAt = data ?? '';
                          }, val: p.takeAt, width: widthPay,
                              key: 'ct.takeAt', text: p.takeAt, label: '업무배당일'),
                          excelGridEditor(context, isDate: true, setFun: setFun, set: (index, data) {
                            p.applyAt = data ?? '';
                          }, val: p.applyAt, width: widthPay,
                              key: 'ct.applyAt', text: p.applyAt, label: '접수일'),
                          excelGridEditor(context, isDate: true, setFun: setFun, set: (index, data) {
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
                    }, icon: Icons.add),
                  ],
                ),
                WidgetT.dividHorizontalLow(),
                for(int i = 0; i < p.confirmDeposits.length; i++)
                  Row(
                  children: [
                    excelGridEditor(context, isDate: true, setFun: setFun,
                        set: (index, data) {
                          p.confirmDeposits[i]['date'] = data;
                        }, val: p.confirmDeposits[i]['date'], width: 150,
                        key: '$i::ct.confirmDeposits.date', text: p.confirmDeposits[i]['date'], label: '입금날짜'),
                    excelGridEditor(context, isDropMenu: true, setFun: setFun, dropMenus: [ '-81', '-51', '카드결제', '기타' ],
                        set: (index, data) {
                          p.confirmDeposits[i]['account'] = data;
                        }, val: p.confirmDeposits[i]['account'], width: 100,
                        key: '$i::ct.confirmDeposits.account', text: p.confirmDeposits[i]['account'], label: '계좌'),
                    excelGridEditor(context, isDropMenu: true, setFun: setFun, dropMenus: [ '계약금', '중도금', '잔금', '기타' ],
                        set: (index, data) {
                          p.confirmDeposits[i]['type'] = data;
                        }, val: p.confirmDeposits[i]['type'], width: 100,
                        key: '$i::ct.confirmDeposits.type', text: p.confirmDeposits[i]['type'], label: '분류'),
                   excelGridEditor(context, setFun: setFun,
                        set: (index, data) {
                          p.confirmDeposits[i]['balance'] = int.tryParse(data) ?? 0;
                        }, val: p.confirmDeposits[i]['balance'].toString(), width: widthPay,
                        key: '$i::ct.confirmDeposits.balance', text: StyleT.intNumberF(p.confirmDeposits[i]['balance']), label: '금액'),
                    excelGridEditor(context, setFun: setFun,
                        set: (index, data) {
                          p.confirmDeposits[i]['uid'] = data;
                        }, val: p.confirmDeposits[i]['uid'], width: 150,
                        key: '$i::ct.confirmDeposits.uid', text: p.confirmDeposits[i]['uid'], label: '입금자'),
                    Expanded(
                      child: excelGridEditor(context, setFun: setFun,
                          set: (index, data) {
                            p.confirmDeposits[i]['desc'] = data;
                          }, val: p.confirmDeposits[i]['desc'],
                          key: '$i::ct.confirmDeposits.desc', text: p.confirmDeposits[i]['desc'], label: '입금내용'),
                    ),
                    excelGridButton(fun: () async {
                      p.confirmDeposits.removeAt(i);
                      if(setFun != null) await setFun();
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
                WidgetT.dividHorizontalLow(),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: excelGridEditor(context,setFun: setFun, multiLine: true,
                            set: (index, data) {
                              p.thirdPartyDetails = data;
                            }, val: p.thirdPartyDetails,
                            key: 'ct.thirdPartyDetails', text: p.thirdPartyDetails, label: '내용'),
                      ),
                      Expanded(
                        child: excelGridEditor(context,setFun: setFun, multiLine: true,
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
        SizedBox(height:  8,),
        Row(
          children: [
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    if(closeFun != null) await closeFun();
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
            SizedBox(width:  8,),
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    if(saveFun != null)
                      saveFun();
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
      ],
    );
  }
  static dynamic ctCreateExcelEditeWidgetDl(BuildContext context, Contract p,
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
                                      WidgetT.dividHorizontalLow(),
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
                                      WidgetT.dividHorizontalLow(),

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
                                      WidgetT.dividHorizontalLow(),
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
                                            WidgetT.dividHorizontalLow(),
                                          ],
                                        ),

                                      WidgetT.dividHorizontalLow(),
                                      excelGrid(label: '계약 정보', width: widthPay * 5 ),
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
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


  static dynamic wmRowShortWidget(BuildContext context, WorkManagement p,
      { bool endVisible=false, Function? moreFun, Function? fun, bool viewShort=false,
        Color? color}) {
    var search = '';
    Widget searchW = SizedBox();
    searchW = Text(p.addresses.first, maxLines: 1, style: StyleT.titleStyle(),);
    if(SystemT.searchAddress != null) {
      search = SystemT.searchAddress.trim();
      if(search != '') {
        var adsss = p.addresses.first.split(search);
        if(adsss.length > 1) {
          List<TextSpan> textList = StyleT.getSearchTextSpans(p.addresses.first, search,
              StyleT.titleStyle(backColor: StyleT.accentColor, color: Colors.white));
          searchW = RichText(
            text: TextSpan(
              style: StyleT.titleStyle(),
              children: textList,
            ),
          );
        }
      }
    }

    var height1 = 28.0;
    var widthDateAt = 250.0;
    var widthPay = 200.0;
    var widthAddress = 300.0;
    var widthClient = 350.0;
    var widthManager = 150.0;
    var widthDateF = 50.0;

    return TextButton(
      onPressed: () {
        if(fun!= null)
          fun();
      },
      style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: color ?? Colors.white.withOpacity(0.5)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: p.isSupplement ? Colors.red.withOpacity(0.03) : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                            WidgetT.dividVerticalLow(height: height1),
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
                            WidgetT.dividVerticalLow(height: height1),
                          ],
                        ),
                      ),
                      Container( width: widthManager, alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child: SizedBox()),
                            Text('실무자  ', style: StyleT.textStyle(),),
                            Text('${SystemT.getManagerName(p.managerUid)}    ', style: StyleT.titleStyle(),),
                            Expanded(child: SizedBox()),
                            WidgetT.dividVerticalLow(height: height1),
                          ],
                        ),
                      ),
                      Container(  width: widthClient, alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(child: SizedBox()),
                            Text('신청인  ', style: StyleT.textStyle(),),
                            Text('${p.clients.first['name']}    ', style: StyleT.titleStyle(),),
                            Text('연락처  ', style: StyleT.textStyle(),),
                            Text('${p.clients.first['phoneNumber']}', style: StyleT.titleStyle(),),
                            Expanded(child: SizedBox()),
                            WidgetT.dividVerticalLow(height: height1),
                          ],
                        ),
                      ),
                      Container( width: widthAddress, alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(child: SizedBox()),
                            Text('소재지  ', style: StyleT.textStyle(),),
                            searchW,
                            Expanded(child: SizedBox()),
                            WidgetT.dividVerticalLow(height: height1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetT.dividHorizontalLow(),
                    Container(
                      height: height1,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          excelGrid(width: widthDateAt, label: '측량일', text:p.workAts['survey']),
                          excelGrid(width: widthDateAt, label: '설계일', text:p.workAts['design']),
                          excelGrid(width: widthDateAt, label: '문서작성일', text:p.workAts['doc']),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetT.dividHorizontalLow(),
                    Container(
                      height: height1,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(  width: widthDateAt, alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('측량자', style: StyleT.textStyle(),),
                                Text('${p.workAts['survey_name'] ?? ' - '}', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
                          Container( width: widthDateAt, alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('설계자', style: StyleT.textStyle(),),
                                Text('${p.workAts['design_name'] ?? ' - '}', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
                          Container( width: widthDateAt, alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('문서작성자', style: StyleT.textStyle(),),
                                Text('${p.workAts['doc_name'] ?? ' - '}', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if(p.isSupplement)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetT.dividHorizontalLow(),
                      Container(
                        height: height1,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(  width: widthDateAt, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('보완일  ', style: StyleT.textStyle(),),
                                  Text('${p.supplementAt}', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                            Container( width: widthDateAt, alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('보완마감일  ', style: StyleT.textStyle(),),
                                  Text('${p.supplementOverAt}', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
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
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ) : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('마감일  ', style: StyleT.textStyle(),),
                                  Text('${p.getSupplementOverAmount().abs()}일 지남', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                            Container( alignment: Alignment.center,
                              color: (p.getSupplementOverAmount() > -3 && p.getSupplementOverAmount() < 3) ?
                              Colors.red.withOpacity(0.15) : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 18,),
                                  Text('보완내용  ', style: StyleT.textStyle(),),
                                  Text('${p.supplementDesc.replaceAll('\n', '   /   ')}', style: StyleT.titleStyle(),),
                                  //WidgetHub.dividVerticalLow(height: height1),
                                ],
                              ) 
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if(!p.isSupplement)
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetT.dividHorizontalLow(),
                    Container(
                      height: height1,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(  width: widthDateAt, alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('업무배당일  ', style: StyleT.textStyle(),),
                                Text('${p.taskAt}', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
                          Container( width: widthDateAt, alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('업무마감일  ', style: StyleT.textStyle(),),
                                Text('${p.taskOverAt}', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ),
                          ),
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
                                WidgetT.dividVerticalLow(height: height1),
                              ],
                            ) : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: SizedBox()),
                                Text('마감일  ', style: StyleT.textStyle(),),
                                Text('만료', style: StyleT.titleStyle(),),
                                Expanded(child: SizedBox()),
                                WidgetT.dividVerticalLow(height: height1),
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
          if(p.isSupplement)
            Positioned(
              left: 18, top: 16, bottom: 16,
              child: Image.asset('assets/stamp_2.png', fit: BoxFit.contain, color: Colors.red.withOpacity(0.3),),
            )
        ],
      ),
    );
  }
  static dynamic wmRowEditeWidget(BuildContext context, WorkManagement p,
      { bool endVisible=false, Function? moreFun, Function? saveFun, Function? fun, Function? setFun, bool viewShort=false,
        Color? color}) {

    var height1 = 28.0;
    var widthDateAt = 200.0;
    var widthPay = 200.0;
    var widthAddress = 500.0;
    var widthClient = 350.0;
    var widthManager = 150.0;
    var widthDateF = 50.0;

    ///
    return Column(
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
                            WidgetT.dividVerticalLow(height: height1),
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
                            WidgetT.dividVerticalLow(height: height1),
                          ],
                        ),
                      ),
                      excelGridEditor(context,setFun: setFun, width: widthManager,
                          alignment: Alignment.centerLeft, isManager: true,
                          set: (index, data) {
                            p.managerUid = data;
                          }, key: 'pm.manager', text: '${SystemT.getManagerName(p.managerUid)}',
                          label: '실무자'),
                    ],
                  ),
                ),
                WidgetT.dividHorizontalLow(),
                WidgetT.dividHorizontalLow(),
                Container( width: 600,
                    child: Row(
                      children: [
                        Expanded(child: excelGrid(label: '소재지'),),
                        excelGridButton(fun: () async {
                          p.addresses.add('');
                          if(setFun != null) await setFun();
                        }, icon: Icons.add),
                      ],
                    ),
                ),
                WidgetT.dividHorizontalLow(),
                for(int i = 0; i < p.addresses.length; i++)
                  Container(
                    height: height1, width: 600,
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: excelGridEditor(context, isAddress: true, width: widthAddress - 28.7,
                              setFun: setFun, set: (index, data) {
                                p.addresses[index] = data;
                              }, val: p.addresses[i] ?? '', key: '$i::pm.addresses',
                              text: p.addresses[i], label: '소재지'),
                        ),
                        excelGridButton(fun: () async {
                          p.addresses.removeAt(i);
                          if(setFun != null) await setFun();
                        }, icon: Icons.delete),
                      ],
                    ),
                  ),
                WidgetT.dividHorizontalLow(),
                WidgetT.dividHorizontalLow(),
                Container( width: 600,
                    child: Row(
                      children: [
                        Expanded(child: excelGrid(label: '신청인',)),
                        excelGridButton(fun: () async {
                          p.clients.add({});
                          if(setFun != null) await setFun();
                        }, icon: Icons.add),
                      ],
                    ),
                ),
                WidgetT.dividHorizontalLow(),
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
                              child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); },
                                  set: (index, data) {
                                    p.clients[index]['name'] = data;
                                  }, val: p.clients[i]['name'] ?? '',  key: '$i::pm.clients.name', text: p.clients[i]['name'], label: '신청인'),
                            ),
                            Expanded( flex: 7,
                              child: excelGridEditor(context, setFun: () { if(setFun != null) setFun(); },
                                  set: (index, data) {
                                    p.clients[index]['phoneNumber'] = data;
                                  }, val: p.clients[i]['phoneNumber'] ?? '', key: '$i::pm.clients.phoneNumber', text: p.clients[i]['phoneNumber'], label: '연락처'),
                            ),
                            excelGridButton(fun: () async {
                              p.clients.removeAt(i);
                              if(setFun != null) await setFun();
                            }, icon: Icons.delete),
                          ],
                        ),
                      ),
                      WidgetT.dividHorizontalLow(),
                    ],
                  ),
                WidgetT.dividHorizontalLow(),
                excelGridEditor(context,setFun: () { if(setFun != null) setFun(); },
                    alignment: Alignment.center,
                    set: (index, data) {
                      p.useType = data.split(',');
                    }, val: p.useType.join(','), width: 600,
                    key: 'ct.useType', text: p.useType.join(',  '), label: '사업목적 ( , , )'),
                WidgetT.dividHorizontalLow(),
                WidgetT.dividHorizontalLow(),
                Container(
                  height: height1,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
                        p.workAts['survey'] = data;
                      }, val: p.workAts['survey'] ?? '', width: widthDateAt, key: 'wm.workAts.survey', text: p.workAts['survey'], label: '측량일'),
                      excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
                        p.workAts['design'] = data;
                      }, val: p.workAts['design'] ?? '', width: widthDateAt, key: 'wm.workAts.design', text: p.workAts['design'], label: '설계'),
                      excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
                        p.workAts['doc'] = data;
                      }, val: p.workAts['doc'] ?? '', width: widthDateAt, key: 'wm.workAts.doc', text: p.workAts['doc'], label: '문서'),
                    ],
                  ),
                ),
                WidgetT.dividHorizontalLow(),
                Container(
                  height: height1,
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      excelGridEditor(context, setFun: setFun, set: (index, data) {
                        p.workAts['survey_name'] = data;
                      }, val: p.workAts['survey_name'] ?? '', width: widthDateAt, key: 'wm.workAts.survey_name',
                          text: p.workAts['survey_name'], label: '측량자'),
                      excelGridEditor(context, setFun: setFun, set: (index, data) {
                        p.workAts['design_name'] = data;
                      }, val: p.workAts['design_name'] ?? '', width: widthDateAt, key: 'wm.workAts.design_name',
                          text: p.workAts['design_name'], label: '설계자'),
                      excelGridEditor(context, setFun: setFun, set: (index, data) {
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
                      excelGridEditor(context, setFun: setFun,
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
                WidgetT.dividHorizontalLow(),
                if(p.isSupplement)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetT.dividHorizontalLow(),
                      Container(
                        height: height1,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
                              p.supplementAt = data;
                            }, val: p.supplementAt ?? '', width: widthDateAt, key: 'wm.supplementAt',
                                text: p.supplementAt, label: '보완일'),
                            excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
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
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ) : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('마감일  ', style: StyleT.textStyle(),),
                                  Text('${p.getSupplementOverAmount().abs()}일 지남', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      WidgetT.dividHorizontalLow(),
                      excelGridEditor(context, setFun: setFun, multiLine: true, set: (index, data) {
                        p.supplementDesc = data;
                      }, val: p.supplementDesc ?? '', width: 600, key: 'wm.supplementDesc',
                          text: p.supplementDesc, label: '보완내용'),
                    ],
                  ),
                if(!p.isSupplement)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetT.dividHorizontalLow(),
                      Container(
                        height: height1,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
                              p.taskAt = data;
                            }, val: p.taskAt ?? '', width: widthDateAt, key: 'wm.taskAt', text: p.taskAt, label: '업무배당일'),
                            excelGridEditor(context, setFun: setFun, isDate:true, set: (index, data) {
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
                                  WidgetT.dividVerticalLow(height: height1),
                                ],
                              ) : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: SizedBox()),
                                  Text('마감일  ', style: StyleT.textStyle(),),
                                  Text('만료', style: StyleT.titleStyle(),),
                                  Expanded(child: SizedBox()),
                                  WidgetT.dividVerticalLow(height: height1),
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
        SizedBox(height: 8,),
        Row(
          children: [
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    //if(closeFun != null) await closeFun();
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
            SizedBox(width:  8,),
            Container( height: 28,
              child: TextButton(
                  onPressed: () async {
                    if(saveFun != null)
                      saveFun();
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
            SizedBox(width:  8,),
            if(!p.isMessageSent)
              Container( height: 28,
                child: TextButton(
                    onPressed: () async {
                      //p.isMessageSent = await AligoAPI.sendMessage();
                      if(p.isMessageSent) {
                        await FirebaseT.postWorkManagementWithAES(p, p.id);
                        await WidgetT.showSnackBar(context, text: '신청인에게 문자가 전송되었습니다.');
                      } else {
                        await WidgetT.showSnackBar(context, text: '문자 전송에 실패했습니다. 나중에 다시 시도해주세요');
                      }
                      if(setFun != null) await setFun();
                    },
                    style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 8,
                        color: StyleT.accentLowColor.withOpacity(0.5)),
                    child: Row( mainAxisSize: MainAxisSize.min,
                      children: [
                        iconStyleMini(icon: Icons.send),
                        Text('업무시작문자전송', style: StyleT.titleStyle(),),
                        SizedBox(width: 12,),
                      ],
                    )
              ),
            ),
            if(p.isMessageSent)
              Container( height: 28,
                child: TextButton(
                    onPressed: null,
                    style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 8,
                        color: Colors.yellow.withOpacity(0.5)),
                    child: Row( mainAxisSize: MainAxisSize.min,
                      children: [
                        iconStyleMini(icon: Icons.send),
                        Text('전송됨', style: StyleT.titleStyle(),),
                        SizedBox(width: 12,),
                      ],
                    )
                ),
              ),
          ],
        )
      ],
    );
  }
  static dynamic wmCreateExcelEditeWidgetDl(BuildContext context, WorkManagement p,
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
                                            WidgetT.dividVerticalLow(height: height1),
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
                                            WidgetT.dividVerticalLow(height: height1),
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
                                WidgetT.dividHorizontalLow(),
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
                                    ],
                                  ),
                                WidgetT.dividHorizontalLow(),
                                excelGridEditor(context,setFun: () { if(setFun != null) setFun(); setStateS(() {}); },
                                    alignment: Alignment.center,
                                    set: (index, data) {
                                      p.useType = data.split(',');
                                    }, val: p.useType.join(','), width: 600,
                                    key: 'ct.useType', text: p.useType.join(',  '), label: '사업목적 ( , , )'),
                                WidgetT.dividHorizontalLow(),
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
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
                                WidgetT.dividHorizontalLow(),
                                if(p.isSupplement)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetT.dividHorizontalLow(),
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
                                                  WidgetT.dividVerticalLow(height: height1),
                                                ],
                                              ) : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감일  ', style: StyleT.textStyle(),),
                                                  Text('${p.getSupplementOverAmount().abs()}일 지남', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetT.dividVerticalLow(height: height1),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      WidgetT.dividHorizontalLow(),
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
                                      WidgetT.dividHorizontalLow(),
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
                                                  WidgetT.dividVerticalLow(height: height1),
                                                ],
                                              ) : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Expanded(child: SizedBox()),
                                                  Text('마감일  ', style: StyleT.textStyle(),),
                                                  Text('만료', style: StyleT.titleStyle(),),
                                                  Expanded(child: SizedBox()),
                                                  WidgetT.dividVerticalLow(height: height1),
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


  static Map<String, GestureDetector> gestureDetector = new Map();
  static Map<String, GlobalKey> globalKey = new Map();

  static Widget excelRow({ List<Widget>? children }) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children ?? [],
      ),
    );
  }
  static Widget excelGrid({ double? width, double? height, String? label, String? text }) {
    return Container( width: width, height: 28, alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: SizedBox()),
          Text('$label  ', style: StyleT.textStyle(),),
          Text('${text ?? ''}', style: StyleT.titleStyle(),),
          Expanded(child: SizedBox()),
          WidgetT.dividVerticalLow(height: height),
        ],
      ),
    );
  }

  static Widget excelGridEditor(BuildContext context, { Alignment alignment=Alignment.center, bool multiLine=false,Function(int, dynamic)? set, Function? setFun, double? width, double? height,
    String? key, String? hint, String? val, String? label, String? text,
    bool isDate=false, bool isArch=false, bool isDropMenu=false, List<String>? dropMenus,
  bool isManager=false, bool isAddress=false }) {
    if(key != null) {
      if(textInputs[key] == null)
        textInputs[key] = new TextEditingController();

      if(editInput[key] == true) {
        if(isAddress) {
          Widget w = Container(
            height: 28,
            child: SimpleAutoCompleteTextField(
              autofocus: true,
              key: GlobalKey(),
              style: StyleT.titleStyle(),
              decoration: WidgetT.textInputDecoration( hintText: hint, round: 0,
                  backColor: Colors.white.withOpacity(0.5)),
              controller: textInputs[key]!,
              suggestionsAmount: 10,
              suggestions: SystemT.searchAddressList,
              submitOnSuggestionTap: true,
              textChanged: (text) {
                //print(text);
              },
              textSubmitted: (text) async {
                //openDropdown(globalKey[key!]!, context);
                //return;

                await AddressAPI.fetchAddressList(text);
                editInput[key!] = false;
                print(text);
                var i = int.tryParse(key!.split('::').first) ?? 0;
                if(set != null) await set(i, text);
                if(setFun != null) await setFun();
              },
            ),
          );
          return Focus(
            onFocusChange: (hasFocus) async {
              if(!hasFocus) {
                await AddressAPI.fetchAddressList(textInputs[key]!.text);

                if(editInput[key] == false) return;
                textOutput[key] = textInputs[key]!.text; textInputs[key]!.clear();
                editInput[key] = false;
                var data = textOutput[key];

                var i = int.tryParse(key.split('::').first) ?? 0;
                if(set != null) await set(i, data);
                if(setFun != null) await setFun();
              }
            },
            child: w,
          );
        }

        Widget w = Transform.scale(
          scaleY: 1, scaleX: 1,
          child: Container(
            width: width, height: multiLine ? null : 28,
            child: TextFormField(
              //focusNode: textInputFocus[k!],
              autofocus: true,
              maxLines: multiLine ? null : 1,
              textInputAction: multiLine ? TextInputAction.newline : TextInputAction.search,
              keyboardType: multiLine ? TextInputType.multiline : TextInputType.none,
              onEditingComplete: () async {
                textOutput[key] = textInputs[key]!.text; textInputs[key]!.clear();
                editInput[key] = false;
                var data = textOutput[key];
                var i = int.tryParse(key.split('::').first) ?? 0;
                if(set != null) await set(i, data);
                if(setFun != null) await setFun();
              },
              decoration: WidgetT.textInputDecoration( hintText: hint, round: 4,
                  backColor: Colors.white.withOpacity(0.5)),
              controller: textInputs[key],
            ),
          ),
        );
        return Focus(
          onFocusChange: (hasFocus) async {
            if(!hasFocus) {
              textOutput[key] = textInputs[key]!.text; textInputs[key]!.clear();
              editInput[key] = false;
              var data = textOutput[key];
              //textInputFocus[k]?.requestFocus();

              var i = int.tryParse(key.split('::').first) ?? 0;
              if(set != null) await set(i, data);
              if(setFun != null) await setFun();
            }
          },
          child: w,
        );
      }
    }

    if(isManager)
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
                    if(isDate)
                      Container(  width: 28, height: 28,
                        child: TextButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(), //get today's date
                                  firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101)
                              );
                              if(key!=null && pickedDate != null) {
                                var i = int.tryParse(key.split('::').first) ?? 0;
                                var dateString = DateFormat('yyyy.MM.dd').format(pickedDate);
                                if(set != null) await set(i, dateString);
                              }
                              if(setFun != null) await setFun();
                            },
                            style: StyleT.buttonStyleNone(padding: 0),
                            child: iconStyleMini(icon: Icons.calendar_month)
                        ),
                      ),
                    if(isArch)
                      Container(  width: 28, height: 28,
                        child: TextButton(
                            onPressed: () async {
                              var arch = await showBTArchList(context);
                              if(key!=null && arch != null) {
                                var i = int.tryParse(key.split('::').first) ?? 0;
                                if(set != null) await set(i, arch.id);
                              }
                              if(setFun != null) await setFun();
                            },
                            style: StyleT.buttonStyleNone(padding: 0),
                            child: iconStyleMini(icon: Icons.more_vert)
                        ),
                      ),
                    WidgetT.dividVerticalLow(height: height),
                  ],
                ),
              ),
            ),
            items: SystemT.managers.map((item) => DropdownMenuItem<dynamic>(
              value: item.id,
              child: Text(
                item.name.toString(),
                style: StyleT.titleStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            )).toList(),
            onChanged: (value) async {
              if(key == null) return;

              var i = int.tryParse(key.split('::').first) ?? 0;
              if(set != null) await set(i, value);
              if(setFun != null) await setFun();
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
    if(isDropMenu)
      return Container(
      height: 28,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton:  Container(  width: width, height: multiLine ? null : 28, alignment: Alignment.center,
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
                  if(isDate)
                    Container(  width: 28, height: 28,
                      child: TextButton(
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2101)
                            );
                            if(key!=null && pickedDate != null) {
                              var i = int.tryParse(key.split('::').first) ?? 0;
                              var dateString = DateFormat('yyyy.MM.dd').format(pickedDate);
                              if(set != null) await set(i, dateString);
                            }
                            if(setFun != null) await setFun();
                          },
                          style: StyleT.buttonStyleNone(padding: 0),
                          child: iconStyleMini(icon: Icons.calendar_month)
                      ),
                    ),
                  if(isArch)
                    Container(  width: 28, height: 28,
                      child: TextButton(
                          onPressed: () async {
                            var arch = await showBTArchList(context);
                            if(key!=null && arch != null) {
                              var i = int.tryParse(key.split('::').first) ?? 0;
                              if(set != null) await set(i, arch.id);
                            }
                            if(setFun != null) await setFun();
                          },
                          style: StyleT.buttonStyleNone(padding: 0),
                          child: iconStyleMini(icon: Icons.more_vert)
                      ),
                    ),
                  WidgetT.dividVerticalLow(height: height),
                ],
              ),
            ),
          ),
          items: dropMenus?.map((item) => DropdownMenuItem<dynamic>(
            value: item,
            child: Text(
              item.toString(),
              style: StyleT.titleStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          )).toList(),
          onChanged: (value) async {
            if(key == null) return;

            var i = int.tryParse(key.split('::').first) ?? 0;
            if(set != null) await set(i, value);
            if(setFun != null) await setFun();
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

    return Container(  width: width, height: multiLine ? null : 28,
      alignment: alignment,
      child: TextButton(
        onPressed: () async {
          if(key != null){
            editInput.clear();
            editInput[key!] = true;

            if(textInputs[key!] == null) textInputs[key!] = new TextEditingController();
            textInputs[key!]!.text = val ?? '';
          }
          if(setFun != null) await setFun();
        },
        style: StyleT.buttonStyleNone(padding: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                alignment: alignment, padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(alignment == Alignment.centerLeft)
                      SizedBox(width: 8,),

                    Text('$label  ', style: StyleT.textStyle(),),
                    Text('${text ?? '' }', style: StyleT.titleStyle(),),
                  ],
                ),
              ),
            ),
            if(isDate)
              Container(  width: 28, height: 28,
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
                      if(key!=null && pickedDate != null) {
                        var i = int.tryParse(key.split('::').first) ?? 0;
                        var dateString = DateFormat('yyyy.MM.dd').format(pickedDate);
                        if(set != null) await set(i, dateString);
                      }
                      if(setFun != null) await setFun();
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: iconStyleMini(icon: Icons.calendar_month)
                ),
              ),
            if(isArch)
              Container(
                height: 28, width: 28,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Container( width: 28, height: 28, alignment: Alignment.center,
                      child: TextButton(
                        onPressed: null,
                        style: StyleT.buttonStyleNone(padding: 0),
                        child:  iconStyleMini(icon: Icons.more_vert),
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
                      if(key == null) return;

                      var i = int.tryParse(key.split('::').first) ?? 0;
                      if(set != null) await set(i, value);
                      if(setFun != null) await setFun();
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
              ),

            if(isAddress)
              Container(  width: 28, height: 28,
                child: TextButton(
                    onPressed: () async {
                      var address = await addressSearchDl(context, textController: textInputs[key]);
                      if(key!=null && address != null) {
                        var i = int.tryParse(key.split('::').first) ?? 0;
                        if(set != null) await set(i, address);
                      }
                      if(setFun != null) await setFun();
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: iconStyleMini(icon: Icons.content_paste_search)
                ),
              ),
              WidgetT.dividVerticalLow(height: height),
          ],
        ),
      ),
    );
  }
  static Widget excelGridEditorButton({ Function? fun, double? width, IconData? icon, String? label, String text='' }) {
    return SizedBox( height: 28, width: width,
      child: TextButton(
        onPressed: () async {
          if(fun != null) await fun();
        },
        style: StyleT.buttonStyleNone(padding: 0),
        child: Container(alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: SizedBox()),
              if(icon != null)
                iconStyleMini(icon: icon),
              if(label != null)
                Text('$label  ', style: StyleT.textStyle(),),
              Text('$text', style: StyleT.titleStyle(),),
              Expanded(child: SizedBox()),
              WidgetT.dividVerticalLow(),
            ],
          ),
        ),
      ),
    );
  }
  static Widget excelGridButton({ Function? fun, IconData? icon, String? label, String text='' }) {
    return SizedBox( height: 28,
      child: TextButton(
        onPressed: () async {
          if(fun != null) await fun();
        },
        style: StyleT.buttonStyleNone(padding: 0),
        child: Container(alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(icon != null)
                iconStyleMini(icon: icon),
              if(label != null)
                Text('$label  ', style: StyleT.titleStyle(),),
              Text('$text', style: StyleT.titleStyle(),),
              WidgetT.dividVerticalLow(),
            ],
          ),
        ),
      ),
    );
  }

  static dynamic addressSearchDl(BuildContext context, { TextEditingController? textController }) async {
    textController?.clear();
    String aa = await showDialog(
        context: context,
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
                title: Container(padding: EdgeInsets.all(12), child: Text('도로명 주소 검색', style: StyleT.titleStyle(bold: true))),
                content: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 500, height: 36,
                          child: TextFormField(
                            //focusNode: textInputFocus[k!],
                            autofocus: true,
                            maxLines: 1,
                            textInputAction: TextInputAction.search,
                            keyboardType: TextInputType.none,
                            onEditingComplete: () async {
                              await AddressAPI.fetchAddressList(textController!.text);
                              setStateS(() {});
                            },
                            decoration: WidgetT.textInputDecoration( hintText: '주소를 입력해 주세요.', round: 4,
                                backColor: Colors.white.withOpacity(0.5)),
                            controller: textController,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(int i = 0; i < AddressAPI.addressStringList.length; i++)
                            Container(
                              padding: EdgeInsets.only(top: 8),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context, AddressAPI.addressStringList[i]);
                                },
                                style: StyleT.buttonStyleOutline(padding: 8, elevation: 0,
                                    strock: 1.4,
                                    color: Colors.white.withOpacity(0.5)),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('지번     ', style: StyleT.textStyle(),),
                                                Text(AddressAPI.addressStringList[i], style: StyleT.titleStyle(),),
                                              ],
                                            ),
                                            Text('도로명  ' +  AddressAPI.addressStringListRoad[i], style: StyleT.textStyle(),),
                                          ],
                                        ),
                                      ),
                                    ),
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
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
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
                                Navigator.pop(context, textController?.text);
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

    return aa;
  }
  
  
  static Widget iconStyleMini({IconData? icon, double? size, double? iconSize, bool accent=false}) {
    return SizedBox(
      height: size ?? 28, width: size ?? 28,
      child: Icon(icon ?? Icons.star_purple500_sharp,  color: accent ? Colors.blue : StyleT.titleColor,  size: iconSize ?? 14,),
    );
  }
  static Widget iconStyleMiddle({IconData? icon, double? size, double? iconSize, bool accent=false}) {
    return SizedBox(
      height: size ?? 28, width: size ?? 28,
      child: Icon(icon ?? Icons.star_purple500_sharp,  color: accent ? Colors.blue : StyleT.titleColor,
        size: iconSize ?? 20,),
    );
  }
  static Widget iconStyleBig({IconData? icon, double? size, Color? color}) {
    return SizedBox(
      height: size ?? 48, width: size ?? 48,
      child: Icon(icon ?? Icons.star_purple500_sharp,  color: color ?? StyleT.titleColor,  size: 24,),
    );
  }
  static Widget iconStyleBigLarge({IconData? icon, double? size}) {
    return SizedBox(
      child: Icon(icon ?? Icons.star_purple500_sharp,  color: StyleT.accentColor,  size: 36,),
    );
  }
  
  static InputDecoration textInputDecoration({ String? hintText, double round=0.0, Color? backColor}) {
    return  InputDecoration(
      enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: StyleT.accentLowColor, width: 1.4)),
      focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: StyleT.accentColor, width: 1.7),),
      filled: true,
      fillColor: backColor ?? StyleT.accentColor.withOpacity(0.07),
      hintText: hintText ?? '',
      hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      contentPadding: EdgeInsets.fromLTRB(12, 8, 8, 8),
    );
  }
  
  static Widget textInputField(TextEditingController controller, { String? hintText, double? height, int? maxLines,
    EdgeInsets? padding, double round=0.0, }) {
    return Container(
      height: height ?? 28,
      margin: padding ?? EdgeInsets.fromLTRB(0, 2, 0, 2),
      child: TextFormField(
        maxLines: maxLines ?? 1,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        decoration: textInputDecoration(hintText: hintText, round: round),
            controller: controller,
      ),
    );
  }
  static void openPageWithFade(BuildContext context, dynamic page, { int? time, bool? first=false}) {
    if(first!)
      Navigator.of(context).popUntil((route) => route.isFirst);

    //Navigator.push(context, MaterialPageRoute(builder: (context) => page),);
    Navigator.of(context).push(FadePageRoute(page, time ?? 0));
  }
  static Widget dividViertical({Color? color, double? height}) {
    return Container(height: height, width: 0.7, color: color ?? StyleT.titleColor.withOpacity(0.35),);
  }
  static Widget dividHorizontal({Color? color, double? width}) {
    return Container(height: 1.4, width: width, color: color ?? StyleT.titleColor.withOpacity(0.35),);
  }

  static Widget dividVerticalLow({Color? color, double? height}) {
    return Container(height: height, width: 0.5, color: color ?? StyleT.titleColor.withOpacity(0.5),);
  }
  static Widget dividHorizontalLow({Color? color, double? width}) {
    return Container(height: 0.5, width: width, color: color ?? StyleT.titleColor.withOpacity(0.5),);
  }

  static Widget backButton(BuildContext context) {
    return SizedBox(
      height: 28, width: 28,
      child: TextButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        //style: SystemStyle.buttonStyleOutline(padding: 0),
        child: Icon(Icons.arrow_back_outlined, size: 14, color: StyleT.titleColor,),
      ),
    );
  }

  static Widget vertSizedPadding() {
    return SizedBox(height: 12,);
  }


  static dynamic loadingBottomSheet(BuildContext context,) async {
    showModalBottomSheet(context: context,
        isDismissible: false,
        builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 18, height: 18, child: CircularProgressIndicator(),),
              SizedBox(height: 8,),
              Text('서버에서 데이터를 가져오는 중입니다.', style: StyleT.titleStyle(),),
            ],
          ),
        );
      });
    });
  }
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
                            iconStyleMini(icon: Icons.cancel),
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
                            iconStyleMini(icon: Icons.check_circle),
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
                    child: Text('버전 알림', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: StyleT.titleColor.withOpacity(0.7)))),
                WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.5)),
              ],
            ),
            content: Container(
              padding: EdgeInsets.all(12),
              child: Text('현재 최신버전이 아닙니다.'
                  '\n버전을 업데이트 해 주세요. ( 웹사이트에서 다운로드 GitHub )'
                  '\nZ:태기측량/태기측량 시스템 프로그램/(버전코드)'
                  '\n\n최신버전: ${SystemT.releaseVer}  현재버전: ${SystemT.currentVer}', style: StyleT.titleStyle()),
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
                            if(!force) {
                              Navigator.pop(context);
                              return;
                            }
                            appWindow.close();
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
                    Expanded(child: SizedBox()),
                    Container( height: 28,
                      child: TextButton(
                          onPressed: () {
                            if(!force) {
                              Navigator.pop(context);
                              return;
                            }
                            appWindow.close();
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
        });

    if(aa == null) aa = false;
    return aa;
  }

  static dynamic showBTManagerList(BuildContext context,) async {
    var aa = await showModalBottomSheet(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in SystemT.managers)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, m);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            m.name ?? '',
                        ),
                      ],
                    ))
            ],
          ),
        );
      });
    });
    return aa ?? '';
  }
  static dynamic showBTArchList(BuildContext context,) async {
    var aa = await showModalBottomSheet(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in SystemT.architectureOffices)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, m);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m.name ?? '',
                        ),
                      ],
                    ))
            ],
          ),
        );
      });
    });
    return aa ?? '';
  }

  static dynamic showSnackBar(BuildContext context, { String? text }) async {
     ScaffoldMessenger.of(context).clearSnackBars();
    await ScaffoldMessenger.of(context).showSnackBar(
      //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
        SnackBar(
          //width: 380,
          //elevation: 18,
          //behavior: SnackBarBehavior.floating,
          //backgroundColor: Colors.redAccent,
          content: Text(text ?? 'The feature is under development.'),
          duration: Duration(seconds: 3), //올라와있는 시간
          action: SnackBarAction(
            label: 'Undo',
            onPressed: (){},
          ),
        )
    );
  }
  Widget build(context) {
    return Container();
  }
}

class AppTitleBar extends StatelessWidget {
  var title = '';
  var back = true;
  AppTitleBar({Key? key, required this.title, required this.back,}) : super(key: key);
  var menu = [
    '허가 관리 대장',
    '종료 알림 목록',
    '업무 배당 관리',
  ];

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: SizedBox(
        height: 28,
        child: Stack(
          children: [
            Positioned(
                left: 0, right: 0, bottom: 0,
                child:  Container(
                  height: 0,
                )
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MoveWindow(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 28, width: 28, child: Image.asset('assets/taegi_icon.png'),),
                        SizedBox(width: 4,),
                        Text(
                          '태기측량 시스템 프로그램', style: StyleT.titleStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const WindowButtons()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
final buttonColors = WindowButtonColors(
    iconNormal: Colors.grey,
    mouseOver: const Color(0xFFe0e0e0),
    mouseDown: Colors.grey.shade400,
    iconMouseOver: Colors.black,
    iconMouseDown: Colors.black,);
final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xffff0000),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: Colors.grey,
    iconMouseOver: Colors.white);
class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(
          colors: closeButtonColors,
          onPressed: () {
            showDialog<void>(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.white.withOpacity(0.85),
                  elevation: 36,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade400, width: 1.4),
                      borderRadius: BorderRadius.circular(8)),
                  titlePadding: EdgeInsets.zero,
                  contentPadding:  EdgeInsets.all(18),
                  title: Container(padding: EdgeInsets.all(18), child: Text('시스템 트레이 모드', style: StyleT.titleStyle(bold: true))),
                  content: Text('프로그램을 백그라운드로 전환합니다.', style: StyleT.titleStyle()),
                  actionsPadding: EdgeInsets.zero,
                  actions: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12),
                      child:
                      Row(
                        children: [
                          Container( height: 28,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  appWindow.close();
                                },
                                style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0,
                                    color: Colors.redAccent.withOpacity(0.5)),
                                child: Row( mainAxisSize: MainAxisSize.min,
                                  children: [
                                    WidgetT.iconStyleMini(icon: Icons.cancel),
                                    Text('강제 종료', style: StyleT.titleStyle(),),
                                    SizedBox(width: 12,),
                                  ],
                                )
                            ),
                          ),
                          Expanded(child:Container()),
                          Container( height: 28,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 0, color: StyleT.accentLowColor.withOpacity(0.5)),
                                child: Row( mainAxisSize: MainAxisSize.min,
                                  children: [
                                    WidgetT.iconStyleMini(icon: Icons.undo),
                                    Text('취소', style: StyleT.titleStyle(),),
                                    SizedBox(width: 12,),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(width:  8,),
                          Container( height: 28,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  appWindow.hide();
                                  SystemT.alert = true;
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
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}