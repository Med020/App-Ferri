<?php
// Retrieve the product ID from the URL parameter
if (!isset($_GET['id'])) {
  // Redirect or display an error message if the ID is not provided
  header("Location: error.php");
  exit();
}

$productId = $_GET['id'];

// Connect to the database (replace with your own database credentials)
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "espace_client";

try {
  $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
  $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

  // Prepare and execute the SQL query to fetch the product details
  $stmt = $conn->prepare("SELECT * FROM produit_recherche WHERE id = :id");
  $stmt->bindParam(':id', $productId);
  $stmt->execute();

  // Fetch the product details as an associative array
  $product = $stmt->fetch(PDO::FETCH_ASSOC);

} catch(PDOException $e) {
  // Handle database connection or query errors
  echo "Error: " . $e->getMessage();
  exit();
}

  
  ?>
  

<!DOCTYPE html>
<html>
<head>
  <title>Edit Product</title>
  <style>
body {
  font-family: Arial, sans-serif;
  background-color: #f1f1f1;
  padding: 20px;
}

h1 {
  color: #333;
}

form {
  background-color: #fff;
  padding: 20px;
  border-radius: 5px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

label {
  display: inline-block;
  width: 120px;
  font-weight: bold;
  margin-bottom: 10px;
}

input[type="text"],
input[type="number"] {
  width: 300px;
  padding: 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
}

input[type="submit"] {
  background-color: #4CAF50;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 10px;
}

input[type="submit"]:hover {
  background-color: #45a049;
}

input[type="submit"]:focus {
  outline: none;
}

.error-message {
  color: #ff0000;
  font-weight: bold;
}

.success-message {
  color: #008000;
  font-weight: bold;
}
  </style>
</head>
<body>
  <h1>Modifier produit</h1>
  <form method="post" action="update_product.php">
    <input type="hidden" name="id" value="<?php echo $productId; ?>">
    <label for="code">Code:</label>
    <input type="text" name="code" value="<?php echo $product['code']; ?>" required>
    <br>
    <label for="designation">Désignation:</label>
    <input type="text" name="designation" value="<?php echo $product['designation']; ?>" required>
    <br>
    <label for="reference">Référence:</label>
    <input type="text" name="reference" value="<?php echo $product['reference']; ?>" required>
    <br>
  <label for="departement">Département:</label>
  <select name="departement" required>
    <option value="PLOMBERIE">PLOMBERIE</option>
    <option value="MAISON">MAISON</option>
    <option value="ELECTRICITE">ELECTRICITE</option>
    <option value="OUTILLAGE">OUTILLAGE</option>
    <option value="SANITAIRE">SANITAIRE</option>
    <option value="QUINCAILLERIE">QUINCAILLERIE</option>
  </select>
    <br>
    <label for="PM">PM (Prix Moyen):</label>
    <input type="number" step="0.01" name="PM" value="<?php echo $product['PM']; ?>" required>
    <br>
    <label for="PG">PG (Prix de Gros):</label>
    <input type="number" step="0.01" name="PG" value="<?php echo $product['PG']; ?>" required>
    <br>
    <label for="PD">PD (Prix d'Unité):</label>
    <input type="number" step="0.01" name="PD" value="<?php echo $product['PD']; ?>" required>
    <br>
    <input type="submit" name="update" value="Modifier">
  </form>
</body>
</html>
