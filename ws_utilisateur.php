<?php
// Connect to the database
$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'espace_client';
$conn = mysqli_connect($db_host, $db_user, $db_password, $db_name);
if (!$conn) {
    die('Could not connect to the database: ' . mysqli_connect_error());
}

// Check if the form was submitted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Parse the form data from the HTTP request
    if (isset($_POST['code'])) {
        $code = $_POST['code'];
    } else {
        $code = '';
    }
    $nom = $_POST['nom'] ?? '';
    $tel = $_POST['tel'] ?? '';
    $email = $_POST['email'] ?? '';
    $adresse = $_POST['adresse'] ?? '';

    // Retrieve existing device id from the database
    $sql = "SELECT device_id FROM user";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    // Store existing codes in an array
    $existing_codes = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $existing_codes[] = $row['device_id'];
    }

    // Check if the entered device_id already exists in the database
    if (in_array($_POST['device_id'], $existing_codes)) {
        $response['success'] = false;
        $response['message'] = 'L’ID de l\'appareil existe déjà';
    } else {
        // Save the form data to the database
        $sql = "INSERT INTO user (code, nom, tel, email, adresse, device_id, activer) VALUES (?, ?, ?, ?, ?, ?, 0)";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 'ssssss', $code, $nom, $tel, $email, $adresse, $_POST['device_id']);
        if (mysqli_stmt_execute($stmt)) {
          $response['success'] = true;
          $response['message'] = 'Inscription avec succès';
           
        } else {
          $response['success'] = false;
          $response['message'] = 'Erreur: ' . mysqli_error($conn);
          
        }
    }
}

// Return the JSON response
header('Content-Type: application/json');
echo json_encode($response);

 // Close the database connection
 mysqli_close($conn);
?>