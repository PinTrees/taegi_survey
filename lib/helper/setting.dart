
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/ManagerPage1.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

import '../xxx/PermitManagementViewerPage.dart';

class SettingT {
  static int pageCount = 20, indexLimit = 10;
  static List<int> pageCountDropMenu = [ 2, 5, 10, 20, 50, 75, 100, ];

  static dynamic pageCountDropDown(Function fun,) {
    return TextButton(
      onPressed: null,
      style: StyleT.buttonStyleOutline(elevation: 8, padding: 0, strock: 1.4,
          color: StyleT.white.withOpacity(0.5) ),
      child: Container(
        height: 32,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Row(
              children: const [
                Icon(
                  Icons.list,
                  size: 16,
                  color: Colors.yellow,
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: Text(
                    'Select Item',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: pageCountDropMenu.map((item) => DropdownMenuItem<dynamic>(
              value: item,
              child: Text('목록 $item개', style: StyleT.hintStyle(bold: true, size: 12, accent: true),),
            ))
                .toList(),
            value: pageCount,
            onChanged: (value) {
              pageCount = value;
              if(fun != null) fun();
            },
            icon: const Icon(
              Icons.expand_more,
            ),
            iconSize: 14,
            iconEnabledColor: StyleT.textColor,
            iconDisabledColor: Colors.grey,
            buttonHeight: 50,

            buttonWidth: 95,
            dropdownWidth: 95,
            buttonElevation: 0,
            //dropdownMaxHeight: 200,

            buttonPadding: const EdgeInsets.only(left: 8, right: 8),

            buttonDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.transparent,),
            dropdownDecoration: StyleT.dropDownStyle(),

            itemHeight: 32,
            itemPadding: const EdgeInsets.only(left: 12, right: 12),
            dropdownPadding: null,
            dropdownElevation: 0,
            scrollbarRadius: const Radius.circular(8),
            scrollbarThickness: 6,
            scrollbarAlwaysShow: true,
            offset: const Offset(0, -4),
          ),
        ),
      ),
    );
  }
}
