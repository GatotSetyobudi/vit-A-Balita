<?php
include 'connection.php';

$nik = $_POST['nik'];
$nama = $_POST['nama'];
$tanggallahir = $_POST['tanggallahir'];
$alamat = $_POST['alamat'];
$namaayah= $_POST['namaayah'];
$namaibu = $_POST['namaibu'];
$nomorkontak = $_POST['nomorkontak'];
$foto = $_POST['foto'];

$sql = "INSERT INTO tb_balita (nik,nama,tanggallahir,alamat,namaayah, namaibu,nomorkontak,foto) VALUES ('".$nik."','".$nama."','".$tanggal_lahir."','".$alamat."','".$nama_ayah."', '".$nama_ibu."','".$nomor_kontak."','".$foto."')";
$result = $connect ->query($sql);

if ($result) {
    echo json_encode(array('success'=>true));
} else {
    echo json_encode(array("success"=>false));
}
