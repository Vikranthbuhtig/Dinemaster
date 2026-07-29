<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$method = $_SERVER['REQUEST_METHOD'];
$parts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$action = $parts[count($parts)-1] ?? '';
$id = intval($parts[count($parts)-2] ?? 0);

/************** GET ALL BILLS **************/
if ($method === 'GET') {
    $sql = "SELECT b.*, c.name AS customer_name
            FROM bills b
            LEFT JOIN customers c ON b.customer_id=c.id
            ORDER BY b.id DESC";
    $res = mysqli_query($conn, $sql);
    echo json_encode(mysqli_fetch_all($res, MYSQLI_ASSOC));
    exit;
}

/************** TOGGLE **************/
if ($method === 'POST' && $action === 'toggle' && $id > 0) {
    $body = json_decode(file_get_contents("php://input"), true);
    $status = $body['status'] ?? 'pending';
    $method = $body['payment_method'] ?? null;

    if ($status === 'paid') {
        $stmt = $conn->prepare("UPDATE bills SET paid=1, paid_at=NOW(), payment_method=? WHERE id=?");
        $stmt->bind_param("si", $method, $id);
    } else {
        $stmt = $conn->prepare("UPDATE bills SET paid=0, paid_at=NULL, payment_method=NULL WHERE id=?");
        $stmt->bind_param("i", $id);
    }
    $stmt->execute();
    echo json_encode(["message" => "updated"]);
    exit;
}

http_response_code(405);
echo json_encode(["message"=>"not allowed"]);
exit;
?>
