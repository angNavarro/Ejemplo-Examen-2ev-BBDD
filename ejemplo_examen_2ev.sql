&DROP TABLE Estudiantes CASCADE CONSTRAINTS;
DROP TABLE Cursos CASCADE CONSTRAINTS;
DROP TABLE Inscripciones CASCADE CONSTRAINTS;
DROP TABLE Notas CASCADE CONSTRAINTS;

CREATE TABLE estudiantes(
	estudiante_id NUMBER (10) PRIMARY KEY,
    nombre VARCHAR2(50),
    apellido VARCHAR2(50),
    edad NUMBER(10),
    email VARCHAR2(50)
    );

CREATE TABLE cursos(
	curso_id NUMBER (10) PRIMARY KEY,
    nombre VARCHAR2(50), 
    descripcion VARCHAR2(50),
    creditos NUMBER (10)
	);

CREATE TABLE inscripciones(
  	inscripcion_id NUMBER (10) PRIMARY KEY,
    estudiante_id NUMBER (10),
    curso_id NUMBER (10),
    fecha_inscripcion DATE 
    );

CREATE TABLE notas(
    nota_id NUMBER (10) PRIMARY KEY,
    estudiante_id NUMBER (10),
    curso_id NUMBER (10),
    nota NUMBER (10)
);

--Creamos restricciones claves ajenas. 
ALTER TABLE inscripciones ADD CONSTRAINT fk_inscripciones_estudiantes FOREIGN KEY (estudiante_id) REFERENCES estudiantes (estudiante_id);
ALTER TABLE inscripciones ADD CONSTRAINT fk_incripciones_cursos FOREIGN KEY (curso_id) REFERENCES cursos (curso_id);
ALTER TABLE notas ADD CONSTRAINT fk_notas_estudiantes FOREIGN KEY (estudiante_id) REFERENCES estudiantes (estudiante_id);
ALTER TABLE notas ADD CONSTRAINT fk_notas_curos FOREIGN KEY (curso_id) REFERENCES cursos (curso_id);

-- Realizar modificaciones. 
-- Eliminar descripcion de la tabla cursos.
ALTER TABLE cursos DROP COLUMN descripcion;

-- Añadir columna comentarios a notas. 
ALTER TABLE notas ADD comentarios VARCHAR2(50);


--Introducir datos en tablas 
INSERT INTO estudiantes VALUES (1, 'Juan', 		'Perez', 	20, 'juan@gmail.com'); --	tab
INSERT INTO estudiantes VALUES (2, 'Maria', 	'Gonzalez', 22, 'maria@example.com');
INSERT INTO estudiantes VALUES (3, 'Carlos',	'Martinez', 21, 'carlos@example.com');

INSERT INTO cursos VALUES (1, 'Matematicas',	12);
INSERT INTO cursos VALUES (2, 'Historia', 	    4);
INSERT INTO cursos VALUES (3, 'Ingles', 	    9);

INSERT INTO inscripciones VALUES (1, 1, 1, TO_DATE('10/02/24', 'DD/MM/YY'));
INSERT INTO inscripciones VALUES (2, 2, 2, TO_DATE('11/01/23', 'DD/MM/YY'));
INSERT INTO inscripciones VALUES (3, 3, 3, TO_DATE('12/12/20', 'DD/MM/YY'));

INSERT INTO notas VALUES (1, 1, 1, 8, 'Bien hecho');
INSERT INTO notas VALUES (2, 2, 2, 7, 'Buen trabajo');
INSERT INTO notas VALUES (3, 3, 3, 5, 'Justo');

-- SELECT * FROM estudiantes;
-- SELECT * FROM cursos;
-- SELECT * FROM inscripciones;
-- SELECT * FROM notas;

-- Realizar operaciones:
-- Elimina las inscripciones del día 11/01/23.
DELETE FROM inscripciones WHERE fecha_inscripcion = TO_DATE('11/01/23', 'DD/MM/YY'); 
-- SELECT * FROM inscripciones;

