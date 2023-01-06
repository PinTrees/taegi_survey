import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart' as en;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';

import '../helper/style.dart';

class PermitManagementPage extends StatefulWidget {
  const PermitManagementPage();
  @override
  State<PermitManagementPage> createState() => _PermitManagementPageState();
}

class _PermitManagementPageState extends State<PermitManagementPage> {
  TextEditingController managerInput = new TextEditingController();

  TextEditingController clientInput = new TextEditingController();
  TextEditingController clientPNInput = new TextEditingController();
  TextEditingController clientDesc = new TextEditingController();

  TextEditingController addressInput = new TextEditingController();
  TextEditingController useTypeInput = new TextEditingController();
  TextEditingController areaInput = new TextEditingController();

  TextEditingController aoInput = new TextEditingController();
  TextEditingController aoTypeInput = new TextEditingController();

  TextEditingController memoInput = new TextEditingController();
  TextEditingController typeInput = new TextEditingController();

  TextEditingController permitStartAtInput = new TextEditingController();

  TextEditingController permitAtInput = new TextEditingController();
  TextEditingController endAtInput = new TextEditingController();
  TextEditingController permitAtTypeInput = new TextEditingController();
  TextEditingController endAtTypeInput = new TextEditingController();

  late PermitManagement currentData;

  var currentClient = {};
  var clients = [];
  var addresses = [];
  var currentPermitAt = {};
  var permitAtList = [];

  var currentEndAt = {};
  var endAtList = [];

  var selectUse = [];
  var selectArea = [];
  var currentInputArea = {};

  var selectStartPermait = 0;
  String selectArchitectureOfficeId = '';
  String selectManagerId = '';
  String selectPermitUse = '';
  var permitUse = [
    '개발',
    '초지'
    '복구',
    '개간',
    '산지',
    '국유재산',
    '공유수면',
    '농지',
    '도로점용',
    '하천점용',
    '농업생산',
    '기타',
  ];
  var permitUseAtCount = 1;

  @override
  void initState() {
    super.initState();
    currentData = PermitManagement.fromDatabase({});
    typeInput.text = '세움터';
  }
  
  void sendDataWithJson({ String? path, String? jsonString }) {
    http.patch(
        Uri.parse(
            "https://taegi-survey-default-rtdb.firebaseio.com/$path.json"), body: jsonString);
  }
  dynamic getDataWithPath({ String? path }) async {
    http.Response a = await http.get(Uri.parse("https://taegi-survey-default-rtdb.firebaseio.com/$path.json"),);
    print(a.body);
  }

  void textControllerClear() {
    clientInput.clear();
    addressInput.clear();
    useTypeInput.clear();
    areaInput.clear();
    clientPNInput.clear();
    aoInput.clear();
    memoInput.clear();
  }

