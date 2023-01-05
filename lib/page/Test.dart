import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:untitled2/xxx/PermitManagementViewerPage.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  void initAsync() async {
    await Window.setEffect(
      effect: WindowEffect.transparent,
      color: Color(0xCCe8e8e8) ,
      //dark: InterfaceBrightness.dark,
    );

    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}