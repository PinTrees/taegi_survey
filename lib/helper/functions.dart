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
import 'interfaceUI.dart';
import 'transition.dart';

class FunctionT {
  static Function? refresh;
  static Function? dialogRefresh;

  static dynamic funRefresh() async {
    if(refresh != null) await refresh!();
  }
  static dynamic funDialogRefresh() async {
    if(refresh != null) await refresh!();
    if(dialogRefresh != null) await dialogRefresh!();
  }
}
