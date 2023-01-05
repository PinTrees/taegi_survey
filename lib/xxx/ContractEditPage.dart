/*
import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:desktop_lifecycle/desktop_lifecycle.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

class CtEditePage extends StatefulWidget {
  Contract c;
  bool read;
  Function? close;

  CtEditePage({ required this.c, this.read=false, this.close});
  @override
  State<CtEditePage> createState() => _CtEditePageState();
}
class _CtEditePageState extends State<CtEditePage> {
  TextEditingController addressInput = new TextEditingController();

  var confirmPaymentDetails = [];
  var desc = '';
  var inputCtr = new Map();
  var tcKeys = ['address', 'clientN', 'clientPN', 'use',
    'contractAt', 'takeAt', 'applyAt', 'permitAt', 'land',
    'dp', 'dpC', 'mp', 'mpC', 'balance', 'balanceC', 'thirdParty',
    'totalCost', 'licenseTax', 'licenseTaxC', 'thirdParty',
    'thirdPartyD', 'Cdetails', 'desc' ];
  //var editBool = new Map();
  //var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    print('sdcccccccddddddddddddddddddddddddddddddddddddddddddddd');

    read = widget.read;
    for (var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    //for (var k in editKeys)
    //  editBool[k] = !read;
  }
  void inputText(String type) {
    if(type == 'address') {
      widget.c.addresses.add(inputCtr['address'].text);
      inputCtr['address'].clear();
    }
    else if(type == 'client') {
      widget.c.clients.add({
        'name': inputCtr['clientN'].text,
        'phoneNumber':  inputCtr['clientPN'].text,
      });
      inputCtr['clientN'].clear(); inputCtr['clientPN'].clear();
    }
    else if(type == 'use') {
      widget.c.useType.add(inputCtr['use'].text);
      inputCtr['use'].clear();
    }
    else if(type == 'land') {
      widget.c.landType = inputCtr['land'].text;
      inputCtr['land'].clear();
    }
    else if(type == 'desc') {
      widget.c.desc = inputCtr['desc'].text;
      inputCtr['desc'].clear();
    }
    setState(() {});
  }

  Widget editButton(String type) {
    return SizedBox();
  }

  Widget inputWidget(String type) {
    if(read) return SizedBox();
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

    if(type == 'deposits') {
      var width = 77.5;
      var padding = 0.74;

      var inputMenu = [ '계약금', '중도금', '잔금', '면허세', '기타' ];
      var accountList = [ '-81', '-51', ];

      List<Widget> widgets = []; var index = 0;
      for(var m in widget.c.confirmDeposits) {
        var key = '${index}::confirmDeposits';
        Widget w = SizedBox();

        w = Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    */
