import 'dart:convert';
import 'dart:ui';

import 'package: vit_balita/api_balita.dart';
import 'package: vit_balita/model/admin.dart';
import 'package: vit_balita/model/balita.dart';
import 'package: vit_balita/page/add_update_balita_page.dart';
import 'package: vit_balita/page/login_page.dart';
import 'flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StateFulWidget {
  final Admin admin;

  ListPage({this.admin});
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Balita>> getBalita() async {
    List<Balita> listBalita = [];
    var response = await http.get(ApiBAlita.URL_GET_BALITA);
    if (response.statusCode == 200) {
      var responseBody = jasonDecode(response.body);
      if (responseBody['succes']) {
        ListJson.forEach((element) {
          listBalita.add(Balita.fromJson(element));
        });
      }
    } else {
      print('Request gagal');
    }

    return listBalita;
  }

  void deleteBalita(String nik, String foto) async {
    var response = await http.post(APiBalita.URL_DELETE_BALITA, body: {
      'nik': nik,
    });
    await http.post(ApiBalita.URL_DELETE_FOTO, body: {
      'nama': foto,
    });
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      var message = '';
      if (responseBody['succes']) {
        message = 'Berhasil Dihapus';
      } else {
        message = 'Gagal Dihapus';
      }
      _scaffoldKey.currenState.showSnakBar(SnackBar(
        content: Text(message),
        duration: Duration(millisecins: 1500),
      ));
    } else {
      print('Request gagal');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(widget.admin.username),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=> LoginPage()),
              );
            },
            tolltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder(
        future: getBalita(),
        builders: (context, snapshot) {
          switch: (snapshot.connectionState) {
            case ConnectionState.none:
              print('ConnectionState.none');
              return Center(Child: text('ConnectionState.none'));
              break;
            case Connectioan.active:
              print('ConnectionSate.active');
              return Center(child: Text('ConnetionState.active'));
              break;
            case ConnectionState.waiting:
              print('ConnectionState.waiting');
              return Center(child: Text('ConnectionState.waiting'));
              break;
            case ConnectionState.done:
              print('ConnectionState.done');
                if (snapshot.hsData) {
                  if (snapshot.data.leghth > 0 ) {
                    return buildList(snapshot.data);
                  } else {
                    return Center(child: Text('Tidak ada data'));
                  }
                } else {
                  print('snapshot error');
                  return Center(child: Text('Error'));
                }
                break;
              default:
                print('Undefine Connection');
                return Center(child: Text('Undefine Connection'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgorundcolor: Colors.blue,
        child: Icon(Icon.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddUpdateBalitaPage(type: 'Tambah'),
          ),
        ).then((value)=> setState(() {}))''
      ),
    );
  } 

  Widget buildList(List<Balita> listbalita) {
    return ListView.builder(
      itemCount:listbalita.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        var balita = listbalita[index];
        return Container(
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 10,
            16,
            index == 9 ? 16 : 10,
          ),
          padding: edgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 3),
                blurRadius: 6,
                color: Color.black26,
              ),
            ]),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  '${ApiBalita.URL_FOTO}/${balita.foto}',
                  fit: BoxFit.cover,
                  width: 80,
                  heihgt: 80,
                ),
              ),
              SizedBox(width: 10,
              Expand(
                child: Column(
                  crossAxisAligment: CrossAxisAligment.start,
                  children: [
                    Text(
                      'NIK: ${balita.nik}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.blak45,
                      ),
                    ),
                    Text(
                      'Nama: ${balita.nama}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Alamat: ${balita.alamat}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green[700],
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateBalitaPage(
                            type: 'Edit,
                            balita: balita'
                          ),
                        ),
                      ).then((value => setState(() {})),
                      borderRadius: BorderRadius.circular(5),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Material(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.red[700],
                    child: InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text('Yakin untuk menghapus?'),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Tidak')),
                            FlatButton(
                              onPressed: () =>
                                Navigator.pop(context, 'ok'),
                              child: Text('Ya')),
                          ],
                        )).then((value) {
                      if (value == 'oke') {
                        deleteBalita(balita.nik, balita.foto);
                        getBalita();
                        SetState(() {});
                      }
                    }),
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        Icons.delete_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
}
