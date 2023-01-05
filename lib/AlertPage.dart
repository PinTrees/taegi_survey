import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/AlertMainPage.dart';
import 'package:untitled2/PermitManagementInfoPage.dart';
import 'package:untitled2/PermitManagementViewerPage.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:window_manager/window_manager.dart';

class AlertMiniPage extends StatefulWidget {
  List<PermitManagement> permits = [];
  AlertMiniPage({ required this.permits});
  @override
  State<AlertMiniPage> createState() => _AlertMiniPageState();
}
class _AlertMiniPageState extends State<AlertMiniPage> {

  @override
  void initState() {
    super.initState();
    initAsync();
  }
  void initAsync() async {
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
                  style: StyleT.buttonStyleOutline(padding: 6, elevation: 0, strock: 1.4, color: Colors.white.withOpacity(0.5)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${_p['type']}', style: StyleT.titleStyle(),),
                      SizedBox(width: 8,),
                      Text('${StyleT.dateFormat(dD)}', style: StyleT.titleStyle(),),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 4,),
              SizedBox(
                height: 24,
                child: TextButton(
                  onPressed: () {},
                  style: StyleT.buttonStyleOutline(padding: 6, elevation: 0, strock: 1.4, color: Colors.red.withOpacity(0.5)),
                  child: Text('${difference}일 남음', style: StyleT.titleStyle(color: Colors.white),),
                ),
              ),
            ],
          )
        );
      }

      var w = Container(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
        child: TextButton(
          onPressed: () async {
            WidgetHub.openPageWithFade(context, PmInfoMiniPage(p: p));
          },
          style: StyleT.buttonStyleOutline(padding: 0, elevation: 0, strock: 1.4, color: Colors.white.withOpacity(0.5)),
          child: Container(
            padding: EdgeInsets.fromLTRB(12, 12, 4, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(p.address, style: StyleT.titleBigStyle(),),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Text('실무자', style: StyleT.titleStyle(bold: true),),
                          SizedBox(width: 8,),
                          Text('${SystemT.getManagerName(p.managerUid)}', style: StyleT.titleStyle(),),
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Text('신청인', style: StyleT.titleStyle(bold: true),),
                          SizedBox(width: 8,),
                          Text('${p.clientName} : ${p.clientPhoneNumber}'.replaceAll('', ''), style: StyleT.titleStyle(),),
                        ],
                      ),
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
                Column(
                  children: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          WidgetHub.openPageWithFade(context, AlertMainPage(permits: widget.permits), time: 0);

                          appWindow.maxSize = Size(2048, 2048);appWindow.minSize = new Size(400, 400);
                          appWindow.size = Size(1280, 720);
                          appWindow.alignment = Alignment.center;
                          appWindow.show();
                          appWindow.size = Size(1280, 720);
                          await windowManager.setAlwaysOnTop(false);
                          await windowManager.show();

                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero, padding: EdgeInsets.all(0),
                        ),
                        child: SizedBox(
                          height: 36, width: 36,
                          child: Icon(Icons.create_outlined,  color: StyleT.titleColor,  size: 20,),
                        )
                    ),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          WidgetHub.openPageWithFade(context, AlertMainPage(permits: widget.permits), time: 0);

                          appWindow.maxSize = Size(2048, 2048);appWindow.minSize = new Size(400, 400);
                          appWindow.size = Size(1280, 720);
                          appWindow.alignment = Alignment.center;
                          appWindow.show();
                          appWindow.size = Size(1280, 720);
                          await windowManager.setAlwaysOnTop(false);
                          await windowManager.show();

                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero, padding: EdgeInsets.all(0),
                        ),
                        child: SizedBox(
                          height: 36, width: 36,
                          child: Icon(Icons.open_in_new_sharp,  color: StyleT.titleColor,  size: 20,),
                        )
                    ),
                  ],
                ),
              ],
            ),
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
         backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              color: Colors.transparent,
              height: 28,
              child: Row(
                children: [
                  SizedBox(width: 8,),
                  Text('종료 예정 알림', style: StyleT.titleStyle(),),
                  SizedBox(width: 8,),

                  Expanded(child: SizedBox()),
                  TextButton(
                      onPressed: () async {
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: StyleT.backgroundColor,
                        minimumSize: Size.zero, padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                      ),
                      child: Container(
                        height: 28,
                        alignment: Alignment.center,
                        child:  Row(
                          children: [
                            Text('알림  ${widget.permits.length}', style: StyleT.titleStyle(),),
                            TextButton(
                                onPressed: () async {
                                },
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero, padding: EdgeInsets.all(0),
                                ),
                                child: WidgetHub.iconStyleMini(icon: Icons.refresh)
                            ),
                          ],
                        ),
                      )
                  ),
                  SizedBox(width: 18,),
                  SizedBox(width: 18,),

                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PermitManagementListViewerPage(isAlert: true,)),);

                        appWindow.maxSize = Size(2048, 2048); appWindow.minSize = new Size(400, 400);
                        appWindow.size = Size(1280, 720);
                        appWindow.alignment = Alignment.center;
                        appWindow.size = Size(1280, 720);
                        await windowManager.setAlwaysOnTop(false);
                        await windowManager.show();

                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.all(0),
                      ),
                      child: WidgetHub.iconStyleMini(icon: Icons.open_in_new_sharp)
                  ),
                  TextButton(
                      onPressed: () async {
                        Navigator.of(context).popUntil((route) => route.isFirst);

                        SystemT.alert = true;
                        await windowManager.setAlwaysOnTop(false);
                        await windowManager.hide();
                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero, padding: EdgeInsets.all(0),
                      ),
                      child: WidgetHub.iconStyleMini(icon: Icons.close)
                  ),
                ],
              ),
            ),
            Container(width: double.maxFinite, height: 1.3, color: Colors.grey.shade500,),

            Expanded(
              child: Container(
                //color: Colors.white,
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 6,),
                      alertList(),
                      SizedBox(height: 6,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

