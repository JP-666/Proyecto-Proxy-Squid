<?php
session_start();
if (!isset($_SESSION['admin_user'])) {
	header("Location: index.php");
	exit();
}
?>


<form action="vercorreosusuario.php" method="POST">
	<label for="usuario">Usuario del email?</label>
	<br>
	<select id="usuario" name="usuario">
		<?php
			$DIRJMAIL = "/jmail/";
			$carpetas = array_diff(scandir($DIRJMAIL), array('..', '.', 'perdido'));
			foreach ($carpetas as $usuario) {
				if (is_dir($DIRJMAIL . $usuario)) {
					echo "<option value=\"$usuario\">$usuario</option>";
				}
			}
		?>
	</select>
	<br>
	<input type="submit" value="Leer">
</form>
