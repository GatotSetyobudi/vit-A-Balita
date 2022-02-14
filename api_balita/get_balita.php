<?php
include 'connection.php';
$sql = "SELECT * from tb_balita";
$result = $connet ->query($sql);
if($result->num_rows >0) {
    $data = array();
    while ($getData = $result ->fetch_assoc()) {
        $data[] = $getData;
    }
    echo json_encode(array(
        "succes"=>true,
        "data"=>$data,
    ));
} else {
    echo json_encode(array(
        "succes"=>false,
        "data"=>[],
    ));
}