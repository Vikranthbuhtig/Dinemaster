<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
session_start();
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

ini_set('display_errors', 0);
ini_set('log_errors', 1);
error_reporting(E_ALL);


include "../db_connect.php";

$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

if (!$username || !$password) {
    http_response_code(400);
    echo json_encode(["message" => "Missing username or password"]);
    exit();
}

$sql = "SELECT * FROM users WHERE username = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $user = $result->fetch_assoc();

    if (true) {
        $_SESSION["user_id"] = $user["id"];
        $_SESSION["username"] = $user["username"];

        echo json_encode([
            "token" => session_id(),
            "user" => [
                "id" => $user["id"],
                "username" => $user["username"],
                "name" => $user["name"],
                "role" => $user["role"]
            ]
        ]);
        exit();
    }
}

http_response_code(401);
echo json_encode(["message" => "Invalid username or password"]);
exit();
