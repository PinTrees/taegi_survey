
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemControl.dart';

class Transaction {
  var id = '';
  var amount = '';

  var transactionAt = '';
  /// in or out
  var transactionType = '';
  //var outType = '';
  //var inType = '';
  /// in or out type [ 계약금, 중도금, 경비 ]
  var type = '';

  var accountIn = '';
  var accountOut = '';
  var holderIn = '';
  var holderOut = '';

  Transaction.fromDatabase(Map<dynamic, dynamic> json) {
    id = json['id'] ?? '';
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}
