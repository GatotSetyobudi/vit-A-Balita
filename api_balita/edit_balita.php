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

$sql = "UPDATE tb_balita SET nama ='".$nama."',tanggllahir ='".$tanggallahir."', alamat = '".$alamat."',namaayah ='".$namaayah."', namaibu ='".$namaibu."',nomorkontak ='".$nomorkontak."',foto = '".$foto."' WHERE nik = '".$nik."'";
$result = $connect ->query($sql);

if ($result) {
    echo json_encode(array('success'=>true));
} else {
    echo json_encode(array("success"=>false));
}
