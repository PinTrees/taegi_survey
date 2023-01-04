import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

import 'helper/interfaceUI.dart';
import 'helper/style.dart';
import 'helper/systemControl.dart';

class PmEditePage extends StatefulWidget {
  PermitManagement p;
  bool read;
  Function? close;

  PmEditePage({ required this.p, this.read=false, this.close});
  @override
  State<PmEditePage> createState() => _PmEditePageState();
}
class _PmEditePageState extends State<PmEditePage> {
  TextEditingController addressInput = new TextEditingController();

  var inputCtr = new Map();
  var tcKeys = ['address', 'clientN', 'clientPN', 'use', 'areaT', 'areaM2', 'permitAtsT', 'permitAtsD', 'endAtsT', 'endAtsD', 'desc', 'arch', 'permit' ];
  var editBool = new Map();
  var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    print('sdcccccccddddddddddddddddddddddddddddddddddddddddddddd');

    read = widget.read;
    for (var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    for (var k in editKeys)
      editBool[k] = !read;
    inputCtr['permit'].text = '세움터';
    inputCtr['arch'].text = SystemControl.getArchitectureOfficeName(widget.p.architectureOffice).toString().replaceAll('\n', '');
  }
  void inputText(String type) {
    if(type == 'address') {
      widget.p.addresses.add(inputCtr['address'].text);
      inputCtr['address'].clear();
    }
    else if(type == 'client') {
      widget.p.clients.add({
        'name': inputCtr['clientN'].text,
        'phoneNumber':  inputCtr['clientPN'].text,
      });
      inputCtr['clientN'].clear(); inputCtr['clientPN'].clear();
    }
    else if(type == 'use') {
      widget.p.useType.add(inputCtr['use'].text);
      inputCtr['use'].clear();
    }
    else if(type == 'area') {
      widget.p.area.add({
        'type': inputCtr['areaT'].text,
        'area':  inputCtr['areaM2'].text,
      });
      inputCtr['areaT'].clear(); inputCtr['areaM2'].clear();
    }
    else if(type == 'permitAts') {
      widget.p.permitAts.add({
        'type': inputCtr['permitAtsT'].text,
        'date':  inputCtr['permitAtsD'].text,
      });
      inputCtr['permitAtsT'].clear(); inputCtr['permitAtsD'].clear();
    }
    else if(type == 'endAts') {
      widget.p.permitAts.add({
        'type': inputCtr['endAtsT'].text,
        'date':  inputCtr['endAtsD'].text,
      });
      inputCtr['endAtsT'].clear(); inputCtr['endAtsD'].clear();
    }
    setState(() {});
  }

  Widget editButton(String type) {
    return SizedBox();

    if(read) return SizedBox();
    if(editBool[type]) return SizedBox();
    return TextButton(
        onPressed: () async {
          editBool[type] = true;
          setState(() {});
        },
        style: TextButton.styleFrom(
          backgroundColor: StyleT.accentColor,
          minimumSize: Size.zero, padding: EdgeInsets.all(0),
        ),
        child: SizedBox(
          height: 36, width: 36,
          child: Icon(Icons.add,  color: StyleT.titleColor, size: 14,),
        )
    );
  }

