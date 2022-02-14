<?php
include 'connetion.php';

$nim = $_POST['nik'];

$sql = "DELETE FROM tb_balita WHERE nim ='".$nik."'";
$result = $connect ->query($sql);

if ($resul) {
    echo json_encode(array("succes"=>true));
} else {
    echo json_encode(array("succes"=>false));
}