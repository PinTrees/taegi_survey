import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

import 'helper/interfaceUI.dart';
import 'helper/style.dart';
import 'helper/systemControl.dart';

class WmInfoPage extends StatefulWidget {
  WorkManagement c;
  bool read;
  Function? close;

  WmInfoPage({ required this.c, this.read=false, this.close});
  @override
  State<WmInfoPage> createState() => _WmInfoPageState();
}
class _WmInfoPageState extends State<WmInfoPage> {
  TextEditingController addressInput = new TextEditingController();

  var confirmPaymentDetails = [];
  var desc = '';
  var inputCtr = new Map();
  var tcKeys = ['additionalWorkDesc', 'delayDesc', 'desc' ];
  //var editBool = new Map();
  //var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    read = widget.read;
    for (var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    inputCtr['additionalWorkDesc'].text = widget.c.supplementDesc;
    inputCtr['delayDesc'].text = widget.c.delayDesc;
    inputCtr['desc'].text = widget.c.desc;

    //for (var k in editKeys)
    //  editBool[k] = !read;
  }

  Widget editButton(String type) {
    return SizedBox();
  }

  Widget inputWidget(String type) {
    if(read) return SizedBox();
    if(type == 'address') {
      if(widget.c.addresses.length == 0)
        widget.c.addresses.add('');

      return Column(
        children: [
          for(int i = 0; i < widget.c.addresses.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.c.addresses[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::addresses', set: (i, data) {
                        widget.c.addresses[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '주소', val: widget.c.addresses[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.addresses.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    if(type == 'ats') {
      var width = 84.0;
      var padding = 4.0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4,),
          Row(
            children: [
              Expanded(
                  child: Text('업무배당일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('업무마감일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Row(
            children: [
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.taskAt}', () {}, true,
                    k: 'taskAt', set: (i, data) {
                      widget.c.taskAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.taskAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.taskOverAt}', () {}, true,
                    k: 'taskOverAt', set: (i, data) {
                      widget.c.taskOverAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.taskOverAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text(' ${0}일 남음', style: StyleT.titleStyle(bold: true, color: Colors.redAccent),)
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                  child: Text('측량', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('설계', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('문서', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Container(
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['survey']}', () {}, true,
                      k: 'workAts.survey', set: (i, data) {
                        widget.c.workAts['survey'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['survey']),
                ),
                WidgetHub.dividVerticalLow(height: 36),
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['design']}', () {}, true,
                      k: 'workAts.design', set: (i, data) {
                        widget.c.workAts['design'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['design']),
                ),
                WidgetHub.dividVerticalLow(height: 36),
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['doc']}', () {}, true,
                      k: 'workAts.doc', set: (i, data) {
                        widget.c.workAts['doc'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['doc']),
                ),
              ],
            ),
          )

        ],
      );
    }
    else if(type == 'client') {
      if(widget.c.clients.length <= 0)
        widget.c.clients.add({});

      return Column(
        children: [
          for(int i = 0; i < widget.c.clients.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetHub.buttonWrap('${widget.c.clients[i]['name']}', width: 100, () {
                    setState(() {});
                  }, true,
                      k: '$i::client.name', set: (i, data) {
                        widget.c.clients[i]['name'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '이름', val: widget.c.clients[i]['name']),
                  SizedBox(width: 4,),
                  Expanded(
                    child:  WidgetHub.buttonWrap('${widget.c.clients[i]['phoneNumber']}', () {
                      setState(() {});
                    }, true,
                        k: '$i::client.phoneNumber', set: (i, data) {
                          widget.c.clients[i]['phoneNumber'] =  data;
                        }, setFun: () { setState(() {}); }, hint: '번호', val: widget.c.clients[i]['phoneNumber']),
                  ),
                  SizedBox(
                      width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.clients.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    else if(type == 'use') {
      if(widget.c.useType.length == 0)
        widget.c.useType.add('');

      return Column(
        children: [
          for(int i = 0; i < widget.c.useType.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.c.useType[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::useType', set: (i, data) {
                        widget.c.useType[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '사업 목적',
                      val: widget.c.useType[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.useType.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    return SizedBox();
  }

  Widget main(WorkManagement c) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text('소재지', style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        for(var a in c.addresses)
          Row(children: [
            Expanded(child:   WidgetHub.buttonWrap('${a}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); }, hint: '주소',),),
          ],),

        WidgetHub.vertSizedPadding(),
        Row(
          children: [
            new Text("실무자", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                  Manager m = await WidgetHub.showBTManagerList(context);
                  if(m != null) {
                    widget.c.managerUid = m.id;
                    setState(() {});
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 28, width: 28,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        WidgetHub.buttonWrap('${SystemT.getManagerName(c.managerUid)}', width: 128, () { setState(() {});}, read),

        WidgetHub.vertSizedPadding(),
        Text("신청인", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        for(var a in c.clients)
          Row(children: [
            WidgetHub.buttonWrap('${a['name']}',() {
              setState(() {});
            }, true,
              width: 100, setFun: () { setState(() {}); }, ),
            Expanded(child:   WidgetHub.buttonWrap('${a['phoneNumber']}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
          ],),

        WidgetHub.vertSizedPadding(),
        Text("사업목적", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        for(var a in c.useType)
          Row(children: [
            Expanded(child:   WidgetHub.buttonWrap('${a}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
          ],),

        WidgetHub.vertSizedPadding(),
        Row(
          children: [
            Expanded(child:  Text("업무배당일", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child:  Text("업무마감일", style: StyleT.titleStyle(bold: true), ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          children: [
            Expanded(child:   WidgetHub.buttonWrap('${c.taskAt}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.taskOverAt}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
          ],
        ),

        WidgetHub.vertSizedPadding(),
        Row(
          children: [
            Expanded(child:  Text("측량", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child:  Text("설계", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child:  Text("문서", style: StyleT.titleStyle(bold: true), ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          children: [
            Expanded(child:   WidgetHub.buttonWrap('${c.workAts['survey']}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.workAts['design']}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.workAts['doc']}',() {
              setState(() {});
            }, true,
              setFun: () { setState(() {}); },),),
          ],
        ),

        SizedBox(height: 12,),
        Text("보완여부 및 내용", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(c.supplementDesc, style: StyleT.textStyleBig(),),
          ],
        ),

        SizedBox(height: 12,),
        Text("지연사항 및 내용", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(c.delayDesc, style: StyleT.textStyleBig(),),
          ],
        ),

        SizedBox(height: 12,),
        Text("비고", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(c.desc, style: StyleT.textStyleBig(),),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: new Color(0xCCe0e0e0),
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(true)
            TextButton(
                onPressed: () async {
                  if(widget.close != null)
                    await widget.close!();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.close, color: StyleT.titleColor, size: 20,),
                )
            ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                children: <Widget>[
                  SizedBox(height: 12,),
                  main(widget.c),
                  SizedBox(height: 18,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class WmCreatePage extends StatefulWidget {
  WorkManagement c;
  bool read;
  Function? close;

  WmCreatePage({ required this.c, this.read=false, this.close});
  @override
  State<WmCreatePage> createState() => _WmCreatePageState();
}
class _WmCreatePageState extends State<WmCreatePage> {
  TextEditingController addressInput = new TextEditingController();

  var confirmPaymentDetails = [];
  var desc = '';
  var inputCtr = new Map();
  var tcKeys = ['additionalWorkDesc', 'delayDesc', 'desc' ];
  //var editBool = new Map();
  //var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    read = widget.read;
    for (var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    inputCtr['additionalWorkDesc'].text = widget.c.supplementDesc;
    inputCtr['delayDesc'].text = widget.c.delayDesc;
    inputCtr['desc'].text = widget.c.desc;

    //for (var k in editKeys)
    //  editBool[k] = !read;
  }

  Widget editButton(String type) {
    return SizedBox();
  }

  Widget inputWidget(String type) {
    if(read) return SizedBox();
    if(type == 'address') {
      if(widget.c.addresses.length == 0)
        widget.c.addresses.add('');

      return Column(
        children: [
          for(int i = 0; i < widget.c.addresses.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.c.addresses[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::addresses', set: (i, data) {
                        widget.c.addresses[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '주소', val: widget.c.addresses[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.addresses.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    if(type == 'ats') {
      var width = 84.0;
      var padding = 4.0;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4,),
          Row(
            children: [
              Expanded(
                  child: Text('업무배당일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('업무마감일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Row(
            children: [
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.taskAt}', () {}, true,
                    k: 'taskAt', set: (i, data) {
                      widget.c.taskAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.taskAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.taskOverAt}', () {}, true,
                    k: 'taskOverAt', set: (i, data) {
                      widget.c.taskOverAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.taskOverAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text(' ${0}일 남음', style: StyleT.titleStyle(bold: true, color: Colors.redAccent),)
              ),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              Expanded(
                  child: Text('측량', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('설계', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('문서', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Container(
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['survey']}', () {}, true,
                      k: 'workAts.survey', set: (i, data) {
                        widget.c.workAts['survey'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['survey']),
                ),
                WidgetHub.dividVerticalLow(height: 36),
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['design']}', () {}, true,
                      k: 'workAts.design', set: (i, data) {
                        widget.c.workAts['design'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['design']),
                ),
                WidgetHub.dividVerticalLow(height: 36),
                Expanded(
                  child: WidgetHub.buttonWrap('${widget.c.workAts['doc']}', () {}, true,
                      k: 'workAts.doc', set: (i, data) {
                        widget.c.workAts['doc'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.workAts['doc']),
                ),
              ],
            ),
          )

        ],
      );
    }
    else if(type == 'client') {
      if(widget.c.clients.length <= 0)
        widget.c.clients.add({});

      return Column(
        children: [
          for(int i = 0; i < widget.c.clients.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetHub.buttonWrap('${widget.c.clients[i]['name']}', width: 100, () {
                    setState(() {});
                  }, true,
                      k: '$i::client.name', set: (i, data) {
                        widget.c.clients[i]['name'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '이름', val: widget.c.clients[i]['name']),
                  SizedBox(width: 4,),
                  Expanded(
                    child:  WidgetHub.buttonWrap('${widget.c.clients[i]['phoneNumber']}', () {
                      setState(() {});
                    }, true,
                        k: '$i::client.phoneNumber', set: (i, data) {
                          widget.c.clients[i]['phoneNumber'] =  data;
                        }, setFun: () { setState(() {}); }, hint: '번호', val: widget.c.clients[i]['phoneNumber']),
                  ),
                  SizedBox(
                      width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.clients.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    else if(type == 'use') {
      if(widget.c.useType.length == 0)
        widget.c.useType.add('');

      return Column(
        children: [
          for(int i = 0; i < widget.c.useType.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.c.useType[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::useType', set: (i, data) {
                        widget.c.useType[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '사업 목적',
                      val: widget.c.useType[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.useType.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
        ],
      );
    }
    return SizedBox();
  }

  Widget main(WorkManagement c) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Row(
          children: [
            Text('소재지', style: StyleT.titleStyle(bold: true), ),
            SizedBox(
                width: 24, height: 24,
                child: TextButton(
                  onPressed: () {
                    widget.c.addresses.add('');
                    inputWidget('address');
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.add),
                )
            ),
          ],
        ),
        inputWidget('address'),
        inputWidget('land'),

        SizedBox(height: 8,),
        Row(
          children: [
            new Text("실무자", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                  Manager m = await WidgetHub.showBTManagerList(context);
                  if(m != null) {
                    widget.c.managerUid = m.id;
                    setState(() {});
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 28, width: 28,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        WidgetHub.buttonWrap('${SystemT.getManagerName(c.managerUid)}', width: 128, () { setState(() {});}, read),

        SizedBox(height: 12,),
        Row(
          children: [
            Text("신청인", style: StyleT.titleStyle(bold: true), ),
            SizedBox(
                width: 24, height: 24,
                child: TextButton(
                  onPressed: () {
                    widget.c.clients.add({});
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.add),
                )
            ),
          ],
        ),
        inputWidget('client'),

        SizedBox(height: 8,),
        Row(
          children: [
            new Text("사업목적", style: StyleT.titleStyle(bold: true), ),
            SizedBox(
                width: 24, height: 24,
                child: TextButton(
                  onPressed: () {
                    widget.c.useType.add('');
                    inputWidget('use');
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.add),
                )
            ),
          ],
        ),
        inputWidget('use'),
        SizedBox(height: 12,),
        inputWidget('ats'),

        SizedBox(height: 12,),
        Row(
          children: [
            Text('보완 여부', style: StyleT.titleStyle(bold: true),),
            SizedBox(width: 4,),
            Container(
              width: 42, alignment: Alignment.center,
              child: Transform.scale(
                scale: 0.7,
                child: Switch(
                  value: widget.c.isSupplement,
                  onChanged: (value) {
                    widget.c.isSupplement = value;
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
        if(widget.c.isSupplement)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text('보완날짜', style: StyleT.titleStyle(bold: true),)
                  ),
                  SizedBox(width: 4,),
                  Expanded(
                      child: Text('보완마감날짜', style: StyleT.titleStyle(bold: true),)
                  ),
                ],
              ),
              SizedBox(height: 2,),
              Container(
                height: 36,
                child: Row(
                  children: [
                    Expanded(
                      child: WidgetHub.buttonWrap('${widget.c.supplementAt}', () {}, true,
                          k: 'workAts.supplementAt', set: (i, data) {
                            widget.c.supplementAt =  data;
                          }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.supplementAt),
                    ),
                    WidgetHub.dividVerticalLow(height: 36),
                    Expanded(
                      child: WidgetHub.buttonWrap('${widget.c.supplementOverAt}', () {}, true,
                          k: 'workAts.supplementOverAt', set: (i, data) {
                            widget.c.supplementOverAt =  data;
                          }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.supplementOverAt),
                    ),
                  ],
                ),
              )

            ],
          ),
        SizedBox(height: 12,),
        Text("보완여부 및 내용", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    print('input desc');
                    widget.c.supplementDesc = text;
                  },
                  style: StyleT.titleStyle(),
                  decoration:  WidgetHub.textInputDecoration( hintText: '비고', round: 4),
                  controller: inputCtr['additionalWorkDesc'],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12,),
        Text("지연사항 및 내용", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    print('input desc');
                    widget.c.delayDesc = text;
                  },
                  style: StyleT.titleStyle(),
                  decoration:  WidgetHub.textInputDecoration( hintText: '비고', round: 4),
                  controller: inputCtr['delayDesc'],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12,),
        Text("비고", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onChanged: (text) {
                    print('input desc');
                    widget.c.desc = text;
                  },
                  style: StyleT.titleStyle(),
                  decoration:  WidgetHub.textInputDecoration( hintText: '비고', round: 4),
                  controller: inputCtr['desc'],
                ),
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
      //backgroundColor: new Color(0xCCe0e0e0),
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(true)
            TextButton(
                onPressed: () async {
                  if(widget.close != null)
                    await widget.close!();
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.close, color: StyleT.titleColor, size: 20,),
                )
            ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                children: <Widget>[
                  SizedBox(height: 12,),
                  main(widget.c),
                  SizedBox(height: 18,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
