
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemControl.dart';

class ArchitectureOffice {
  var name = '';
  var desc = '';
  var phoneNumber = '';
  var id = '';

  ArchitectureOffice.fromDatabase(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    desc = json['desc'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'desc': desc,
      'phoneNumber': phoneNumber,
    };
  }
}

class Manager {
  var id = '';
  var name = '';
  var type = '';
  var phoneNumber = '';

  Manager.fromDatabase(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'phoneNumber': phoneNumber,
    };
  }
}

class PermitManagement {
  var id = '';
  var managerUid = '';
  var clientName = '';
  var clientPhoneNumber = '';

  var clients = [];
  var address = '';
  var addresses = [];

  var useType = [];
  var area = [];

  var permitType = '세움터';
  var architectureOffice = '동아 (횡성)';
  var complete = true;
  var isDeposited = true;

  var desc = '';

  var permitAts = [];
  var endAts = [];

  var permitAt = '';

  var exitAt = DateTime.now();
  var startAt = DateTime.now();
  var completeAt = DateTime.now();


  PermitManagement.fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
    managerUid = json['managerUid'] ?? '';
    clientName = json['clientName'] ?? '';
    clientPhoneNumber = json['clientPhoneNumber'] ?? '';
    architectureOffice = json['architectureOffice'] ?? '';
    address = json['address'] ?? '';
    desc = json['desc'] ?? '';

    permitType = json['permitType'] ?? '';

    useType = json['useType'] ?? [];
    area = json['area'] ?? [];

    clients = json['clients'] ?? [];
    addresses = json['addresses'] ?? [];
    permitAts = json['permitAts'] ?? [];
    endAts = json['endAts'] ?? [];

    permitAt = json['permitAt'].toString();

    if(clients.length > 0) {
      clientName = clients.first['name'] ?? '';
      clientPhoneNumber = clients.first['phoneNumber'] ?? '';
    }
    else {
      //clients.add( { 'name': clientName, 'phoneNumber': clientPhoneNumber });
    }

    if(addresses.length > 0)
      address = addresses.first ?? '';


    //추후 변경 false
    isDeposited =  json['isDeposited'] ?? true;
  }
  void fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
    managerUid = json['managerUid'] ?? '';
    clientName = json['clientName'] ?? '';
    clientPhoneNumber = json['clientPhoneNumber'] ?? '';
    architectureOffice = json['architectureOffice'] ?? '';
    address = json['address'] ?? '';
    desc = json['desc'] ?? '';

    permitType = json['permitType'] ?? '';

    useType = json['useType'] ?? [];
    area = json['area'] ?? [];

    clients = json['clients'] ?? [];
    addresses = json['addresses'] ?? [];
    permitAts = json['permitAts'] ?? [];
    endAts = json['endAts'] ?? [];

    permitAt = json['permitAt'].toString();

    if(clients.length > 0) {
      clientName = clients.first['name'] ?? '';
      clientPhoneNumber = clients.first['phoneNumber'] ?? '';
    }
    else {
      //clients.add( { 'name': clientName, 'phoneNumber': clientPhoneNumber });
    }

    if(addresses.length > 0)
      address = addresses.first ?? '';


    //추후 변경 false
    isDeposited =  json['isDeposited'] ?? true;
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'managerUid': managerUid,
      'clientName': clientName,
      'clientPhoneNumber': clientPhoneNumber,
      'address': address,
      'useType': useType,
      'area': area,
      'desc': desc,

      'architectureOffice': architectureOffice,
      'permitType': permitType,

      'clients': clients as List,
      'addresses': addresses as List,
      'permitAts': permitAts as List,
      'endAts': endAts as List,
      'permitAt': permitAt.toString(),

      'startAt': startAt.microsecondsSinceEpoch,
      'completeAt': completeAt.microsecondsSinceEpoch,
      'complete': complete,
      'type': permitType,

      'isDeposited': isDeposited,
    };
  }
  DateTime? getPermitAtsFirst() {
    if(permitAts.length < 1) return null;
    var dS = permitAts.first['date'].replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
    return dD;
  }
  DateTime? getPermitAtsFirstNull() {
    if(permitAts.length < 1) return null;
    if(permitAts.first['date'] == null) return null;
    var dS = permitAts.first['date'].replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS);
    return dD;
  }
}
class Contract {
  var id = '';
  var contractAt = '';
  var permitAt = '';
  /// 배당일
  var takeAt = '';
  /// 업무 마감일
  var takeOverAt = '';
  var applyAt = '';
  var managerUid = '';
  var clients = [];
  var addresses = [];
  var useType = [];
  var landType = '';

  ///계약 내용
  var downPayment = 0;
  var middlePayment = 0;
  var middlePayments = [];
  var balance = 0;
  var totalCost = 0;
  var licenseTax = 0;
  var thirdParty = [];
  var isVAT = false;
  
