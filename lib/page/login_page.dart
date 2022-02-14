import 'dart:convert';
import 'dart:html';;
import 'package:vit_balita/page/list_page.dart';
import 'package:vit_balita/model/admin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_balita.dart';

class LoginPage extends StateFulWidget {
  @override
  _LoginPageState createState () => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _controllerUsername = TextEditingController();
  var _controllerPassword = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  void login() async {
    if (_formKey.currentState.validate()) {
      var response = await http.post(ApiBalita.URL_LOGIN, body: {
        'username': _controllerUsername.text,
        'password': _controllerPassword.text,
      });
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        if (responseBody['succes']) {
          var admin = Admin.fromJson(responseBody['data']);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('admin', response.body);
          showDialog(
            context: context,
            buider: (context) => SimpleDialog(
              backgrounColor: colors.white,
              children: [
                Center(child: CircularProgressIndicator()),
                SizeBox(height: 10);
                center(child: Text('Loading...')),
              ],
            ),
          );
          Futere.delayed(
            Duration(miliiseconds: 1500),
            () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(bulider: (context)=> ListPage(admin: admin)
                ),
                );
            },
          );
        } else {
          _scaffolKey.currentState.showSnackBar(SnackNar(
            content: Text('Login Gagal'),
            duration: Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[700],
          ));
        }
      } else {
        throw Exception('Exception Gagal Login');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scafold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildHeader(context),
              sizedBox(height: 30),
              Padding(
                padding: EdgeInset,symmetric(horizontal: 30),
                child: TextField(
                  controller: _controllerUsername,
                  validator: (value) =>
                    value.isEmpty ? 'Tidak boleh kosong' : null,
                  decoration: InputDecoration(
                    border: OutLineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(colorL COlor.blue, width : 2),
                    ),
                    contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertila: 2),
                    enableBorder: OutLineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors, blue, witdh:2),
                    ),
                    focusedBorder: OutLineInputBorder(
                      borderRadius: BorderRadius.circlar(8),
                      borderSide: BorderSide(color: Colors.blue, width:2),
                    ),
                    labelText: Colors/blue,
                    keyboardType: TextInputType.EmailAddress,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    controller: _controllerPassword,
                    validator: (value) =>
                      value.isEmpty ? 'Tidak boleh kosong' : null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: borderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      contentPadding: EdgeInsets.fromTRB(20, 2, 0, 20),
                      enabledBorder: OutLineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, witdh: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.blue, witdh: 2),
                        ),
                        labelText: 'Password',
                        LabelStyle: TextStyle(color: Colors.blue),
                        suffixIcon: Icon(Icons.lock, color: Colors.blue),
                    ),
                    cursorColor: Colors.blue,
                    obscureText: Text,
                  ),
                ),
                SizedBox(height: 30),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoratian: BoxDecoration(
                      gradient: LinearGradient(
                        begin:Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.lightBlue],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () => login(),
                        borderRadius: BorderRadius.circular(30),
                        child:Container(
                          width: 150,
                          height: 45,
                          alignment: ALignment.center,
                          child: Text('Log in',
                            style: TextStyle(
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
              ],
            ),
          ),
        ),
      );
    }

Widget builderHeader(BuildContext context) {
  return Container(
    height: 300,
    child : Stack(
      children:[
        ClipPath(
          clipper: _ClipHeader(),
          child: Container(color: COlors.blue),
        ),
        Positioned(
          top: 80,
          left: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat Datang,',
                style: TextStyle(color: Colors.white. fontsize: 24),
              ),
              Text(
                'log In',
                style: TextStyle(
                  color: COlors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 40,
          child: gestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context)=> Registered()),
            ),
            child: Row(
              children: [
                Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}

calss _ClipHeader extends CustomClipper<Path> {
  @override 
  getClip(Size size) {
    Path path= Path();
    double heihgt = size.height;
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