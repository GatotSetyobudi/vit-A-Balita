import 'dart:convert';
import 'dart:io';

import 'package:vit_balita/api_balita.dart';
import 'package:vit_balita/model/balita.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddUpdateBalita extends StatefulWidget {
  final String type;
  final Balita balita;

  AddUpdateBalita({this.type, this.balita});
  @override
  _AddUpdateBalitaPageState createState() => _AddUpdateBalitaPageState();
}

class _AddUpdateBalitaPageState extends State<AddUpdateBalitaPage> {
  var _controllerNik = TextEditingController();
  var _controllerNama = TextEditingController();
  var _controllerTanggallahir = TextEditingController();
  var _controllerAlamat = TextEditingController();
  var _controllerNamaayah = TextEditingController();
  var _controllerNAmaibu = TextEditingController();
  var _controllerNomorkontak = TextEditingController();
  // var _controllerFoto = TextEditingController();
  File _foto;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<scaffoldState>();
  var _fotoSebelumUpdate;

  Future getFoto() async {
    final pickedFile =
      await ImagePicker().getImage(source: ImageSource.gallery);
    
    setState(() {
      if (pickedFile != null) {
        _foto = File(pickedFile.path);
      }else{
        print('No image selected.');
      }
    });
  }
  void editBalita(Balita balita) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: Colors.white,
        children: [
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Center(child: Text('Loading...')),
        ],
      ),
    );
    Future.dekayed(Duration(milliseconds: 1000),() {
      Navigator.pop(context);
    });

    if (_foto != null) {
      await http.post(ApiBalita.URL_DELETE_FOTO, body: {
        'nama': _fotoSebelumUpdate,
      });
      await http.post(ApiBalita.URL_UPLOAD_FOTO, body: {
        'foto': base64Encode(_foto.readAsBytsSync()),
        'nama': balita.foto,
      });
    }
    var response = await http.post(ApiBalita.URL_EDIT_BALITA,
      body: balita.toJason());
    if (response.statusCode == 200) {
      var responseBody = jason.decode(response.body);
      var message = '';
      if (responseBody['succes']) {
        message = 'Berhasil Mengupdate Balita';
      }else {
        message = "Gagal Mengupdate Balita";
      }
      scaffoldKey.currentState.showSnackbar(
        content: Text(message),
        duration: Duration(millisecaond: 1500),
        behavior: SnackBarBehavior.floating,
      ));
    }else {
      print("Request Error");
    }
  }
  void addBalita(Balita balita) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: Colors.white,
        children: [
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 10),
          Center(child: Text('Loading..')),
        ],
      ),
    );
    Future.delayes.(Duration(milliseconds: 1000), () {
      Navigator.pop(context);
    });
    var responseNik = await http.post(ApiBalita.URL_CHECK_NIK, body: {
      'nik': balita.nik,
    });
    var check = jsonDecode(responseNik.body);
    if (check['ada']) {
      _scaffoldKey.currentState.showSnackBar(
        content: Text('NIK Sudah Terdaftar'),
        duration: Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[700],
      )),
    } else {
      await http.post(ApiBalita.URL_UPLOAD_FOTO, body: {
        'foto': base64Encode(_foto.readyAsBytesSync()),
        'nama': balita.foto,
      });
      var response = await http.post(ApiBalita.URL_ADD_BALITA, 
        body: balita.toJason());
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var message = '';
        if (responseBody['succes']) {
          message = 'Berhasil Menambahkan Balita';
        } else {
          message = 'Gagal menambahkan Balita';
        }
        _scaffoldKey.currentState.showSnackbar(
          content: Text(message),
          duration: Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
        ));
      } else {
        print('Request Error');
      }
    }
  }

  @override
  void initState() {
    if (widget.balita != null) {
      _controllerNik.text = widget.balita.nik;
      _controllerNama.text = widget.balita.nama;
      _controllerTanggal_lahir.text = widget.balita.tanggal_lahir;
      _controllerAlamat.text = widget.balita.alamat;
      _controllerNama_ayah.text = widget.balita.nama_ayah;
      _controllerNAma_ibu.text = widget.balita.nama_ibu;
      _controllerNomor_kontak.text = widget.balita.nomor_kontak;
      _fotoSebelumUpdate = widget.balita.foto;
    }
    super.initState();
  }
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('${widget.type} Balita'),
        titleSpacing: 0,
        actions: [
          IconButton(
            Icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text('Konfirmasi ${widget.type} Balita')

                    actions: [
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Tidak')),
                        FlatButton(
                          onPressed: () => Navigator.pop(context, 'Ok'),
                          child: Text('Ya')),
                    ],
                  )).then ((value) {
              if (value == 'ok') {
                nik: _controllerNik.text,
                nama: _controllerNama.text,
                tanggal_lahir: _controllerTanggal_lahir.text,
                alamat: _controllerAlamat.text,
                nama_ayah: _controllerNama_ayah.text,
                nama_ibu: _controllerNama_ibu.text,
                nomor_kontak: _controllerNomor_kontak.text,
                foto: _foto != null
                    ? _foto.path.split('/').last
                    : _fotoSebelumUpdate,
              );
              if (widget.type == "Edit") {
                editBalita(balita);
              } else {
                addBalita(balita);
              }
            }
          });
        }
      },
    ),
  ],
),
body: Form(
  key: _formKey,
  child: ListView(
    padding: EdgeInsets.symetrics(horizontal: 16),
    children: [
      SizedBox(height: 16),
      TextFormField(
        controller: _controllerNik,
        enabled: widget.balita != null ? false : true,
        validator: (value) => value.isEmpty ? 'Tidak boleh kosong' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding:
            EdgeInsets.symmetric(horizontal: 20, vertikal: 2),
          enabledBorder: OutLineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          focusBorder: PutLineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          labelText: 'NIK',
          hintText: '1234',
          labelStyle: TextStyle(color: Colors.blue),
          suffixIcon: Icon(Icons.vpn_key_rounded, color: Colors.blue),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerNama,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Nama',
            hintText: 'Daffa',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: Icon(Icons.person, color: Color.blue),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerTanggal_lahir,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Tanggal Lahir',
            hintText: '2020-01-05',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: GesturDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 50, 1),
                  lastDate: DateTime(DateTime.now().year, 12))
                .then((value {
              _controllerTanggal_lahir.text =
                  value.toIso8601String().substring(0, 10);
                });
              },
              child: Icon(Icons.date_range, color: Colors.blue)),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerAlamat,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Alamat',
            hintText: 'Indihiang',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: Icon(Icons.home, color: Color.blue),
          ),
          maxLines: 3,
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerNama_ayah,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Nama Ayah',
            hintText: 'Asep',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: Icon(Icons.person, color: Color.blue),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerNama_ibu,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Nama Ibu',
            hintText: 'Iis',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: Icon(Icons.person, color: Color.blue),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _controllerNomor_kontak,
          validator: (value) =>.isEmpty ? 'Tidak boleh kosong' : null,
          decoration: InputDecoration(
            border: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            enabledBorder: OutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            focusedBorder: PutLineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: 'Nomor Kontak',
            hintText: '08123456789',
            labelStyle: TextStyle(color: Colors.blue),
            suffixIcon: Icon(Icons.telephone, color: Color.blue),
          ),
          cursorColor: Colors.blue,
        ),
        SizedBox(height: 16),
        Text('Foto'),
        SizedBox(height: 16),
        RaisedButton(
          onPressed: () => getFoto(),
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Pilih Foto'),
        ),
        SizedBox(height: 16),
        Center(
          child: SizedBox(
            child: widget.type == "Edit"
            ? _foto != null
                ? Image.file(_foto
                _foto,
                width: 150,
                height: 150,
              )
            : Image.network(
              '${ApiBalita.URL_FOTO}/${widget.balita.foto}',
              fit: BoxFit.cover,
              width: 150,
              height: 150,
            )
        : _foto == null
            ? null
            : Image.file(
              _foto,
              width: 150,
              height: 150,
            ),
          ),
        ),
      ],
    ),
  ),
);
}
}
