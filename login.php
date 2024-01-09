<?php
$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'espace_client';
$conn = mysqli_connect($db_host, $db_user, $db_password, $db_name);
if (!$conn) {
    die('Could not connect to the database: ' . mysqli_connect_error());
}

// Retrieve existing code, activation status, and user ID from the database
$sql = "SELECT id, code, activer FROM user";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$existing_codes = array();
$activation_statuses = array();
$user_ids = array();
while ($row = mysqli_fetch_assoc($result)) {
    $existing_codes[] = $row['code'];
    $activation_statuses[] = $row['activer'];
    $user_ids[] = $row['id'];
}

// Check if the entered code exists in the database
if (in_array($_POST['code'], $existing_codes)) {
    $index = array_search($_POST['code'], $existing_codes);
    if ($activation_statuses[$index] == 1) {
        // Account is activated
        $response['success'] = true;
        $response['message'] = 'Authentification réussie.';
        
        // Retrieve profile value from the database
        $sql = "SELECT profil FROM user WHERE code = ?";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 's', $_POST['code']);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);
        $row = mysqli_fetch_assoc($result);
        
        // Set profile value in the response
        $response['profil'] = $row['profil'];
        
        // Set user ID in the response
        $response['id'] = $user_ids[$index];
    } else {
        // Account is not activated yet
        $response['success'] = false;
        $response['message'] = 'Compte en cours d\'activation';
    }
} else {
    // Login failed, invalid code
    $response['success'] = false;
    $response['message'] = 'Code invalide !';
}

// Return the JSON response
header('Content-Type: application/json');
echo json_encode($response);

// Close the database connection
mysqli_close($conn);
?>
