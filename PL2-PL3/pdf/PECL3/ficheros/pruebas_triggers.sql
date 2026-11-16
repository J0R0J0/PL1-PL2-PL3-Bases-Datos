-- PRUEBAS DE LA PRIMERA PARTE DE LA PECL3
-- INSERTAMOS UN NUEVO USUARIO A LA TABLA DE USUARIOS
INSERT INTO PL2_final.usuarios (nombre_usuario, nombre_completo, email, password) VALUES 
    ('mariorojo', 'Mario Rojo Doñoro', 'mario@example.com', 'password123');

-- INSERTAMOS UN NUEVO DISCO A LA TABLA DE DISCOS
INSERT INTO PL2_final.discos (titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada) VALUES 
    ('Paquito', 2000, 'Kevin Lear', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

-- INSERTAMOS UNA NUEVA EDICION A LA TABLA DE EDICIONES
INSERT INTO PL2_final.ediciones (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato) VALUES 
    (2000, 'Paquito', 2001, 'España', 'Vinyl');

-- INSERTAMOS UN NUEVO DISCO QUE DESEA UN USUARIO
INSERT INTO PL2_final.usuario_desea_disco (ano_lanzamiento_disco, titulo_disco, nombre_usuario) VALUES 
    (2000, 'Paquito', 'mariorojo');

-- INSERTAMOS UN DISCO QUE TIENE UN USUARIO EN LA TABLA DE DESEA DISCO EN LA TABLA DE USUARIO TIENE DISCO 
INSERT INTO PL2_final.usuario_tiene_edicion (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado) VALUES 
    (2000, 'Paquito', 2001, 'España', 'Vinyl', 'mariorojo', 'M');

-- ELIMINAMOS AL USUARIO mariorojo Y AL DISCO Paquito DE LA TABLA DE USUARIO TIENE EDICION
DELETE FROM PL2_final.usuario_tiene_edicion WHERE nombre_usuario = 'mariorojo' AND titulo_disco = 'Paquito';

-- ELIMINAMOS AL USUARIO mariorojo DE LA TABLA USUARIOS
DELETE FROM PL2_final.usuarios WHERE nombre_usuario = 'mariorojo';

-- INTRODUCIMOS UN NUEVO USUARIOS A LA TABLA DE USUARIOS
INSERT INTO PL2_final.usuarios (nombre_usuario, nombre_completo, email, password) VALUES 
    ('juanjorojo', 'Juanjo Rojo Doñoro', 'juanjorojo@example.com', '1234');

-- MODIFICAMOS LOS DATOS DE UN USUARIO QUE ACABAMOS DE INTRODUCIR
UPDATE PL2_final.usuarios SET nombre_completo = 'Juanjo Rojo Martín', email = 'a@example.com', password = '12345'
    WHERE nombre_usuario = 'juanjorojo';

INSERT INTO PL2_final.grupos (nombre_grupo, URL) VALUES 
    ('Marea', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

INSERT INTO PL2_final.discos (titulo_disco, ano_lanzamiento_disco, nombre_grupo, URL_portada) VALUES 
    ('AEIOU', 2024, 'Marea', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

INSERT INTO PL2_final.canciones (ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion) VALUES
    (2024, 'AEIOU', 'Cancion1', '3:45');

/* CONSULTAS QUE FUNCIONAN
-- VERFICAMOS QUE SE HAYA INTRODUCIDO CORRECTAMENTE
SELECT * FROM PL2_final.usuarios
    WHERE nombre_usuario IN ('mariorojo');
-- VERIFICAMOS QUE SE HA INSERTADO CORRECTAMENTE

SELECT * FROM PL2_final.discos
    WHERE (titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada) IN 
        (('Paquito', 2000, 'Kevin Lear', 'https://www.youtube.com/watch?v=1D1pbagPP0Y'));
-- VERIFICAMOS QUE SE HA INSERTADO CORRECTAMENTE

SELECT * FROM PL2_final.ediciones
    WHERE (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato) IN 
        ((2000, 'Paquito', 2001, 'España', 'Vinyl'));
-- VERIFICAMOS QUE SE HA INSERTADO CORRECTAMENTE

SELECT * FROM PL2_final.usuario_desea_disco
    WHERE (ano_lanzamiento_disco, titulo_disco, nombre_usuario) IN 
        ((2000, 'Paquito', 'mariorojo'));

-- VERIFICAMOS QUE SE HA INSERTADO CORRECTAMENTE
SELECT * FROM PL2_final.usuario_tiene_edicion
    WHERE (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado) IN 
        ((2000, 'Paquito', 2001, 'España', 'Vinyl', 'mariorojo', 'M'));
*/

-- VEMOS EL CONTENIDO DE LA TABLA DE AUDITORIA
-- SELECT * FROM PL2_final.auditoria;