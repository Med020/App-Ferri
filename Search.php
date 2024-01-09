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

// Perform the search operation in your database or any other data source
$sql = "SELECT designation FROM produit_recherche WHERE designation LIKE '%$searchQuery%'";
$result = $conn->query($sql);

$searchResults = []; // Placeholder for search results

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $searchResults[] = $row['designation'];
    }
}


// Return the search results as JSON
header('Content-Type: application/json');
echo json_encode($searchResults);
?>
