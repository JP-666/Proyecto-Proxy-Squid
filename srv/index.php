<?php
// Toda la logica del "login"

	session_start();

	$conn = new mysqli('127.0.0.1', 'urouter', 'controuter', 'router');

	if (isset($_GET['action']) && $_GET['action'] == 'logout') {
		session_destroy();
		header("Location: " . $_SERVER['PHP_SELF']);
		exit;
	}

	$error = "";
	if ($_SERVER["REQUEST_METHOD"] == "POST") {
		$u = $_POST['username'];
		$p = $_POST['password'];

		$stmt = $conn->prepare("SELECT contrahash FROM datoslogin WHERE usuario = ?");
		$stmt->bind_param("s", $u);
		$stmt->execute();
		$result = $stmt->get_result();

		if ($row = $result->fetch_assoc()) {
			if (password_verify($p, $row['contrahash'])) {
				$_SESSION['admin_user'] = $u;
			} else {
				$error = "Contraseña incorrecta!";
				}
			} else {
				$error = "No existe el usuario";
		}
	}

// Abajo esta el "Nuevo" HTML (Mas """profesional""")
?>

<!DOCTYPE html>
<html>
	<head>
		<title>Página del router</title>
			<style>
				body {
					max-width: 30%;
					margin: 0 auto;
				}
				table, td, tr, th {
					width: 100%;
					border: 3px solid black;
					border-collapse: collapse;
					table-layout: fixed;
					text-align: center;
				}
			</style>
		</head>
	<body>

<!-- Esto es la pagina "dentro" del router -->

		<?php if (isset($_SESSION['admin_user'])): ?> 
			<h1>Bienvenido a la página del router.</h1>
			<p>Te has logueado correctamente, <strong><?php echo htmlspecialchars($_SESSION['admin_user']); ?></strong></p>
			<hr>
			<a href="?action=logout">Salir ahora</a>
			<hr>
			<br>

<!-- "Descargar el certificado" -->

			<?php include 'comun.php'; ?>
			<br>
<!-- Lo antiguo (Memoria, IP, uptime, etc." -->


			<br>
			<table>
				<tr>
					<th>IP</th>
					<th>Uptime</th>
					<th>Memoria</th>
				</tr>
				<tr>
					<td><?php echo str_replace("\n","<br>",shell_exec('ip -4 addr | grep -oP \'(?<=inet\s)\d+(\.\d+){3}\'')); ?></td> <!-- No, enserio, me he copiado de esto de internet?!?! -->
					<td><?php echo str_replace("\n","<br>",shell_exec('uptime')); ?></td> 
					<td><?php echo shell_exec('free -m | awk \'/Mem/ {print "Total: " $2 "MB<br>", " Libre: " $4 "MB"}\''); ?> </td>
				</tr>

			</table>


<!-- El resto de cosas que "puede hacer el admin" -->

			<h1> Cambiar contraseñas o crear usuarios RADIUS (SQL) </h1>
			<form action="cambiar.php" method="POST">
			<fieldset>
			<label for="usuariobaserad">Usuario</label>
			<input type="text" id="usuariobaserad" name="usuariobaserad">
			</br>
			<label for="contbaserad">Contraseña</label>
			<input type="text" id="contbaserad" name="contbaserad">
			</br>
			<input type="submit" value="OK">
			</fieldset>
			</form>






		<?php else: ?> <!-- Ni puta idea de como funciona esto, pero funciona (!!!!) -->
			<h2>Logueate.</h2>
			<?php if($error) echo "<p style='color:red'>Hay un error: $error</p>"; ?> <!-- Si fallamos -->
			<form method="POST">
			<input type="text" name="username" placeholder="Admin?" required>
			<input type="password" name="password" placeholder="Contraseña?" required>
			<button type="submit">Login</button>
			</form>
			<br>
			<?php include 'comun.php'; ?>
		<?php endif; ?>
	</body>
</html>
