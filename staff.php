<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// For preflight request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { exit; }

$method = $_SERVER['REQUEST_METHOD'];

// GET = list all staff
if ($method === 'GET') {
    $sql = "SELECT id, name, role, phone FROM staff ORDER BY id DESC";
    $result = mysqli_query($conn, $sql);
    $staff = mysqli_fetch_all($result, MYSQLI_ASSOC);
    echo json_encode($staff);
    exit;
}

// POST = add staff
if ($method === 'POST') {

    $data = json_decode(file_get_contents("php://input"), true);

    $name = $data['name'] ?? '';
    $role = $data['role'] ?? '';
    $phone = $data['phone'] ?? '';

    if ($name === '') {
        http_response_code(400);
        echo json_encode(["message" => "Name required"]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO staff (name, role, phone) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $name, $role, $phone);
    $stmt->execute();
    
    echo json_encode(["message" => "Added"]);
    exit;
}

// DELETE = remove staff by id
if ($method === 'DELETE') {

    $urlParts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
    $id = intval(end($urlParts));

    if ($id > 0) {
        $stmt = $conn->prepare("DELETE FROM staff WHERE id=?");
        $stmt->bind_param("i", $id);
        $stmt->execute();
        echo json_encode(["message" => "Deleted"]);
        exit;
    }
}

http_response_code(405);
echo json_encode(["message" => "Method Not Allowed"]);
exit;
?>
