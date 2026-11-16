-- Eliminamos el esquema de PL2_temp y sus tablas temporales
DROP SCHEMA IF EXISTS PL2_temp CASCADE;

-- Eliminamos el esquema de PL2_final y sus tablas
DROP SCHEMA IF EXISTS PL2_final CASCADE;

-- ELIMINAMOS LOS ROLES CREADOS
DROP ROLE IF EXISTS administrador;
DROP ROLE IF EXISTS gestor;
DROP ROLE IF EXISTS cliente;
DROP ROLE IF EXISTS invitado;

-- ELIMINAMOS LOS USUARIOS CREADOS
DROP USER IF EXISTS admin_usr;
DROP USER IF EXISTS gestor_usr;
DROP USER IF EXISTS cliente_usr;
DROP USER IF EXISTS invitado_usr;