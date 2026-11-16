/*
    DEPENDIENDO DEL USUARIO QUE CON EL QUE EJECUTEMOS EL SCRIPT DEBERÍA DE SALIRNOS UNA COSA U OTRA.
    SI EJECUTAMOS EL SCRIPT COMO USUARIO 'admin_usr' DEBERÍA DE EJECUTARSE SIN NINGÚN PROBLEMA
    SI EJECUTAMOS EL SCRIPT COMO USUARIO 'gestor_usr' DEBERÍA DE EJECUTARSE SIN NINGÚN PROBLEMA, MENOS SI ESTAMOS 
        CREANDO UNA NUEVA TABLA O ELIMINANDO UNA TABLA
    SI EJECUTAMOS EL SCRIPT COMO USUARIO 'cliente_usr' DEBERÍA DE FALLAR EN TODO TIPO DE CONSULTAS QUE NO SEAN LAS DE 
        'usuario_tiene_edicion' Y 'usuario_desea_disco', TODO TIPO DE INSERCIONES, ELIMINACIONES O ACTUALIZACIONES
        MENOS LAS QUE SON DE 'usuario_tiene_edicion' Y 'usuario_desea_disco'
    SI EJECUTAMOS EL SCRIPT COMO USUARIO 'invitado_usr' DEBERÍA DE FALLAR EN TODO TIPO DE CONSULTAS QUE NO SEAN LAS DE 
        'canciones', 'grupos' Y 'discos', TODO TIPO DE INSERCIONES, ELIMINACIONES O ACTUALIZACIONES DEBERÍA DE FALLAR
*/

-- \echo 'Vemos si pueden ver toda la información de cada tabla de la base de datos'
-- SELECT * FROM PL2_final.grupos;
-- SELECT * FROM PL2_final.discos;
-- SELECT * FROM PL2_final.canciones;
-- SELECT * FROM PL2_final.ediciones;
-- SELECT * FROM PL2_final.usuarios;
-- SELECT * FROM PL2_final.usuario_desea_disco;
-- SELECT * FROM PL2_final.usuario_tiene_edicion;
-- SELECT * FROM PL2_final.generos_dsc;
-- SELECT * FROM PL2_final.auditoria;

\echo 'Vemos si pueden insertar en cada tabla de la base de datos'
SELECT * FROM PL2_final.discos;

INSERT INTO PL2_final.usuarios (nombre_usuario, nombre_completo, email, password) VALUES 
    ('mariorojo', 'Mario Rojo Donoro', 'mario@example.com', 'password123');

INSERT INTO PL2_final.discos (titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada) VALUES 
    ('Paquito', 2000, 'Kevin Lear', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

INSERT INTO PL2_final.ediciones (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato) VALUES 
    (2000, 'Paquito', 2001, 'España', 'Vinyl');

INSERT INTO PL2_final.usuario_desea_disco (ano_lanzamiento_disco, titulo_disco, nombre_usuario) VALUES 
    (2000, 'Paquito', 'mariorojo');

INSERT INTO PL2_final.usuario_tiene_edicion (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado) VALUES 
    (2000, 'Paquito', 2001, 'España', 'Vinyl', 'mariorojo', 'M');

INSERT INTO PL2_final.usuarios (nombre_usuario, nombre_completo, email, password) VALUES 
    ('juanjorojo', 'Juanjo Rojo Doncccoro', 'juanjorojo@example.com', '1234');

INSERT INTO PL2_final.grupos (nombre_grupo, URL) VALUES 
    ('Marea', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

INSERT INTO PL2_final.discos (titulo_disco, ano_lanzamiento_disco, nombre_grupo, URL_portada) VALUES 
    ('AEIOU', 2024, 'Marea', 'https://www.youtube.com/watch?v=1D1pbagPP0Y');

INSERT INTO PL2_final.canciones (ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion) VALUES
    (2024, 'AEIOU', 'Cancion1', '3:45');

\echo 'Vemos si puede actualizar una inserción de un dato en cualquier tabla'

UPDATE PL2_final.usuarios SET nombre_completo = 'Juanjo Rojo Martín', email = 'a@example.com', password = '12345'
    WHERE nombre_usuario = 'juanjorojo';

\echo 'Vemos si puede borrar una inserción de un dato en cualquier tabla'
DELETE FROM PL2_final.usuario_tiene_edicion WHERE nombre_usuario = 'mariorojo' AND titulo_disco = 'Paquito';

DELETE FROM PL2_final.usuarios WHERE nombre_usuario = 'mariorojo';