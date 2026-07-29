<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$data = json_decode(file_get_contents("php://input"), true);
$order_id = intval($data['order_id'] ?? 0);

if ($order_id <= 0) {
    http_response_code(400);
    echo json_encode(["message"=>"Invalid order"]);
    exit;
}

// Fetch order total
$sql = "SELECT total, customer_id, table_id FROM orders WHERE id=? LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $order_id);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows === 0) {
    http_response_code(404);
    echo json_encode(["message"=>"Order not found"]);
    exit;
}

$order = $res->fetch_assoc();
$total = floatval($order['total']);
$customer_id = $order['customer_id'] ?: NULL;
$table_id = $order['table_id'] ?: NULL;

// Tax + Service charge calculation (C Confirm)
$tax = $total * 0.18;
$service_charge = $total * 0.10;
$final_amount = $total + $tax + $service_charge;

// Insert bill
$stmt2 = $conn->prepare("INSERT INTO bills (order_id, customer_id, amount, tax, service_charge, paid) 
                         VALUES (?, ?, ?, ?, ?, 0)");
$stmt2->bind_param("iiddd", $order_id, $customer_id, $final_amount, $tax, $service_charge);
$stmt2->execute();

// Update order status to closed
$conn->query("UPDATE orders SET status='closed' WHERE id=$order_id");

// Free table
if ($table_id) {
    $conn->query("UPDATE dining_tables SET status='free' WHERE id=$table_id");
}

echo json_encode(["message"=>"Bill generated"]);
exit;
?>
