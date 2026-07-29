<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$method = $_SERVER['REQUEST_METHOD'];

// GET all orders with items
if ($method === 'GET') {
    $sql = "SELECT o.id, o.total, o.status,
                   o.customer_id, o.table_id,
                   c.name AS customer_name,
                   t.number AS table_number
            FROM orders o
            LEFT JOIN customers c ON o.customer_id = c.id
            LEFT JOIN dining_tables t ON o.table_id = t.id
            ORDER BY o.id DESC";
    $res = mysqli_query($conn, $sql);
    $orders = mysqli_fetch_all($res, MYSQLI_ASSOC);

    foreach ($orders as &$o) {
        $oid = intval($o['id']);
        $sql2 = "SELECT m.name, oi.qty, oi.unit_price
                 FROM order_items oi
                 JOIN menu_items m ON oi.menu_item_id = m.id
                 WHERE oi.order_id = $oid";
        $r2 = mysqli_query($conn, $sql2);
        $items = mysqli_fetch_all($r2, MYSQLI_ASSOC);
        $o['items'] = $items ?: [];
    }

    // Convert numeric strings to numbers for JS
    array_walk_recursive($orders, function (&$v) {
        if (is_numeric($v)) $v = $v + 0;
    });

    echo json_encode($orders);
    exit;
}

// POST : Create order
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $customer_id = $data['customer_id'] ?: NULL;
    $table_id = $data['table_id'] ?: NULL;
    $items = $data['items'] ?? [];

    if (empty($items)) {
        http_response_code(400);
        echo json_encode(["message" => "Cart is empty"]);
        exit;
    }

    $status = "pending";
    $total = 0;

    // Insert order header
    $stmt = $conn->prepare("INSERT INTO orders (customer_id, table_id, status, total) VALUES (?, ?, ?, 0)");
    $stmt->bind_param("iis", $customer_id, $table_id, $status);
    $stmt->execute();
    $order_id = $stmt->insert_id;

    // Insert items with real prices
    $qry = $conn->prepare("SELECT price FROM menu_items WHERE id=?");

    foreach ($items as $it) {
        $menu_item_id = $it['menu_item_id'];
        $qty = $it['qty'];

        $qry->bind_param("i", $menu_item_id);
        $qry->execute();
        $res = $qry->get_result();
        $price = ($res->num_rows ? $res->fetch_assoc()['price'] : 0);

        $line = $price * $qty;
        $total += $line;

        $stmt2 = $conn->prepare(
            "INSERT INTO order_items (order_id, menu_item_id, qty, unit_price) 
             VALUES (?, ?, ?, ?)"
        );
        $stmt2->bind_param("iiid", $order_id, $menu_item_id, $qty, $price);
        $stmt2->execute();
    }

    // Update final total
    $upd = $conn->prepare("UPDATE orders SET total=? WHERE id=?");
    $upd->bind_param("di", $total, $order_id);
    $upd->execute();

    echo json_encode(["message" => "Order placed"]);
    exit;
}

http_response_code(405);
echo json_encode(["message" => "Method not allowed"]);
exit;
?>
