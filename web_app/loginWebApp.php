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
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $adminCode = $_POST['adminCode'];
$error='';
  // Validate the admin code against the database
  $sql = "SELECT * FROM admin WHERE code = $adminCode";
  $result = mysqli_query($conn, $sql);

  if (mysqli_num_rows($result) === 1) {
    // Admin code is valid, redirect to the admin dashboard or perform any other actions
    header('Location: data_manager.php');
    exit();
  } else {
    $error = "Invalid admin code. Please try again.";
  }
}
?>
