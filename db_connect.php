<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "dinemaster";

$conn = mysqli_connect($servername, $username, $password, $dbname);

if (!$conn) {
    http_response_code(500);
    die("Database connection failed: " . mysqli_connect_error());
}

?>