-- Modifica los apellidos del alumno 3 para que sea Martinez Gil.
UPDATE Estudiantes SET apellido = 'Martinez Gil' WHERE estudiante_id = 3;
-- SELECT * FROM estudiantes;

-- Modifica los comentarios de todas las notas que sean igual a 5, para que el comentario sea 'aprobado'.
UPDATE notas SET comentarios = 'aprobado' WHERE nota = 5;
--SELECT * FROM Notas;

--Consultas
-- Seleccionar el nombre de los cursos en los que estén matriculados aquellos alumnos que su edad sea de 20 años.

SELECT nombre FROM cursos WHERE curso_id IN(
    SELECT curso_id FROM inscripciones WHERE estudiante_id IN(
    	SELECT estudiante_id FROM estudiantes WHERE edad>20)
);

SELECT cursos.nombre FROM cursos 
 JOIN inscripciones ON cursos.curso_id = incripciones.curso_id
JOIN estudiantes ON incripciones.estudiantes_id = estuantes.estudiante_id
WHERE estudiantes.edad>20;

--Seleccionar el nombre, apellidos del alumno y nombre del curso, de aquellos alumnos que hayan sacado la máxima nota de entre todos los alumnos.

SELECT Estudiantes.nombre, Estudiantes.apellido, Cursos.nombre, Notas.nota 
FROM Estudiantes
WHERE Estudiantes.estudiante_id IN (
    SELECT estudiante_id
    FROM Notas
    WHERE nota = (SELECT MAX(nota) FROM Notas)
);


 SELECT estudiantes.nombre, estudiantes.apellido, cursos.nombre, notas.nota FROM estudiantes
 JOIN notas ON estudiantes.estudiante_id = notas.estudiante_id
 JOIN cursos ON notas.curso_id = cursos.curso_id
WHERE notas.nota = (SELECT MAX(nota) FROM notas);

--Seleccionar el nombre del curso y su nota media, del curso con la nota media más alta.

SELECT Cursos.nombre, AVG(Notas.nota) AS "Nota media más alta"
FROM Notas, Cursos
WHERE Notas.curso_id = Cursos.curso_id
  AND AVG(Notas.nota) = (
    SELECT MAX(AVG(nota))
    FROM Notas
    GROUP BY curso_id
  )
GROUP BY Cursos.nombre;

 SELECT Cursos.nombre, AVG(Notas.nota) AS "Nota media más alta"
 FROM Notas
JOIN Cursos ON Cursos.curso_id = Notas.curso_id
 GROUP BY Cursos.nombre
 HAVING AVG(Notas.nota) = (
    SELECT MAX(AVG(nota))
   FROM Notas
     GROUP BY curso_id
 );

--Seleccionar el nombre de los cursos junto con el número de estudiantes inscritos en cada curso.

SELECT Cursos.nombre AS "Curso", COUNT(*) AS "Total alumnos inscritos"
FROM Cursos
WHERE Cursos.curso_id IN (
    SELECT curso_id
    FROM Inscripciones
)
GROUP BY Cursos.nombre;

 SELECT Cursos.nombre AS "Curso", COUNT(*) AS "Total alumnos inscritos"
 FROM Cursos
 JOIN Inscripciones ON Inscripciones.curso_id = Cursos.curso_id
 GROUP BY Cursos.nombre, Inscripciones.curso_id;

--Seleccionar el nombre y apellido de los estudiantes que tienen al menos una nota registrada, junto con el curso en el que tienen la nota.

SELECT Estudiantes.nombre, Estudiantes.apellido
FROM Estudiantes
WHERE Estudiantes.estudiante_id IN (
    SELECT estudiante_id
    FROM Notas
)
GROUP BY Estudiantes.nombre, Estudiantes.apellido
HAVING COUNT(*) >= 1;

 SELECT Estudiantes.nombre, Estudiantes.apellido
FROM Estudiantes
 JOIN Notas ON Notas.estudiante_id = Estudiantes.estudiante_id
 GROUP BY Estudiantes.nombre, Estudiantes.apellido
 HAVING COUNT(*) >= 1;