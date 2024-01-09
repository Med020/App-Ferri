<?php
$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'espace_client';
$conn = mysqli_connect($db_host, $db_user, $db_password, $db_name);
if (!$conn) {
    die('Could not connect to the database: ' . mysqli_connect_error());
}

// Retrieve existing code and activation status from the database
$sql = "SELECT code, profil FROM user";
$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$existing_codes = array();
$activation_statuses = array();
while ($row = mysqli_fetch_assoc($result)) {
    $existing_codes[] = $row['code'];
    $activation_statuses[] = $row['profil'];
}

// Check if the entered code exists in the database
if (in_array($_POST['code'], $existing_codes)) {
    $index = array_search($_POST['code'], $existing_codes);
    if ($activation_statuses[$index] == 'client') {
        // Account is activated
        $presponse['client'] = true;
        $presponse['message'] = 'Authentification réussie.';
    } elseif($activation_statuses[$index] == 'commercial') {
        // Account is not activated yet
        $presponse['commercial'] = true;
        $presponse['message'] = 'Compte en cours d\'activation';
    } elseif ($activation_statuses[$index] == 'gerant'){
    // Login failed, invalid code
    $presponse['gerant'] = false;
    $presponse['message'] = 'Code invalide !';
}
}

// Return the JSON response
header('Content-Type: application/json');
echo json_encode($presponse);
 // Close the database connection
 mysqli_close($conn);
?>
