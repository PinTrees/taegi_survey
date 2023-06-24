import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:http/http.dart' as http;
import 'package:local_notifier/local_notifier.dart';
import 'package:quick_notify/quick_notify.dart';
import 'package:system_tray/system_tray.dart';
import 'package:untitled2/AlertPage.dart';
import 'package:untitled2/ManagerPage.dart';
import 'package:untitled2/ManagerPage1.dart';
import 'package:untitled2/OwnerPage.dart';
import 'package:untitled2/xxx/PermitManagementInfoPage.dart';
import 'package:untitled2/SystemUploder.dart';

import 'package:untitled2/helper/firebaseCore.dart';
import 'package:untitled2/helper/interfaceUI.dart';
import 'package:untitled2/helper/style.dart';
import 'package:untitled2/helper/systemClass.dart';
import 'package:untitled2/helper/systemControl.dart';
import 'package:untitled2/setting/LoginPage.dart';
import 'package:window_manager/window_manager.dart';
import 'page/Test.dart';
import 'package:encrypt/encrypt.dart' as en;

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await Window.initialize();

  await localNotifier.setup(
    appName: '태기측량 시스템 프로그램',
    shortcutPolicy: ShortcutPolicy.requireCreate,
  );

  runApp(const MyApp(),);

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1280, 720);
    win.minSize = Size(256, 256);
    win.maxSize = Size(2048, 2048);
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "taegi survey system tray mode";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(splashFactory: InkRipple.splashFactory,),
      darkTheme: ThemeData.dark().copyWith(splashFactory: InkRipple.splashFactory,),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: WindowBorder(
          color: Colors.black,
          width: 1,
          child: InitPage(),
        ),
      ),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);
  @override
  State<InitPage> createState() => _InitPageState();
}
class _InitPageState extends State<InitPage> {
  var loadText = '';
  late Timer? mainService;
  late Timer? alertService;
  bool isLoad = false;

  List<LocalNotification> _notificationList = [];


