<!DOCTYPE html>
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

session_start();

if(isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in']==true){
  header('location:web_app.php');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $adminCode = $_POST['adminCode'];
    $error = '';

    // Validate the admin code against the database
    $sql = "SELECT * FROM admin WHERE code = '$adminCode'";
    $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) === 1) {
        // Admin code is valid, set the session variable
        echo "reach here <br>";
        $_SESSION['admin_logged_in'] = true;
        // Admin code is valid, redirect to the admin dashboard or perform any other actions
        header('Location: web_app.php');
        exit();
    } else {
        $error = "Invalid admin code. Please try again.";
    }
}
?>

<html>
<head>
  <title>Inscription Administrateur</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f1f1f1;
    }
    
    .login-container {
      width: 300px;
      margin: 0 auto;
      margin-top: 100px;
      background-color: #fff;
      padding: 20px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    
    .login-container h2 {
      text-align: center;
    }
    
    .form-group {
      margin-bottom: 20px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
    }
    
    .form-group input {
      width: 90%;
      padding: 10px;
      border-radius: 3px;
      border: 1px solid #ccc;
    }
    
    .form-group .error {
      color: red;
    }
    
    .form-group .success {
      color: green;
    }
    
    .btn {
      display: block;
      width: 100%;
      padding: 10px;
      background-color: #4CAF50;
      color: #fff;
      text-align: center;
      border: none;
      border-radius: 3px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="login-container">
    <h2>Inscription Administrateur</h2>
    <?php if (isset($error) && $error !== '') : ?>
      <div class="form-group error">
        <?php echo $error; ?>
      </div>
    <?php endif; ?>
    <form action="login.php" method="POST">
      <div class="form-group">
        <label for="adminCode">Code Administrateur:</label>
        <input type="text" id="adminCode" name="adminCode" required>
      </div>
      <button type="submit" class="btn">Valider</button>
    </form>
  </div>
</body>
</html>

