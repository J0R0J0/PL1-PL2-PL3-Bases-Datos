\pset pager off

SET client_encoding = 'UTF8';

-- BEGIN;

\echo 'Creando el esquema para la BBDD de discos'

\echo 'Creando un esquema temporal'

-- CREAMOS EL ESQUEMA TEMPORAL
CREATE SCHEMA IF NOT EXISTS PL2_temp;

\echo 'Creando tablas temporales'

-- CREANDO TABLAS TEMPORALES

-- TABLA TEMPORAL DE CANCIONES
CREATE TABLE IF NOT EXISTS PL2_temp.canciones_temp (
    id_disco text,
    titulo_cancion text,
    duracion text
);

-- TABLA TEMPORAL DE DISCOS
CREATE TABLE IF NOT EXISTS PL2_temp.discos_temp (
    id_disco text,
    titulo_disco text,
    ano_lanzamiento_disco text,
    id_grupo text,
    nombre_grupo text,
    url_grupo text,
    generos text,
    url_portada text
);

-- TABLA TEMPORAL DE EDICIONES
CREATE TABLE IF NOT EXISTS PL2_temp.ediciones_temp (
    id_disco text,
    ano_edicion text,
    pais_edicion text,
    formato text
);

-- TABLA TEMPORAL DE USUARIO_DESEA_DISCO
CREATE TABLE IF NOT EXISTS PL2_temp.usuario_desea_disco_temp (
    nombre_usuario text,
    titulo_disco text,
    ano_lanzamiento_disco text
);

-- TABLA TEMPORAL DE USUARIO_TIENE_EDICIÓN
CREATE TABLE IF NOT EXISTS PL2_temp.usuario_tiene_edicion_temp (
    nombre_usuario text,
    titulo_disco text,
    ano_lanzamiento_disco text,
    ano_edicion text,
    pais_edicion text,
    formato text,
    estado text
);

-- TABLA TEMPORAL DE USUARIOS
CREATE TABLE IF NOT EXISTS PL2_temp.usuarios_temp (
    nombre_completo text,
    nombre_usuario text,
    email text,
    password text
);

SET search_path='PL2_temp';

\echo 'Cargando datos'

-- CARGAMOS LOS DATOS EN LAS TABLAS TEMPORALES
\copy PL2_temp.canciones_temp FROM './datos/canciones.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');
\copy PL2_temp.discos_temp FROM './datos/discos.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');
\copy PL2_temp.ediciones_temp FROM './datos/ediciones.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');
\copy PL2_temp.usuario_desea_disco_temp FROM './datos/usuario_desea_disco.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');
\copy PL2_temp.usuario_tiene_edicion_temp FROM './datos/usuario_tiene_edicion.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');
\copy PL2_temp.usuarios_temp FROM './datos/usuarios.csv' WITH (FORMAT csv, HEADER, DELIMITER ';', NULL 'NULL', ENCODING 'UTF-8');

\echo 'Creando esquema final'

-- CREAMOS EL ESQUEMA FINAL
CREATE SCHEMA IF NOT EXISTS PL2_final;

\echo 'Creando tablas finales'

-- CREAMOS LAS TABLAS FINALES
-- TABLA FINAL DE USUARIOS
CREATE TABLE IF NOT EXISTS PL2_final.usuarios (
    /*
    ATRIBUTES: nombre_usuario, nombre_completo, email, password
    PRIMARY KEY: nombre_usuario
    */
    
    nombre_usuario TEXT NOT NULL,
    nombre_completo TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,

    -- PRIMARY KEY 
    CONSTRAINT pk_usuarios PRIMARY KEY (nombre_usuario)
);

-- TABLA FINAL DE GRUPOS
CREATE TABLE IF NOT EXISTS PL2_final.grupos (
    /*
    ATRIBUTES: nombre_grupo, URL
    PRIMARY KEY: nombre_grupo
    */

    nombre_grupo TEXT NOT NULL,
    URL TEXT NOT NULL,

    -- PRIMARY KEY
    CONSTRAINT pk_grupos PRIMARY KEY (nombre_grupo)
);