/*
                    Row(
                      children: [
                        Expanded(
                            child: Text('입금일', style: SystemStyle.titleStyle(bold: false),)
                        ),
                        Expanded(
                            child: Text('입금자', style: SystemStyle.titleStyle(bold: false),)
                        ),
                        Expanded(
                            child: Text('타입', style: SystemStyle.titleStyle(bold: false),)
                        ),
                        Expanded(
                            child: Text('금액', style: SystemStyle.titleStyle(bold: false),)
                        ),
                      ],
                    ),
                     *//*

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 36,
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
                                items: inputMenu.map((item) => DropdownMenuItem<dynamic>(
                                  value: item,
                                  child: Text(
                                    item.toString(),
                                    style: StyleT.titleStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                                value: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'],
                                onChanged: (value) {
                                  widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'] = value;
                                  setState(() {});
                                },
                                icon: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'] != null ? SizedBox(
                                  width: 28,
                                  child: TextButton(
                                    onPressed: () {
                                      widget.c.confirmDeposits[index]['type'] = null;
                                      setState(() {});
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
                                buttonWidth: 75,
                                dropdownWidth: 75,
                                buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                buttonDecoration: StyleT.dropButtonStyle(),
                                buttonElevation: 0,
                                itemHeight: 32,
                                itemPadding: const EdgeInsets.only(left: 12, right: 0),
                                dropdownMaxHeight: 512,
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
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['date'] ?? '임금날짜'}', () {}, true, k: key + 'date', set: (i, data) {
                            widget.c.confirmDeposits[i]['date'] =  data;
                          }, setFun: () { setState(() {}); }, hint: '날짜'),
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['uid'] ?? '예금주'}', () {}, true, k: key + 'uid', set: (i, data) {
                            widget.c.confirmDeposits[i]['uid'] =  data;
                          }, setFun: () { setState(() {}); }, hint: '예금주'),
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['balance']}만', () {}, true, k: key + 'balance', set: (i, data) {
                            widget.c.confirmDeposits[i]['balance'] = int.tryParse(data) ?? 0;
                          }, setFun: () { setState(() {}); }, hint: '금액'),
                        ),
                      ],
                    ),
                    SizedBox(height: padding,),
                    Row(
                      children: [
                        Container(
                          height: 36,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '계좌',
                                      style: StyleT.titleStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: accountList.map((item) => DropdownMenuItem<dynamic>(
                                value: item,
                                child: Text(
                                  item.toString(),
                                  style: StyleT.titleStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )).toList(),
                              value: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'],
                              onChanged: (value) {
                                widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'] = value;
                                setState(() {});
                              },
                              icon: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'] != null ? SizedBox(
                                width: 28,
                                child: TextButton(
                                  onPressed: () {
                                    widget.c.confirmDeposits[index]['account'] = null;
                                    setState(() {});
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
                              buttonWidth: width,
                              dropdownWidth: width,
                              buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                              buttonDecoration: StyleT.dropButtonStyle(),
                              buttonElevation: 0,
                              itemHeight: 32,
                              itemPadding: const EdgeInsets.only(left: 12, right: 0),
                              dropdownMaxHeight: 512,
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
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['desc']}', () {}, true,
                              width: null, k: key + 'desc', set: (i, data) {
                                widget.c.confirmDeposits[i]['desc'] = data;
                              }, setFun: () { setState(() {}); }, hint: '기타 내용'),
                        ),
                      ],
                    ),
                    SizedBox(height: 6,),
                  ]
              ),
            ),
            SizedBox(width: 2,),
            SizedBox(
                width: 24, height: 24,
                child: TextButton(
                  onPressed: () {
                    widget.c.confirmDeposits.remove(m);
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.delete),
                )
            ),
          ],
        );

        widgets.add(w);
        index++;
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.only(right: padding),
                    child: Text('입금 내역', style: StyleT.titleStyle(bold: true),)
                ),
                SizedBox(
                    width: 26,
                    child: TextButton(
                      onPressed: () {
                        widget.c.confirmDeposits.add({});
                        setState(() {});
                      },
                      style: StyleT.buttonStyleNone(padding: 0),
                      child: WidgetHub.iconStyleMini(icon: Icons.add),
                    )
                ),
              ],
            ),
            for(var w in widgets)
              w,
          ]
      );
    }
    if(type == 'payment') {
      var width = 72.0;
      var padding = 4.0;

      List<Widget> widgets = []; var index = 0;
      for(var m in widget.c.confirmMiddlePayment) {
        var key = '${index}::$m';
        Widget w = SizedBox();

        w = Container(
          padding: EdgeInsets.only(bottom: padding),
          child: WidgetHub.buttonWrap('${m}', () {
            widget.c.confirmMiddlePayment.remove(m);
          }, read, width: width - 4, k: key, set: (i, data) {
            widget.c.confirmMiddlePayment.removeAt(i);
            widget.c.confirmMiddlePayment.insert(i, data);
          }, setFun: () { setState(() {}); }),
        );

        widgets.add(w);
        index++;
      }

      //var inputMenu = [ 'dpC', 'licenseTaxC', 'mpC', 'balanceC' ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: width,  padding: EdgeInsets.only(right: padding),
              child: Text('계약 내용', style: StyleT.titleStyle(bold: true),)
          ),
          Row(
            children: [
              Container(
                  width: width,  padding: EdgeInsets.only(right: padding),
                  child: Text('계약금', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('면허세', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('중도금', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: 0),
                  child: Text('잔금', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: 0),
                  child: Text('부가세', style: StyleT.titleStyle(bold: false),)
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.downPayment}만', () {}, true,
                    width: width - 4, k: 'dp', set: (i, data) {
                      widget.c.downPayment =  int.tryParse(data) ?? 0;
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.licenseTax}만', () {}, true,
                    width: width - 4, k: 'licenseTax', set: (i, data) {
                      widget.c.licenseTax =  int.tryParse(data) ?? 0;
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.middlePayment}만', () {}, true,
                    width: width - 4, k: 'mp', set: (i, data) {
                      widget.c.middlePayment =  int.tryParse(data) ?? 0;
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                padding: EdgeInsets.only(right: 0),
                child: WidgetHub.buttonWrap('${widget.c.balance}만', () {}, true,
                    width: width - 4, k: 'balance', set: (i, data) {
                      widget.c.balance =  int.tryParse(data) ?? 0;
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                width: 42, alignment: Alignment.center,
                child: Transform.scale(
                  scale: 0.74,
                  child: Switch(
                    value: widget.c.isVAT,
                    onChanged: (value) {
                      widget.c.isVAT = value;
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 8,),
          Container(
              width: width,  padding: EdgeInsets.only(right: padding),
              child: Text('입금 현황', style: StyleT.titleStyle(bold: true),)
          ),
          SizedBox(height: 2,),
          Row(
            children: [
              Container(
                  width: width,  padding: EdgeInsets.only(right: padding),
                  child: Text('계약금', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('면허세', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('중도금', style: StyleT.titleStyle(bold: false),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('잔금', style: StyleT.titleStyle(bold: false),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.confirmDownPayment}만', () {
                  //widget.c.confirmMiddlePayment.remove(m);
                }, true, width: width - 4, k: 'dpC', set: (i, data) {
                  widget.c.confirmDownPayment = int.tryParse(data) ?? 0;
                  //widget.c.confirmMiddlePayment.removeAt(i);
                  //widget.c.confirmMiddlePayment.insert(i, data);
                }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.confirmLicenseTax}만', () {
                  //widget.c.confirmMiddlePayment.remove(m);
                }, true, width: width - 4, k: 'licenseTaxC', set: (i, data) {
                  widget.c.confirmLicenseTax = int.tryParse(data) ?? 0;
                  //widget.c.confirmMiddlePayment.removeAt(i);
                  //widget.c.confirmMiddlePayment.insert(i, data);
                }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
              Container(
                width: width, height: 36, padding: EdgeInsets.only(right: padding),
                child: TextFormField(
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.none,
                  onEditingComplete: () {
                    widget.c.confirmMiddlePayment.add(inputCtr['mpC'].text);
                    inputCtr['mpC'].clear();
                    setState(() {});
                  },
                  decoration: WidgetHub.textInputDecoration( hintText: '...', round: 4),
                  controller: inputCtr['mpC'],
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.confirmBalance}만', () {
                  //widget.c.confirmMiddlePayment.remove(m);
                }, true, width: width - 4, k: 'balanceC', set: (i, data) {
                  widget.c.confirmBalance = int.tryParse(data) ?? 0;
                  //widget.c.confirmMiddlePayment.removeAt(i);
                  //widget.c.confirmMiddlePayment.insert(i, data);
                }, setFun: () { setState(() {}); }, hint: '계약금'),
              ),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20,),
              Column(
                children: [
                  for(var w in widgets)
                    w,
                  SizedBox(height: 4,),
                ],
              ),
            ],
          ),
        ],
      );
    }

    if(type == 'ats') {
      var width = 84.0;
      var padding = 4.0;
      return Column(
        children: [
          Row(
            children: [
              Container(
                  width: width,  padding: EdgeInsets.only(right: padding),
                  child: Text('계약일', style: StyleT.titleStyle(bold: true),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('업무배당일', style: StyleT.titleStyle(bold: true),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('접수일', style: StyleT.titleStyle(bold: true),)
              ),
              Container(
                  width: width, padding: EdgeInsets.only(right: padding),
                  child: Text('허가일', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.contractAt}', () {}, true,
                    width: width - 4, k: 'contractAt', set: (i, data) {
                      widget.c.contractAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.takeAt}', () {}, true,
                    width: width - 4, k: 'takeAt', set: (i, data) {
                      widget.c.takeAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.applyAt}', () {}, true,
                    width: width - 4, k: 'applyAt', set: (i, data) {
                      widget.c.applyAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜'),
              ),
              Container(
                padding: EdgeInsets.only(right: padding),
                child: WidgetHub.buttonWrap('${widget.c.permitAt}', () {}, true,
                    width: width - 4, k: 'permitAt', set: (i, data) {
                      widget.c.permitAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜'),
              ),
            ],
          ),
        ],
      );
    }
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
            width: 150, height: 36,
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

    else if(type == 'land')
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: WidgetHub.buttonWrap('지목: ${widget.c.landType}', () {}, true,
                width: 180 - 4, k: 'landType', set: (i, data) {
                  widget.c.landType =  data;
                }, setFun: () { setState(() {}); }, hint: '지목'),
          ),
        ],
      );

    else if(type == 'Cdetails') {
      //Cdetails
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(right: 8),
              child: Text('입금내용 및 참고사항', style: StyleT.titleStyle(bold: true),)
          ),
          SizedBox(height: 4,),
          Container(
            child: TextFormField(
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                print('input confirmPaymentDetails');
                widget.c.confirmPaymentDetails = text;
              },
              onEditingComplete: () {
                //print('input  confirmPaymentDetails');
                setState(() {});
              },
              style: StyleT.titleStyle(),
              decoration: WidgetHub.textInputDecoration( hintText: '입금 내용', round: 4),
              controller: inputCtr['Cdetails'],
            ),
          ),
        ],
      );
    }
    else if(type == 'thirdParty') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('타사 업무', style: StyleT.titleStyle(bold: false),),
          SizedBox(height: 4,),
          Container(
            width: 200, height: 36,
            child: TextFormField(
              maxLines: 1,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.none,
              onEditingComplete: () {
                widget.c.thirdParty.add(inputCtr['thirdParty'].text);
                inputCtr['thirdParty'].clear();
                setState(() {});
              },
              decoration: WidgetHub.textInputDecoration( hintText: '용도', round: 4),
              controller: inputCtr['thirdParty'],
            ),
          ),
        ],
      );
    }
    else if(type == 'thirdPartyD') {
      return Container(
        width: double.maxFinite, height: 36,
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.none,
          onEditingComplete: () {
            //inputText('use');
          },
          decoration: WidgetHub.textInputDecoration( hintText: '용도', round: 4),
          controller: inputCtr['thirdPartyD'],
        ),
      );
    }
    return SizedBox();
  }

  Widget main(Contract c) {
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        SizedBox(height: 4,),
        Text(" 소재지", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            for(var s in c.addresses)
              WidgetHub.buttonWrap(s, () {
                c.addresses.remove(s);
                setState(() {});}, read),
          ],
        ),
        SizedBox(height: 4,),
        WidgetHub.buttonWrap('지목  -  ${c.landType}', width: 128, () {}, read),

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
        WidgetHub.buttonWrap('${SystemT.getManagerName(c.managerUid)}', width: 128, () {}, read),

        SizedBox(height: 16,),
        Text("신청인", style: StyleT.titleStyle(bold: true), ),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            inputWidget('client'),
            for(var s in c.clients)
              WidgetHub.buttonWrap('${s['name']}  ${s['phoneNumber']}', () {
                c.clients.remove(s);
                setState(() {});}, read),
            editButton('client'),
          ],
        ),

        SizedBox(height: 12,),
        Row(
          children: [
            new Text("사업목적", style: StyleT.titleStyle(bold: true), ),
          ],
        ),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          children: [
            inputWidget('use'),
            for(var s in c.useType)
              WidgetHub.buttonWrap(s, () {
                c.useType.remove(s);
                setState(() {});}, read),
            editButton('use'),
          ],
        ),

        SizedBox(height: 12,),
        Row(
          children: [
            Expanded(child: Text("계약일", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child: Text("접수일", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child: Text("허가일", style: StyleT.titleStyle(bold: true), ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          children: [
            Expanded(child:   WidgetHub.buttonWrap('${c.contractAt}', () {}, read),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.applyAt}', () {}, read),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.permitAt}', () {}, read),),
          ],
        ),
        SizedBox(height: 4,),
        Row(
          children: [
            Expanded(child: Text("업무배당일", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child: Text("업무마감일", style: StyleT.titleStyle(bold: true), ),),
            SizedBox(width: 4,),
            Expanded(child: Text("", style: StyleT.titleStyle(bold: true, color: Colors.redAccent), ),),
          ],
        ),
        SizedBox(height: 2,),
        Row(
          children: [
            Expanded(child:   WidgetHub.buttonWrap('${c.takeAt}', () {}, read),),
            SizedBox(width: 4,),
            Expanded(child:   WidgetHub.buttonWrap('${c.takeOverAt}', () {}, read),),
            SizedBox(width: 4,),
            Expanded(child: Text(" 3일 남음", style: StyleT.titleStyle(bold: true, color: Colors.redAccent), ),),
          ],
        ),
        SizedBox(height: 12,),
        Text("타사 업무", style: StyleT.titleStyle(bold: true), ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          runSpacing: 4,
          spacing: 4,
          children: [
            inputWidget('thirdParty'),
            for(var s in c.thirdParty)
              WidgetHub.buttonWrap('${s}', () {c.thirdParty.remove(s);setState(() {});}, read),
            editButton('client'),
          ],
        ),
        SizedBox(height: 8,),

        SizedBox(height: 8,),
        Row(
          children: [
            new Text("계약 현황", style: StyleT.titleStyle(bold: true), ),
          ],
        ),
        SizedBox(height: 4,),
        Row(
          children: [
            Expanded(
                child: Column(
                  children: [
                    WidgetHub.buttonWrap('계약금  ' + StyleT.intNumberF(c.downPayment) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('중도금  ' + StyleT.intNumberF(c.middlePayment) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('잔금     ' + StyleT.intNumberF(c.balance) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('총용역비용  ' + StyleT.intNumberF(c.getAllPay()) + '원', () {}, read),
                  ],
                )
            ),
            SizedBox(width: 8,),
            Expanded(
                child: Column(
                  children: [
                    WidgetHub.buttonWrap('입금  ' + StyleT.intNumberF(c.getCfDownPay()) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('입금  ' +  StyleT.intNumberF(c.getCfMiddlePay()) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('입금  ' +  StyleT.intNumberF(c.getCfBalance()) + '원', () {}, read),
                    SizedBox(height: 4,),
                    WidgetHub.buttonWrap('총 입금  ' +  StyleT.intNumberF(c.getAllCfPay()) + '원', () {}, read),
                  ],
                )
            ),
            Column(
              children: [
                WidgetHub.iconStyleMiddle(size: 36, icon: Icons.task_alt, accent: (c.getCfDownPay() >= c.downPayment)),
                SizedBox(height: 4,),
                WidgetHub.iconStyleMiddle(size: 36,icon: Icons.task_alt, accent: (c.getCfMiddlePay() >= c.middlePayment)),
                SizedBox(height: 4,),
                WidgetHub.iconStyleMiddle(size: 36,icon: Icons.task_alt, accent: (c.getCfBalance() >= c.balance)),
                SizedBox(height: 4,),
                WidgetHub.iconStyleMiddle(size: 36,icon: Icons.task_alt, accent: (c.getAllCfPay() >= c.getAllPay())),
              ],
            )
          ],
        ),
        SizedBox(height: 8,),
        Row(
          children: [
            Expanded(child: WidgetHub.buttonWrap('미수금   - ${StyleT.intNumberF(c.getRemainderPay())}원', () {}, read),),
            SizedBox(width: 4,),
            WidgetHub.buttonWrap('38%', width: 32, () {}, read),
          ],
        ),
        SizedBox(height: 18,),

        Text("입금내역", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 4,),
        for(var cd in c.confirmDeposits)
          WidgetHub.buttonWrap('${cd['date']}   ${cd['type']}입금   ${cd['balance']}원'
              '   ${cd['account']}(${cd['uid']})', () {}, read),

        inputWidget('payment'),
        SizedBox(height: 12,),
        inputWidget('deposits'),
        SizedBox(height: 12,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            inputWidget('Cdetails'),
          ],
        ),
        SizedBox(height: 12,),
        Text("입금내역 및 참고사항", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Text( widget.c.confirmPaymentDetails, style: StyleT.textStyleBig(),),
        //inputWidget('thirdPartyD'),
        SizedBox(height: 12,),
        Text("타사업무내용 및 특이사항", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Text( widget.c.thirdPartyDetails, style: StyleT.textStyleBig(),),
        //inputWidget('thirdPartyD'),

        SizedBox(height: 12,),
        Text("비고", style: StyleT.titleStyle(bold: true), ),
        SizedBox(height: 2,),
        Text( widget.c.desc, style: StyleT.textStyleBig(),),
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

class CtCreatePage extends StatefulWidget {
  Contract c;
  bool read;
  Function? close;

  CtCreatePage({ required this.c, this.read=false, this.close});
  @override
  State<CtCreatePage> createState() => _CtCreatePageState();
}
class _CtCreatePageState extends State<CtCreatePage> {
  TextEditingController addressInput = new TextEditingController();

  var confirmPaymentDetails = [];
  var desc = '';
  var inputCtr = new Map();
  var tcKeys = ['thirdPartyD', 'Cdetails', 'desc' ];
  //var editBool = new Map();
  //var editKeys = ['address', 'client', 'use', 'area', 'permitAts','endAts', 'desc', 'arch', 'permit' ];
  var read = false;
  @override
  void initState() {
    super.initState();
    read = widget.read;
    for (var k in tcKeys)
      inputCtr[k] = new TextEditingController();
    inputCtr['Cdetails'].text = widget.c.confirmPaymentDetails;
    inputCtr['thirdPartyD'].text = widget.c.thirdPartyDetails;
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

    if(type == 'deposits') {
      var width = 76.0;
      var padding = 2.0;

      var inputMenu = [ '계약금', '중도금', '잔금', '면허세', '기타' ];
      var accountList = [ '-81', '-51', ];

      List<Widget> widgets = []; var index = 0;
      for(var m in widget.c.confirmDeposits) {
        var key = '${index}::confirmDeposits';
        Widget w = SizedBox();

        w = Row(
          children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 36,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '입금',
                                        style: StyleT.titleStyle(),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: inputMenu.map((item) => DropdownMenuItem<dynamic>(
                                  value: item,
                                  child: Text(
                                    item.toString(),
                                    style: StyleT.titleStyle(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                                value: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'],
                                onChanged: (value) {
                                  widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'] = value;
                                  setState(() {});
                                },
                                icon: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'] != null ? SizedBox(
                                  width: 28,
                                  child: TextButton(
                                    onPressed: () {
                                      widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['type'] = null;
                                      setState(() {});
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
                                buttonWidth: 75,
                                dropdownWidth: 75,
                                buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                                buttonDecoration: StyleT.dropButtonStyle(),
                                buttonElevation: 0,
                                itemHeight: 32,
                                itemPadding: const EdgeInsets.only(left: 12, right: 0),
                                dropdownMaxHeight: 512,
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
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap(
                              '${m['date'] ?? '임금날짜'}', () {}, true, k: key + 'date', set: (i, data) {
                            widget.c.confirmDeposits[i]['date'] =  data;
                          }, setFun: () { setState(() {}); }, hint: '날짜',
                              val: m['date']),
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['uid'] ?? '예금주'}', () {}, true, k: key + 'uid', set: (i, data) {
                            widget.c.confirmDeposits[i]['uid'] =  data;
                          }, setFun: () { setState(() {}); }, hint: '예금주',
                              val: m['uid']),
                        ),
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${StyleT.intNumberF(m['balance'] ?? 0)}', () {}, true, k: key + 'balance', set: (i, data) {
                            widget.c.confirmDeposits[i]['balance'] = int.tryParse(data) ?? 0;
                          }, setFun: () { setState(() {}); }, hint: '금액',
                              val: (m['balance'].toString() == '0' || m['balance'].toString() == 'null' )
                                  ? '' : m['balance'].toString()),
                        ),
                      ],
                    ),
                    SizedBox(height: padding,),
                    Row(
                      children: [
                        Container(
                          height: 36,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              isExpanded: true,
                              hint: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '계좌',
                                      style: StyleT.titleStyle(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              items: accountList.map((item) => DropdownMenuItem<dynamic>(
                                value: item,
                                child: Text(
                                  item.toString(),
                                  style: StyleT.titleStyle(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )).toList(),
                              value: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'],
                              onChanged: (value) {
                                widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'] = value;
                                setState(() {});
                              },
                              icon: widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'] != null ? SizedBox(
                                width: 28,
                                child: TextButton(
                                  onPressed: () {
                                    widget.c.confirmDeposits[int.tryParse(key.split('::').first) ?? 0]['account'] = null;
                                    setState(() {});
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
                              buttonWidth: width,
                              dropdownWidth: width,
                              buttonPadding: const EdgeInsets.only(left: 8, right: 2),
                              buttonDecoration: StyleT.dropButtonStyle(),
                              buttonElevation: 0,
                              itemHeight: 32,
                              itemPadding: const EdgeInsets.only(left: 12, right: 0),
                              dropdownMaxHeight: 512,
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
                        SizedBox(width: padding,),
                        Expanded(
                          child: WidgetHub.buttonWrap('${m['desc']}', () {}, true,
                              width: null, k: key + 'desc', set: (i, data) {
                                widget.c.confirmDeposits[i]['desc'] = data;
                              }, setFun: () { setState(() {}); }, hint: '기타 내용',
                          val: m['desc']),
                        ),
                      ],
                    ),
                    SizedBox(height: 6,),
                  ]
              ),
            ),
            SizedBox(width: 2,),
            SizedBox(
                width: 24, height: 24,
                child: TextButton(
                  onPressed: () {
                    widget.c.confirmDeposits.remove(m);
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.delete),
                )
            ),
          ],
        );

        widgets.add(w);
        index++;
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.only(right: padding),
                    child: Text('입금 내역', style: StyleT.titleStyle(bold: true),)
                ),
                SizedBox(
                  width: 26,
                  child: TextButton(
                    onPressed: () {
                      widget.c.confirmDeposits.add({});
                      setState(() {});
                    },
                    style: StyleT.buttonStyleNone(padding: 0),
                    child: WidgetHub.iconStyleMini(icon: Icons.add),
                  )
                ),
              ],
            ),
            for(var w in widgets)
              w,
          ]
      );
    }
    if(type == 'payment') {
      var width = 72.0;
      var padding = 4.0;

      List<Widget> widgets = []; var index = 0;
      for(var m in widget.c.confirmMiddlePayment) {
        var key = '${index}::$m';
        Widget w = SizedBox();

        w = Container(
          padding: EdgeInsets.only(bottom: padding),
          child: WidgetHub.buttonWrap('${m}', () {
            widget.c.confirmMiddlePayment.remove(m);
          }, read, width: width - 4, k: key, set: (i, data) {
            widget.c.confirmMiddlePayment.removeAt(i);
            widget.c.confirmMiddlePayment.insert(i, data);
          }, setFun: () { setState(() {}); }),
        );

        widgets.add(w);
        index++;
      }

      //var inputMenu = [ 'dpC', 'licenseTaxC', 'mpC', 'balanceC' ];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: width,  padding: EdgeInsets.only(right: padding),
              child: Text('계약 내용', style: StyleT.titleStyle(bold: true),)
          ),

          Row(children: [

          ],),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Column(
                children: [
                  Row(
                    children: [
                      Text('부가세 포함', style: StyleT.titleStyle(bold: true),),
                      SizedBox(width: 4,),
                      Container(
                        width: 42, alignment: Alignment.center,
                        child: Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: widget.c.isVAT,
                            onChanged: (value) {
                              widget.c.isVAT = value;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('계약금 ${StyleT.intNumberF(widget.c.downPayment)}', () {}, true, k: 'dp', set: (i, data) {
                          widget.c.downPayment =  int.tryParse(data) ?? 0;
                        }, setFun: () { setState(() {}); }, hint: '금액',
                        val: widget.c.downPayment == 0 ? '' : widget.c.downPayment.toString()),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('면허세 ${StyleT.intNumberF(widget.c.licenseTax)}', () {}, true,
                        k: 'licenseTax', set: (i, data) {
                          widget.c.licenseTax = int.tryParse(data) ?? 0;
                        }, setFun: () { setState(() {}); }, hint: '금액',
                        val: widget.c.licenseTax == 0 ? '' : widget.c.licenseTax.toString()),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('중도금 ${StyleT.intNumberF(widget.c.middlePayment)}', () {}, true,
                        k: 'mp', set: (i, data) {
                          widget.c.middlePayment =  int.tryParse(data) ?? 0;
                        }, setFun: () { setState(() {}); }, hint: '금액',
                        val: widget.c.middlePayment == 0 ? '' : widget.c.middlePayment.toString()),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 0),
                    child: WidgetHub.buttonWrap('잔금 ${StyleT.intNumberF(widget.c.balance)}', () {}, true,
                       k: 'balance', set: (i, data) {
                          widget.c.balance =  int.tryParse(data) ?? 0;
                        }, setFun: () { setState(() {}); }, hint: '금액',
                        val: widget.c.balance == 0 ? '' : widget.c.balance.toString()),
                  ),
                ],
              )),
              SizedBox(width: 4,),
              Expanded(child: Column(
                children: [
                  */
