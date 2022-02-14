import 'dart:convert';

import 'package:vit_balita/model/admin.dart';
import 'package:vit_balita/page/list_page.dart';
import 'package:vit_balita/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var admin = prefs.getString('admin');
  var responseBody;
  if (admin != null) {
    responseBody = json.decode(admin);
  }
  runApp(materialApp(
    debugShowCheckedModeBanner: false,
    home: admin == null
        ? LoginPage()
        : ListPage(admin: Admin.fromJson(responseBody['data'])),
  ));
}

class WidgetFlutterBinding {
}