-- TABLA FINAL DE DISCOS
CREATE TABLE IF NOT EXISTS PL2_final.discos (
    /*
    ATRIBUTES: titulo_disco, ano_lanzamiento_disco, nombre_grupo, generos, url_portada
    PRIMARY KEY: titulo_disco, ano_lanzamiento_disco
    FOREING KEY: nombre_grupo
    */
    
    titulo_disco TEXT NOT NULL,                 
    ano_lanzamiento_disco INTEGER NOT NULL,        
    nombre_grupo TEXT NOT NULL,                                    
    url_portada TEXT NOT NULL,

    -- PRIMARY KEY
    CONSTRAINT pk_discos PRIMARY KEY (titulo_disco, ano_lanzamiento_disco),

    -- FOREIGN KEY
    CONSTRAINT fk_discos FOREIGN KEY (nombre_grupo) REFERENCES PL2_final.grupos(nombre_grupo) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA FINAL DE CANCIONES
CREATE TABLE IF NOT EXISTS PL2_final.canciones (
    /*
    ATRIBUTES: ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion
    PRIMARY KEY: titulo_cancion
    FOREING KEY: titulo_disco, ano_lanzamiento_disco
    */
    
    ano_lanzamiento_disco INTEGER NOT NULL,
    titulo_disco TEXT NOT NULL,
    titulo_cancion TEXT NOT NULL,
    duracion INTERVAL,

    -- PRIMARY KEY
    CONSTRAINT pk_canciones PRIMARY KEY (titulo_cancion, ano_lanzamiento_disco, titulo_disco),

    -- FOREIGN KEY
    CONSTRAINT fk_canciones FOREIGN KEY (titulo_disco, ano_lanzamiento_disco) REFERENCES PL2_final.discos(titulo_disco, ano_lanzamiento_disco) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA FINAL DE EDICIONES
CREATE TABLE IF NOT EXISTS PL2_final.ediciones (
    /*
    ATRIBUTES: ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato
    PRIMARY KEY: titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato
    FOREING KEY: titulo_disco, ano_lanzamiento_disco
    */
    
    ano_lanzamiento_disco INTEGER NOT NULL,
    titulo_disco TEXT NOT NULL,
    ano_edicion INTEGER NOT NULL,
    pais_edicion TEXT NOT NULL,
    formato TEXT NOT NULL,

    -- PRIMARY KEY
    CONSTRAINT pk_ediciones PRIMARY KEY (titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato),

    -- FOREIGN KEY
    CONSTRAINT fk_ediciones FOREIGN KEY (titulo_disco, ano_lanzamiento_disco) REFERENCES PL2_final.discos(titulo_disco, ano_lanzamiento_disco) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA FINAL DE USUARIO_DESEA_DISCO
CREATE TABLE IF NOT EXISTS PL2_final.usuario_desea_disco (
    /*
    ATRIBUTES: ano_lanzamiento_disco, titulo_disco, nombre_usuario
    PRIMARY KEY: nombre_usuario, titulo_disco, ano_lanzamiento_disco
    FOREING KEY: nombre_usuario, titulo_disco, ano_lanzamiento_disco
    */
    
    ano_lanzamiento_disco INTEGER NOT NULL,
    titulo_disco TEXT NOT NULL,
    nombre_usuario TEXT NOT NULL,

    -- PRIMARY KEY
    CONSTRAINT pk_usuario_desea_disco PRIMARY KEY (nombre_usuario, titulo_disco, ano_lanzamiento_disco),

    -- FOREIGN KEY
    CONSTRAINT fk1_usuario_desea_disco FOREIGN KEY (nombre_usuario) REFERENCES PL2_final.usuarios(nombre_usuario) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk2_usuario_desea_disco FOREIGN KEY (titulo_disco, ano_lanzamiento_disco) REFERENCES PL2_final.discos(titulo_disco, ano_lanzamiento_disco) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE 
);

-- TABLA FINAL DE USUARIO_TIENE_EDICION
CREATE TABLE IF NOT EXISTS PL2_final.usuario_tiene_edicion (
    /*
    ATRIBUTES: ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado
    PRIMARY KEY: nombre_usuario, titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato
    FOREING KEY: nombre_usuario, titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato
    */
    
    ano_lanzamiento_disco INTEGER NOT NULL,
    titulo_disco TEXT NOT NULL,
    ano_edicion INTEGER NOT NULL,
    pais_edicion TEXT NOT NULL,
    formato TEXT NOT NULL,
    nombre_usuario TEXT NOT NULL,
    estado TEXT NOT NULL,    

    -- PRIMARY KEY
    CONSTRAINT pk_usuario_tiene_edicion PRIMARY KEY (nombre_usuario, titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato),

    -- FOREIGN KEY
    CONSTRAINT fk1_usuario_tiene_edicion FOREIGN KEY (nombre_usuario) REFERENCES PL2_final.usuarios(nombre_usuario) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk2_usuario_tiene_edicion FOREIGN KEY (titulo_disco, ano_lanzamiento_disco) REFERENCES PL2_final.discos(titulo_disco, ano_lanzamiento_disco) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk3_usuario_tiene_edicion FOREIGN KEY (titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato) REFERENCES PL2_final.ediciones(titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

-- TABLA FINAL DE GENEROS_DSC
CREATE TABLE IF NOT EXISTS PL2_final.generos_dsc (
    /*
    ATRIBUTES: ano_lanzamiento_disco, titulo_disco, generos
    PRIMARY KEY: titulo_disco, ano_lanzamiento_disco, generos
    */
    
    ano_lanzamiento_disco INTEGER NOT NULL,
    titulo_disco TEXT NOT NULL,
    generos TEXT[],

    -- PRIMARY KEY
    CONSTRAINT pk_generos_dsc PRIMARY KEY (titulo_disco, ano_lanzamiento_disco, generos),

    -- FOREIGN KEY
    CONSTRAINT fk_generos_dsc FOREIGN KEY (titulo_disco, ano_lanzamiento_disco) REFERENCES PL2_final.discos(titulo_disco, ano_lanzamiento_disco) MATCH FULL ON DELETE CASCADE ON UPDATE CASCADE
);

SET search_path='PL2_final';

\echo Insertando datos en el esquema final

-- INSERTAMOS LOS DATOS EN LAS TABLAS FINALES
-- INSERTAMOS LOS DATOS EN LA TABLA DE USUARIOS
INSERT INTO PL2_final.usuarios(nombre_usuario, nombre_completo, email, password)
    SELECT DISTINCT ON(nombre_usuario) 
        nombre_usuario::TEXT, 
        nombre_completo::TEXT, 
        email::TEXT, 
        password::TEXT
    FROM PL2_temp.usuarios_temp
    WHERE nombre_usuario IS NOT NULL 
        AND nombre_completo IS NOT NULL 
        AND email IS NOT NULL 
        AND password IS NOT NULL
    ON CONFLICT (email) DO NOTHING;

-- INSERTAMOS LOS DATOS EN LA TABLA DE GRUPOS
INSERT INTO PL2_final.grupos(nombre_grupo, URL)
    SELECT DISTINCT ON(nombre_grupo) 
        nombre_grupo::TEXT, 
        url_grupo::TEXT
    FROM PL2_temp.discos_temp;

-- INSERTAMOS LOS DATOS EN LA TABLA DE DISCOS
INSERT INTO PL2_final.discos(titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada)
    SELECT DISTINCT ON(titulo_disco, ano_lanzamiento_disco) 
        titulo_disco::TEXT, 
        ano_lanzamiento_disco::INTEGER, 
        nombre_grupo::TEXT, 
        url_portada::TEXT
    FROM PL2_temp.discos_temp
    WHERE url_portada IS NOT NULL AND ano_lanzamiento_disco::INTEGER != 0;

-- INSERTAMOS LOS DATOS EN LA TABLA DE CANCIONES
INSERT INTO PL2_final.canciones(ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion)
    SELECT DISTINCT ON(titulo_cancion) 
        PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER, 
        PL2_temp.discos_temp.titulo_disco::TEXT, 
        PL2_temp.canciones_temp.titulo_cancion::TEXT, 
        COALESCE(
            make_interval(mins => split_part(PL2_temp.canciones_temp.duracion, ':', 1)::int, secs => split_part(PL2_temp.canciones_temp.duracion, ':', 2)::int),
            interval '0 seconds'
        )
    FROM PL2_temp.canciones_temp
    JOIN PL2_temp.discos_temp ON 
        PL2_temp.canciones_temp.id_disco = PL2_temp.discos_temp.id_disco
    WHERE (PL2_temp.discos_temp.titulo_disco, PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER) IN 
    (SELECT titulo_disco, ano_lanzamiento_disco FROM PL2_final.discos);

-- INSERTAMOS LOS DATOS EN LA TABLA DE EDICIONES
INSERT INTO PL2_final.ediciones(ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato)
    SELECT DISTINCT ON(titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato) 
        PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER, 
        PL2_temp.discos_temp.titulo_disco::TEXT,
        PL2_temp.ediciones_temp.ano_edicion::INTEGER, 
        PL2_temp.ediciones_temp.pais_edicion::TEXT, 
        PL2_temp.ediciones_temp.formato::TEXT
    FROM PL2_temp.ediciones_temp
    JOIN PL2_temp.discos_temp ON 
        PL2_temp.ediciones_temp.id_disco = PL2_temp.discos_temp.id_disco
    WHERE (PL2_temp.discos_temp.titulo_disco, PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER) IN 
    (SELECT titulo_disco, ano_lanzamiento_disco FROM PL2_final.discos)
    AND PL2_temp.ediciones_temp.ano_edicion::INTEGER != 0;

-- INSERTAMOS LOS DATOS EN LA TABLA DE USUARIO_DESEA_DISCO
INSERT INTO PL2_final.usuario_desea_disco(ano_lanzamiento_disco, titulo_disco, nombre_usuario)
    SELECT DISTINCT ON(nombre_usuario, titulo_disco, ano_lanzamiento_disco) 
        PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER, 
        PL2_temp.discos_temp.titulo_disco::TEXT, 
        PL2_temp.usuario_desea_disco_temp.nombre_usuario::TEXT
    FROM PL2_temp.usuario_desea_disco_temp
    JOIN PL2_temp.discos_temp ON 
        PL2_temp.usuario_desea_disco_temp.titulo_disco = PL2_temp.discos_temp.titulo_disco AND 
        PL2_temp.usuario_desea_disco_temp.ano_lanzamiento_disco = PL2_temp.discos_temp.ano_lanzamiento_disco AND 
        PL2_temp.usuario_desea_disco_temp.ano_lanzamiento_disco = PL2_temp.discos_temp.ano_lanzamiento_disco
    WHERE (PL2_temp.discos_temp.titulo_disco, PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER) IN 
    (SELECT titulo_disco, ano_lanzamiento_disco FROM PL2_final.discos);

-- INSERTAMOS LOS DATOS EN LA TABLA DE USUARIO_TIENE_EDICION
INSERT INTO PL2_final.usuario_tiene_edicion(ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado)
    SELECT DISTINCT ON(nombre_usuario, titulo_disco, ano_lanzamiento_disco, ano_edicion, pais_edicion, formato)
        PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER, 
        PL2_temp.discos_temp.titulo_disco::TEXT, 
        PL2_temp.ediciones_temp.ano_edicion::INTEGER, 
        PL2_temp.ediciones_temp.pais_edicion::TEXT, 
        PL2_temp.ediciones_temp.formato::TEXT, 
        PL2_temp.usuario_tiene_edicion_temp.nombre_usuario::TEXT,
        PL2_temp.usuario_tiene_edicion_temp.estado::TEXT
    FROM PL2_temp.usuario_tiene_edicion_temp
    JOIN PL2_temp.discos_temp ON 
        PL2_temp.usuario_tiene_edicion_temp.titulo_disco = PL2_temp.discos_temp.titulo_disco AND 
        PL2_temp.usuario_tiene_edicion_temp.ano_lanzamiento_disco = PL2_temp.discos_temp.ano_lanzamiento_disco
    JOIN PL2_temp.ediciones_temp ON 
        PL2_temp.usuario_tiene_edicion_temp.ano_edicion = PL2_temp.ediciones_temp.ano_edicion AND 
        PL2_temp.usuario_tiene_edicion_temp.pais_edicion = PL2_temp.ediciones_temp.pais_edicion AND 
        PL2_temp.usuario_tiene_edicion_temp.formato = PL2_temp.ediciones_temp.formato
    WHERE PL2_temp.ediciones_temp.ano_edicion::INTEGER != 0 AND PL2_temp.discos_temp.ano_lanzamiento_disco::INTEGER != 0;

-- INSERTAMOS LOS DATOS EN LA TABLA DE GENEROS_DSC
INSERT INTO PL2_final.generos_dsc(titulo_disco, ano_lanzamiento_disco, generos)
    SELECT DISTINCT ON (titulo_disco, ano_lanzamiento_disco)
        titulo_disco::TEXT,
        ano_lanzamiento_disco::INTEGER,
        array_agg(DISTINCT regexp_replace(genre, '[\[\]\''"&\s]', '', 'g'))::TEXT[] AS generos
    FROM (
        SELECT titulo_disco, ano_lanzamiento_disco, regexp_split_to_table(generos, ',') AS genre
        FROM PL2_temp.discos_temp
    ) AS genres_split
    WHERE (titulo_disco, ano_lanzamiento_disco::INTEGER) IN 
        (SELECT titulo_disco, ano_lanzamiento_disco FROM PL2_final.discos)
    GROUP BY titulo_disco, ano_lanzamiento_disco
    ON CONFLICT (titulo_disco, ano_lanzamiento_disco, generos) DO NOTHING;


-- CODIGO DE LAS CONSULTAS
/*
\echo Consulta 1: Mostrar  los  discos  que  tengan  más  de  5  canciones.  Construir  la  expresión equivalente en álgebra relacional.
SELECT titulo_disco, COUNT(*) as num_canciones -- Filtramos las canciones segun disco y contamos cuantas canciones pertenecen al mismo disco.
    FROM PL2_final.canciones -- Elegimos los datos de la tabla canciones.
    GROUP BY titulo_disco -- Agrupamos por titulo de disco.
    HAVING COUNT(*) > 5; -- Solo mostramos los discos que tengan mas de 5 canciones.

\echo Consulta 2: Mostrar los vinilos que tiene el usuario Juan García Gómez junto con el título del disco, y el país y año de edición de este.
SELECT nombre_usuario, titulo_disco, pais_edicion, ano_edicion
    FROM PL2_final.usuario_tiene_edicion
    WHERE nombre_usuario = 'juangomez' AND formato = 'Vinyl';

\echo Consulta 3: Hallar  el  disco  con  mayor  duración  de  la  colección.  Construir  la  expresión equivalente en álgebra relacional.
SELECT titulo_disco, SUM(duracion) as duracion_total -- Sumamos la duracion de todas las canciones de un disco.
    FROM PL2_final.canciones -- Elegimos los datos de la tabla canciones.
    GROUP BY titulo_disco -- Agrupamos por titulo de disco.
    ORDER BY duracion_total DESC -- Ordenamos de forma descendente.
    LIMIT 1; -- Limitamos a 1 para mostrar solo el disco con mayor duracion.

\echo Consulta 4: De los discos que tiene en su lista de deseos el usuario Juan García Gómez, indicar el nombre de los grupos musicales que los interpretan.
SELECT nombre_usuario, nombre_grupo 
    FROM PL2_final.usuario_desea_disco JOIN PL2_final.discos -- Unimos las tablas para obtener los datos de usuarios que desean y autores de los discos
    ON PL2_final.usuario_desea_disco.titulo_disco = PL2_final.discos.titulo_disco
    WHERE PL2_final.usuario_desea_disco.nombre_usuario = 'juangomez';

\echo Consulta 5: Mostrar los discos publicados entre 1970 y 1972 junto con sus ediciones ordenados por el año de publicación. 
SELECT titulo_disco, ano_lanzamiento_disco, formato
    FROM PL2_final.ediciones
    WHERE ano_lanzamiento_disco >= 1970 AND ano_lanzamiento_disco <= 1972
    ORDER BY ano_lanzamiento_disco ASC; -- Ordenamos de forma ascendente.

\echo Consulta 6: Listar  el  nombre  de  todos  los  grupos  que  han  publicado  discos  del  género ‘Electronic’. Construir la expresión equivalente en álgebra relacional.
SELECT DISTINCT nombre_grupo, generos
    FROM PL2_final.discos
    JOIN PL2_final.generos_dsc ON PL2_final.discos.titulo_disco = PL2_final.generos_dsc.titulo_disco
    WHERE 'Electronic' = ANY (PL2_final.generos_dsc.generos);

\echo Consulta 7: Lista de discos con la duración total del mismo editados antes del año 2000.
SELECT SUBSTRING(titulo_disco, 1, 10) as titulo_disco, SUM(duracion) as duracion_album
    FROM PL2_final.canciones
    WHERE ano_lanzamiento_disco < 2000
    GROUP BY SUBSTRING(titulo_disco, 1, 10)
    ORDER BY duracion_album DESC;

\echo Consulta 8: Lista de ediciones de discos deseados por el usuario Sergio Fernández Moreno que tiene el usuario Juan García Gómez.
SELECT PL2_final.usuario_desea_disco.titulo_disco, PL2_final.usuario_tiene_edicion.formato, PL2_final.usuario_desea_disco.nombre_usuario
    FROM PL2_final.usuario_desea_disco JOIN PL2_final.usuario_tiene_edicion
    ON PL2_final.usuario_desea_disco.titulo_disco =  PL2_final.usuario_tiene_edicion.titulo_disco
    WHERE PL2_final.usuario_desea_disco.nombre_usuario = 'sergiofernández'
    AND PL2_final.usuario_tiene_edicion.nombre_usuario = 'juangomez';

\echo Consulta 9: Lista todas las ediciones de los discos que tiene el usuario Gómez García en un estado NM o M. Construir la expresión equivalente en álgebra relacional.
SELECT titulo_disco, formato, nombre_usuario, estado
    FROM PL2_final.usuario_tiene_edicion
    WHERE nombre_usuario = 'juangomez' AND (estado = 'NM' OR estado = 'M');

\echo Consulta 10:Listar  todos  los  usuarios  junto  al  número  de  ediciones  que  tiene  de  todos  los discos junto al año de lanzamiento de su disco más antiguo, el año de lanzamiento  de  su  disco  más  nuevo,  y  el  año  medio  de  todos  sus  discos  de  su colección
SELECT nombre_usuario, COUNT(*) AS num_ediciones, 
    MIN(ano_lanzamiento_disco) AS disco_mas_antiguo,
    MAX(ano_lanzamiento_disco) AS disco_mas_nuevo,
    AVG(ano_lanzamiento_disco) AS promedio_discos
    FROM PL2_final.usuario_tiene_edicion
    GROUP BY nombre_usuario;

\echo Consulta 11: Listar el nombre de los grupos que tienen más de 5 ediciones de sus discos en la base de datos. 
SELECT nombre_grupo
    FROM PL2_final.discos
    JOIN PL2_final.ediciones ON PL2_final.discos.titulo_disco = PL2_final.ediciones.titulo_disco
    GROUP BY nombre_grupo
    HAVING COUNT(*) > 5;

\echo Consulta 12: Listar  el  usuario  que  más  discos  tiene  en  la  base  de  datos  contando  todas  sus ediciones.
SELECT nombre_usuario
    FROM PL2_final.usuario_tiene_edicion
    GROUP BY nombre_usuario
    ORDER BY COUNT(*) DESC
    LIMIT 1;

\echo Consulta n:
*/

-- PRIMERA PARTE DE LA PECL3

\echo 'Creando tabla auditoria'

-- CREACION DE LA TABLA AUDITORIA
CREATE TABLE PL2_final.auditoria (
    id SERIAL,
    nom_tabla_afectada TEXT,
    tipo_evento TEXT,
    usuario TEXT,
    fecha TIMESTAMP,

    -- PRIMARY KEY
    CONSTRAINT pk_auditoria PRIMARY KEY (id)
);

\echo 'Creando función auditoria'

-- CREACION DE LA FUNCION AUDITORIA
CREATE OR REPLACE FUNCTION PL2_final.fn_auditoria() RETURNS TRIGGER AS $fn_auditoria$
    DECLARE
        -- NO HACE FALTA QUE DECLAREMOS NADA EN ESTA PARTE
    BEGIN
        -- SE DETERMINA QUE ACCION HA ACTIVADO EL TRIGGER Y SE INSERTA UN NUEVO VALOR EN LA TABLA DEPENDIENDO DE DICHA ACCION. jUNTO CON LA ACCION SE ESCRIBE LO QUE SOLICITA EL ENUNCIADO
        IF TG_OP='INSERT' THEN 
            INSERT INTO PL2_final.auditoria (nom_tabla_afectada, tipo_evento, usuario, fecha)
            VALUES (TG_TABLE_NAME, 'INSERT', current_user, current_timestamp);
        ELSEIF TG_OP='UPDATE' THEN
            INSERT INTO PL2_final.auditoria (nom_tabla_afectada, tipo_evento, usuario, fecha)
            VALUES (TG_TABLE_NAME, 'UPDATE', current_user, current_timestamp);
        ELSEIF TG_OP='DELETE' THEN
            INSERT INTO PL2_final.auditoria (nom_tabla_afectada, tipo_evento, usuario, fecha) 
            VALUES (TG_TABLE_NAME, 'DELETE', current_user, current_timestamp);
        END IF;
        RETURN NULL;
    END;
$fn_auditoria$ LANGUAGE plpgsql;

-- CREACION DE LOS TRIGGERS, SE CREA UN TRIGGER POR CADA TABLA DE LA BASE DE DATOS

\echo 'Creando triggers'

-- CREAMOS EL TRIGGER DE LA TABLA USUARIOS
CREATE TRIGGER tg_aditoria_usuarios AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.usuarios FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA DISCOS
CREATE TRIGGER tg_aditoria_discos AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.discos FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA GRUPOS
CREATE TRIGGER tg_aditoria_grupos AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.grupos FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA CANCIONES
CREATE TRIGGER tg_aditoria_canciones AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.canciones FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA EDICIONES
CREATE TRIGGER tg_aditoria_ediciones AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.ediciones FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA USUARIO_DESEA_DISCO
CREATE TRIGGER tg_aditoria_usuario_desea_disco AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.usuario_desea_disco FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA USUARIO_TIENE_EDICION
CREATE TRIGGER tg_aditoria_usuario_tiene_edicion AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.usuario_tiene_edicion FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- CREAMOS EL TRIGGER DE LA TABLA GENEROS_DSC
CREATE TRIGGER tg_aditoria_generos_dsc AFTER INSERT OR UPDATE OR DELETE 
    ON PL2_final.generos_dsc FOR EACH ROW 
    EXECUTE PROCEDURE PL2_final.fn_auditoria();

-- FUNCION QUE VERIFICA QUE UN DISCO ESTA EN LA TABLA DE USUARIO DESEA DISCO
CREATE OR REPLACE FUNCTION PL2_final.fn_verifica_disco()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        IF EXISTS (SELECT 1 FROM PL2_final.usuario_desea_disco 
                    WHERE nombre_usuario = NEW.nombre_usuario 
                        AND titulo_disco = NEW.titulo_disco 
                        AND ano_lanzamiento_disco = NEW.ano_lanzamiento_disco) THEN
            DELETE FROM PL2_final.usuario_desea_disco 
                WHERE nombre_usuario = NEW.nombre_usuario 
                    AND titulo_disco = NEW.titulo_disco 
                    AND ano_lanzamiento_disco = NEW.ano_lanzamiento_disco;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER DE VERIFICACION DE QUE UN DISCO ESTA EN LA TABLA DESEOS
CREATE TRIGGER tg_verifica_disco
    AFTER INSERT
    ON PL2_final.usuario_tiene_edicion
    FOR EACH ROW
    EXECUTE FUNCTION PL2_final.fn_verifica_disco();

-- SEGUNDA PARTE DE LA PECL3
/* 
USUARIOS QUE TENEMOS QUE CREAR:

UNO DE LOS USUARIOS SERÁ ADMINISTRADOR QUE DEBE DE PODER EJECUTAR CUALQUIER OPERACIÓN 
SOBRE LA BASE DE DATOS.

UN USUARIO GESTOR QUE DEBE PODER MANEJAR LOS DATOS DE LA BASE DE DATOS (INSERCIÓN, 
ACTUALIZACIÓN, BORRADO Y CONSULTA), PERO NO DEBE PODER CREAR NUEVAS TABLAS, NI 
ELEMENTOS QUE AFECTEN A LA ESTRUCTURA DE LA BASE DE DATOS.

UN USUARIO CLIENTE QUE SOLO PUEDE CONSULTAR E INSERTAR EN LA TABLA 
USUARIO_TIENE_EDICIONES Y USUARIO_DESEA_DISCO.

UN USUARIO INVITADO QUE SOLO PUEDE CONSULTAR LOS GRUPOS, DISCOS Y CANCIONES, PERO 
NINGUNA OTRA TABLA.
*/

-- CREAMOS EL ROL DE ADMINISTRADOR
CREATE ROLE administrador;

-- CREAMOS EL ROL DE GESTOR
CREATE ROLE gestor;

-- CREAMOS EL ROL DE CLIENTE
CREATE ROLE cliente;

-- CREAMOS EL ROL DE INVITADO
CREATE ROLE invitado;

-- ASIGNAMOS LOS PERMISOS A LOS ROLES
-- PERMISOS PARA EL ROL DE ADMINISTRADOR
GRANT ALL PRIVILEGES ON SCHEMA PL2_final TO administrador;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA PL2_final TO administrador;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA PL2_final TO administrador;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA PL2_final TO administrador;
GRANT USAGE ON SCHEMA PL2_final TO administrador;

-- PERMISOS PARA EL ROL DE GESTOR
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA PL2_final TO gestor;
GRANT USAGE ON SCHEMA PL2_final TO gestor;
GRANT USAGE, SELECT ON SEQUENCE PL2_final.auditoria_id_seq TO gestor;

-- PERMISOS PARA EL ROL DE CLIENTE
REVOKE ALL ON PL2_final.grupos FROM cliente;
GRANT SELECT, INSERT ON PL2_final.usuario_tiene_edicion TO cliente;
GRANT SELECT, INSERT ON PL2_final.usuario_desea_disco TO cliente;
GRANT USAGE ON SCHEMA PL2_final TO cliente;

-- PERMISOS PARA EL ROL DE INVITADO
GRANT SELECT ON PL2_final.grupos TO invitado;
GRANT SELECT ON PL2_final.discos TO invitado;
GRANT SELECT ON PL2_final.canciones TO invitado;
GRANT USAGE ON SCHEMA PL2_final TO invitado;

-- CREAMOS LOS USUARIOS
-- USUARIO ADMINISTRADOR
CREATE USER admin_usr WITH PASSWORD '1234';
GRANT administrador TO admin_usr;

-- USUARIO GESTOR
CREATE USER gestor_usr WITH PASSWORD '1234';
GRANT gestor TO gestor_usr;

-- USUARIO CLIENTE
CREATE USER cliente_usr WITH PASSWORD '1234';
GRANT cliente TO cliente_usr;

-- USUARIO INVITADO
CREATE USER invitado_usr WITH PASSWORD '1234';
GRANT invitado TO invitado_usr;

-- MARIO
-- \i ./ficheros/plantilla.sql; 
-- \i ./ficheros/borrar.sql; 

-- JAVI
-- \i ./ficheros/plantilla.sql;
-- \i ./ficheros/borrar.sql;

--MIGUEL
-- \i ./ficheros/plantilla.sql;
-- \i ./ficheros/borrar.sql;

-- ROLLBACK;                       -- importante! permite correr el script multiples veces...