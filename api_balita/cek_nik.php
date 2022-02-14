<?php
include 'connection.php';

$nim = $_POST['nik'];
$sql = "SELECT * from tb_balita WHERE nim='".$nik."'";
$result = $connect->query($sql);

if($result->num_rows > 0) {
    echo json_encode(array("ada"=>true));
} else {
    echo json_encode(array("ada"=>false));
}
