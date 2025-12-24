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

?>

<!DOCTYPE html>
<html>
	<head>
		<title>Página del router</title>
			<style>
				body {
					max-width: 90%;
					margin: 0 auto;
					padding: 25px;
				}
				table, td, tr, th {
					width: 100%;
					table-layout: fixed;
					text-align: center;
				}
				th {
					background-color: #1a73e8;
					color: white;
				}
				td {
					background-color: #fafafa;
				}
				table {
					font-size: 2em;
					margin: 25px 0px;
				}
				form {
					padding: 25px;
				}
				fieldset {
					border: 2px solid black;
					border-radius: 25px;
					background-color: #fafafa;
				}
				legend {
					font-size: 2em;
					color: #1a73e8;
				}
				input[type="text"], input[type="password"] {
					margin: 15px;
					width: 90%;
					font-size: 2em;
				}
				label {
					margin: 25px;
					color: #383630;
					font-weight: bold;
					font-size: 2em;
				}
				input[type="submit"] {
					background-color: #1a73e8;
					font-size: 2em;
					color: white;
					border: none;
					margin: 25px 15px;
					padding: 12px 24px;
					border-radius: 6px;
					cursor: pointer;
					font-weight: bold;
					transition: background-color 0.2s;
				}	
				input[type="submit"]:hover {
					background-color: #1557b0;
				}
				input[type="checkbox"] {
					width: 2em;
					height: 2em;
					margin: 0px 0px 0px 25px;
				}
				h1 {
					color: #1a73e8;
					font-size: 3em;
				}
				.partelogin {
					margin: 10%;
					border: 5px solid black;
					border-radius: 25px;
				}
				.partelogin button {
					background-color: #1a73e8;
					font-size: 2em;
					color: white;
					border: none;
					margin: 25px 15px;
					padding: 12px 24px;
					border-radius: 6px;
					cursor: pointer;
					font-weight: bold;
					transition: background-color 0.2s;
				}
				p {
					font-size: 2em;
				}
				p button {
					background-color: #1a73e8;
					font-size: 1em;
					color: white;
					border: none;
					margin: 0px 0px 0px 40%;
					padding: 12px 24px;
					border-radius: 6px;
					cursor: pointer;
					font-weight: bold;
					transition: background-color 0.2s;
				}
			</style>
		</head>
	<body>


		<?php if (isset($_SESSION['admin_user'])): ?>
			<h1>Admin. del router</h1>
			<hr>
			<p>Te has logueado correctamente como <strong><?php echo htmlspecialchars($_SESSION['admin_user']); ?>  </strong><button onclick="location.href = '?action=logout';">Salir ahora</button></p> <!-- Feo pero funciona! -->
			<hr>


			<?php include 'comun.php'; ?>
<!-- Lo antiguo (Memoria, IP, uptime, etc.) -->

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

			<form action="cambiar.php" method="POST">
				<fieldset>
					<legend>Cambiar contraseñas o crear usuarios RADIUS (SQL)</legend>
					<label for="usuariobaserad">Usuario</label>
					<br>
					<input type="text" id="usuariobaserad" name="usuariobaserad">
					<br>
					<label for="contbaserad">Contraseña</label>
					<br>
					<input type="text" id="contbaserad" name="contbaserad">
					</br>
					<input type="submit" value="Guardar cambios">
				</fieldset>
			</form>

			<form action="contra.php" method="POST">
				<fieldset>
					<legend>Cambiar contraseña interfaz de usuario (Esta paǵina)</legend>
					<label for="contra">Nueva contraseña</label>
					<br>
					<input type="text" id="contra" name="contra">
					</br>
					<input type="checkbox" id="salir" name="salir" value="salir">
					<label for="salir">Salir tambien</label>
					</br>
					<input type="submit" value="Guardar cambios">
				</fieldset>
			</form>





		<?php else: ?>
			<form method="POST" class="partelogin">
				<h1>Login del router</h1>
				<?php if($error) echo "<p style='color:red'>Hay un error: $error</p>"; ?>
				<input type="text" name="username" placeholder="Admin?" required>
				<input type="password" name="password" placeholder="Contraseña?" required>
				<button type="submit">Entrar</button>
			</form>
			<br>
			<?php include 'comun.php'; ?>
		<?php endif; ?>
	</body>
</html>
