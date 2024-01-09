<?php
$imagePath = 'C:\xampp\htdocs\app_ferri\images\Fiche-aliment-Images-11-700x700.png'; // Provide the path to your image file

// Read the image file
$imageData = file_get_contents($imagePath);

// Encode the image data as base64
$base64Image = base64_encode($imageData);

// Output the encoded image data
echo $base64Image;
?>