  ///입금 현황
  var confirmDeposits = [];

  var confirmDownPayment = 0;
  var confirmMiddlePayment = [];
  var confirmBalance = 0;
  var confirmLicenseTax = 0;
  ///임금 합계 + 미수금 계산

  var thirdPartyDetails = '';
  var confirmPaymentDetails = '';
  var desc = '';

  Contract.fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
    permitAt = json['permitAt'].toString();
    contractAt = json['contractAt'].toString();

    /// 배당일
    takeAt = json['takeAt'] ?? '';
    takeOverAt = json['takeOverAt'] ?? '';
    applyAt = json['applyAt'] ?? '';
    managerUid = json['managerUid'] ?? '';

    useType = json['useType'] ?? [];
    landType = json['landType'] ?? '';

    clients = json['clients'] ?? [];
    addresses = json['addresses'] ?? [];

    ///계약 내용
    downPayment = json['downPayment'] ?? 0;
    middlePayment = json['middlePayment'] ?? 0;
    middlePayments = json['middlePayments'] ?? [];
    if(middlePayments.length <= 0) middlePayments.add(middlePayment);

    balance = json['balance'] ?? 0;
    totalCost = json['totalCost'] ?? 0;
    licenseTax = json['licenseTax'] ?? 0;
    thirdParty = json['thirdParty'] ?? [];
    isVAT = json['isVAT'] ?? false;

    ///입금 현황
    confirmDeposits = json['confirmDeposits'] ?? [];
    confirmDownPayment = json['confirmDownPayment'] ?? 0;
    confirmMiddlePayment = json['confirmMiddlePayment'] ?? [];
    confirmBalance = json['confirmBalance'] ?? 0;
    confirmLicenseTax = json['confirmLicenseTax'] ?? 0;

    thirdPartyDetails = json['thirdPartyDetails'] ?? '';
    confirmPaymentDetails = json['confirmPaymentDetails'] ?? '';
    desc = json['desc'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'permitAt': permitAt,
      'contractAt': contractAt,

      'takeAt': takeAt,
      'takeOverAt': takeOverAt,
      'applyAt': applyAt,
      'managerUid': managerUid,

      'useType': useType,
      'landType': landType,
      'clients': clients as List,
      'addresses': addresses as List,

      'downPayment': downPayment,
      'middlePayment': middlePayment,
      'middlePayments': middlePayments as List,
      'balance': balance,
      'totalCost': totalCost,
      'licenseTax': licenseTax,
      'thirdParty': thirdParty as List,
      'isVAT': isVAT,

      'confirmDeposits': confirmDeposits as List,
      'confirmDownPayment': confirmDownPayment,
      'confirmMiddlePayment': confirmMiddlePayment as List,
      'confirmBalance': confirmBalance,
      'confirmLicenseTax': confirmLicenseTax,

      'thirdPartyDetails': thirdPartyDetails,
      'confirmPaymentDetails': confirmPaymentDetails,
      'desc': desc,
    };
  }

  DateTime? getContractAtsFirst() {
    if(contractAt.length < 1) return null;
    var dS = contractAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
    return dD;
  }
  DateTime? getContractAtsFirstNull() {
    if(contractAt.length < 1) return null;
    var dS = contractAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS);
    return dD;
  }

  int getTakeOver() {
    var _toDay = DateTime.now();
    //var take = DateTime.parse(takeAt);
    var takeOverString = takeOverAt.replaceAll('.', '-');
    DateTime? takeOver = DateTime.tryParse(takeOverString) ?? DateTime.now();

    int difference = int.parse(
        _toDay.difference(takeOver).inDays.toString());

    difference = difference * -1;
    return difference;
  }

  int getCfDownPay() {
    var cf = 0;
    for(var c in confirmDeposits) {
      if(c['type'] == '계약금') {
        cf += int.tryParse(c['balance'].toString()) ?? 0;
      }
    }
    return cf;
  }
  int getCfMiddlePay() {
    var cf = 0;
    for(var c in confirmDeposits) {
      if(c['type'] == '중도금') {
        cf += int.tryParse(c['balance'].toString()) ?? 0;
      }
    }
    return cf;
  }
  int getCfBalance() {
    var cf = 0;
    for(var c in confirmDeposits) {
      if(c['type'] == '잔금') {
        cf += int.tryParse(c['balance'].toString()) ?? 0;
      }
    }
    return cf;
  }

  int getMiddlePays() {
    int t = 0;
    for(var m in middlePayments) {
      var a = int.tryParse(m.toString()) ?? 0;
      t += a;
    }
    return t;
  }
  String getMiddlePaysToString() {
    var ms = [];
    for(var m in middlePayments) {
      var c = '${ms.length + 1}차: ' +  StyleT.intNumberF(m);
      ms.add(c);
    }
    return ms.join('  +  ');
  }
  String getMiddlePaysToEdite() {
    var ms = [];
    for(var m in middlePayments) {
      ms.add(m.toString());
    }
    return ms.join('/');
  }

  int getAllPay() {
    return downPayment + getMiddlePays() + balance ;
  }
  int getAllCfPay() {
    return getCfDownPay() + getCfMiddlePay() + getCfBalance();
  }
  int getRemainderPay() {
    return getAllPay() - getAllCfPay();
  }

  bool isContract() {
    if(contractAt == null) return false;
    if(contractAt == '') return false;
    return true;
  }
  bool isManaged() {
    if(managerUid == null) return false;
    if(managerUid == '') return false;
    return true;
  }
  bool isApplied() {
    if(applyAt == null) return false;
    if(applyAt == '') return false;
    if(applyAt == 'null') return false;

    return true;
  }
  bool isPermitted() {
    if(permitAt == null) return false;
    if(permitAt == '') return false;
    if(permitAt == 'null') return false;
    return true;
  }
}
class WorkManagement {
  var id = '';
  var managerUid = '';
  var clients = [];
  var addresses = [];
  var useType = [];

