import 'dart:convert';

import 'package:vit_balita/api_balita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _formKey = GlobalKey<FormState>();
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  var _controllerUsername = TextEditingController();
  var _controllerPassword = TextEditingController();

  void register() async {
    if (_formKey.currentState.validate()) {
      var response = await http.post(ApiBalita.URL_REGISTER, body: {
        'username': _controllerUsername.text,
        'password': _controllerPassword.text,
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var message = '';
        if (responseBody['succes']) {
          message = 'Berhasil Register';
        } else {
          message = 'Gagal Register';
        }
        _scaffoldKey.currenState.showSnackkBar(SnackBar(
          content: Text(message),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        throw Exception('Gagal Login');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldKey,
    body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          buildHeader(context),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextFormField(
              controller: _controllerUsername,
              validator: (value) =>
                value.isEmpty ? 'Tidak boleh kosong' : null,
              decoration: InputDecoration(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: COlors.blue, width: 2),
              ),
              contentPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              enabledBorder: PutLineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              focusBorder: OutLineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              labelText: 'UserName',
              labelStyle: TextStyle(color: Colors.blue),
              suffixIcon: Icon(icons,lock, color: Colors.blue),
            ),
            cursorColor: Colors.blue,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            controller: _controllerPassword,
            validator: (value) =>
              value.isEmpty ? 'Tidak boleh kosong' : null,
            decoration:InputDecoration(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.fromTRB(20, 2, 0, 20),
            enableBorder: BorderRadius.circular(8),
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width:2),
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 2, 0, 20),
          enableBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderISde: BorderSide(color: Colors.blue, width: 2),
          ),
          focusBorder: OutLineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          cursorColor: Colors.blue,
          obscureText: true,
        ),
      ),
      SizedBox(height: 30),
      Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            gradient: LineraGradient(
              begin: Aligment.topleft,
              colors: [Colors.blue, Colors.lightBlue],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: Inkwell(
              onTap: () => register(),
              borderRadius: BorderRadius.circular(30),
              child: COntainer(
                width: 150,
                height: 45,
                aligment: ALigment.center,
                child: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
          ),
        ),
      ),
      SizedBox(height: 30),
      Material(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoratiaon : BoxDecoratioan(
            color: COlors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Inkwell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 150,
              height: 45,
              alignment: Alignment.center,
              child: Text('Login'),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeigt.bold,
                )),
            ),
          ),
        ),
      ),
    ),
    SizedBox(height: 30),
    ],
    ),
    ),
    ),
  );
}
Widget buliderHeader(BuildContext context) {
  return Container(
    height: 300,
    child: Stack(
      children: [
        ClipPath(
          clipper: -ClipHeader(),
          child: Container(color: Colors.blue),
        ),
        Positioned(
          top: 80,
          left: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                'Register',
                style: TextStyle(
                  color: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ), 
            ],
        ),
        ),
      ],
   );

}
}
class ClipHeader extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    double height = size.height;
    double width = size.width;

    path.lineTo(0, height * 0.8);
    path.quadraticBezierTo(width * 0.35, height, width * 0.6, height * 0.5);
    path.quadraticBezierTo(width * 0.7, height * 0.3, width * 0.8, height * 0.4);
    path.quadraticBezierTo(width * 0.9, height * 0.48, width, height * 0.4);
    path.lineTo(width, height * 0.5);
    path.lineTo(width, 0);

    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}