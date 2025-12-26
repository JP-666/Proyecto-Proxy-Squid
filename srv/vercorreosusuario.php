<?php
session_start();
if (!isset($_SESSION['admin_user'])) {
    header("Location: index.php");
    exit();
}

$correos = [];
$u = "";
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST["usuario"])) {
	$u = basename($_POST["usuario"]);
	$lista_archivos = shell_exec("sudo /usr/bin/leerweb.sh " . escapeshellarg($u) . " LISTAR"); // Usamos sudo para leer los correos de los demas usuarios
	if ($lista_archivos) {
		$archivos = explode("\n", trim($lista_archivos));
		foreach ($archivos as $ruta_completa) {
			if (empty($ruta_completa)) continue; // Si el argumento estaba vacio. Que si no, falla.
				$nombre_archivo = basename($ruta_completa);
				$comando_leer = "sudo /usr/bin/leerweb.sh " . escapeshellarg($u) . " LEER " . escapeshellarg($nombre_archivo);
				$contenido = shell_exec($comando_leer);
				$datos = json_decode($contenido, true);
				if ($datos && isset($datos['MAIL'])) { // Si datos (Que es nuestro json ya parseado) no esta vacio, y es un "MAIL" valido.
					$correos[$nombre_archivo] = $datos['MAIL'];
			    	}
			}
		krsort($correos);
	}
}
?>
<!-- Me queda: Arreglar el HTML -->
<form method="POST">
	<label for="usuario">¿A quien vamos a cotillear hoy?</label>
	<select id="usuario" name="usuario">
		<?php
		$carpetas = array_diff(scandir("/jmail/"), array('..', '.', 'perdido'));
		foreach ($carpetas as $folder) {
			if (is_dir("/jmail/" . $folder)) {
				$sel = ($u == $folder) ? "selected" : "";
				echo "<option value=\"$folder\" $sel>$folder</option>";
			}
		}
		?>
	</select>
	<br>
	<button type="submit">Cargar Mensajes</button>
</form>

<hr>

<?php if ($u): ?>
	<h3>JMails para: <?= htmlspecialchars($u) ?></h3>
	<?php if (empty($correos)): ?>
		<p>NO TIENES CORREO;  <?= htmlspecialchars($u) ?>.</p>
	<?php else: ?>
		<table border="1" style="width:100%;">
			<thead>
				<tr>
					<th>Archivo</th>
					<th>De</th>
					<th>Asunto</th>
					<th>Acciones</th>
				</tr>
			</thead>
			<tbody>
			<?php foreach ($correos as $file => $info): ?>
				<tr>
					<td><?= htmlspecialchars($file) ?></td>
					<td><?= htmlspecialchars($info['DE'] ?? '???') ?></td>
					<td><?= htmlspecialchars($info['ASUNTO'] ?? 'S/A') ?></td>
					<td>
						<a href="descargar.php?user=<?= urlencode($u) ?>&file=<?= urlencode($file) ?>" target="_blank">
							[CLICK AQUI PARA DESCARGAR]
						</a>
					</td>
				</tr>
			<?php endforeach; ?>
			</tbody>
		</table>
	<?php endif; ?>
<?php endif; ?>


