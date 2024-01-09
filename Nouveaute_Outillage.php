<?php
// Allow cross-origin requests
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
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

// Fetch Cadre data from the database with favoris = 1
$query = "SELECT files.code, files.titre, files.picture_url, files.file_path
          FROM files 
          JOIN produit_recherche ON files.code = produit_recherche.code
          WHERE produit_recherche.nouveaute = 1
          AND produit_recherche.departement = 'QUINCAILLERIE'
          OR produit_recherche.nouveaute = 1
          AND produit_recherche.departement = 'OUTILLAGE' ";
$result = $conn->query($query);

// Check if there are any rows returned
if ($result->num_rows > 0) {
    // Create an empty array to store the Cadre data
    $cadres = [];

    // Iterate through the result and fetch each Cadre object
    while ($row = $result->fetch_assoc()) {
        // Create a Cadre object and populate it with the retrieved data
        $cadre = [
            'code' => $row['code'],
            'titre' => $row['titre'],
            'picture_url' => $row['picture_url'],
            'file_path' => $row['file_path'],
        ];

        // Add the Cadre object to the array
        $cadres[] = $cadre;
    }

    // Convert the array to JSON for the API response
    $response = json_encode($cadres);

    // Return the JSON response
    echo $response;
} else {
    echo 'No cadres found.';
}

// Close the database connection
$conn->close();
?>
