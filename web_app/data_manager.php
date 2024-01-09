<!DOCTYPE html>
<html>
  <style>
    body {
    font-family: Arial, sans-serif;
  }

  .container {
    max-width: 1500px;
    margin: 0 auto;
    padding: 20px;
    border: 1px solid #ccc;
    border-radius: 5px;
  }

  .container h2 {
    text-align: center;
    margin-bottom: 20px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  table th,
  table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }

  table th {
    background-color: #f2f2f2;
  }

  .form-group {
    margin-bottom: 15px;
  }

  .form-group label {
    display: block;
    font-weight: bold;
  }

  .form-group input[type="text"],
  .form-group input[type="number"] {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    box-sizing: border-box;
  }

  .form-group button {
    background-color: #4CAF50;
    color: white;
    padding: 10px 15px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  .form-group button:hover {
    background-color: #45a049;
  }

  .success {
    color: green;
  }

  .error {
    color: red;
  }

  .activate-button {
    background-color: #3498db;
  }

  .activate-button:hover {
    background-color: #2980b9;
  }

  .deactivate-button {
    background-color: #e74c3c;
  }

  .deactivate-button:hover {
    background-color: #c0392b;
  }
  /* CSS for navigation bar */
  ul.navbar {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
    background-color: gray;
  }

  ul.navbar li {
    float: left;
  }

  ul.navbar li a {
    display: block;
    color: white;
    text-align: center;
    padding: 14px 16px;
    text-decoration: none;
  }

  ul.navbar li a:hover {
    background-color: black;
  }
  </style>
<script>
    function goToPage(page) {
      window.location.href = page;
    }
  </script>
<head>
  <title>Gestion des utilisateurs</title>
  </head>
<body>
  <div class="container">
  <ul class="navbar">
    <li><a href="javascript:void(0);" onclick="goToPage('data_manager.php')">Gestion des utilisateurs</a></li>
    <li><a href="javascript:void(0);" onclick="goToPage('web_app.php')">Gestion des produits</a></li>
  </ul>
    <h2>Gestion des utilisateurs</h2>
<?php
// Prevent caching
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");




// Check if the user is logged in, if not then redirect him to login page
if (isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in'] === true) {
  // User is already logged in, redirect to data_manager.php
  header('Location: data_manager.php');
  exit();
}
// Connect to the database
$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'espace_client';
$conn = mysqli_connect($db_host, $db_user, $db_password, $db_name);
if (!$conn) {
    die('Could not connect to the database: ' . mysqli_connect_error());
}




      // Handle account activation/deactivation
      if (isset($_GET['action']) && in_array($_GET['action'], array('activate', 'deactivate')) && isset($_GET['id'])) {
        $id = $_GET['id'];
        $status = ($_GET['action'] == 'activate') ? 1 : 0;

        $sql = "UPDATE user SET activer = ? WHERE id = ?";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 'ii', $status, $id);
        if (mysqli_stmt_execute($stmt)) {
          echo '<p class="success">Compte ' . ($_GET['action'] == 'activer' ? 'activé' : 'desactivé') . ' avec succès.</p>';
        } else {
          echo '<p class="error">Error ' . ($_GET['action'] == 'activer' ? 'activation:' : 'desactivation') . ' compte: ' . mysqli_error($conn) . '</p>';
        }
        }
 

    // Remove user
    if (isset($_POST['remove'])) {
      $id = $_POST['remove'];

      $sql = "DELETE FROM user WHERE id = ?";
      $stmt = mysqli_prepare($conn, $sql);
      mysqli_stmt_bind_param($stmt, 'i', $id);
      if (mysqli_stmt_execute($stmt)) {
        echo '<p class="success">L\utilisateur est supprimé.</p>';
      } else {
        echo '<p class="error">Erreur de suppression ' . mysqli_error($conn) . '</p>';
      }
    }
  

  // Fetch user data from the database
  $sql = "SELECT * FROM user";
  $result = mysqli_query($conn, $sql);

  if (mysqli_num_rows($result) > 0) {
    echo '<table>';
    echo '<tr>';
    echo '<th>ID</th>';
    echo '<th>Device ID</th>';
    echo '<th>Code</th>';
    echo '<th>Nom</th>';
    echo '<th>Tel</th>';
    echo '<th>Email</th>';
    echo '<th>Adresse</th>';
    echo '<th>Profil</th>';
    echo '<th>Activer</th>';
    echo '<th>Action</th>';
    echo '</tr>';

    while ($row = mysqli_fetch_assoc($result)) {
      echo '<tr>';
      echo '<td>' . $row['id'] . '</td>';
      echo '<td>' . $row['device_id'] . '</td>';
      echo '<td>' . $row['code'] . '</td>';
      echo '<td>' . $row['nom'] . '</td>';
      echo '<td>' . $row['tel'] . '</td>';
      echo '<td>' . $row['email'] . '</td>';
      echo '<td>' . $row['adresse'] . '</td>';
      echo '<td>' . $row['profil'] . '</td>';
      echo '<td>' . ($row['activer'] == 1 ? 'Activé' : 'Desactivé') . '</td>';
      echo '<td>';
      if ($row['activer'] == 0) {
        echo '<a class="activate-button" href="?action=activate&id=' . $row['id'] . '">Activer</a> ';
      } else {
        echo '<a class="deactivate-button" href="?action=deactivate&id=' . $row['id'] . '">Desactiver</a> ';
    }
    echo '<form method="POST" style="display: inline-block;">
    <input type="hidden" name="remove" value="' . $row['id'] . '">
    <button type="submit">Supprimer</button>
    </form>';
    echo '</td>';
    echo '</tr>';
    }
    
    echo '</table>';
}
 else {
    echo '<p>Aucun utilisateur trouvé.</p>';
  }
  // Close the database connection
  mysqli_close($conn);
?>
 
</form>
</div>
</body>
</html>