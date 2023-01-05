
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:korea_regexp/get_regexp.dart';
import 'package:korea_regexp/models/regexp_options.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/ManagerPage1.dart';
import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:window_manager/window_manager.dart';

import '../xxx/PermitManagementViewerPage.dart';

class SystemT {
  static List<Manager> managers = [];
  static List<ArchitectureOffice> architectureOffices = [];
  //static List<PermitManagement> permitManagements = [];
  static Map<String, PermitManagement> permitManagementMaps = Map();
  static Map<String, WorkManagement> workManagements = Map();
  static Map<String, Contract> contracts = Map();

  static Map<dynamic, dynamic> currentManager = {};

  static SecurityKeys securityKeys = SecurityKeys.fromDatabase({});

  static double alertDu = 60;
  static double alertDuDefault = 60;

  static var alert = false;

  static var serverPath = 'Z:\\태기측량\\공용\\1.작업\\taegi_system_server';
  static var serverUsage = 0.0;

  static var releaseVer = '0.1.0+beta';
  static var currentVer = '0.1.0+beta';

  static var idToken = '';

  ///현재 검색어
  static var searchText = '';
  static var searchAddress = '';
  static var searchManager = '';
  static var searchClient = '';

  static var searchAddressList = [
    '횡성군 횡성읍',
    '횡성군 둔내면',
    '횡성군 서원면',
    '횡성군 갑천면',
    '횡성군 우천면',
    '횡성군 청일면',
    '횡성군 공근면',
    '횡성군 안흥면',
    '횡성군 강림면',

    '횡성군 횡성읍 횡성로',
    '횡성군 둔내면 둔내로',
    '횡성군 서원면 서원로',
    '횡성군 갑천면 갑천로',
    '횡성군 갑천면 매일리',
    '횡성군 우천면 용둔리',
    '횡성군 횡성읍 반곡리',
    '횡성군 둔내면 우용리',
    '횡성군 둔내면 둔방내리',
    '횡성군 횡성읍 남산리',
    '횡성군 우천면 오원리',
    '횡성군 둔내면 삽교리',
    '횡성군 우천면 백달리',
    '횡성군 우천면 상대리',
    '횡성군 청일면 속실리',
    '횡성군 둔내면 영랑리',
    '횡성군 공근면 삼배리',
    '횡성군 둔내면 조항리',
    '횡성군 갑천면 하대리',
    '횡성군 청일면 유평리',
    '횡성군 안흥면 소사리',
    '횡성군 안흥면 상안리',
    '횡성군 청일면 유동리',
    '횡성군 우천면 정금리',
    '횡성군 둔내면 석문리',
    '횡성군 청일면 갑천리',
    '횡성군 둔내면 궁종리',
    '횡성군 안흥면 지구리',
    '횡성군 청일면 초현리',
    '횡성군 청일면 고시리',
    '횡성군 횡성읍 마산리',
    '횡성군 우천면 하궁리',
    '횡성군 갑천면 병지방리',
    '횡성군 안흥면 안흥리',
    '홍천군 북방면 화동리',
    '횡성군 둔내면 자포곡리',
    '횡성군 청일면 신대리',
    '횡성군 횡성읍 정암리',
    '횡성군 우천면 양적리',
    '횡성군 공근면 오산리',
    '횡성군 횡성읍 마옥리',
    '횡성군 서원면 옥계리',
    '횡성군 갑천면 구방리',
    '횡성군 둔내면 현천리',
    '횡성군 청일면 봉명리',
    '횡성군 우천면 산전리',
    '횡성군 공근면 부창리',
    '횡성군 서원면 석화리',
    '횡성군 서원면 유현리',
    '횡성군 공근면 수백리',
    '횡성군 강림면 강림리',
    '횡성군 횡성읍 조곡리',
    '횡성군 공근면 가곡리',
    '횡성군 공근면 상동리',
    '횡성군 갑천면 전촌리',
    '횡성군 둔내면 영랑리',
    '횡성군 횡성읍 영영포리',
    '횡성군 공근면 어둔리',
    '횡성군 우천면 문암리',



    '원주시 소초면 학곡리',
    '원주시 호저면 광격리',


    '정선군 남면 유평리',



    '평창군 방림면 계촌리',
    '평창군 진부면 두일리',
    '평창군 봉평면 진조리',
    '평창군 방림면 계촌리',
    '평창군 봉평면 무이리',


    '횡성군 서원면',
  ];
  static dynamic searchDropAddress() {
    return searchAddressList;
  }


