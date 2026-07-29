<?php
session_start();
require_once __DIR__ . '/../db_connect.php';

header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit;

$method = $_SERVER['REQUEST_METHOD'];
$parts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
$id = intval(end($parts));

// GET reservations list
if ($method === 'GET') {
    $sql = "SELECT r.id, r.name, r.phone, r.reserved_date, r.reserved_time,
                   r.guests,
                   t.number AS table_number
            FROM reservations r
            LEFT JOIN dining_tables t ON r.table_id = t.id
            ORDER BY r.reserved_date ASC, r.reserved_time ASC";
    $res = mysqli_query($conn, $sql);
    echo json_encode(mysqli_fetch_all($res, MYSQLI_ASSOC));
    exit;
}

// POST save reservation
if ($method === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $name = $data['name'] ?? '';
    $phone = $data['phone'] ?? '';
    $date = $data['reserved_date'] ?? null;
    $time = $data['reserved_time'] ?? null;
    $table_id = $data['table_id'] ?: null;
    $guests = $data['guests'] ?? 1;

    if ($name === '' || !$date || !$time) {
        http_response_code(400);
        echo json_encode(["message" => "Missing required fields"]);
        exit;
    }

    // Auto-manage customers + visits count
    $customer_id = null;
    if ($phone !== '') {
        $q = $conn->prepare("SELECT id, visits FROM customers WHERE phone=? LIMIT 1");
        $q->bind_param("s", $phone);
        $q->execute();
        $r = $q->get_result();

        if ($r->num_rows > 0) {
            $row = $r->fetch_assoc();
            $customer_id = $row['id'];

            $newVisits = $row['visits'] + 1;
            $upd = $conn->prepare("UPDATE customers SET visits=? WHERE id=?");
            $upd->bind_param("ii", $newVisits, $customer_id);
            $upd->execute();
        } else {
            $ins = $conn->prepare("INSERT INTO customers (name, phone, visits) VALUES (?, ?, 1)");
            $ins->bind_param("ss", $name, $phone);
            $ins->execute();
            $customer_id = $ins->insert_id;
        }
    }

    // INSERT reservation (fixed bind types & placeholder count)
    $stmt = $conn->prepare(
        "INSERT INTO reservations (customer_id, name, phone, reserved_date, reserved_time, table_id, guests)
         VALUES (?, ?, ?, ?, ?, ?, ?)"
    );
    $stmt->bind_param("issssii", $customer_id, $name, $phone, $date, $time, $table_id, $guests);
    $stmt->execute();

    echo json_encode(["message" => "Reservation saved"]);
    exit;
}

// DELETE
if ($method === 'DELETE' && $id > 0) {
    $stmt = $conn->prepare("DELETE FROM reservations WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    echo json_encode(["message"=>"Reservation removed"]);
    exit;
}

http_response_code(405);
echo json_encode(["message"=>"Method not allowed"]);
exit;
?>
