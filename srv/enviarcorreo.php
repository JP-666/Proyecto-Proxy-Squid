<?php
session_start();
if (!isset($_SESSION['admin_user'])) header("Location: index.php");

$resultado = "";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
	$ip_srv = $_POST["ipservidor"];
	$puerto = 42069;
	$json_data = [
		"MAIL" => [
			"PARA"   => $_POST['para'],
			"DE"     => $_POST['de'],
			"ASUNTO" => $_POST['asunto'],
			"CUERPO" => $_POST['cuerpo']
		]
	];
	$paquete = json_encode($json_data) . "\nHASTALAVISTABABY\n"; // El 'Fin' del paquete que he puesto en el servidor. No deberias cambiar esto, romperias la compatibilidad con todos los "servidores".

	$socket = @fsockopen($ip_srv, $puerto, $errno, $errstr, 2);

	if ($socket) {
		fwrite($socket, $paquete);
		fclose($socket);
		$resultado = "Paquete lanzado al servidor. Que Dios reparta suerte.";
	} else {
		$resultado = "Servidor inalcanzable.";
	}

}

?>

<head>
	<style>
		p input, textarea, button {
			background-color: #222;
			color: #0f0;
			border: 1px solid #0f0;
			width: 100%;
		}
		button {
			background-color: #222;
			color: #0f0;
			border: 1px solid #0f0;
			margin-top: 1%; /* Un poco de separacion */
		}
	</style>
	<title>Enviar mensajes de JMAIL</title>
</head>


<body style="background: #000; color: #0f0; padding: 20px; font-family: monospace;">
	<h2>SISTEMA DE ENVÍO J-MAIL</h2>

	<?php if ($resultado): ?>
		<p style="color: yellow;">[SISTEMA]: <?= htmlspecialchars($resultado) ?></p>
	<?php endif; ?>

	<form method="POST">
		<p>PARA (IP) <input type="text" name="ipservidor" required value="127.0.0.1"</input></p>
		<p>PARA (usuario): <input type="text" name="para" required></p>
		<p>DE:   <input type="text" name="de" value="<?= $_SESSION['admin_user'] ?>"></p>
		<p>ASUNTO: <input type="text" name="asunto"></p>
		<p>MENSAJE:
		<textarea name="cuerpo" rows="10"></textarea>
		<br></p> <!-- Para que quede pegado -->
		<button type="submit"> EJECUTAR ENVÍO (HASTALAVISTABABY)</button>
		<br>
		<button onclick="location.href = 'enviarcorreo.php';">Restablecer</button>
		<br>
		<button onclick="location.href = 'index.php';">Volver a la interfaz</button>
	</form>
</body>
