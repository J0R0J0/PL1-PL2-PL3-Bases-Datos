import sys
import psycopg2

class portException(Exception): pass

def ask_port(msg):
    """
        ask for a valid TCP port
        ask_port :: String -> IO Integer | Exception
    """
    try:                                                                        # try
        answer = input(msg)                                                     # pide el puerto
        port = int(answer)                                                      # convierte a entero
        if (port < 1024) or (port > 65535):                                     # si el puerto no es valido
            raise ValueError                                                    # lanza una excepción
    except ValueError:                                                          # if ValueError
        raise portException                                                     # raise portException
    finally:                                                                    # finally
        return port                                                             # return port

def ask_conn_parameters():
    """
        ask_conn_parameters:: () -> IO String
        pide los parámetros de conexión
        TODO: cada estudiante debe introducir los valores para su base de datos
    """
    host = 'localhost'                                                         
    port = 5432 # ask_port('TCP port number: ')                                        
    user = 'cliente_usr' # str(input('Usuario al que te quieres conectar: ')) # USUARIOS DISPONIBLES: admin_usr, gestor_usr, cliente_usr, invitado_usr                                                            
    password = '1234' # str(input('Contraseña: '))   #CONTRASEÑA PARA TODOS LOS USUARIOS 1234                                                       
    database = 'pl2'                                                            
    return (host, port, user, password, database)
        
