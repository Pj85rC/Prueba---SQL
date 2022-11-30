--PRUEBA FINAL

CREATE DATABASE desafio_prueba_final_patricio_ramirez_g21;

\c desafio_prueba_final_patricio_ramirez_g21

1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos. (1 punto).

CREATE TABLE films(
    id SERIAL PRIMARY KEY,
    names VARCHAR(255),
    years INTEGER
);

CREATE TABLE tags(
    id SERIAL PRIMARY KEY,
    tag VARCHAR(32)
);

CREATE TABLE films_tags(
    id_film INT,
    id_tag INT,
    FOREIGN KEY(id_film) REFERENCES films(id),
    FOREIGN KEY(id_tag) REFERENCES tags(id)
);

2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. (1 punto)

--Insert Films
INSERT INTO films (names, years) VALUES('Alien', 1979);
INSERT INTO films (names, years) VALUES('Lord of the Rings: The Return of the King', 2001);
INSERT INTO films (names, years) VALUES('The Shinning', 1980);
INSERT INTO films (names, years) VALUES('The godfather', 1972);
INSERT INTO films (names, years) VALUES('Fight Club', 1999);

SELECT * FROM films;

--Insert Tags
INSERT INTO tags (tag) VALUES('Horror');
INSERT INTO tags (tag) VALUES('Cult Movie');
INSERT INTO tags (tag) VALUES('Crime');
INSERT INTO tags (tag) VALUES('Adventure');
INSERT INTO tags (tag) VALUES('Sci-Fi');

SELECT * FROM tags;

--Insert films_tags
INSERT INTO films_tags (id_film, id_tag) VALUES (1,1);
INSERT INTO films_tags (id_film, id_tag) VALUES (1,2);
INSERT INTO films_tags (id_film, id_tag) VALUES (1,5);
INSERT INTO films_tags (id_film, id_tag) VALUES (2,2);
INSERT INTO films_tags (id_film, id_tag) VALUES (2,4);

SELECT * FROM films_tags;

3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0. (1 punto)
SELECT films.names, COUNT(films_tags.id_tag) AS number_of_tags 
FROM films
LEFT JOIN films_tags ON films.id = films_tags.id_film
GROUP BY films.names;

4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. (1 punto)
CREATE TABLE Preguntas(
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

CREATE TABLE Usuarios(
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INT
);

CREATE TABLE Respuestas (
    usuario_id SERIAL,
    pregunta_id SERIAL, 
    respuesta VARCHAR(255),
    FOREIGN KEY(usuario_id) REFERENCES Usuarios(id),
    FOREIGN KEY(pregunta_id) REFERENCES Preguntas(id)
);

5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
(1 punto)
a. Contestada correctamente significa que la respuesta indicada en la tabla
respuestas es exactamente igual al texto indicado en la tabla de preguntas.
--Insert Usuarios
INSERT INTO usuarios (nombre, edad) VALUES ('Eric Cartman',12);
INSERT INTO usuarios (nombre, edad) VALUES ('Kenny McCormick',10);
INSERT INTO usuarios (nombre, edad) VALUES ('Stan Marsh',10);
INSERT INTO usuarios (nombre, edad) VALUES ('Kyle Broflovski',10);
INSERT INTO usuarios (nombre, edad) VALUES ('Butters', 10);

SELECT * FROM usuarios;

--Insert Preguntas
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('Según South Park, ¿Cuáles son los efectos secundarios de tomar Ritalín?', 'Ver bichos de color rosa con la cara de Christina Aguilera' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuál es el personaje que tiene fama de morir en todos los capítulos?', 'Kenny McCormick' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Dónde se encuentra situado el pueblo de South Park?', 'Colorado' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cómo se llama el profesor por excelencia de los protagonistas?', 'Señor Garrison' );
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES (' ¿Qué tipo de personaje es el de Cartman en el World of Warcraft?', 'Enano' );

SELECT * FROM preguntas;

--Insert respuestas
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Ver bichos de color rosa con la cara de Christina Aguilera',1,1);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Kenny McCormick',4,2);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Ver bichos de color rosa con la cara de Christina Aguilera',3,1);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Malo malito',5,5);
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id ) VALUES('Profesor rosa',2,4);

SELECT * FROM respuestas;

6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta). (1 punto)
SELECT u.id, u.nombre, COUNT(r.respuesta)
FROM usuarios u
LEFT JOIN respuestas r
ON u.id = r.usuario_id
LEFT JOIN preguntas p 
ON r.pregunta_id = p.id
WHERE p.respuesta_correcta = r.respuesta
GROUP by u.id, u.nombre;

7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta. (1 punto)
SELECT p.pregunta , COUNT(r.respuesta) AS N_USERS
FROM usuarios AS u
LEFT JOIN respuestas r
ON u.id = r.usuario_id
LEFT JOIN preguntas AS p 
ON r.pregunta_id = p.id
WHERE p.respuesta_correcta = r.respuesta
GROUP by p.pregunta;


8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación. (1 punto)
ALTER TABLE Respuestas DROP CONSTRAINT respuestas_usuario_id_fkey, ADD FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE;

DELETE FROM usuarios WHERE ID = 1;

9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos. (1 punto)
ALTER TABLE Usuarios ADD CHECK (edad >18 );

10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único. (1 punto)
ALTER TABLE Usuarios 
ADD email VARCHAR(255) UNIQUE;

SELECT * FROM Usuarios;
\d Usuarios