  managerSelectUI(BuildContext context,) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return   Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in SystemT.managers)
                TextButton(
                onPressed: () {
                  selectManagerId = m.id;
                  setState(() {});
                  Navigator.pop(context);
                },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m.name
                        ),
                        SizedBox(width: 24,),
                        Text(
                            m.type
                        ),
                      ],
                    ))
            ],
          ),
        );
      });
    }
    );
  }
  dynamic permitAtUseSelectUI(BuildContext context,) async {
    var aa = await showModalBottomSheet(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in permitUse)
                TextButton(
                    onPressed: () {
                      Navigator.pop(context, m);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            m
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
  areaTypeSelectUI(BuildContext context,) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in permitUse)
                TextButton(
                    onPressed: () {
                      currentInputArea['type'] = m;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            m
                        ),
                      ],
                    ))
            ],
          ),
        );
      });
    });
  }
  architectureOfficeSelectUI(BuildContext context,) {
    showModalBottomSheet<void>(context: context, builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context, StateSetter setStateManager) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for(var m in SystemT.architectureOffices)
                TextButton(
                    onPressed: () {
                      selectArchitectureOfficeId = m.id;
                      aoInput.text = m.name;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            m.name
                        ),
                        SizedBox(width: 24,),
                        Text(
                            m.phoneNumber
                        ),
                      ],
                    ))
            ],
          ),
        );
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> permitUseAtInput = [];
    for(int i = 0; i < permitAtList.length; i++) {
      var p = permitAtList[i];
      var tmp = Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: TextButton(
                onPressed: () async {
                },
                style: StyleT.buttonStyleOutline(padding: 8, elevation: 0),
                child: Row(
                  children: [
                    Text('${p['type']}', style: StyleT.textStyle(),),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8,),
            Text('${p['date']}', style: StyleT.textStyle(),),
            SizedBox(width: 8,),
            SizedBox(
              height: 28,
              child: TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                },
                style: StyleT.buttonStyleOutline(padding: 8, elevation: 0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 18, color: StyleT.textColor,),
                    SizedBox(width: 12,),
                    Text('날짜 변경', style: StyleT.textStyle(),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 28, width: 28,
              child: TextButton(
                onPressed: () async {
                  permitAtList.remove(p);
                  setState(() {});
                },
                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                child: Icon(Icons.close, size: 12, color: Colors.redAccent,),
              ),
            ),
          ],
        ),
      );
      permitUseAtInput.add(tmp);
    }

    List<Widget> endAtListW = [];
    for(int i = 0; i < endAtList.length; i++) {
      var p = endAtList[i];
      var tmp = Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: TextButton(
                onPressed: () async {
                },
                style: StyleT.buttonStyleOutline(padding: 8, elevation: 0),
                child: Row(
                  children: [
                    Text('${p['type']}', style: StyleT.textStyle(),),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8,),
            Text('${p['date']}', style: StyleT.textStyle(),),
            SizedBox(width: 8,),
            SizedBox(
              height: 28,
              child: TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(), //get today's date
                      firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101)
                  );
                },
                style: StyleT.buttonStyleOutline(padding: 8, elevation: 0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_month, size: 18, color: StyleT.textColor,),
                    SizedBox(width: 12,),
                    Text('날짜 변경', style: StyleT.textStyle(),),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 28, width: 28,
              child: TextButton(
                onPressed: () async {
                  endAtList.remove(p);
                  setState(() {});
                },
                style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                child: Icon(Icons.close, size: 12, color: Colors.redAccent,),
              ),
            ),
          ],
        ),
      );
      endAtListW.add(tmp);
    }
     return Scaffold(
       body: Column(
         children: [
           AppTitleBar(title: '태기측량 허가 관리 목록 추가 시스템', back: true,),
           Expanded(
             child: Stack(
               children: [
                 Positioned(
                   left: 0, right: 0, top: 0, bottom: 0,
                   child: ListView(
                     padding: EdgeInsets.all(18),
                     children: <Widget>[

                       SizedBox(height: 8,),
                       Text('허가 완료일', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Container(
                             height: 32, width: 200,
                             margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                             child: TextFormField(
                               maxLines: 1,
                               textInputAction: TextInputAction.search,
                               keyboardType: TextInputType.none,
                               onEditingComplete: () {
                                 var dateString = permitStartAtInput.text.replaceAll('.', '-');
                                 var date = DateTime.tryParse(dateString);
                                 if(date == null) return;
                                 selectStartPermait = date.microsecondsSinceEpoch;
                                 setState(() {});
                               },
                               decoration: InputDecoration(
                                 enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                 focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                 filled: true,
                                 fillColor: Colors.grey.shade100,
                                 hintText: '허가 날짜 입력',
                                 hintStyle: TextStyle(fontSize: 12),
                               ),
                               controller: permitStartAtInput,
                             ),
                           ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('기본 정보', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Container(
                             width: 288,
                             child: Container(
                               height: 32,
                               margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                               child: TextFormField(
                                 maxLines: 1,
                                 textInputAction: TextInputAction.search,
                                 keyboardType: TextInputType.none,
                                 onEditingComplete: () {
                                   addresses.add(addressInput.text);
                                   setState(() {});
                                   addressInput.clear();
                                 },
                                 decoration: InputDecoration(
                                   enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                   focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                   filled: true,
                                   fillColor: Colors.grey.shade100,
                                   hintText: '소재지 입력',
                                   hintStyle: TextStyle(fontSize: 12),
                                 ),
                                 controller: addressInput,
                               ),
                             ),
                           ),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32, width: 32,
                             child: TextButton(
                                 onPressed: () async {
                                   //permitAtUseSelectUI(context);
                                 },
                                 style: StyleT.buttonStyleOutline(padding: 0),
                                 child: Icon(Icons.add, color: StyleT.titleColor, size: 18,)
                             ),
                           ),
                         ],
                       ),
                       Wrap(
                         runSpacing: 4,
                         spacing: 4,
                         children: [
                           for(var s in addresses)
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 SizedBox(
                                   height: 28,
                                   child: TextButton(
                                       onPressed: () async {
                                       },
                                       style: StyleT.buttonStyleOutline(padding: 4, elevation: 0),
                                       child: Row(
                                         children: [
                                           SizedBox(width: 4,),
                                           Text( '$s', style: StyleT.textStyle(),),
                                           SizedBox(width: 8,),
                                           SizedBox(
                                             height: 18, width: 18,
                                             child: TextButton(
                                               onPressed: () async {
                                                 addresses.remove(s);
                                                 setState(() {});
                                               },
                                               style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                                               child: Icon(Icons.close, color: Colors.redAccent, size: 12,),
                                             ),
                                           ),
                                         ],
                                       )
                                   ),
                                 ),
                               ],
                             ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('용도', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Container(width: 256,
                               child:  Container(
                                 height: 32,
                                 margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                 child: TextFormField(
                                   maxLines: 1,
                                   textInputAction: TextInputAction.search,
                                   keyboardType: TextInputType.none,
                                   onEditingComplete: () {
                                     selectUse.add(useTypeInput.text);
                                     setState(() {});
                                     useTypeInput.clear();
                                   },
                                   decoration: InputDecoration(
                                     enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                     focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                     filled: true,
                                     fillColor: Colors.grey.shade100,
                                     hintText: '용도 직접 입력',
                                     hintStyle: TextStyle(fontSize: 12),
                                   ),
                                   controller: useTypeInput,
                                 ),
                               )),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32, width: 32,
                             child: TextButton(
                               onPressed: () async {
                                 //permitAtUseSelectUI(context);
                               },
                               style: StyleT.buttonStyleOutline(padding: 0),
                               child: Icon(Icons.add, color: StyleT.titleColor, size: 18,)
                             ),
                           ),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32,
                             child: TextButton(
                               onPressed: () {
                                 //managerSelectUI(context);
                               },
                               style: StyleT.buttonStyleOutline(padding: 8),
                               child: Row(
                                 children: [
                                   Text('용도 선택', style: StyleT.textStyle(),),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 4,),
                       Wrap(
                         runSpacing: 4,
                         spacing: 4,
                         children: [
                           for(var s in selectUse)
                            Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               SizedBox(
                                 height: 32,
                                 child: TextButton(
                                     onPressed: () async {
                                     },
                                     style: StyleT.buttonStyleOutline(padding: 4, elevation: 0),
                                     child: Row(
                                       children: [
                                         SizedBox(width: 4,),
                                         Text( '$s', style: StyleT.textStyle(),),
                                         SizedBox(width: 8,),
                                         SizedBox(
                                           height: 24, width: 24,
                                           child: TextButton(
                                             onPressed: () async {
                                               selectUse.remove(s);
                                               setState(() {});
                                             },
                                             style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                                             child: Icon(Icons.close, color: Colors.redAccent, size: 12,),
                                           ),
                                         ),
                                       ],
                                     )
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('허가 면적 정보', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           SizedBox(
                             height: 32,
                             child: TextButton(
                               onPressed: () async {
                                 var select = await permitAtUseSelectUI(context);
                                 aoTypeInput.text = select;
                               },
                               style: StyleT.buttonStyleOutline(padding: 8),
                               child: Row(
                                 children: [
                                   Text('허가용도 선택', style: StyleT.textStyle(),),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(width: 8,),
                           Container(width: 80, child: WidgetT.textInputField(aoTypeInput, hintText: '타입')),
                           SizedBox(width: 8,),
                           Container(
                             width: 128,
                             height: 32,
                             margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                             child: TextFormField(
                               maxLines: 1,
                               textInputAction: TextInputAction.search,
                               keyboardType: TextInputType.none,
                               onEditingComplete: () {
                                 currentInputArea['type'] = aoTypeInput.text;
                                 currentInputArea['area'] = areaInput.text;
                                 selectArea.add(currentInputArea);
                                 currentInputArea = {};
                                 areaInput.clear(); aoTypeInput.clear();
                                 setState(() {});
                               },
                               decoration: InputDecoration(
                                 enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                 focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                 filled: true,
                                 fillColor: Colors.grey.shade100,
                                 hintText: '면적 입력',
                                 hintStyle: TextStyle(fontSize: 12),
                               ),
                               controller: areaInput,
                             ),
                           ),
                           SizedBox(width: 8,),
                           Text('㎡', style: StyleT.titleStyle(bold: true),),

                           SizedBox(width: 24,),

                           /*
                           Expanded( child: WidgetHub.textInputField(areaInput, hintText: '직접 입력')),
                            */
                         ],
                       ),
                       SizedBox(height: 4,),
                       Wrap(
                         runSpacing: 4,
                         spacing: 4,
                         children: [
                           for(var s in selectArea)
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 SizedBox(
                                   height: 32,
                                   child: TextButton(
                                       onPressed: () async {
                                       },
                                       style: StyleT.buttonStyleOutline(padding: 4, elevation: 0),
                                       child: Row(
                                         children: [
                                           SizedBox(width: 4,),
                                           Text( '${s['type'] ?? ''} - ${s['area']} ㎡', style: StyleT.textStyle(),),
                                           SizedBox(width: 8,),
                                           SizedBox(
                                             height: 24, width: 24,
                                             child: TextButton(
                                               onPressed: () async {
                                                 selectArea.remove(s);
                                                 setState(() {});
                                               },
                                               style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                                               child: Icon(Icons.close, color: Colors.redAccent, size: 12,),
                                             ),
                                           ),
                                         ],
                                       )
                                   ),
                                 ),
                               ],
                             ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('실무자 입력', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Text(SystemT.getManagerName(selectManagerId)),
                           Container(width: 256, child: WidgetT.textInputField(managerInput, hintText: '실무자 직접 입력')),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32,
                             child: TextButton(
                               onPressed: () {
                                 managerSelectUI(context);
                               },
                               style: StyleT.buttonStyleOutline(padding: 8),
                               child: Row(
                                 children: [
                                   Text('실무자 선택', style: StyleT.textStyle(),),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('신청인 입력', style: StyleT.titleStyle(bold: true),),
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             children: [
                               Container(width: 128, child: WidgetT.textInputField(clientInput, hintText: '이름 입력')),
                               SizedBox(width: 8,),
                               Container(
                                 width: 150,
                                 height: 32,
                                 margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                 child: TextFormField(
                                   maxLines: 1,
                                   textInputAction: TextInputAction.search,
                                   keyboardType: TextInputType.none,
                                   onEditingComplete: () {
                                     currentClient['phoneNumber'] = clientPNInput.text;
                                     currentClient['name'] = clientInput.text;
                                     currentClient['desc'] = clientDesc.text;

                                     clients.add(currentClient);
                                     currentClient = {};

                                     clientInput.clear();
                                     clientPNInput.clear();
                                     clientDesc.clear();
                                     setState(() {});
                                   },
                                   decoration: InputDecoration(
                                     enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                     focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                     filled: true,
                                     fillColor: Colors.grey.shade100,
                                     hintText: '연락처 입력',
                                     hintStyle: TextStyle(fontSize: 12),
                                   ),
                                   controller: clientPNInput,
                                 ),
                               ),
                               SizedBox(width: 8,),
                               SizedBox(
                                 height: 32, width: 32,
                                 child: TextButton(
                                     onPressed: () async {
                                       //permitAtUseSelectUI(context);
                                     },
                                     style: StyleT.buttonStyleOutline(padding: 0),
                                     child: Icon(Icons.add, color: StyleT.titleColor, size: 18,)
                                 ),
                               ),
                             ],
                           ),
                           Container(width: 334, child: WidgetT.textInputField(clientDesc, hintText: '참고사항 입력 // 비고')),
                         ],
                       ),
                       SizedBox(height: 4,),
                       Wrap(
                         runSpacing: 4,
                         spacing: 4,
                         children: [
                           for(var s in clients)
                             Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 SizedBox(
                                   height: 32,
                                   child: TextButton(
                                       onPressed: () async {
                                       },
                                       style: StyleT.buttonStyleOutline(padding: 4, elevation: 0),
                                       child: Row(
                                         children: [
                                           SizedBox(width: 4,),
                                           Text( '${s['name'] ?? ''}  ${s['phoneNumber']}  ${s['desc']}  ', style: StyleT.textStyle(),),
                                           SizedBox(width: 8,),
                                           SizedBox(
                                             height: 24, width: 24,
                                             child: TextButton(
                                               onPressed: () async {
                                                 clients.remove(s);
                                                 setState(() {});
                                               },
                                               style: StyleT.buttonStyleOutline(padding: 0, elevation: 0),
                                               child: Icon(Icons.close, color: Colors.redAccent, size: 12,),
                                             ),
                                           ),
                                         ],
                                       )
                                   ),
                                 ),
                               ],
                             ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('건축사 정보', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Container(
                             height: 32, width: 200,
                             margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                             child: TextFormField(
                               maxLines: 1,
                               textInputAction: TextInputAction.search,
                               keyboardType: TextInputType.none,
                               onEditingComplete: () {
                                 selectArchitectureOfficeId = aoInput.text;
                                 setState(() {});
                               },
                               decoration: InputDecoration(
                                 enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                 focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                 filled: true,
                                 fillColor: Colors.grey.shade100,
                                 hintText: '건축사 직접 입력',
                                 hintStyle: TextStyle(fontSize: 12),
                               ),
                               controller: aoInput,
                             ),
                           ),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32,
                             child: TextButton(
                                 onPressed: () async {
                                   architectureOfficeSelectUI(context);
                                 },
                                 style: StyleT.buttonStyleOutline(padding: 8),
                                 child: Text('건축사 목록 선택', style: StyleT.textStyle(),)
                             ),
                           ),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('허가일 정보', style: StyleT.titleStyle(bold: true),),
                       Row(
                       children: [
                         SizedBox(
                           height: 32,
                           child: TextButton(
                             onPressed: () async {
                               var select = await permitAtUseSelectUI(context);
                               permitAtTypeInput.text = currentPermitAt['type'] = select;
                               setState(() {});
                             },
                             style: StyleT.buttonStyleOutline(),
                             child: Row(
                               children: [
                                 Text('허가용도', style: StyleT.textStyle(),),
                               ],
                             ),
                           ),
                         ),
                         SizedBox(width: 8,),
                         Container(width: 80, child: WidgetT.textInputField(permitAtTypeInput, hintText: '타입')),
                         SizedBox(width: 8,),
                         Container(
                           height: 32, width: 200,
                           margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                           child: TextFormField(
                             maxLines: 1,
                             textInputAction: TextInputAction.search,
                             keyboardType: TextInputType.none,
                             onEditingComplete: () {
                               var dateString = permitAtInput.text.replaceAll('.', '-');
                               var date = DateTime.tryParse(dateString);
                               if(date == null) return;

                               currentPermitAt['type'] = permitAtTypeInput.text;
                               currentPermitAt['date'] = StyleT.dateFormat(date).replaceAll(' ', '');
                               permitAtInput.clear(); permitAtTypeInput.clear();
                               permitAtList.add(currentPermitAt);
                               currentPermitAt = {};
                               setState(() {});
                             },
                             decoration: InputDecoration(
                               enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                               focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                               filled: true,
                               fillColor: Colors.grey.shade100,
                               hintText: '허가 날짜 입력',
                               hintStyle: TextStyle(fontSize: 12),
                             ),
                             controller: permitAtInput,
                           ),
                         ),
                         SizedBox(width: 8,),
                         SizedBox(
                           height: 32,
                           child: TextButton(
                             onPressed: () async {
                               DateTime? pickedDate = await showDatePicker(
                                   context: context,
                                   initialDate: DateTime.now(), //get today's date
                                   firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                   lastDate: DateTime(2101)
                               );
                               if(pickedDate  == null) return;

                               currentPermitAt['type'] = permitAtTypeInput.text;
                               currentPermitAt['date'] = pickedDate!.microsecondsSinceEpoch;
                               permitAtInput.clear(); permitAtTypeInput.clear();
                               permitAtList.add(currentPermitAt);
                               currentPermitAt = {};
                               setState(() {});
                             },
                             style: StyleT.buttonStyleOutline(),
                             child: Row(
                               children: [
                                 Icon(Icons.calendar_month, size: 18, color: StyleT.textColor,),
                                 SizedBox(width: 12,),
                                 Text('날짜 선택', style: StyleT.textStyle(),),
                               ],
                             ),
                           ),
                         ),
                         SizedBox(width: 8,),
                       ],
                     ),
                       SizedBox(height: 4,),
                       Wrap(
                         spacing: 8, runSpacing: 8,
                         children: [
                           for(var p in permitUseAtInput)
                             p,
                         ],
                       ),


                       SizedBox(height: StyleT.divideHeight,),
                       Text('종료일 입력', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           SizedBox(
                             height: 32,
                             child: TextButton(
                               onPressed: () async {
                                 var select = await permitAtUseSelectUI(context);
                                 endAtTypeInput.text = currentEndAt['type'] = select;
                                 setState(() {});
                                 },
                               style: StyleT.buttonStyleOutline(),
                               child: Row(
                                 children: [
                                   Text('허가용도', style: StyleT.textStyle(),),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(width: 8,),
                           Container(width: 80, child: WidgetT.textInputField(endAtTypeInput, hintText: '타입')),
                           SizedBox(width: 8,),
                           Container(
                             height: 32, width: 200,
                             margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                             child: TextFormField(
                               maxLines: 1,
                               textInputAction: TextInputAction.search,
                               keyboardType: TextInputType.none,
                               onEditingComplete: () {
                                 var dateString = endAtInput.text.replaceAll('.', '-');
                                 var date = DateTime.tryParse(dateString);
                                 if(date == null) return;

                                 currentEndAt['type'] = endAtTypeInput.text;
                                 currentEndAt['date'] = StyleT.dateFormat(date).replaceAll(' ', '');
                                 endAtInput.clear(); endAtTypeInput.clear();
                                 endAtList.add(currentEndAt);
                                 currentEndAt = {};
                                 setState(() {});
                               },
                               decoration: InputDecoration(
                                 enabledBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                 focusedBorder: OutlineInputBorder( borderRadius: BorderRadius.circular(0), borderSide: BorderSide(color: Colors.grey.shade300)),
                                 filled: true,
                                 fillColor: Colors.grey.shade100,
                                 hintText: '종료 날짜 입력',
                                 hintStyle: TextStyle(fontSize: 12),
                               ),
                               controller: endAtInput,
                             ),
                           ),
                           SizedBox(width: 8,),
                           SizedBox(
                             height: 32,
                             child: TextButton(
                               onPressed: () async {
                                 DateTime? pickedDate = await showDatePicker(
                                     context: context,
                                     initialDate: DateTime.now(), //get today's date
                                     firstDate:DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                     lastDate: DateTime(2101)
                                 );
                                 if(pickedDate == null) return;

                                 currentEndAt['date'] = pickedDate!.microsecondsSinceEpoch;
                                 endAtInput.clear();
                                 endAtList.add(currentEndAt);
                                 currentEndAt = {};
                                 setState(() {});
                               },
                               style: StyleT.buttonStyleOutline(),
                               child: Row(
                                 children: [
                                   Icon(Icons.calendar_month, size: 18, color: StyleT.textColor,),
                                   SizedBox(width: 12,),
                                   Text('날짜 선택', style: StyleT.textStyle(),),
                                 ],
                               ),
                             ),
                           ),
                           SizedBox(width: 8,),
                         ],
                       ),
                       SizedBox(height: 4,),
                       Wrap(
                         spacing: 8, runSpacing: 8,
                         children: [
                           for(var p in endAtListW)
                             p,
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       Text('허가유형', style: StyleT.titleStyle(bold: true),),
                       Row(
                         children: [
                           Container(width: 128, child: WidgetT.textInputField(typeInput, hintText: '허가유형 입력')),
                         ],
                       ),

                       SizedBox(height: StyleT.divideHeight,),
                       WidgetT.textInputField(memoInput, hintText: '진행 및 특이사항 입력', height: 128, maxLines: 8),

                       SizedBox(height: StyleT.divideHeight,),
                       Column(
                         children: [
                           SizedBox(
                             //width: 128,
                             child: TextButton(
                               onPressed: () async {
                                 var data =  PermitManagement.fromDatabase({
                                   'clientName': clientInput.text,
                                   'clientPhoneNumber': clientPNInput.text,
                                   'address': addressInput.text,

                                   'useType': selectUse,
                                   'area': selectArea,

                                   'permitAt': selectStartPermait,
                                   'permitAts': permitAtList,
                                   'endAts': permitAtList,
                                   'clients': clients,
                                   'addresses': addresses,
                                   'permitType': typeInput.text,

                                   'desc': memoInput.text,
                                   'architectureOffice': selectArchitectureOfficeId,
                                   'managerUid': selectManagerId,

                                 });
                                 var json = data.toJson();
                                 var jsonString = jsonEncode(json);
                                 print(jsonString);

                                 final key = en.Key.fromUtf8('J7MNLAde38qtpHP7i6PaHpzaoToMxX4Y');
                                 final iv = en.IV.fromLength(16);
                                 final encrypter = en.Encrypter(en.AES(key));
                                 var security = encrypter.encrypt(jsonString, iv: iv).base64;
                                 print('암호화 된값: ${security}');


                                 var list = []; var length = 128; //Random.secure().nextInt(32) + 32;
                                 var current = '';
                                 for(var c in security.characters) {
                                   current += c;
                                   length--;
                                   if(length <= 0) {
                                     length = 128;
                                     list.add(current);
                                     current = '';
                                   }
                                 }
                                 if(current != '')
                                   list.add(current);

                                 list.add('-NI4ujaycSizu0Tx5cYA');
                                 //var k = list.removeLast(); print(k);
                                 print(list.join());

                                 await FirebaseT.pushPermitManagementWithAES(list);
                                 await FirebaseT.pushPermitManagement(data);
                                 Navigator.pop(context);
                               },
                               style: StyleT.buttonStyleOutline(),
                               child: Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Icon(Icons.save, size: 18, color: Colors.green,),
                                   SizedBox(width: 8,),
                                   Text(
                                     '저장하기', style: StyleT.titleStyle(),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     );
  }
}
