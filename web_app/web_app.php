<!DOCTYPE html>
<html>
<head>
  <title>Gestion produits</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
    }
    
  .container h2 {
    text-align: center;
    margin-bottom: 20px;
  }
    table {
      border-collapse: collapse;
      width: 100%;
    }
    table, th, td {
      border: 1px solid black;
      padding: 8px;
    }
    th {
      background-color: #f2f2f2;
    }
    form {
      margin-bottom: 20px;
    }
    .form-field {
      margin-bottom: 10px;
    }
    .form-field label {
      display: inline-block;
      width: 150px;
    }
    .form-field input[type="text"],
    .form-field input[type="number"] {
      width: 300px;
    }
    .form-field input[type="submit"] {
      margin-left: 155px;
    }
    .success-message {
      color: green;
      font-weight: bold;
    }
    .error-message {
      color: red;
      font-weight: bold;
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
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script>
    function goToPage(page) {
      window.location.href = page;
    }
$(document).ready(function() {
  // Handle the click event on the edit button
  $(".edit-button").click(function() {
    // Get the product ID from the data attribute
    var productId = $(this).data("id");

    // Open the edit form window (you can replace this with your preferred method)
    window.open("edit_product.php?id=" + productId, "_blank");
  });
});
  </script>
</head>
<body>
<ul class="navbar">
<li><a href="javascript:void(0);" onclick="goToPage('data_manager.php')">Gestion des utilisateurs</a></li>
    <li><a href="javascript:void(0);" onclick="goToPage('web_app.php')">Gestion des produits</a></li>
  </ul>
  <h2>Gestion produits</h2>
  
  <?php
  // Prevent caching
header("Cache-Control: no-cache, must-revalidate");
header("Expires: Sat, 01 Jan 2000 00:00:00 GMT");

// Check if the user is logged in, if not then redirect him to login page
if (isset($_SESSION['admin_logged_in']) && $_SESSION['admin_logged_in'] === true) {
  // User is already logged in, redirect to data_manager.php
  header('Location: web_app.php');
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


  // Function to escape special characters in a string for use in an SQL statement
  function escape($str) {
    global $conn;
    return $conn->real_escape_string($str);
  }

  // Function to get all products from the database
  function getProducts() {
    global $conn;
    $sql = "SELECT * FROM produit_recherche";
    $result = $conn->query($sql);
    $products = [];
    if ($result->num_rows > 0) {
      while ($row = $result->fetch_assoc()) {
        $products[] = $row;
      }
    }
    return $products;
  }

  // Function to add a new product to the database
  function addProduct($code, $designation, $reference, $departement, $pm, $pg, $pd, $creePar) {
    global $conn;
    $code = escape($code);
    $designation = escape($designation);
    $reference = escape($reference);
    $departement = escape($departement);
    $pm = escape($pm);
    $pg = escape($pg);
    $pd = escape($pd);
    $creePar = escape($creePar);

    $sql = "INSERT INTO produit_recherche (code, designation, reference, departement, PM, PG, PD, cree_par)
            VALUES ('$code', '$designation', '$reference', '$departement', '$pm', '$pg', '$pd', '$creePar')";
    if ($conn->query($sql) === TRUE) {
      return true;
    } else {
      return false;
    }
  }

  // Function to remove a product from the database
  function removeProduct($id) {
    global $conn;
    $id = escape($id);
    $sql = "DELETE FROM produit_recherche WHERE id = '$id'";
    if ($conn->query($sql) === TRUE) {
      return true;
    } else {
      return false;
    }
  }


  // Process form submissions
  if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (isset($_POST["add"])) {
      $code = $_POST["code"];
      $designation = $_POST["designation"];
      $reference = $_POST["reference"];
      $departement = $_POST["departement"];
      $pg = $_POST["pg"];
      $pd = $_POST["pd"];
      $creePar = $_POST["cree_par"];
      
      // Calculate the average price
      $pm = ($pg + $pd) / 2;
  
      if (addProduct($code, $designation, $reference, $departement, $pm, $pg, $pd, $creePar)) {
        echo '<p class="success-message">Produit ajouté avec succès.</p>';
      } else {
        echo '<p class="error-message">Erreur d’ajout de produit. Veuillez réessayer.</p>';
      }
    } elseif (isset($_POST["remove"])) {
      $id = $_POST["id"];
  
      if (removeProduct($id)) {
        echo '<p class="success-message">Produit supprimé avec succès.</p>';
      } else {
        echo '<p class="error-message">Erreur de suppression de produit. Veuillez réessayer.</p>';
      }
    } elseif (isset($_POST["update"])) {
      $id = $_POST["id"];
      $code = $_POST["code"];
      $designation = $_POST["designation"];
      $reference = $_POST["reference"];
      $departement = $_POST["departement"];
      $pg = $_POST["pg"];
      $pd = $_POST["pd"];
  
      // Calculate the average price
      $pm = ($pg + $pd) / 2;
  
      if (updateProduct($id, $code, $designation, $reference, $departement, $pm, $pg, $pd)) {
        echo '<p class="success-message">Produit modifié avec succès.</p>';
      } else {
        echo '<p class="error-message">Erreur de modification de produit. Veuillez réessayer.</p>';
      }
    }
  }
?>  

  <table>
    <tr>
      <th>Code</th>
      <th>Désignation</th>
      <th>Référence</th>
      <th>Départment</th>
      <th>PM</th>
      <th>PG</th>
      <th>PD</th>
      <th>Action</th>
    </tr>

    <?php
    // Get all products from the database
    $products = getProducts();

    foreach ($products as $product) {
      echo "<tr>";
      echo "<td>" . $product['code'] . "</td>";
      echo "<td>" . $product['designation'] . "</td>";
      echo "<td>" . $product['reference'] . "</td>";
      echo "<td>" . $product['departement'] . "</td>";
      echo "<td>" . $product['PM'] . "</td>";
      echo "<td>" . $product['PG'] . "</td>";
      echo "<td>" . $product['PD'] . "</td>";
      echo '<td><a href="edit_product.php?id=' . $product['id'] . '">Modifier</a> | 
            <form method="post" style="display: inline-block;">
              <input type="hidden" name="id" value="' . $product['id'] . '">
              <input type="submit" name="remove" value="Supprimer" onclick="return confirm(\'Êtes-vous sûr que vous voulez supprimer ce produit ?\');">
            </form></td>';
      echo "</tr>";
    }
    
    ?>

  </table>

  <h2>Nouveau Produit</h2>
  <form method="post">
    <div class="form-field">
      <label for="code">Code:</label>
      <input type="text" name="code" required>
    </div>
    <div class="form-field">
      <label for="designation">Désignation:</label>
      <input type="text" name="designation" required>
    </div>
    <div class="form-field">
      <label for="reference">Référence:</label>
      <input type="text" name="reference" required>
    </div>
    <div class="form-field">
  <label for="departement">Département:</label>
  <select name="departement" required>
    <option value="PLOMBERIE">PLOMBERIE</option>
    <option value="MAISON">MAISON</option>
    <option value="ELECTRICITE">ELECTRICITE</option>
    <option value="OUTILLAGE">OUTILLAGE</option>
    <option value="SANITAIRE">SANITAIRE</option>
    <option value="QUINCAILLERIE">QUINCAILLERIE</option>
  </select>
</div>
    <div class="form-field">
      <label for="pg">PG:</label>
      <input type="number" name="pg" step="0.01" required>
    </div>
    <div class="form-field">
      <label for="pd">PD:</label>
      <input type="number" name="pd" step="0.01" required>
    </div>
    <div class="form-field">
      <label for="cree_par">Creé par:</label>
      <input type="text" name="cree_par">
    </div>
    <input type="submit" name="add" value="Ajouter produit">
  </form>
</body>
</html>
