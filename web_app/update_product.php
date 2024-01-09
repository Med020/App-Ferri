<?php
// Include the necessary files and establish database connection
$db_host = 'localhost';
$db_user = 'root';
$db_password = '';
$db_name = 'espace_client';
$conn = mysqli_connect($db_host, $db_user, $db_password, $db_name);
if (!$conn) {
    die('Could not connect to the database: ' . mysqli_connect_error());
}


  // Function to update product information in the database
  function updateProduct($id, $code, $designation, $reference, $departement, $pm, $pg, $pd) {
    global $conn;
    

    $sql = "UPDATE produit_recherche
            SET code = '$code', designation = '$designation', reference = '$reference',
                departement = '$departement', PM = '$pm', PG = '$pg', PD = '$pd'
            WHERE id = '$id'";
    if ($conn->query($sql) === TRUE) {
      return true;
    } else {
      return false;
    }
  }
// Process form submission
if ($_SERVER["REQUEST_METHOD"] === "POST" && isset($_POST["update"])) {
  $id = $_POST["id"];
  $code = $_POST["code"];
  $designation = $_POST["designation"];
  $reference = $_POST["reference"];
  $departement = $_POST["departement"];
  $pm = $_POST["PM"];
  $pg = $_POST["PG"];
  $pd = $_POST["PD"];

  if (updateProduct($id, $code, $designation, $reference, $departement, $pm, $pg, $pd)) {
    // Product updated successfully
    header("Location: web_app.php");
    exit();
  } else {
    // Error updating product
    echo '<p class="error-message">Error updating product. Please try again.</p>';
  }
}
?>
