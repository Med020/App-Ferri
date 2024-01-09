<?php
// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Set Content-Type header for JSON response
header('Content-Type: application/json');

// Connect to the database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "espace_client";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve the product code and user ID from the request body
// $data = json_decode(file_get_contents('php://input'), true);

echo "<pre>";
var_dump($_POST);
echo "</pre>";

if (isset($_POST['product_code']) && isset($_POST['user_id'])) {
    $productCode = $_POST['product_code'];
    $userId = $_POST['user_id'];
    $Action = $_POST['action'];
    if($Action == 'add'){
    // Insert the product code and user ID into the favoris table
    $stmt = $conn->prepare('INSERT INTO favoris (code, id_user) VALUES (?, ?)');
    $stmt->bind_param('ss' , $productCode, $userId);

    if ($stmt->execute()) {
        // Return a success message or appropriate response
        echo json_encode(['success' => true]);
    } else {
        // Return an error message or appropriate response
        echo json_encode(['success' => false, 'error' => 'Failed to add the product to favorites: ' . $stmt->error]);
    }
    }
    else if ($Action == 'delete'){
        // Insert the product code and user ID into the favoris table
    $stmt = $conn->prepare('DELETE FROM favoris WHERE code = ? AND id_user = ?');
    $stmt->bind_param('ss' , $productCode, $userId);

    if ($stmt->execute()) {
        // Return a success message or appropriate response
        echo json_encode(['success' => true]);
    } else {
        // Return an error message or appropriate response
        echo json_encode(['success' => false, 'error' => 'Failed to add the product to favorites: ' . $stmt->error]);
    }
    }
    $stmt->close();
} else {
    echo json_encode(['success' => false, 'error' => 'Product code or user ID is missing in the request body']);
}

// Close the database connection
$conn->close();
?>
