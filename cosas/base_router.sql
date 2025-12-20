DROP DATABASE IF EXISTS router;
DROP USER IF EXISTS "urouter";

CREATE DATABASE IF NOT EXISTS router;

SELECT "El usuario de la base de datos es urouter y la contraseña es controuter" AS "Nota sobre el usuario";

CREATE USER "urouter" IDENTIFIED BY "controuter";

USE router;

CREATE TABLE datoslogin (
    id INT PRIMARY KEY,
    usuario VARCHAR(255),
    contrahash VARCHAR(255)
);

SELECT "La contraseña para \"admin\" es \"1234\"" AS "Nota sobre la contraseña:";

INSERT INTO datoslogin (id, usuario, contrahash) VALUES (1, 'admin', '$2y$05$UjShC02fX2O9mwQlvx7cKOZX5w1FnnejVuKIKHmkIKqNZLs51qLvC');

GRANT ALL PRIVILEGES ON router.* to "urouter";