  var taskAt = '';
  var taskOverAt = '';
  var supplementAt = '';
  var supplementOverAt = '';
  var isSupplement = false;

  var workAts = {};

  var supplementDesc = '';
  var delayDesc = '';
  var desc = '';

  WorkManagement.fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
    managerUid = json['managerUid'] ?? '';
    useType = json['useType'] ?? [];
    clients = json['clients'] ?? [];
    addresses = json['addresses'] ?? [];

    taskAt = json['taskAt'] ?? '';
    taskOverAt = json['taskOverAt'] ?? '';
    supplementAt = json['supplementAt'] ?? '';
    supplementOverAt = json['supplementOverAt'] ?? '';
    workAts = json['workAts'] ?? {};

    isSupplement = json['isSupplement'] ?? false;

    supplementDesc = json['additionalWorkDesc'] ?? '';
    delayDesc = json['delayDesc'] ?? '';
    desc = json['desc'] ?? '';
  }
  void fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
    managerUid = json['managerUid'] ?? '';
    useType = json['useType'] ?? [];
    clients = json['clients'] ?? [];
    addresses = json['addresses'] ?? [];

    taskAt = json['taskAt'] ?? '';
    taskOverAt = json['taskOverAt'] ?? '';
    supplementAt = json['supplementAt'] ?? '';
    supplementOverAt = json['supplementOverAt'] ?? '';
    workAts = json['workAts'] ?? {};

    isSupplement = json['isSupplement'] ?? false;

    supplementDesc = json['additionalWorkDesc'] ?? '';
    delayDesc = json['delayDesc'] ?? '';
    desc = json['desc'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'managerUid': managerUid,
      'clients': clients as List,
      'addresses': addresses as List,
      'useType': useType as List,

      'taskAt': taskAt,
      'taskOverAt': taskOverAt,
      'supplementAt': supplementAt,
      'supplementOverAt': supplementOverAt,
      'workAts': workAts as Map,

      'isSupplement': isSupplement,

      'additionalWorkDesc': supplementDesc,
      'delayDesc': delayDesc,
      'desc': desc,
    };
  }

  DateTime? getTaskAt() {
    var dS = taskAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
    return dD;
  }
  DateTime? getTaskAtNull() {
    var dS = taskAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS);
    return dD;
  }

  DateTime? getTaskOverAt() {
    var dS = taskOverAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS) ?? DateTime.now();
    return dD;
  }
  DateTime? getSupplementOverAt() {
    var dS = supplementOverAt.replaceAll('.', '-');
    DateTime? dD = DateTime.tryParse(dS);
    return dD;
  }

  int getTaskOverAmount() {
    var a = DateTime.now().difference(getTaskOverAt()!);
    var diff = 0;
    if(a != null) diff = a.inDays * -1;

    return diff + 1;
  }
  int getSupplementOverAmount() {
    if(getSupplementOverAt() == null) return 0;
    var a = DateTime.now().difference(getSupplementOverAt()!);
    var diff = 0;
    if(a != null) diff = a.inDays * -1;

    return diff + 1;
  }
}

class Massage {
  var title = '';
  var subTitle = '';
  var desc = '';
  var type = '';

  Massage({required this.title, required this.subTitle, required this.desc, required this.type}) {
  }
  Massage.fromJson(Map<dynamic, dynamic> json) {
    title = json['title'];
  }
}

class SecurityKeys {
  Map<dynamic, dynamic> keys = new Map();

  SecurityKeys.fromDatabase(Map<String, dynamic> json) {
    if (json['list'] != null)
      keys = json['list'] as Map ?? {};
  }
  String getKey(String key) {
    var data = keys['$key'] ?? {};
    return data['key'] ?? '';
  }
}