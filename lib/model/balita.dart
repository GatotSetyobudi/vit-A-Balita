class Balita {
  String nik;
  String nama;
  String tanggallahir;
  String alamat;
  String namaayah;
  String namaibu;
  String nomorkontak;
  String foto;

  Balita({
    this.nik;
    this.nama;
    this.tanggallahir;
    this.alamat;
    this.namaayah;
    this.namaibu;
    this.nomorkontak;
    this.foto;
  });

  factory Balita.fromJson(Map<String, dynamic> json) => Balita(
        nik: json['nik'],
        nama: json['nama'],
        tanggallahir: json['tanggallahir'],
        alamat: json['alamat'],
        namaayah: json['namaayah'],
        namaibu: json['namaibu'],
        nomorkontak: json['nomorkontak'],
        foto: json['foto'],
      );
  Map<String, dynamic> toJson () => {
    'nik': nik,
    'nama': nama,
    'tanggallahir': tanggallahir,
    'alamat': alamat,
    'namaayah': namaayah,
    'namaibu': namaibu,
    'nomorkontak': nomorkontak,
    'foto': foto,
  };

}