def main():
    """
        main :: () -> IO None
    """
    try:
        (host, port, user, password, database) = ask_conn_parameters()          
        connstring = f'host={host} port={port} user={user} password={password} dbname={database}' 
        conn = psycopg2.connect(connstring)                                                                                            
        cur = conn.cursor()
        
        if user == 'admin_usr' or user == 'gestor_usr':  
            print('1. Consultas de la PL2')
            print('2. Escribir la consulta, inserción, actualización o eliminación de algo de una tabla a mano')
            print('3. Salir del modo de consultas')
            ans = int(input('Seleccione una de las opciones: '))
            if ans == 1:                        
                print('1. Mostrar los discos que tengan más de 5 canciones.')
                print('2. Mostrar los vinilos que tiene el usuario Juan García Gómez.')
                print('3. Hallar el disco con mayor duración de la colección.')
                print('4. Indicar el nombre de los grupos musicales de los discos en la lista de deseos de Juan García Gómez.')
                print('5. Mostrar los discos publicados entre 1970 y 1972.')
                print('6. Listar el nombre de todos los grupos que han publicado discos del género Electronic.')
                print('7. Lista de discos con la duración total del mismo editados antes del año 2000.')
                print('8. Lista de ediciones de discos deseados por Sergio Fernández Moreno que tiene Juan García Gómez.')
                print('9. Lista todas las ediciones de los discos que tiene el usuario Gómez García en un estado NM o M.')
                print('10. Listar todos los usuarios junto al número de ediciones que tiene de todos los discos.')
                print('11. Listar el nombre de los grupos que tienen más de 5 ediciones de sus discos.')
                print('12. Listar el usuario que más discos tiene en la base de datos.')
                eleccion = int(input('Seleccione por favor una opción: '))

                if eleccion == 1:
                    query = '''SELECT titulo_disco, COUNT(*) as num_canciones
                                FROM PL2_final.canciones
                                GROUP BY titulo_disco
                                HAVING COUNT(*) > 5;'''
                elif eleccion == 2:
                    query = '''SELECT nombre_usuario, titulo_disco, pais_edicion, ano_edicion
                                FROM PL2_final.usuario_tiene_edicion
                                WHERE nombre_usuario = 'juangomez' AND formato = 'Vinyl';'''
                elif eleccion == 3:
                    query = '''SELECT titulo_disco, SUM(duracion) as duracion_total
                                FROM PL2_final.canciones
                                GROUP BY titulo_disco
                                ORDER BY duracion_total DESC
                                LIMIT 1;'''
                elif eleccion == 4:
                    query = '''SELECT nombre_usuario, nombre_grupo 
                                FROM PL2_final.usuario_desea_disco
                                JOIN PL2_final.discos
                                ON PL2_final.usuario_desea_disco.titulo_disco = PL2_final.discos.titulo_disco
                                WHERE PL2_final.usuario_desea_disco.nombre_usuario = 'juangomez';'''
                elif eleccion == 5:
                    query = '''SELECT titulo_disco, ano_lanzamiento_disco, formato
                                FROM PL2_final.ediciones
                                WHERE ano_lanzamiento_disco >= 1970 AND ano_lanzamiento_disco <= 1972
                                ORDER BY ano_lanzamiento_disco ASC;'''
                elif eleccion == 6:
                    query = '''SELECT DISTINCT nombre_grupo, generos
                                FROM PL2_final.discos
                                JOIN PL2_final.generos_dsc
                                ON PL2_final.discos.titulo_disco = PL2_final.generos_dsc.titulo_disco
                                WHERE 'Electronic' = ANY (PL2_final.generos_dsc.generos);'''
                elif eleccion == 7:
                    query = '''SELECT SUBSTRING(titulo_disco, 1, 10) as titulo_disco, SUM(duracion) as duracion_album
                                FROM PL2_final.canciones
                                WHERE ano_lanzamiento_disco < 2000
                                GROUP BY SUBSTRING(titulo_disco, 1, 10)
                                ORDER BY duracion_album DESC;'''
                elif eleccion == 8:
                    query = '''SELECT PL2_final.usuario_desea_disco.titulo_disco, PL2_final.usuario_tiene_edicion.formato, PL2_final.usuario_desea_disco.nombre_usuario
                                FROM PL2_final.usuario_desea_disco
                                JOIN PL2_final.usuario_tiene_edicion
                                ON PL2_final.usuario_desea_disco.titulo_disco = PL2_final.usuario_tiene_edicion.titulo_disco
                                WHERE PL2_final.usuario_desea_disco.nombre_usuario = 'sergiofernández'
                                AND PL2_final.usuario_tiene_edicion.nombre_usuario = 'juangomez';'''
                elif eleccion == 9:
                    query = '''SELECT titulo_disco, formato, nombre_usuario, estado
                                FROM PL2_final.usuario_tiene_edicion
                                WHERE nombre_usuario = 'juangomez' AND (estado = 'NM' OR estado = 'M');'''
                elif eleccion == 10:
                    query = '''SELECT nombre_usuario, COUNT(*) AS num_ediciones, 
                                MIN(ano_lanzamiento_disco) AS disco_mas_antiguo,
                                MAX(ano_lanzamiento_disco) AS disco_mas_nuevo,
                                AVG(ano_lanzamiento_disco) AS promedio_discos
                                FROM PL2_final.usuario_tiene_edicion
                                GROUP BY nombre_usuario;'''
                elif eleccion == 11:
                    query = '''SELECT nombre_grupo
                                FROM PL2_final.discos
                                JOIN PL2_final.ediciones
                                ON PL2_final.discos.titulo_disco = PL2_final.ediciones.titulo_disco
                                GROUP BY nombre_grupo
                                HAVING COUNT(*) > 5;'''
                elif eleccion == 12:
                    query = '''SELECT nombre_usuario
                                FROM PL2_final.usuario_tiene_edicion
                                GROUP BY nombre_usuario
                                ORDER BY COUNT(*) DESC
                                LIMIT 1;'''
                else:
                    print('La opción seleccionada no es válida.')
                    query = None

                if query:
                    cur.execute(query)                                                      
                    for record in cur.fetchall():                                           
                        print(record)

            elif ans == 2:
                query = str(input('Introduzca la consulta que desea realizar: '))
                cur.execute(query)                                                      
                for record in cur.fetchall():                                           
                    print(record)

            # Pregunta si quiere añadir un nuevo disco a la base de datos
            ans1 = str(input('¿Le gustaria añadir un nuevo disco a la base de datos? Y/N ').upper())
            
            # Si dice que si, se le pide la información del disco
            if ans1 == "Y":
                titulo_disco = str(input('Introduzca el nombre del disco a introducir en la base de datos: '))
                ano_lanzamiento_disco = int(input('Introduzca el año de lanzamiento del disco: '))
                nombre_grupo = str(input('Introduzca el nombre del grupo: '))
                url_portada = 'http://' + titulo_disco + '.com'
                
                num_canciones = int(input('¿Cuantas canciones deseas introducir en el disco?'))

                canciones = []

                for i in range(num_canciones):
                    titulo_cancion = str(input(f'Introduzca el nombre de la canción {i + 1}: '))
                    duracion = str(input(f'Introduzca la duración de la canción {i + 1} {{HH:MM:SS}}: ')) 
                    canciones.append([ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion])

                
                cur = conn.cursor()
                # Verificar si el grupo existe, si no, insertarlo
                cur.execute('SELECT 1 FROM Pl2_final.grupos WHERE nombre_grupo = %s', (nombre_grupo,))
                if not cur.fetchone():
                    cur.execute('INSERT INTO Pl2_final.grupos (nombre_grupo, URL) VALUES (%s, %s)', (nombre_grupo, url_portada))
                    conn.commit()

                # Insertar el nuevo disco
                cur.execute('INSERT INTO Pl2_final.discos (titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada) VALUES (%s, %s, %s, %s)',
                            (titulo_disco, ano_lanzamiento_disco, nombre_grupo, url_portada))
                conn.commit()

                # Insertar canciones
                for cancion in canciones:
                    cur.execute("INSERT INTO Pl2_final.canciones (ano_lanzamiento_disco, titulo_disco, titulo_cancion, duracion) VALUES (%s, %s, %s, %s)",
                                (cancion[0], cancion[1], cancion[2], cancion[3]))
                    conn.commit()
                cur.close()
            
            else:
                pass


        elif user == 'invitado_usr':
            ans = str(input("¿Le gustaría realizar una consulta como invitado? Y/N ").upper())
            if ans == "Y": 
                print('1. Consultar los grupos')
                print('2. Consultar los discos')
                print('3. Consultar las ediciones')
                eleccion = int(input('Seleccione por favor una opción: '))

                if eleccion == 1:
                    query = 'SELECT * FROM Pl2_final.grupos' #Aqui se pone el codigo de las consultas. 
                elif eleccion == 2:
                    query = 'SELECT * FROM Pl2_final.discos'
                elif eleccion == 3:
                    query = 'SELECT * FROM Pl2_final.ediciones'
                else:
                    print('La opción seleccionada no es válida.')

                if query:
                    cur.execute(query)                                                      
                for record in cur.fetchall():                                           
                    print(record)
        
        else:
            eleccion = str(input('¿Deseas consultar o insertar? (C/I)').upper())
            if eleccion == 'C':
                print('\n1. Consultar las ediciones que poseen los usuarios.')
                print('2. Consultar los discos deseados por los usuarios')
                eleccion = int(input('\nSeleccione por favor una opción: '))

                if eleccion == 1:
                    query = "SELECT * FROM Pl2_final.usuario_tiene_edicion"  
                elif eleccion == 2:
                    query = "SELECT * FROM Pl2_final.usuario_desea_disco"
                else:
                    print('La opción seleccionada no es válida.')

                if query:
                    cur.execute(query)                                                      
                for record in cur.fetchall():                                           
                    print(record)
            elif eleccion == 'I':
                print('1. Insertar una nueva edición.')
                print('2. Inserta un disco que desees.')
                eleccion = int(input('Seleccione por favor una opción (1/2): '))

                if eleccion == 1:
                    # Se pide la información de la nueva edición
                    ano_lanzamiento_d = int(input('Introduzca el año de lanzamiento del disco: '))
                    titulo_d = str(input('Introduzca el nombre del disco: '))
                    ano_edicion = int(input('Introduzca el año de la edición: '))
                    pais_edicion = str(input('Introduzca el país de la edición: '))
                    formato = str(input('Introduzca el formato de la edición: {Vynil/File/CD}'))
                    nom_usuario = str(input('Introduzca tu nombre de usuario: '))
                    estado = str(input('Introduzca el estado de la edición: {NM/VG/M/G/F/EX}'))
                    cur.execute('INSERT INTO Pl2_final.usuario_tiene_edicion (ano_lanzamiento_disco, titulo_disco, ano_edicion, pais_edicion, formato, nombre_usuario, estado) VALUES (%s, %s, %s, %s, %s, %s, %s)',
                                (ano_lanzamiento_d, titulo_d, ano_edicion, pais_edicion, formato, nom_usuario, estado))
                    conn.commit()
                
                elif eleccion == 2:
                    ano_lanzamiento_d = int(input('Introduzca el año de lanzamiento del disco: '))
                    titulo_d = str(input('Introduzca el nombre del disco: '))
                    nom_usuario = str(input('Introduzca tu nombre de usuario: '))
                    cur.execute('INSERT INTO Pl2_final.usuario_desea_disco (ano_lanzamiento_disco, titulo_disco, nombre_usuario) VALUES (%s, %s, %s)',
                                (ano_lanzamiento_d, titulo_d, nom_usuario))
                    conn.commit()

        cur.close()                                                               
        conn.close()                                                              
    except portException:
        print("The port is not valid!")
    except KeyboardInterrupt:
        print("Program interrupted by user.")
    except psycopg2.errors.InsufficientPrivilege:
        print('El usuario al que te has conectado no tiene permisos para realizar esta consulta')
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        print("Program finished")

if __name__ == "__main__":                                                      
    if '--test' in sys.argv:                                                    
        import doctest                                                          
        doctest.testmod()                                                       
    else:                                                                       
        main()                                                                  