  static dynamic init() async {
    securityKeys = await FirebaseT.getSecurityKey();


    managers = await FirebaseT.getManagerAll();
    architectureOffices = await FirebaseT.getArchitectureOfficeAll();

    //permitManagementMaps;
    await FirebaseSSE.subscribePermitManagementSSE();
    //workManagementMaps;
    await FirebaseSSE.subscribeWorkManagementSSE();
    //contracts;
    await FirebaseSSE.subscribeContractSSE();

    //permitManagements = await FirebaseT.getPermitManagementAll_Security();
    //workManagements = await FirebaseT.getWorkManagementAll_Security();
    //contracts = await FirebaseT.getContractAll_Security();

    releaseVer = await FirebaseT.getWindowsVersion();

    for(var p in permitManagementMaps.values) {
      if (p.addresses.first != null)
        if (p.addresses.first != '')
          searchAddressList.add(p.addresses.first);
    }
    print(releaseVer);
  }
  static dynamic update() async {
    try{
      //permitManagements = await FirebaseT.getPermitManagementAll_Security();
      //workManagements = await FirebaseT.getWorkManagementAll_Security();
      //contracts = await FirebaseT.getContractAll_Security();
      updateServerUsage();
    } catch (e) {
      print(e);
    }
  }
  static dynamic updateServerUsage() async {
    var download = await FirebaseT.getServerUsage();
    serverUsage =  download / 100000000000;
  }

  static dynamic updateVersion() async {
    releaseVer = await FirebaseT.getWindowsVersion();
  }
  static int versionCheck() {
    var rI = int.tryParse(releaseVer.split('+').first.replaceAll('.', '').toString()) ?? 1;
    var cI = int.tryParse(currentVer.split('+').first.replaceAll('.', '').toString()) ?? 0;

   return rI - cI;
  }

  static dynamic initPageValue() {
    searchText = searchAddress = searchManager = searchClient = '';
  }

  static getServerDateId() {
    var date = DateTime.now();
    var dateId = DateFormat('yyyy-MM').format(date).toString();
    print(dateId);
    return dateId;
  }
  static getManagerKey(String name) {
    for(var m in managers) {
      if(m.name == name)
        return m.id;
    }
    return '';
  }
  static getManagerName(String uid) {
    for(var m in managers) {
      if(m.id == uid)
        return m.name;
    }
    return uid;
  }
  static dynamic getManager(String uid) {
    for(var m in managers) {
      if(m.id == uid)
        return m;
    }
    return null;
  }
  static getArchitectureOfficeName(String uid) {
    for(var a in architectureOffices) {
      if(a.id == uid)
        return a.name;
    }
    return uid;
  }

