<?php
// correct path to the DB connection file
require_once __DIR__ . '/../db_connect.php';

$newPassword = "vikranthsql";
$hash = password_hash($newPassword, PASSWORD_BCRYPT);

// Ensure $conn exists before query
if (!isset($conn)) {
    die("Database connection failed");
}

$sql = "UPDATE users SET password_hash='$hash' WHERE username='vikranth'";
if ($conn->query($sql)) {
    echo "Password updated successfully!";
} else {
    echo "Error: " . $conn->error;
}
