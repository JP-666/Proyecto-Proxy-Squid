<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FUERA DE MI ROUTER!!!</title>

<!-- Descargamos lo que vendria a ser el clon de comic sans -->

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Comic+Relief:wght@400;700&display=swap" rel="stylesheet">


<style>
body {
background-color: #FFFF33;
font-family: "Comic Relief", system-ui;
color: #8B0000;
margin: 0;
font-style: Italic;
padding: 0 20% 50 20%;
text-align: center;
font-weight: bolder;
}

h1 {
border: 10px double #00FF00;
background-color: #FF00FF;
color: #0000FF;
padding: 20px;
margin-bottom: 50px;
text-shadow: 4px 4px 2px #000000;
font-size: 3em;
}

form {
width: 80%;
max-width: 600px;
margin: 0 auto;
padding: 30px;
background-color: #008080;
border: 7px dashed #FF69B4;
box-shadow: 25px 25px 25px #000000;
}


label {
font-size: 2em;
color: #FFD700;
font-family: 'Courier New', monospace;
margin-bottom: 5px;
font-weight: bold;
}

input[type="text"] {
width: 100%;
padding: 15px;
font-size: 1.2em;
border: 3px solid #FF0000;
background-color: #C0C0C0;
color: #006400;
outline: none;
text-align: right;
border-radius: 0;
transition: all 1.5s;
}

input:focus {
background-color: #FFC0CB;
border-color: #FFA500;
}


button {
width: 100%;
padding: 25px;
background-image: linear-gradient(90deg,rgba(42, 123, 155, 1) 0%, rgba(87, 199, 133, 1) 50%, rgba(237, 221, 83, 1) 100%); /* Esto es un gradiente */
color: #00FF00;
font-size: 2em;
font-weight: 900;
border: none;
cursor: pointer;
text-transform: uppercase;
letter-spacing: 5px;
margin-top: 20px;
transition: all 2s; /* all = todo */
}

button:hover {
background-color: #00FF00;
color: #FF0000;
background-image: url("house.jpg"); /* Pues no podemos transicionar la image, oh bueno. */
box-shadow: 0 0 20px #FF0000;
background-size: 50px;

}
details {
background-color: red;
}
summary {
background-color: white;
transition: font-size 1s;
}
summary:hover {
font-size: 3em;
}
#feoprocesos {
margin: 0 auto;
width: 500px;
background-color: orange;
color: yellow;
}
#construccion {
position: absolute;
background-image: url("cons.gif");
height: 1200px;
padding: 0 0 0 0;
margin-top: 250px;
margin-left: -20%;
width: 100%;
}
.h1_peque {
all: unset;
color: white;
font-size: 2em;
background-color: red;
}
</style>
</head>
<body>

<h1>ADMIN DEL ROUTER!!! ADBERTENCIA:: PELIJRO!!</h1>

<form action="pros_ip.php" method="POST"> <!-- Las palabras de alguien resuenan, "no hace falta poner esto en mayusculas", pero es que se me hace ANTI-NATURAL!! -->
<label for="nuevaip">MI NUEVA IP:::!!!:</label>
<input type="text" id="nuevaip" name="nuevaip" placeholder="1.1.1.1">

<button type="submit">GUARDA MI NUEVA IP!</button>
</form>

<br>

<form action="instala.php" method="POST"> <!-- Las palabras de alguien resuenan, "no hace falta poner esto en mayusculas", pero es que se me hace ANTI-NATURAL!! -->
<label for="paquete">INSLAKA PAKETES!!:!!!:</label>
<input type="text" id="paquete" name="paquete" placeholder="Paquete">

<button type="submit">DALE! MISTE WORLWAID!</button>
</form>

<br>

<form>
<label for="wifin">NOMBRE WIFI (PROXIAMTE!!!):!!!:</label>
<input type="text" disabled id="wifin" name="wifin" placeholder="Mi56K_DEADBEEF">
<label for="wificontra">LA CONTRASSE?A (NO DISPONIVLE)</label>
<input type="text" id="wificontra" name="wificontra" placeholder="JOEBIDEN69">

<button type="submit" disabled>VAMO AL WAIFAI!!</button>

</form>








<?php
$memor = shell_exec('free -m | awk \'/Mem/ {print "Total: " $2 "MB<br>", " Libre: " $4 "MB"}\'');
$upti = shell_exec('uptime');
$ps = shell_exec('ps -aux');
$conn = shell_exec('timeout 1.5 ping -c 1 8.8.8.8 > /dev/null 2>&1 && echo "CONECTADO AL CIBERESPACIO!" || echo "DESCONECTADO! ALERTA HACKEO RUSO!!!"');



echo "<h1>MEMORIA:</h1>";

echo $memor;

echo "<h1>UPTIME:</h1>";

echo $upti;

echo "<h1>PROCESOS:</h1>";

echo "<details> <summary>Lista procesos</summary><div id=\"feoprocesos\">";

echo str_replace("\n","<br>", $ps) . "</div></details>";

echo "<h1>ESTATO DE LA RED:;</h1>";

echo $conn;

?>


<div id="construccion">
<h1 class="h1_peque">Este sitio esta bajo construccion!!!!!!11!!</h1><br>
<h1 class="h1_peque">POR FABOR VUELVE LUEGO"</h1><br>
<h1 class="h1_peque">h1 class="h1_peque"> para ver mas!!</h1><br>
</div>

</body>
</html>