  static dynamic searchPmWithAddress(String search, {List<PermitManagement>? sort}) async {
    searchAddress = search;
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return sort ?? [];
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
    return [];
    //return await SystemControl.permitManagements.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
  }
  static dynamic searchPmWithClient(String search, {List<PermitManagement>? sort}) async {
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return sort ?? [];
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.clientName)).toList() ?? [];
    return sort ?? [];
  }
  static dynamic searchPmWithManager(String search, {List<PermitManagement>? sort}) async {
    var m = getManagerKey(search);
    if(m == null)
      return sort;
    if(sort != null)
      return await sort.where((e) => e.managerUid == m).toList() ?? [];
    return sort ?? [];
  }

  static dynamic searchPmWithYear(String search, {List<PermitManagement>? sort}) async {

    if(sort != null) {
      return sort.where((e) {
        if(e.getPermitAtsFirstNull() == null) return false;
        if(e.getPermitAtsFirstNull()!.year.toString() == search)
          return true;
        return false;
      }).toList() ?? [];
    }
    return sort ?? [];
  }
  static dynamic searchPmWithMonth(String search, { List<PermitManagement>? sort }) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getPermitAtsFirst() == null) return false;
        if(e.getPermitAtsFirst()!.month.toString() == search) return true;
        return false;
      }).toList() ?? [];
    return await permitManagementMaps.values.where((e) {
      if(e.getPermitAtsFirst() == null) return false;
      if(e.getPermitAtsFirst()!.month.toString() == search) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchPmSortF(List<PermitManagement>? sorts, { bool? dsss=false }) async {
    if(sorts!.length > 0) {
      sorts.sort((a, b) {
        if(a.getPermitAtsFirstNull() == null)
          return 1;
        if(b.getPermitAtsFirstNull() == null)
          return -1;


        int aDate = a.getPermitAtsFirst()!.microsecondsSinceEpoch;
        int bDate = b.getPermitAtsFirst()!.microsecondsSinceEpoch;


        if(dsss == true)
          return aDate.compareTo(bDate);
        else
          return bDate.compareTo(aDate);

        if((aDate > bDate) == dsss) return 1;
        else if((aDate < bDate) == dsss) return -1;
        return 0;
      });

      print(sorts.length);

      return sorts;
    }
    return sorts ?? [];
  }


  static dynamic searchCtWithComplete({List<Contract>? sort}) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getAllCfPay() >= e.getAllPay()) return true;
        return false;
      }).toList() ?? [];
    return await contracts.values.where((e) {
      if(e.getAllCfPay() >= e.getAllPay()) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchCtWithConfirm({List<Contract>? sort}) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getAllCfPay() < e.getAllPay()) return true;
        return false;
      }).toList() ?? [];
    return await contracts.values.where((e) {
      if(e.getAllCfPay() < e.getAllPay()) return true;
      return false;
    }).toList() ?? [];
  }

  static dynamic searchCtWithAddress(String search, {List<Contract>? sort}) async {
    searchAddress = search;
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return SystemT.contracts.values.toList();
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
    return await SystemT.contracts.values.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
  }
  static dynamic searchCtWithManager(String search, {List<Contract>? sort}) async {
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return SystemT.contracts.values.toList();
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(getManagerName(e.managerUid) ?? '')).toList() ?? [];
    return await SystemT.contracts.values.where((e) => regExp.hasMatch(getManagerName(e.managerUid) ?? '')).toList() ?? [];
  }
  static dynamic searchCtWithClient(String search, {List<Contract>? sort}) async {
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return SystemT.contracts.values.toList();
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.clients.first['name'] ?? '')).toList() ?? [];
    return await SystemT.contracts.values.where((e) => regExp.hasMatch(e.clients.first['name'] ?? '')).toList() ?? [];
  }
  static dynamic searchCtWithMonth(String search, {List<Contract>? sort}) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getContractAtsFirstNull() == null) return false;
        if(e.getContractAtsFirstNull()!.month.toString() == search) return true;
        return false;
      }).toList() ?? [];
    return await contracts.values.where((e) {
      if(e.getContractAtsFirst() == null) return false;
      if(e.getContractAtsFirst()!.month.toString() == search) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchCtWithYear(String search, {List<Contract>? sort}) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getContractAtsFirstNull() == null) return false;
        if(e.getContractAtsFirstNull()!.year.toString() == search) return true;
        return false;
      }).toList() ?? [];
    return await contracts.values.where((e) {
      if(e.getContractAtsFirst() == null) return false;
      if(e.getContractAtsFirst()!.month.toString() == search) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchCtSortF(List<Contract>? sorts, { bool? dsss=false }) async {
    if(sorts!.length > 0) {
      sorts.sort((a, b) {
        if(a.getContractAtsFirstNull() == null)
          return 1;
        if(b.getContractAtsFirstNull() == null)
          return -1;


        int aDate = a.getContractAtsFirstNull()!.microsecondsSinceEpoch;
        int bDate = b.getContractAtsFirstNull()!.microsecondsSinceEpoch;


        if(dsss == true)
          return aDate.compareTo(bDate);
        else
          return bDate.compareTo(aDate);
      });
      print(sorts.length);
      return sorts;
    }
    return sorts ?? [];
  }

  static dynamic searchWmWithAddress(String search, {List<WorkManagement>? sort}) async {
    searchAddress = search;
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
      return sort ?? SystemT.workManagements.values.toList();
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
    return await SystemT.workManagements.values.where((e) => regExp.hasMatch(e.addresses.first ?? '')).toList() ?? [];
  }
  static dynamic searchWmWithManager(String search, {List<WorkManagement>? sort}) async {
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(getManagerName(e.managerUid) ?? '')).toList() ?? [];
    return sort ?? [];
  }
  static dynamic searchWmWithClient(String search, {List<WorkManagement>? sort}) async {
    late RegExp regExp;
    try {
      regExp = getRegExp(search, RegExpOptions(initialSearch: true, startsWith: false, endsWith: false));
    } catch (e) {
      print(e);
    }
    if(sort != null)
      return await sort.where((e) => regExp.hasMatch(e.clients.first['name'] ?? '')).toList() ?? [];
    return sort ?? [];
  }
  static dynamic searchWmWithMonth(String search, {List<WorkManagement>? sort}) async {
    if(sort != null)
      return await sort.where((e) {
        if(e.getTaskAt() == null) return false;
        if(e.getTaskAt()!.month.toString() == search) return true;
        return false;
      }).toList() ?? [];
    return await workManagements.values.where((e) {
      if(e.getTaskAt() == null) return false;
      if(e.getTaskAt()!.month.toString() == search) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchWmWithYear(String search, {List<WorkManagement>? sort}) async {
    if(sort!.length > 0)
      return await sort.where((e) {
        if(e.getTaskAt() == null) return false;
        if(e.getTaskAt()!.year.toString() == search) return true;
        return false;
      }).toList() ?? [];
    return await workManagements.values.where((e) {
      if(e.getTaskAt() == null) return false;
      if(e.getTaskAt()!.year.toString() == search) return true;
      return false;
    }).toList() ?? [];
  }
  static dynamic searchWmSortF(List<WorkManagement>? sorts, { bool? dsss=false }) async {
    if(sorts!.length > 0) {
      sorts.sort((a, b) {
        if(a.getTaskAtNull() == null)
          return 1;
        if(b.getTaskAtNull() == null)
          return -1;


        int aDate = a.getTaskAtNull()!.microsecondsSinceEpoch;
        int bDate = b.getTaskAtNull()!.microsecondsSinceEpoch;

        if((aDate > bDate) == dsss) return 1;
        return 0;
      });

      print(sorts.length);

      return sorts;
    }
    return sorts ?? [];
  }
  static dynamic searchWmSortTaskOverAt(List<WorkManagement>? sorts,) async {
    if(sorts!.length > 0) {
      sorts.sort((a, b) {
        //int cDate = DateTime.now().microsecondsSinceEpoch;
        int aDate = a.getTaskOverAt()!.microsecondsSinceEpoch;
        int bDate = b.getTaskOverAt()!.microsecondsSinceEpoch;
        if((aDate > bDate)) return 0;
        return 1;
      });

      print(sorts.length);

      return sorts;
    }
    return sorts ?? [];
  }
  static dynamic searchWmSortTaskOverAtOnly(List<WorkManagement>? sorts,) async {
    List<WorkManagement> tmpList = [];
    if(sorts!.length > 0) {
      int c = DateTime.now().add(-Duration(days: 2)).microsecondsSinceEpoch;
      for(var t in sorts) {
        int tDate = t.getTaskOverAt()!.microsecondsSinceEpoch;
        if (c <= tDate)
          tmpList.add(t);
      }
      return tmpList;
    }
    return sorts ?? [];
  }
  static dynamic searchWmSortNullManager(List<WorkManagement>? sorts,) async {
    List<WorkManagement> tmpList = [];
    if(sorts!.length > 0) {
      for(var t in sorts) {
        if(getManager(t.managerUid) == null)
          tmpList.add(t);
      }
      return tmpList;
    }
    return sorts ?? [];
  }
  static dynamic searchWmSortIsSum(List<WorkManagement>? sorts,) async {
    List<WorkManagement> tmpList = [];
    if(sorts!.length > 0) {
      int c = DateTime.now().add(-Duration(days: 2)).microsecondsSinceEpoch;
      for(var t in sorts) {
        if(!t.isSupplement) continue;
        if(t.getSupplementOverAt() == null) continue;
        int tDate = t.getSupplementOverAt()!.microsecondsSinceEpoch;
        if (c <= tDate)
          tmpList.add(t);
      }
      return tmpList;
    }
    return sorts ?? [];
  }

  static dynamic readCSV(BuildContext context) async {
    var fileString = await DefaultAssetBundle.of(context).loadString('assets/csv/test.txt',);
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(fileString);

    return rowsAsListOfValues;
  }


  static List<PermitManagement> getPermitEndAtsList(int day, {List<PermitManagement>? sort}) {
    List<PermitManagement> result = [];

    if(sort != null) {
      for(var p in sort) {
        for(var _p in p.endAts) {
          if(_p['date'] == null) continue;

          var dS = _p['date'].replaceAll('.', '-');
          DateTime? dD = DateTime.tryParse(dS);
          if(dD == null) continue;

          int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
          if(difference > (day * -1) && difference < 3) {
            result.add(p); break;
          }
        }
      }
      return result;
    }

    for(var p in permitManagementMaps.values) {
      for(var _p in p.endAts) {
        var dS = _p['date'].replaceAll('.', '-');
        DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();

        int difference = int.parse(DateTime.now().difference(dD).inDays.toString());
        if(difference > (day * -1) && difference < 3) {
          result.add(p); break;
        }
      }
    }
    return result;
  }

  /// System Manager
  static startTrayOpen(BuildContext context) async {
    WidgetHub.openPageWithFade(context, ManagerPage1(), time: 0, first: true);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => PermitManagementListViewerPage()),);
    await SystemT.windowMainStyle(show: true);
  }
  static windowMainStyle({ bool show=false }) async {
    SystemT.alert = false;

    appWindow.maxSize = Size(2048, 2048);appWindow.minSize = new Size(400, 400);
    appWindow.size = Size(1280, 720);
    appWindow.alignment = Alignment.center;
    appWindow.size = Size(1280, 720);
    await windowManager.setAlwaysOnTop(false);

    if(show) {
      await windowManager.show();
      await windowManager.focus();
    }
  }
}
