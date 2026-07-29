<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$method = $_SERVER['REQUEST_METHOD'];
$parts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$id = intval(end($parts));

// GET all items
if ($method === 'GET' && $parts[count($parts)-1] !== 'menu.php' && $id > 0) {
    $stmt = $conn->prepare("SELECT * FROM menu_items WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    echo json_encode($stmt->get_result()->fetch_assoc());
    exit;
}

if ($method === 'GET') {
    $result = mysqli_query($conn, "SELECT id, name, category, price FROM menu_items WHERE is_active=1 ORDER BY id DESC");
    echo json_encode(mysqli_fetch_all($result, MYSQLI_ASSOC));
    exit;
}

// POST = add item
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    $name = $data['name'] ?? '';
    $cat = $data['category'] ?? 'Main';
    $price = $data['price'] ?? 0;

    if (!$name) {
        http_response_code(400);
        echo json_encode(["message" => "Name required"]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO menu_items (name, category, price) VALUES (?, ?, ?)");
    $stmt->bind_param("ssd", $name, $cat, $price);
    $stmt->execute();

    echo json_encode(["message" => "Added"]);
    exit;
}

// PUT = update item
if ($method === 'PUT' && $id > 0) {
    $data = json_decode(file_get_contents("php://input"), true);
    $name = $data['name'] ?? null;
    $price = $data['price'] ?? null;

    if (!$name || !$price) {
        http_response_code(400);
        echo json_encode(["message" => "Invalid update data"]);
        exit;
    }

    $stmt = $conn->prepare("UPDATE menu_items SET name=?, price=? WHERE id=?");
    $stmt->bind_param("sdi", $name, $price, $id);
    $stmt->execute();

    echo json_encode(["message" => "Updated"]);
    exit;
}

// DELETE = mark inactive
if ($method === 'DELETE' && $id > 0) {
    $stmt = $conn->prepare("UPDATE menu_items SET is_active=0 WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    echo json_encode(["message" => "Deleted"]);
    exit;
}

http_response_code(405);
echo json_encode(["message" => "Method Not Allowed"]);
