<?php

// Este script esta un poco "feo", pero funciona
// Probablemente te estes preguntando por que estoy
// Borrando y creando una nueva cuenta cada vez que
// Hago esto, "pero JP, no es mas facil usar el estamento
// ON DUPLICATE KEY VALUE???", y efectivamente, eso seria
// muchisimo mas facil, pero RADIUS hace sus tablas sin
// indices unicos, asi que no hay ningun "unique key" en
// ningun sitio, osea que estamos obligados a BORRAR y luego
// CREAR una nueva cuenta, entiendo que esto seria por que
// Puede haber mas de un "atributo" para cada usuario.


session_start();

// Tenemos sesion de ADMIN??
if (!isset($_SESSION['admin_user'])) die("Acceso denegado");

// Variables del POST por que es mas elegante, obviamente.
$u = $_POST['usuariobaserad'] ?? null;
$p = $_POST['contbaserad'] ?? null;

if (!$u || !$p) die("Datos incompletos"); // Si no tenemos todos los datos

try {
    $db = new PDO("mysql:host=localhost;dbname=baseradius", "Fran", "FranPassword");
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); // Esto dice internet que es importante, que si no, no nos da info sobre los errores
    $db->beginTransaction(); // Empezamos la operacion
    $db->prepare("DELETE FROM radcheck WHERE username = ?")->execute([$u]); // Borramos el usuario antes
    $contbuena=password_hash($p, PASSWORD_BCRYPT);
    $ins = "INSERT INTO radcheck (username, attribute, op, value) VALUES (?, 'Crypt-Password', ':=', ?)"; // Metemos de nuevo el usuario
    $db->prepare($ins)->execute([$u, $contbuena]); // Lo de antes, pero en otra linea que costaba verse antes
    $db->commit(); // Cerramos
    echo "OK: Usuario $u creado o actualizado con contraseña $p .";

} catch (Exception $e) { // Si la consulta falla
    if (isset($db) && $db->inTransaction()) $db->rollBack();
    die("Error: " . $e->getMessage());
}