/*
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('${widget.c.confirmDownPayment}만', () {
                      //widget.c.confirmMiddlePayment.remove(m);
                    }, true, width: width - 4, k: 'dpC', set: (i, data) {
                      widget.c.confirmDownPayment = int.tryParse(data) ?? 0;
                      //widget.c.confirmMiddlePayment.removeAt(i);
                      //widget.c.confirmMiddlePayment.insert(i, data);
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('${widget.c.confirmLicenseTax}만', () {
                      //widget.c.confirmMiddlePayment.remove(m);
                    }, true, width: width - 4, k: 'licenseTaxC', set: (i, data) {
                      widget.c.confirmLicenseTax = int.tryParse(data) ?? 0;
                      //widget.c.confirmMiddlePayment.removeAt(i);
                      //widget.c.confirmMiddlePayment.insert(i, data);
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
                  ),
                  Container(
                    width: width, height: 36, padding: EdgeInsets.only(bottom: padding),
                    child: TextFormField(
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.none,
                      onEditingComplete: () {
                        widget.c.confirmMiddlePayment.add(inputCtr['mpC'].text);
                        inputCtr['mpC'].clear();
                        setState(() {});
                      },
                      decoration: WidgetHub.textInputDecoration( hintText: '...', round: 4),
                      controller: inputCtr['mpC'],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: padding),
                    child: WidgetHub.buttonWrap('${widget.c.confirmBalance}만', () {
                      //widget.c.confirmMiddlePayment.remove(m);
                    }, true, width: width - 4, k: 'balanceC', set: (i, data) {
                      widget.c.confirmBalance = int.tryParse(data) ?? 0;
                      //widget.c.confirmMiddlePayment.removeAt(i);
                      //widget.c.confirmMiddlePayment.insert(i, data);
                    }, setFun: () { setState(() {}); }, hint: '계약금'),
                  ),
                   *//*

                ],
              )),
            ],
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
          Row(
            children: [
              Expanded(
                  child: Text('계약일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('접수일', style: StyleT.titleStyle(bold: true),)
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text('허가일', style: StyleT.titleStyle(bold: true),)
              ),
            ],
          ),
          SizedBox(height: 2,),
          Row(
            children: [
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.contractAt}', () {}, true,
                    k: 'contractAt', set: (i, data) {
                      widget.c.contractAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.contractAt),
              ),

              SizedBox(width: 4,),
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.applyAt}', () {}, true,
                   k: 'applyAt', set: (i, data) {
                      widget.c.applyAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.applyAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.permitAt}', () {}, true,
                     k: 'permitAt', set: (i, data) {
                      widget.c.permitAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.permitAt),
              ),
            ],
          ),
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
                child: WidgetHub.buttonWrap('${widget.c.takeAt}', () {}, true,
                    k: 'takeAt', set: (i, data) {
                      widget.c.takeAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.takeAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: WidgetHub.buttonWrap('${widget.c.takeOverAt}', () {}, true,
                    k: 'takeOverAt', set: (i, data) {
                      widget.c.takeOverAt =  data;
                    }, setFun: () { setState(() {}); }, hint: '날짜', val: widget.c.takeOverAt),
              ),
              SizedBox(width: 4,),
              Expanded(
                  child: Text(' ${widget.c.getTakeOver()}일 남음', style: StyleT.titleStyle(bold: true, color: Colors.redAccent),)
              ),
            ],
          ),
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


    else if(type == 'land') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: WidgetHub.buttonWrap('지목: ${widget.c.landType}', () {}, true,
                width: 180 - 4, k: 'landType', set: (i, data) {
                  widget.c.landType =  data;
                }, setFun: () { setState(() {}); }, hint: '지목', val: widget.c.landType),
          ),
        ],
      );
    }

    else if(type == 'Cdetails') {
      //Cdetails
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(right: 8),
              child: Text('입금내용 및 참고사항', style: StyleT.titleStyle(bold: true),)
          ),
          SizedBox(height: 4,),
          Container(
            child: TextFormField(
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              onChanged: (text) {
                print('input confirmPaymentDetails');
                widget.c.confirmPaymentDetails = text;
              },
              onEditingComplete: () {
                //print('input  confirmPaymentDetails');
                setState(() {});
              },
              style: StyleT.titleStyle(),
              decoration: WidgetHub.textInputDecoration( hintText: '입금 내용', round: 4),
              controller: inputCtr['Cdetails'],
            ),
          ),
        ],
      );
    }
    else if(type == 'thirdParty') {
      if(widget.c.thirdParty.length == 0)
        widget.c.thirdParty.add('');

      return Column(
        children: [
          for(int i = 0; i < widget.c.thirdParty.length; i++)
            Container(
              padding: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child:   WidgetHub.buttonWrap('${widget.c.thirdParty[i]}',() {
                    setState(() {});
                  }, true,
                      k: '$i::thirdParty', set: (i, data) {
                        widget.c.thirdParty[i] =  data;
                      }, setFun: () { setState(() {}); }, hint: '타사 업무', val: widget.c.thirdParty[i]),),
                  SizedBox(
                      height: 26,
                      child: TextButton(
                        onPressed: () {
                          widget.c.thirdParty.removeAt(i);
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

  Widget main(Contract c) {
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
        SizedBox(height: 6,),
        Row(
          children: [
            Text("타사 업무", style: StyleT.titleStyle(bold: true), ),
            SizedBox(
                width: 26,
                child: TextButton(
                  onPressed: () {
                    widget.c.thirdParty.add('');
                    inputWidget('thirdParty');
                    setState(() {});
                  },
                  style: StyleT.buttonStyleNone(padding: 0),
                  child: WidgetHub.iconStyleMini(icon: Icons.add),
                )
            ),
          ],
        ),
        inputWidget('thirdParty'),
        SizedBox(height: 8,),
        inputWidget('payment'),
        SizedBox(height: 12,),
        inputWidget('deposits'),
        SizedBox(height: 12,),
        Wrap(
          runSpacing: 4,
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            inputWidget('Cdetails'),
          ],
        ),
        SizedBox(height: 12,),
        Row(
          children: [
            new Text("타사업무내용 및 특이사항", style: StyleT.titleStyle(bold: true), ),
          ],
        ),
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
                    print('input thirdPartyDetails');
                    widget.c.thirdPartyDetails = text;
                  },
                  style: StyleT.titleStyle(),
                  decoration:  WidgetHub.textInputDecoration( hintText: '비고', round: 4),
                  controller: inputCtr['thirdPartyD'],
                ),
              ),
            ),
          ],
        ),
        //inputWidget('thirdPartyD'),

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
*/
