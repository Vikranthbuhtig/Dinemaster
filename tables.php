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

// GET all tables
if ($method === 'GET') {
    $result = mysqli_query($conn, "SELECT id, number, seats, status FROM dining_tables ORDER BY number ASC");
    echo json_encode(mysqli_fetch_all($result, MYSQLI_ASSOC));
    exit;
}

// POST = insert or update based on table number uniqueness
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $number = $data['number'] ?? null;
    $seats = $data['seats'] ?? 2;
    $status = $data['status'] ?? 'free';

    if (!$number) {
        http_response_code(400);
        echo json_encode(["message" => "Table number required"]);
        exit;
    }

    // Check if table exists
    $check = $conn->prepare("SELECT id FROM dining_tables WHERE number=?");
    $check->bind_param("i", $number);
    $check->execute();
    $exists = $check->get_result()->num_rows > 0;

    if ($exists) {
        $stmt = $conn->prepare("UPDATE dining_tables SET seats=?, status=? WHERE number=?");
        $stmt->bind_param("isi", $seats, $status, $number);
        $stmt->execute();
        echo json_encode(["message" => "Updated"]);
    } else {
        $stmt = $conn->prepare("INSERT INTO dining_tables (number, seats, status) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $number, $seats, $status);
        $stmt->execute();
        echo json_encode(["message" => "Added"]);
    }
    exit;
}

// DELETE by table id
if ($method === 'DELETE' && $id > 0) {
    $stmt = $conn->prepare("DELETE FROM dining_tables WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    echo json_encode(["message" => "Deleted"]);
    exit;
}

http_response_code(405);
echo json_encode(["message" => "Method Not Allowed"]);
exit;
?>
