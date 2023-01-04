import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'dart:io';


class Address{
  Common common;
  List<Juso> jusoList = [];

  Address({
    required this.common,
    required this.jusoList,
  });

  factory Address.formJson(Map<String,dynamic> json){
    final results = json['results'];
    final common = Common.fromJson(results['common']);
    List<Juso> jusoList = [];
    if(results['juso'] != null){
      final jusoJsonList = results['juso'] as List;
      jusoList = jusoJsonList.map((item) => Juso.fromJson(item)).toList();
    }

    return Address(
      common: common,
      jusoList: jusoList,
    );
  }
}
class Common{
  String? errorMessage;
  String? countPerPage;
  String? totalCount;
  String? errorCode;
  String? currentPage;

  Common({
    this.errorMessage,
    this.countPerPage,
    this.totalCount,
    this.errorCode,
    this.currentPage
  });

  factory Common.fromJson(Map<String, dynamic> json){
    return Common(
      errorMessage: json['errorMessage'],
      countPerPage: json['countPerPage'],
      totalCount: json['totalCount'],
      errorCode: json['errorCode'],
      currentPage: json['currentPage'],
    );
  }
}
class Juso{
  String? detBdNmList, engAddr, rn;
  String? emdNm, zipNo, roadAddrPart2;
  String? emdNo, sggNm, jibunAddr;
  String? siNm, roadAddrPart1, bdNm;
  String? admCd, udrtYn, lnbrMnnm;
  String? roadAddr, lnbrSlno, buldMnnm;
  String? bdKdcd, liNm, rnMgtSn;
  String? mtYn, bdMgtSn, buldSlno;

  Juso({
    this.detBdNmList, this.engAddr, this.rn,
    this.emdNm, this.zipNo, this.roadAddrPart2,
    this.emdNo, this.sggNm, this.jibunAddr,
    this.siNm, this.roadAddrPart1, this.bdNm,
    this.admCd, this.udrtYn, this.lnbrMnnm,
    this.roadAddr, this.lnbrSlno, this.buldMnnm,
    this.bdKdcd, this.liNm, this.rnMgtSn,
    this.mtYn, this.bdMgtSn, this.buldSlno
  });

  factory Juso.fromJson(Map<String, dynamic> json){

    return Juso(
      detBdNmList: json["detBdNmList"],engAddr: json["engAddr"],rn: json["rn"],
      emdNm: json["emdNm"],zipNo: json["zipNo"],roadAddrPart2: json["roadAddrPart2"],
      emdNo: json["emdNo"],sggNm: json["sggNm"],jibunAddr: json["jibunAddr"],
      siNm: json["siNm"],roadAddrPart1: json["roadAddrPart1"],bdNm: json["bdNm"],
      admCd: json["admCd"],udrtYn: json["udrtYn"],lnbrMnnm: json["lnbrMnnm"],
      roadAddr: json["roadAddr"],lnbrSlno: json["lnbrSlno"],buldMnnm: json["buldMnnm"],
      bdKdcd: json["bdKdcd"],liNm: json["liNm"],rnMgtSn: json["rnMgtSn"],
      mtYn: json["mtYn"],bdMgtSn: json["bdMgtSn"],buldSlno: json["buldSlno"],
    );
  }
}

class AddressRepository{
  final logger = Logger();

  Future<Address> searchAddress(String query) async{
    String url = "http://business.juso.go.kr/addrlink/addrLinkApi.do?$query";

    Response response = await get(Uri.parse(url),);
    print(response.body);
    Map<String, dynamic> body = jsonDecode(response.body);

    return Address.formJson(body);
  }

}

class AddressAPI {
  static final apiKey = 'U01TX0FVVEgyMDIyMTIyOTEwNTUwNjExMzM4NTY=';
  static AddressRepository _addressRepository = AddressRepository();
  static List<Juso> _addressList = [];
  static List<String> addressStringList = [];
  static List<String> addressStringListRoad = [];

  static dynamic fetchAddress(String keywords, int pageNumber) async {
    String query = "confmKey=$apiKey&currentPage=1&countPerPage=10&keyword=$keywords&resultType=json";
    //query = httpGetQuery(query, "resultType", 'json');
    print(query);
    try {
      Address address = await _addressRepository.searchAddress(query);
      if (address.jusoList!.isEmpty && address.common.errorCode == '0') {
        //throw ErrorModel(statusCode: 0, error: -101, message: '검색 결과가 없습니다.');
      } else if (address.common.errorCode != '0') {
        //throw ErrorModel(statusCode: 0, error: 0, message: address.common.errorMessage);
      }

      if (pageNumber == 1) _addressList.clear();
      _addressList.addAll(address.jusoList!);
      print(_addressList.toString());
    } catch (e) {
      print(e);
    }
  }
  static dynamic fetchAddressList(String keywords,) async {
    String query = "confmKey=$apiKey&currentPage=1&countPerPage=10&keyword=$keywords&resultType=json"
        "&hstryYn=Y&firstSort=location";
    //query = httpGetQuery(query, "resultType", 'json');
    print(query);
    try {
      Address address = await _addressRepository.searchAddress(query);
      if (address.jusoList!.isEmpty && address.common.errorCode == '0') {
        //throw ErrorModel(statusCode: 0, error: -101, message: '검색 결과가 없습니다.');
      } else if (address.common.errorCode != '0') {
        //throw ErrorModel(statusCode: 0, error: 0, message: address.common.errorMessage);
      }

      print(address.toString());
      print(address.jusoList.first.jibunAddr);

      _addressList.clear();
      addressStringList.clear();
      addressStringListRoad.clear();
      _addressList.addAll(address.jusoList!);
      for(var a in _addressList) {
        addressStringList.add(a.jibunAddr ?? '');
        addressStringListRoad.add('${a.roadAddrPart1 ?? ''}${a.roadAddrPart2 ?? ''}');
      }
      print(addressStringList.toString());
    } catch (e) {
      addressStringList.clear();
      addressStringListRoad.clear();
      addressStringList.add('');
      addressStringListRoad.add('');
      print(e);
    }

    return addressStringList;
  }

  static String httpGetQuery(String query, String key, String value) {
    if (value == null) {
      return query;
    }
    String firstWord = query == null ? "?" : "$query&";
    return "$firstWord$key=$value";
  }
}
