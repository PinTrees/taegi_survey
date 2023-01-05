import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

import 'helper/firebaseCore.dart';
import 'helper/interfaceUI.dart';
import 'helper/style.dart';
import 'helper/systemControl.dart';

class EditeTemplatePage extends StatefulWidget {
  EditeTemplatePage();
  @override
  State<EditeTemplatePage> createState() => _EditeTemplatePageState();
}

class _EditeTemplatePageState extends State<EditeTemplatePage> {
  TextEditingController mngNameInput = new TextEditingController();
  TextEditingController mngTypeInput = new TextEditingController();
  TextEditingController mngPhoneNumberInput = new TextEditingController();

  TextEditingController nameInput = new TextEditingController();
  TextEditingController phoneNumberInput = new TextEditingController();
  TextEditingController descInput = new TextEditingController();

  var inputCtr = new Map();
  var tcKeys = ['address', 'clientN',];
  
  var selectMenu;
  var menus = [ '실무자', '건축회사' ];

  var edits = new Map();
  @override
  void initState() {
    super.initState();

    selectMenu = menus.first;

    for(var k in tcKeys)
      inputCtr[k] = new TextEditingController();

    for(var k in menus)
      edits[k] = false;

    setState(() {});
  }

  void inputText(String type) {
    setState(() {});
  }
  Widget main() {
    if(selectMenu == '실무자') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(edits[menus.first])
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetHub.textInputField(mngNameInput, height: 36, hintText: '담당자 이름 입력'),
                      WidgetHub.textInputField(mngTypeInput, height: 36, hintText: '담당자 직책 입력'),
                      WidgetHub.textInputField(mngPhoneNumberInput, height: 36, hintText: '담당자 연락처 입력'),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        var check = false;
                        if(mngNameInput.text == '') check = true;
                        if(mngTypeInput.text == '') check = true;
                        if(mngPhoneNumberInput.text == '') check = true;

                        if(check) {
                          return;
                        }

                        FirebaseT.pushManager(Manager.fromDatabase({
                          'name': mngNameInput.text, 'type': mngTypeInput.text, 'phoneNumber': mngPhoneNumberInput.text,
                        }));
                        mngNameInput.clear();
                        mngTypeInput.clear();
                        mngPhoneNumberInput.clear();

                        edits[menus.first] = false;
                        setState(() {});
                      },
                      style: StyleT.buttonStyleNone( elevation: 8, color: StyleT.backgroundColor),
                      child: SizedBox( height: 55,
                          child: Icon(Icons.group_add, size: 20, color: StyleT.accentColor,)),
                    ),
                    SizedBox(height: 4,),
                    TextButton(
                      onPressed: () {
                        edits[menus.first] = false;
                        setState(() {});
                      },
                      style: StyleT.buttonStyleNone( elevation: 8, color: StyleT.backgroundColor),
                      child: SizedBox( height: 26,
                          child: Icon(Icons.close, size: 20, color: Colors.redAccent,)),
                    ),
                  ],
                ),
              ],
            ),
          for(var m in SystemT.managers)
            TextButton(
              onPressed: () {
              },
              style: StyleT.buttonStyleNone(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${m.name}', style: StyleT.titleBigStyle(),),
                        Text('${m.type}', style: StyleT.textStyle(),),
                        SizedBox(height: 4,),
                        Text('${m.phoneNumber}', style: StyleT.titleBigStyle(),),
                      ],
                    ),
                  ),
                  Icon(Icons.more_vert, color: StyleT.textColor, size: 18,),
                ],
              ),
            ),
        ],
      );
    }
    else if(selectMenu == '건축회사') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(edits[menus.last])
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WidgetHub.textInputField(nameInput, height: 36,  hintText: '건설회사 입력'),
                      WidgetHub.textInputField(phoneNumberInput,  height: 36, hintText: '연락처 입력'),
                      WidgetHub.textInputField(descInput,  height: 36, hintText: '자세한 정보'),
                    ],
                  ),
                ),
                SizedBox(width: 8,),
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        var check = false;
                        if(nameInput.text == '') check = true;
                        if(phoneNumberInput.text == '') check = true;
                        if(descInput.text == '') check = true;
                        if(check) {
                          return;
                        }

                        FirebaseT.pushArchitectureOffice(ArchitectureOffice.fromDatabase({
                          'phoneNumber': phoneNumberInput.text,
                          'name': nameInput.text,
                          'desc': descInput.text,
                        }));
                        phoneNumberInput.clear();
                        nameInput.clear();
                        descInput.clear();

                        edits[menus.last] = false;
                        setState(() {});
                      },
                      style: StyleT.buttonStyleNone( elevation: 8, color: StyleT.backgroundColor),
                      child: SizedBox( height: 55,
                          child: Icon(Icons.add_home_work, size: 20, color: StyleT.accentColor,)),
                    ),
                    SizedBox(height: 4,),
                    TextButton(
                      onPressed: () {
                        edits[menus.last] = false;
                        setState(() {});
                      },
                      style: StyleT.buttonStyleNone( elevation: 8, color: StyleT.backgroundColor),
                      child: SizedBox( height: 26,
                          child: Icon(Icons.close, size: 20, color: Colors.redAccent,)),
                    ),
                  ],
                ),
              ],
            ),
          for(var m in SystemT.architectureOffices)
            TextButton(
              onPressed: () {
              },
              style: StyleT.buttonStyleNone(),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${m.name}', style: StyleT.titleBigStyle(),),
                        Text('${m.desc ?? 'desc'}', style: StyleT.textStyle(),),
                        SizedBox(height: 4,),
                        Text('${m.phoneNumber}', style: StyleT.titleBigStyle(),),
                      ],
                    ),
                  ),
                  Icon(Icons.more_vert, color: StyleT.textColor, size: 18,),
                ],
              ),
            ),
        ],
      );
    }
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            TextButton(
              onPressed: () {

              },
              child: Text(
                '건설 회사 추가',
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
      body: Column(
        children: [
          Container(
            color: StyleT.backgroundHighColor,
            height: 36,
            child: Row(
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.all(0),
                    ),
                    child: SizedBox(
                      height: 36, width: 36,
                      child: Icon(Icons.arrow_back,  color: StyleT.titleColor,  size: 20,),
                    )
                ),
                Expanded(child: Text('기초 정보 입력', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),)),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
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
          Container(
            color: StyleT.backgroundHighColor,
            height: 64,
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                TextButton(
                    onPressed: () async {
                      selectMenu = menus.first;
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(),
                    child: Row(
                      children: [
                        Icon(Icons.manage_accounts,  color: selectMenu == menus.first ?
                        StyleT.titleColor : StyleT.textColor,  size: 20,),
                        SizedBox(width: 8,),
                        Text('담당자', style: StyleT.titleStyle(color: selectMenu == menus.first ?
                        StyleT.titleColor : StyleT.textColor, bold: selectMenu == menus.first ),)
                      ],
                    )
                ),
                SizedBox(width: 8,),
                TextButton(
                    onPressed: () async {
                      selectMenu = menus.last;
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(),
                    child: Row(
                      children: [
                        Icon(Icons.room_preferences, color: selectMenu == menus.last ?
                        StyleT.titleColor : StyleT.textColor,  size: 20,),
                        SizedBox(width: 8,),
                        Text('건설 회사', style: StyleT.titleStyle(color: selectMenu == menus.last ?
                        StyleT.titleColor : StyleT.textColor, bold: selectMenu == menus.last ),)
                      ],
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
                  main(),
                  SizedBox(height: 18,),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(!edits[menus.first] && selectMenu == menus.first)
            SizedBox(
              width: 48, height: 48,
              child: FloatingActionButton(
                heroTag: 'uniqueTag',
                onPressed: () {
                  edits[menus.first] = true;
                  setState(() {});
                },
                child: Icon(Icons.group_add, size: 20,),
              ),
            ),
          if(!edits[menus.last] && selectMenu == menus.last)
            SizedBox(
              width: 48, height: 48,
              child: FloatingActionButton(
                heroTag: 'uniqueTag1',
                onPressed: () {
                  edits[menus.last] = true;
                  setState(() {});
                },
                child: Icon(Icons.add_home_work, size: 20,),
              ),
            ),
        ],
      ),
    );
  }
}