  Widget inputWidget(String type) {
    if(read) return SizedBox();
    if(!editBool[type]) return SizedBox();

    if(type == 'address')
      return  Container(
        width: 300, height: 36,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.none,
          onEditingComplete: () {
            inputText('address');
          },
          decoration: WidgetHub.textInputDecoration( hintText: '소재지 입력', round: 4),
          controller: inputCtr['address'],
        ),
      );
    else if(type == 'client')
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('client');
              },
              decoration:  WidgetHub.textInputDecoration( hintText: '이름 입력', round: 4),
              controller: inputCtr['clientN'],
            ),
          ),
          SizedBox(width: 4,),
          Container(
            width: 200, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('client');
              },
              decoration:  WidgetHub.textInputDecoration( hintText: '번호 입력', round: 4),
              controller: inputCtr['clientPN'],
            ),
          ),
        ],
      );
    else if(type == 'use')
      return Container(
        width: 200, height: 36,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.none,
          onEditingComplete: () {
            inputText('use');
          },
          decoration: WidgetHub.textInputDecoration( hintText: '용도', round: 4),
          controller: inputCtr['use'],
        ),
      );
    else if(type == 'area')
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('area');
              },
              decoration: WidgetHub.textInputDecoration( hintText: '타입', round: 4),
              controller: inputCtr['areaT'],
            ),
          ),
          SizedBox(width: 4,),
          Container(
            width: 100, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('area');
              },
              decoration: WidgetHub.textInputDecoration( hintText: '면적', round: 4),
              controller: inputCtr['areaM2'],
            ),
          ),
        ],
      );
    else if(type == 'permitAts')
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('permitAts');
              },
              decoration: WidgetHub.textInputDecoration( hintText: '타입', round: 4),
              controller: inputCtr['permitAtsT'],
            ),
          ),
          SizedBox(width: 4,),
          Container(
            width: 100, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('permitAts');
              },
              decoration: WidgetHub.textInputDecoration( hintText: '날짜', round: 4),
              controller: inputCtr['permitAtsD'],
            ),
          ),
        ],
      );
    else if(type == 'endAts')
      return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100, height: 36,
          child: TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.none,
            onEditingComplete: () {
              inputText('endAts');
            },
            decoration:  WidgetHub.textInputDecoration( hintText: '타입', round: 4),
            controller: inputCtr['endAtsT'],
          ),
        ),
        SizedBox(width: 4,),
        Container(
          width: 100, height: 36,
          child: TextFormField(
            maxLines: 1,
            textInputAction: TextInputAction.search,
            keyboardType: TextInputType.none,
            onEditingComplete: () {
              inputText('endAts');
            },
            decoration:  WidgetHub.textInputDecoration( hintText: '날짜', round: 4),
            controller: inputCtr['endAtsD'],
          ),
        ),
      ],
    );
    return SizedBox();
  }

  Widget main(PermitManagement p) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text("소재지", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            for(var s in p.addresses)
              WidgetHub.buttonWrap(s, () {
                p.addresses.remove(s);
                setState(() {});}, read),
            editButton('address'),
            inputWidget('address'),
          ],
        ),

        SizedBox(height: 12,),
        Text("실무자", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        WidgetHub.buttonWrap("${SystemControl.getManagerName(p.managerUid)}", () {}, true),

        WidgetHub.vertSizedPadding(),
        Text("신청인", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            for(var s in p.clients)
              WidgetHub.buttonWrap('${s['name']}  ${s['phoneNumber']}', () {
                p.clients.remove(s);
                setState(() {});}, read),
            editButton('client'),
            inputWidget('client'),
          ],
        ),

        WidgetHub.vertSizedPadding(),
        Text("용도", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            for(var s in p.useType)
              WidgetHub.buttonWrap(s, () {
                p.useType.remove(s);
                setState(() {});}, read),
            editButton('use'),
            inputWidget('use'),
          ],
        ),

        WidgetHub.vertSizedPadding(),
        Text("허가 면적", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            for(var s in p.area)
              Row(
                children: [
                  WidgetHub.buttonWrap('${s['type']}', width: 100, () {
                    p.area.remove(s);
                    setState(() {});}, read),
                  SizedBox(width: 4,),
                  WidgetHub.buttonWrap('${s['area']} ㎡', width: 200, () {
                    p.area.remove(s);
                    setState(() {});}, read),
                ],
              ),
          ],
        ),

        WidgetHub.vertSizedPadding(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("허가일", style: StyleT.titleStyle(bold: true), ),
                  SizedBox(height: 2,),
                  Wrap(
                    runSpacing: 4,
                    spacing: 4,
                    children: [
                      for(var s in p.permitAts)
                        WidgetHub.buttonWrap('${s['type']}  ${s['date']}'.replaceAll('.', '. '), () {
                          p.permitAts.remove(s);
                          setState(() {});}, read),
                      editButton('permitAts'),
                      inputWidget('permitAts'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 4,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("종료일", style: StyleT.titleStyle(bold: true), ),
                  SizedBox(height: 2,),
                  Wrap(
                    runSpacing: 4,
                    spacing: 4,
                    children: [
                      for(var s in p.endAts)
                        WidgetHub.buttonWrap('${s['type']}  ${s['date']}'.replaceAll('.', '. '), () {
                          p.endAts.remove(s);
                          setState(() {});}, read),
                      editButton('endAts'),
                      inputWidget('endAts'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),


        WidgetHub.vertSizedPadding(),
        Text("허가유형", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        WidgetHub.buttonWrap(p.permitType, () {}, true),

        WidgetHub.vertSizedPadding(),
        Text("건축사", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        WidgetHub.buttonWrap(SystemControl.getArchitectureOfficeName(p.architectureOffice)
            .toString().replaceAll('\n', ' '), () {}, true),

        WidgetHub.vertSizedPadding(),
        Row(
          children: [
            new Text("비고", style: StyleT.titleStyle(bold: true), ),
          ],
        ),
        SizedBox(height: 2,),
        Text(p.desc, style: StyleT.textStyleBig(), ),
        SizedBox(height: 128,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: new Color(0xCCe0e0e0),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          if(true)
            Container(
            height: 36,
            child: Row(
              children: [
                SizedBox(width: 4,),
                Expanded(child: Text('', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),)),
                SizedBox(width: 16,),
                if(false)
                  TextButton(
                    onPressed: () async {
                      read = !read;
                      for(var k in editKeys)
                        editBool[k] = !read;

                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.all(0),
                    ),
                    child: SizedBox(
                      height: 36, width: 36,
                      child: Icon(Icons.create, color: StyleT.titleColor, size: 20,),
                    )
                ),
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
              ],
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                children: <Widget>[
                  SizedBox(height: 12,),
                  main(widget.p),
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


class PmCreatePage extends StatefulWidget {
  PermitManagement p;
  bool read;
  Function? close;

  PmCreatePage({ required this.p, this.read=false, this.close});
  @override
  State<PmCreatePage> createState() => _PmCreatePageState();
}
class _PmCreatePageState extends State<PmCreatePage> {
  TextEditingController addressInput = new TextEditingController();

  var inputCtr = new Map();
  var tcKeys = ['address', 'clientN', 'clientPN', 'use', 'areaT', 'areaM2', 'permitAtsT', 'permitAtsD', 'endAtsT', 'endAtsD', 'desc', 'arch', 'permit' ];
  var editBool = new Map();
  var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    print('sdcccccccddddddddddddddddddddddddddddddddddddddddddddd');

    read = widget.read;
    for(var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    for(var k in editKeys)
      editBool[k] = !read;
    inputCtr['permit'].text = '세움터';
  }
  void inputText(String type) {
    if(type == 'use') {
      widget.p.useType.add(inputCtr['use'].text);
      inputCtr['use'].clear();
    }




    else if(type == 'area') {
      widget.p.area.add({
        'type': inputCtr['areaT'].text,
        'area':  inputCtr['areaM2'].text,
      });
      inputCtr['areaT'].clear(); inputCtr['areaM2'].clear();
    }
    else if(type == 'permitAts') {
      widget.p.permitAts.add({
        'type': inputCtr['permitAtsT'].text,
        'date':  inputCtr['permitAtsD'].text,
      });
      inputCtr['permitAtsT'].clear(); inputCtr['permitAtsD'].clear();
    }
    else if(type == 'endAts') {
      widget.p.endAts.add({
        'type': inputCtr['endAtsT'].text,
        'date':  inputCtr['endAtsD'].text,
      });
      inputCtr['endAtsT'].clear(); inputCtr['endAtsD'].clear();
    }
    setState(() {});
  }
  Widget inputWidget(String type) {
    if(read) return SizedBox();
    if(!editBool[type]) return SizedBox();

    if(type == 'address') {
      if(widget.p.addresses.length <= 0)
        widget.p.addresses.add('');

      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(int i = 0; i <  widget.p.addresses.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.p.addresses[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::addresses', set: (i, data) {
                        widget.p.addresses[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '주소', val: widget.p.addresses[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.addresses.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
          WidgetHub.buttonAdd(fun: () {
            widget.p.addresses.add('');
            inputWidget('address');
            setState(() {});
          }),
        ],
      );
    }
    else if(type == 'client') {
      if(widget.p.clients.length <= 0)
        widget.p.clients.add({});

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(int i = 0; i <  widget.p.clients.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  WidgetHub.buttonWrap('${widget.p.clients[i]['name']}', width: 100, () {
                    setState(() {});
                  }, true, k: '$i::clients.name', set: (i, data) {
                    widget.p.clients[i]['name'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '이름', val: widget.p.clients[i]['name']),
                  SizedBox(width: 4,),
                  Expanded(child:   WidgetHub.buttonWrap('${widget.p.clients[i]['phoneNumber']}',() {
                    setState(() {});
                  }, true,
                      k: '$i::clients.phoneNumber', set: (i, data) {
                        widget.p.clients[i]['phoneNumber'] =  data;
                      }, setFun: () { setState(() {}); }, hint: '연락처', val: widget.p.clients[i]['phoneNumber']),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.clients.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            ),
          WidgetHub.buttonAdd(fun: () {
            widget.p.clients.add({});
            inputWidget('client');
            setState(() {});
          }),
        ],
      );
    }
    else if(type == 'use') {
      return Column(
        children: [
          Container( height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                inputText('use');
              },
              decoration: WidgetHub.textInputDecoration( hintText: '용도', round: 4),
              controller: inputCtr['use'],
            ),
          ),
          for(int i = 0; i < widget.p.useType.length; i++)
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.useType[i]}', () {
                    setState(() {});
                  }, true, k: '$i::useType', set: (i, data) {
                    widget.p.useType[i] =  data;
                  }, setFun: () { setState(() {}); }, hint: '용도', val: widget.p.useType[i]),),
                  SizedBox(
                      height: 26, width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.useType.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            )
        ],
      );
    }
    else if(type == 'area') {
      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                 height: 36,
                  child: TextFormField(
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.none,
                    onEditingComplete: () {
                      inputText('area');
                    },
                    decoration: WidgetHub.textInputDecoration( hintText: '타입', round: 4),
                    controller: inputCtr['areaT'],
                  ),
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Container( height: 36,
                  child: TextFormField(
                    maxLines: 1,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.none,
                    onEditingComplete: () {
                      inputText('area');
                    },
                    decoration: WidgetHub.textInputDecoration( hintText: '면적', round: 4),
                    controller: inputCtr['areaM2'],
                  ),
                ),
              ),
              SizedBox(
                  height: 26, width: 26,
                  child: TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: WidgetHub.iconStyleMini(icon: Icons.clear),
                  )
              ),
            ],
          ),
          for(int i = 0; i < widget.p.area.length; i++)
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.area[i]['type']}', () {
                    setState(() {});
                  }, true, k: '$i::area.type', set: (i, data) {
                    widget.p.area[i]['type'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '타입', val: widget.p.area[i]['type']),),
                  SizedBox(width: 4,),
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.area[i]['area']} ㎡', () {
                    setState(() {});
                  }, true, k: '$i::area.area', set: (i, data) {
                    widget.p.area[i]['area'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '면적 M2', val: widget.p.area[i]['area']),),
                  SizedBox(
                      height: 26, width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.area.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            )
        ],
      );
    }
    else if(type == 'permitAts') {
      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Container( height: 36,
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.none,
                  onEditingComplete: () {
                    inputText('permitAts');
                  },
                  decoration: WidgetHub.textInputDecoration( hintText: '타입', round: 4),
                  controller: inputCtr['permitAtsT'],
                ),
              ),),
              SizedBox(width: 4,),
              Expanded(child: Container( height: 36,
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.none,
                  onEditingComplete: () {
                    inputText('permitAts');
                  },
                  decoration: WidgetHub.textInputDecoration( hintText: '날짜', round: 4),
                  controller: inputCtr['permitAtsD'],
                ),
              ),),
              SizedBox(
                  height: 26, width: 26,
                  child: TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: WidgetHub.iconStyleMini(icon: Icons.clear),
                  )
              ),
            ],
          ),
          for(int i = 0; i < widget.p.permitAts.length; i++)
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.permitAts[i]['type']}', () {
                    setState(() {});
                  }, true, k: '$i::permitAts.type', set: (i, data) {
                    widget.p.permitAts[i]['type'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '타입', val: widget.p.permitAts[i]['type']),),
                  SizedBox(width: 4,),
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.permitAts[i]['date']}', () {
                    setState(() {});
                  }, true, k: '$i::permitAts.date', set: (i, data) {
                    widget.p.permitAts[i]['date'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.p.permitAts[i]['date']),),
                  SizedBox(
                      height: 26, width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.permitAts.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            )
        ],
      );
    }
    else if(type == 'endAts') {
      return Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Container( height: 36,
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.none,
                  onEditingComplete: () {
                    inputText('endAts');
                  },
                  decoration: WidgetHub.textInputDecoration( hintText: '타입', round: 4),
                  controller: inputCtr['endAtsT'],
                ),
              ),),
              SizedBox(width: 4,),
              Expanded(child: Container( height: 36,
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.none,
                  onEditingComplete: () {
                    inputText('endAts');
                  },
                  decoration: WidgetHub.textInputDecoration( hintText: '날짜', round: 4),
                  controller: inputCtr['endAtsD'],
                ),
              ),),
              SizedBox(
                  height: 26, width: 26,
                  child: TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: WidgetHub.iconStyleMini(icon: Icons.clear),
                  )
              ),
            ],
          ),
          for(int i = 0; i < widget.p.endAts.length; i++)
            Container(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.endAts[i]['type']}', () {
                    setState(() {});
                  }, true, k: '$i::endAts.type', set: (i, data) {
                    widget.p.endAts[i]['type'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '타입', val: widget.p.endAts[i]['type']),),
                  SizedBox(width: 4,),
                  Expanded(child:    WidgetHub.buttonWrap('${widget.p.endAts[i]['date']}', () {
                    setState(() {});
                  }, true, k: '$i::endAts.date', set: (i, data) {
                    widget.p.endAts[i]['date'] =  data;
                  }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.p.endAts[i]['date']),),
                  SizedBox(
                      height: 26, width: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.p.endAts.removeAt(i);
                          setState(() {});
                        },
                        style: StyleT.buttonStyleNone(padding: 0),
                        child: WidgetHub.iconStyleMini(icon: Icons.delete),
                      )
                  ),
                ],
              ),
            )
        ],
      );
    }
    return SizedBox();
  }

  Widget main(PermitManagement p) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Text(" 소재지", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('address'),

        SizedBox(height: 12,),
        Row(
          children: [
            new Text("실무자", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                  Manager m = await WidgetHub.showBTManagerList(context);
                  if(m != null) {
                    widget.p.managerUid = m.id;
                    setState(() {});
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        WidgetHub.buttonWrap('${SystemControl.getManagerName(p.managerUid)}', width: 128,  () {}, true),

        WidgetHub.vertSizedPadding(),
        Text("신청인", style: StyleT.titleBigStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('client'),

        WidgetHub.vertSizedPadding(),
        Text("용도", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('use'),

        WidgetHub.vertSizedPadding(),
        Text("허가 면적", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('area'),

        WidgetHub.vertSizedPadding(),
        Text("허가일", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('permitAts'),

        WidgetHub.vertSizedPadding(),
        Text("종료일", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        inputWidget('endAts'),

        SizedBox(height: 12,),
        Row(
          children: [
            new Text("허가유형", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            Container(
              width: 200, height: 36,
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.none,
                onEditingComplete: () {
                  inputText('permit');
                },
                decoration: WidgetHub.textInputDecoration( hintText: '허가유형', round: 4),
                controller: inputCtr['permit'],
              ),
            ),
          ],
        ),
        //new Text("${p.permitType}", style: SystemStyle.titleStyle(), ),

        SizedBox(height: 12,),
        Row(
          children: [
            new Text("건축사", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                  ArchitectureOffice a = await WidgetHub.showBTArchList(context);
                  if(a != null) {
                    widget.p.architectureOffice = a.id;
                    inputCtr['arch'].text = a.name;
                    setState(() {});
                  }
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            Container(
              width: 200, height: 36,
              child: TextFormField(
                maxLines: 1,
                textInputAction: TextInputAction.search,
                keyboardType: TextInputType.none,
                onEditingComplete: () {
                  inputText('arch');
                },
                decoration: WidgetHub.textInputDecoration( hintText: '건축사', round: 4),
                controller: inputCtr['arch'],
              ),
            ),
          ],
        ),

        SizedBox(height: 12,),
        Row(
          children: [
            new Text("비고", style: StyleT.titleStyle(bold: true), ),
            TextButton(
                onPressed: () async {
                },
                style: TextButton.styleFrom(
                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                ),
                child: SizedBox(
                  height: 36, width: 36,
                  child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 14,),
                )
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  maxLines: 7,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  onEditingComplete: () {
                    inputText('desc');
                  },
                  style: StyleT.titleStyle(),
                  decoration:  WidgetHub.textInputDecoration( hintText: '비고', round: 4),
                  controller: inputCtr['desc'],
                ),
              ),
            ),
          ],
        )
        //new Text("${p.desc}", style: SystemStyle.titleStyle(), ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: new Color(0xCCe0e0e0),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          if(true)
            Container(
              height: 36,
              child: Row(
                children: [
                  SizedBox(width: 4,),
                  Expanded(child: Text('자세한 정보', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),)),
                  SizedBox(width: 16,),
                  /*
                  TextButton(
                      onPressed: () async {
                        read = !read;
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.all(0),
                      ),
                      child: SizedBox(
                        height: 36, width: 36,
                        child: Icon(Icons.create, color: SystemStyle.titleColor, size: 20,),
                      )
                  ),
                  TextButton(
                      onPressed: () async {
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.all(0),
                      ),
                      child: SizedBox(
                        height: 36, width: 36,
                        child: Icon(Icons.save, color: SystemStyle.titleColor, size: 20,),
                      )
                  ),
                   */
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
                ],
              ),
            ),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                children: <Widget>[
                  SizedBox(height: 12,),
                  main(widget.p),
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


class PmCreatePageDialog extends StatefulWidget {
  PmCreatePageDialog() : super();
  @override
  _PmCreatePageDialogState createState() => _PmCreatePageDialogState();
}
class _PmCreatePageDialogState extends State<PmCreatePageDialog> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog();
  }
}