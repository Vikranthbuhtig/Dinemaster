<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$method = $_SERVER['REQUEST_METHOD'];
$urlParts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$id = intval(end($urlParts));

// GET: fetch all customers
if ($method === 'GET') {
    $q = "SELECT id, name, phone, visits FROM customers ORDER BY id DESC";
    $result = mysqli_query($conn, $q);
    echo json_encode(mysqli_fetch_all($result, MYSQLI_ASSOC));
    exit;
}

// POST: add a customer (visits start at 1)
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    $name = $data['name'] ?? '';
    $phone = $data['phone'] ?? '';

    if ($name === '') {
        http_response_code(400);
        echo json_encode(["message" => "Name required"]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO customers (name, phone, visits) VALUES (?, ?, 1)");
    $stmt->bind_param("ss", $name, $phone);
    $stmt->execute();

    echo json_encode(["message" => "Added"]);
    exit;
}

// DELETE: remove customer by id
if ($method === 'DELETE' && $id > 0) {
    $stmt = $conn->prepare("DELETE FROM customers WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    echo json_encode(["message" => "Deleted"]);
    exit;
}

http_response_code(405);
echo json_encode(["message" => "Method Not Allowed"]);
exit;
?>
