
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

import '../PermitManagementViewerPage.dart';

class MassageT {
  static List<Massage> massages = [];
  static List<Massage> currentMassages = [];
  static List<Widget> messagesW = [];

  static dynamic init({String? name, List<PermitManagement>? sortP, List<WorkManagement>? sortW}) async {
    var tmpP = await SystemControl.getPermitEndAtsList(30, sort: sortP);
    massages.add(Massage(title: '허가관리 종료 알림', subTitle: '',
        desc: '곧 허가종료가 다가오는 문서 ${tmpP.length}건이 있습니다.', type: 'alert'));

    var tmpW = await SystemControl.searchWmSortTaskOverAtOnly(sortW ?? SystemControl.workManagements);
    massages.add(Massage(title: '엄무마감 알림', subTitle: '',
        desc: '곧 마감이 다가오는 업무 ${tmpW.length}건이 있습니다.', type: 'alert'));

    massages.add(Massage(title: '진행중 알림', subTitle: '',
        desc: '현재 ${name}님이 진행중인 업무 ${tmpW.length}건이 있습니다.', type: 'none'));

    currentMassages.addAll(massages);
  }
}