  @override
  void initState() {
    super.initState();
    initAsync();
  }
  Future<void> initSystemTray() async {
    String path = Platform.isWindows ? 'assets/icon.ico' : 'assets/icon.png';

    final AppWindow appWindow = AppWindow();
    final SystemTray systemTray = SystemTray();

    await systemTray.initSystemTray(iconPath: path);
    systemTray.setTitle("태기측량 시스템");
    systemTray.setToolTip("태기측량 시스템 프로그램이 백그라운드에서 작동중 입니다.");

    // create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
    ]);

    // set context menu
    await systemTray.setContextMenu(menu);
    systemTray.registerSystemTrayEventHandler((eventName) async {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        if(Platform.isWindows) {
          await SystemT.startTrayOpen(context);
          setState(() {});
        }
        else {
          systemTray.popUpContextMenu();
        }
      } else if (eventName == kSystemTrayEventRightClick) {
        if(Platform.isWindows) {
          await SystemT.startTrayOpen(context);
          setState(() {});
        }
        else {
          systemTray.popUpContextMenu();
        }
      }
    });
  }
  void initAsync() async {
    await Window.setEffect(
      effect: WindowEffect.aero,
      color: Color(0xEEf0f0f0),
      //dark: InterfaceBrightness.dark,
    );

    /*var sss = await FirebaseNTT.spacarniasdcweijncd();
    dynamic fff = await FirebaseNTT.orasklnasldvnlksanksadcjn(kyasvjsadnvlkn: await FirebaseNTT.kyasdnvalksdnvknsvmmvav(lcdasoinkasdvnk: await FirebaseNTT.lccdskasdcawnfqlncljacd(spascdnand: sss['sp'], lcasodncjqwnls: sss['lc']), kyasnvljnlasljdlnvkasd: sss['ky']),
    oranlsjdavbjasbdlknaskdc: sss['or']) ?? {};
    if(fff == null) return;*/
    try{
      await SystemT.initSystem(context);
    }catch(e) {
      WidgetT.showSnackBar(context, text: '시스템 기초정보를 불러올 수 없습니다. 관리자에게 문의해 주세요. ERROR: 101052');
      print(e);
    }
    if(SystemT.settingS == null) {
      WidgetT.showSnackBar(context, text: '시스템 기초정보를 불러올 수 없습니다. 관리자에게 문의해 주세요. ERROR: 101052');
      return;
    }

    loadText = '서버 정보를 설정하고 있습니다.'; setState(() {});
    var firebaseOptions = FirebaseOptions(
      appId: SystemT.settingS.appId,
      apiKey: SystemT.settingS.databaseKey,
      projectId: SystemT.settingS.projectId,
      messagingSenderId: SystemT.settingS.messagingSenderId,
      authDomain: SystemT.settingS.authDomain,
    );
    //fff = null;
    setState(() {});

    await Firebase.initializeApp(options: firebaseOptions);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

    loadText = '시스템 초기 설정중입니다.'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});
    await initSystemTray();
    await _handleNewLocalNotification();

    var isLoggedIn = await Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()),);
    if(!isLoggedIn) {
      appWindow.close();
      return;
    }

    loadText = '시스템에 로그인을 시도하는 중입니다.'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});

    loadText = '버전 확인중입니다.'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});
    await SystemT.updateVersion();
    if(SystemT.versionCheck() >= 2) {
      WidgetT.showAlertDlVersion(context);
      return;
    } else if(SystemT.versionCheck() != 0) {
      WidgetT.showAlertDlVersion(context, force: false);
    }


    loadText = '서버와 연결을 시도중입니다.'; setState(() {});
    await SystemT.init();
    loadText = '로딩 완료'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});
    loadText = '시스템 화면 설정중'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});

    loadText = '백그라운드 시스템 활성화 중'; setState(() {});
    await Future.delayed(const Duration(milliseconds: 300), () {});
    mainSV();
    alertSV();

    /// 서버 데이터 추가 로직 (중요)  *************************
    //WidgetHub.openPageWithFade(context, SystemUploadPage());

    //WidgetHub.openPageWithFade(context, PermitManagementListViewerPage());

    var data = await FirebaseT.getManger();
    if(data == null) return;
    if(data['name'] == '변석현') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerPage()),);
      return;
    }
    else if(data['name'] != '통합') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerPage1()),);
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => OwnerPage()),);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => PermitManagementListViewerPage()),);

    //WidgetHub.openPageWithFade(context, TestPage(key: widget.key,));
    //Navigator.push(context, MaterialPageRoute(builder: (context) => TestPage()),);
    setState(() {});
  }
  _handleNewLocalNotification() async {
    LocalNotification notification = LocalNotification(
      silent: true,
      title: "종료 일정 알림",
      //subtitle: "종료 알림",
      body: "-\n곧 종료일이 다가오는 일정이 있습니다.\n일정을 확인해주세요.\n-",
      actions: [
        LocalNotificationAction(
          text: '확인하기',
        )
      ]
    );
    notification.onClickAction = (index) {
      print('윈도우 알림창에서 확인하기가 클릭됨');
      Navigator.of(context).popUntil((route) => route.isFirst);

      //WidgetHub.openPageWithFade(context, PermitManagementListViewerPage(), time: 0);
      appWindow.show();
    };
    notification.onShow = () {
      print('onShow ${notification.identifier}');
    };
    notification.onClose = (closeReason) {
      print('onClose ${notification.identifier} - $closeReason\ncallback - 윈도우 알림창 닫힘');
    };
    notification.onClick = () async {
      print('onClick ${notification.identifier}\n윈도우 알림창이 클릭됨');
      Navigator.of(context).popUntil((route) => route.isFirst);

      //WidgetHub.openPageWithFade(context, PermitManagementListViewerPage(), time: 0);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => PermitManagementListViewerPage()),);
      await SystemT.windowMainStyle(show: true);
    };

    _notificationList.add(notification);

    setState(() {});
  }

  /// 백그라운드 알림 서비스 동작
  void mainSV() {
    mainService = Timer.periodic(Duration(minutes: 30), (timer) async {
      await SystemT.update();

      if(SystemT.alert) {
        SystemT.alert = false;

        List<PermitManagement> list = SystemT.getPermitEndAtsList(30);
        ///종료 예정일이 가까운 목록 없음 반환됨
        if(list.length <= 0)
          return;

        ///종료 예정일이 가까운 리스트 목록 봔환 확인됨
        //WidgetHub.openPageWithFade(context, AlertMiniPage(permits: list), time: 0);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AlertMiniPage(permits: list)),);


        appWindow.minSize = Size(360, 360);
        appWindow.maxSize = Size(360, 1080);
        appWindow.size = Size(360, 360);
        /// 창 사이즈 재설정   사이즈 -> 포지션
        await windowManager.setSize(Size(360, 360));
        appWindow.alignment = Alignment.bottomRight;

        await windowManager.setAlwaysOnTop(true);
        await windowManager.show();
        //appWindow.show();
        setState(() {});
      }
    });
  }
  void alertSV() {
    mainService = Timer.periodic(Duration(seconds: 1), (timer) async {
      if(isLoad) return;
      isLoad = true;
      SystemT.alertDu = SystemT.alertDuDefault;

      while(SystemT.alertDu > 0) {
        await Future.delayed(const Duration(milliseconds: 1024), () {});
        SystemT.alertDu--;
      }

      if(SystemT.alertDu <= 0) {
        _notificationList.clear();
        await _handleNewLocalNotification();

        print('try show notification');
        _notificationList.first.show();
        await Future.delayed(const Duration(milliseconds: 1024), () {});
        print('try close notification');
        _notificationList.first.close();
        _notificationList.first.destroy();
      }

      isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AppTitleBar(back: false, title: '태기측량 시스템 프로그램',),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$loadText',
                      style: StyleT.titleBigStyle(),
                    ),
                    SizedBox(height: 8,),
                    SizedBox(width: 512, height: 2, child: LinearProgressIndicator(minHeight: 2,)),
                  ],
                )
              ),
            )
          ],
        ),
      );
  }
}