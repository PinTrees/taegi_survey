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

class PmInfoMiniPage extends StatefulWidget {
  PermitManagement p;
  PmInfoMiniPage({ required this.p});
  @override
  State<PmInfoMiniPage> createState() => _PmInfoMiniPageState();
}

class _PmInfoMiniPageState extends State<PmInfoMiniPage> {

  @override
  void initState() {
    super.initState();
  }

  Widget main(PermitManagement p) {
    var clientString = '';
    clientString = '이름: ' + p.clients.first['name'] + ',  연락처: ' + p.clients.first['phoneNumber'];

    var useString = '';
    for(var u in p.useType)
      useString += u + '\n';

    var areaString = '';
    for(var u in p.area)
      areaString += u['type'] + ': ' + u['area'] + '제곱미터' + '\n';

    var permitAtString = '';
    for(var u in p.permitAts)
      permitAtString += u['type'] + ': ' + u['date'] + '' + '\n';

    var endAtString = '';
    for(var u in p.endAts)
      endAtString += u['type'] + ': ' + u['date'] + '' + '\n';

    return   Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("소재지", style: StyleT.titleStyle(bold: true), ),
        new Text("${p.address}", style: StyleT.titleBigStyle(), ),
        SizedBox(height: 12,),
        new Text("실무자: ${SystemT.getManagerName(p.managerUid)}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("신청인", style: StyleT.titleStyle(bold: true), ),
        new Text("${clientString}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("용도", style: StyleT.titleStyle(bold: true), ),
        new Text("${useString}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("허가 면적 ", style: StyleT.titleStyle(bold: true), ),
        new Text("${areaString}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("허가일 ", style: StyleT.titleStyle(bold: true), ),
        new Text("${permitAtString}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("종료일 ", style: StyleT.titleStyle(), ),
        new Text("${endAtString}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("허가유형: ${p.permitType}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("건축사: ${(p.architectureOffice + '\n' + '010-0000-0000').replaceAll('\n', '')}", style: StyleT.titleStyle(), ),
        SizedBox(height: 12,),
        new Text("비고", style: StyleT.titleStyle(), ),
        new Text("${p.desc}", style: StyleT.titleStyle(), ),
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
                Expanded(child: Text(widget.p.address, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 14),)),
                TextButton(
                    onPressed: () async {
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.all(0),
                    ),
                    child: SizedBox(
                      height: 36, width: 36,
                      child: Icon(Icons.create_outlined,  color: StyleT.titleColor, size: 20,),
                    )
                ),
                SizedBox(width: 16,),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      SystemT.alert = false;
                      await windowManager.hide();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero, padding: EdgeInsets.all(0),
                    ),
                    child: SizedBox(
                      height: 36, width: 36,
                      child: Icon(Icons.minimize,  color: StyleT.titleColor, size: 20,),
                    )
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      WidgetHub.openPageWithFade(context, PermitManagementListViewerPage(), time: 0);

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
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      SystemT.alert = true;
                      await windowManager.setAlwaysOnTop(false);
                      await windowManager.hide();
                      setState(() {});
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