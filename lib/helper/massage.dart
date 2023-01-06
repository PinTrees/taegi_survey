
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';

class MassageT {
  static List<Massage> massages = [];
  static List<Massage> currentMassages = [];
  static List<Widget> messagesW = [];

  static dynamic init({String? name, List<PermitManagement>? sortP, List<WorkManagement>? sortW}) async {
    var tmpP = await SystemT.getPermitEndAtsList(30, sort: sortP);
    massages.add(Massage(title: '허가관리 종료 알림', subTitle: '',
        desc: '곧 허가종료가 다가오는 문서 ${tmpP.length}건이 있습니다.', type: 'alert',));

    var tmpW = await SystemT.searchWmSortTaskOverAtOnly(sortW ?? SystemT.workManagements.values.toList());
    massages.add(Massage(title: '업무마감 알림', subTitle: '',
        desc: '곧 마감이 다가오는 업무 ${tmpW.length}건이 있습니다.', type: 'alert'));

    massages.add(Massage(title: '진행중 알림', subTitle: '',
        desc: '현재 ${name}님이 진행중인 업무 ${tmpW.length}건이 있습니다.', type: 'none'));

    currentMassages.addAll(massages);
  }

  static dynamic messagePopup(BuildContext context,
      { Function? fun, Function()? saveFun, Function? setFun,}) async {

    List<Widget> children = [];
    for(int i = 0; i < MassageT.massages.length; i++) {
      var m = MassageT.massages[i];

      var color = Colors.transparent;
      if(m.type == 'alert') color = StyleT.errorLowColor.withOpacity(0.5);
      else if(m.type == 'none') color = StyleT.accentLowColor.withOpacity(0.5);

      var w =  Container(
        padding: EdgeInsets.only(bottom: 8),
        child: TextButton(
          onPressed: () {
          },
          style: StyleT.buttonStyleOutline(elevation: 0, padding: 0,
              color: color, strock: 1.4,),
          child: Container( width: 325,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetT.iconStyleMini(icon: Icons.notifications_active),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.title,
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: StyleT.titleColor.withOpacity(0.7))),
                        SizedBox(height: 4,),
                        Text(m.desc,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: StyleT.textColor.withOpacity(0.7))),
                        SizedBox(height: 4,),
                        Text(StyleT.dateFormatAtEpoch(m.createAt),
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: StyleT.textColor.withOpacity(0.7))),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      children.add(w);
    }

    bool? aa = await showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.15),
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateS) {
              return AlertDialog(
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 36,
                /// 다이얼로그 margin 바깥 패딩
                insetPadding: EdgeInsets.fromLTRB(0, 72, 12, 48),
                alignment: Alignment.topRight,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade400, width: 1.4),
                    borderRadius: BorderRadius.circular(8)),
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                title: Column(
                  children: [
                    Container(padding: EdgeInsets.all(12), child: Text('알림창', style: StyleT.titleStyle(bold: true))),
                    WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.35)),
                  ],
                ),
                content: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.zero,
                actions: <Widget>[
                  Column(
                    children: [
                      WidgetT.dividHorizontal(color: Colors.grey.withOpacity(0.35)),
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container( height: 28,
                              child: TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4, elevation: 18,
                                      color: Colors.redAccent.withOpacity(0.5)),
                                  child: Row( mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WidgetT.iconStyleMini(icon: Icons.cancel),
                                      Text('닫기', style: StyleT.titleStyle(),),
                                      SizedBox(width: 12,),
                                    ],
                                  )
                              ),
                            ),
                            Expanded(child: SizedBox(),),
                            Container( height: 28,
                              child: TextButton(
                                  onPressed: () async {
                                    await WidgetT.showSnackBar(context, text: '기능을 개발중 입니다.');
                                    setStateS(() {});
                                    //Navigator.pop(context);
                                  },
                                  style: StyleT.buttonStyleOutline(padding: 0, strock: 1.4,
                                      elevation: 18, color: StyleT.accentColor.withOpacity(0.5)),
                                  child: Row( mainAxisSize: MainAxisSize.min,
                                    children: [
                                      WidgetT.iconStyleMini(icon: Icons.settings),
                                      Text('알람설정', style: StyleT.titleStyle(),),
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
}
