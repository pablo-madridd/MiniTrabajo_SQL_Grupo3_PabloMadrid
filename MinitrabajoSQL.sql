-- create_stremaing_musical.sql
-- (tip: usa utf8mb4 para emojis y caracteres especiales)


CREATE DATABASE streaming_musical;

USE streaming_musical;

-- 1) USUARIOS
CREATE TABLE usuarios (
  usuario_id       INT AUTO_INCREMENT PRIMARY KEY,
  nombre           VARCHAR(100) NOT NULL,
  email            VARCHAR(150) NOT NULL UNIQUE,
  pais             VARCHAR(80)  NOT NULL,
  fecha_registro   DATE         NOT NULL,
  INDEX idx_usuarios_pais (pais),
  INDEX idx_usuarios_fecha (fecha_registro)
) ENGINE=InnoDB;

-- 2) PLANES
CREATE TABLE planes (
  plan_id     INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(80) NOT NULL UNIQUE,
  precio      DECIMAL(10,2) NOT NULL,
  descripcion TEXT NULL
) ENGINE=InnoDB;

-- 3) SUSCRIPCIONES (histórico)
CREATE TABLE suscripciones (
  suscripcion_id  INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id      INT NOT NULL,
  plan_id         INT NOT NULL,
  fecha_inicio    DATE NOT NULL,
  fecha_fin       DATE NULL,
  estado          ENUM('activa','vencida','cancelada') NOT NULL,
  CONSTRAINT fk_susc_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_susc_plan
    FOREIGN KEY (plan_id) REFERENCES planes(plan_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_susc_usuario (usuario_id),
  INDEX idx_susc_plan (plan_id),
  INDEX idx_susc_estado (estado),
  INDEX idx_susc_inicio (fecha_inicio),
  INDEX idx_susc_fin (fecha_fin)
) ENGINE=InnoDB;

-- 4) ARTISTAS
CREATE TABLE artistas (
  artista_id        INT AUTO_INCREMENT PRIMARY KEY,
  nombre            VARCHAR(120) NOT NULL,
  pais              VARCHAR(80)  NOT NULL,
  genero_principal  VARCHAR(60)  NOT NULL,
  INDEX idx_artistas_nombre (nombre),
  INDEX idx_artistas_genero (genero_principal)
) ENGINE=InnoDB;

-- 5) ALBUMES
CREATE TABLE albumes (
  album_id          INT AUTO_INCREMENT PRIMARY KEY,
  artista_id        INT NOT NULL,
  titulo            VARCHAR(150) NOT NULL,
  fecha_lanzamiento DATE NOT NULL,
  genero            VARCHAR(60)  NOT NULL,
  CONSTRAINT fk_alb_artista
    FOREIGN KEY (artista_id) REFERENCES artistas(artista_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_albumes_artista (artista_id),
  INDEX idx_albumes_fecha (fecha_lanzamiento),
  INDEX idx_albumes_genero (genero)
) ENGINE=InnoDB;

-- 6) CANCIONES
CREATE TABLE canciones (
  cancion_id          INT AUTO_INCREMENT PRIMARY KEY,
  album_id            INT NOT NULL,
  titulo              VARCHAR(150) NOT NULL,
  duracion_seg        INT NOT NULL,
  num_reproducciones  INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_cancion_album
    FOREIGN KEY (album_id) REFERENCES albumes(album_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_canciones_album (album_id),
  INDEX idx_canciones_titulo (titulo),
  INDEX idx_canciones_numrep (num_reproducciones)
) ENGINE=InnoDB;

-- 7) PLAYLISTS
CREATE TABLE playlists (
  playlist_id    INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id     INT NOT NULL,
  nombre         VARCHAR(120) NOT NULL,
  fecha_creacion DATE NOT NULL,
  CONSTRAINT fk_playlist_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_playlists_usuario (usuario_id),
  INDEX idx_playlists_fecha (fecha_creacion)
) ENGINE=InnoDB;

-- 8) PLAYLIST_CANCION (N:M)
CREATE TABLE playlist_cancion (
  playlist_id     INT NOT NULL,
  cancion_id      INT NOT NULL,
  fecha_agregado  DATETIME NOT NULL,
  PRIMARY KEY (playlist_id, cancion_id),
  CONSTRAINT fk_pc_playlist
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pc_cancion
    FOREIGN KEY (cancion_id) REFERENCES canciones(cancion_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_pc_fecha (fecha_agregado)
) ENGINE=InnoDB;

-- 9) HISTORIAL_REPRODUCCION
CREATE TABLE historial_reproduccion (
  historial_id       BIGINT AUTO_INCREMENT PRIMARY KEY,
  usuario_id         INT NOT NULL,
  cancion_id         INT NOT NULL,
  fecha_reproduccion DATETIME NOT NULL,
  CONSTRAINT fk_hist_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_hist_cancion
    FOREIGN KEY (cancion_id) REFERENCES canciones(cancion_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_hist_usuario (usuario_id),
  INDEX idx_hist_cancion (cancion_id),
  INDEX idx_hist_fecha (fecha_reproduccion)
) ENGINE=InnoDB;

-- 10) LIKES
CREATE TABLE likes (
  like_id     BIGINT AUTO_INCREMENT PRIMARY KEY,
  usuario_id  INT NOT NULL,
  cancion_id  INT NOT NULL,
  fecha_like  DATETIME NOT NULL,
  CONSTRAINT fk_like_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_like_cancion
    FOREIGN KEY (cancion_id) REFERENCES canciones(cancion_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uk_like_user_song (usuario_id, cancion_id),
  INDEX idx_like_fecha (fecha_like)
) ENGINE=InnoDB;


USE streaming_musical;

-- ========================
-- 1) PLANES
-- ========================
INSERT INTO planes (nombre, precio, descripcion) VALUES
('Free', 0.00, 'Acceso limitado con anuncios'),
('Premium Individual', 9.99, 'Acceso ilimitado para un usuario'),
('Familiar', 14.99, 'Hasta 6 cuentas premium'),
('Estudiante', 4.99, 'Descuento especial para estudiantes');

-- ========================
-- 2) USUARIOS
-- ========================
INSERT INTO usuarios (nombre, email, pais, fecha_registro) VALUES
('Ana López','ana@gmail.com','España','2023-01-12'),
('Carlos Pérez','carlos@gmail.com','México','2023-02-05'),
('María Torres','maria@gmail.com','Argentina','2023-03-11'),
('José Fernández','jose@gmail.com','Chile','2023-04-02'),
('Lucía Romero','lucia@gmail.com','España','2023-04-15'),
('Pedro Sánchez','pedro@gmail.com','Colombia','2023-05-20'),
('Valentina Ríos','vale@gmail.com','México','2023-06-01'),
('Diego Castro','diego@gmail.com','Argentina','2023-06-07'),
('Andrea Suárez','andrea@gmail.com','España','2023-06-20'),
('Miguel Ángel','miguel@gmail.com','Chile','2023-07-02'),
('Sofía Martínez','sofia@gmail.com','Colombia','2023-07-10'),
('Raúl Jiménez','raul@gmail.com','México','2023-07-18'),
('Camila Herrera','camila@gmail.com','España','2023-07-25'),
('Javier Alonso','javier@gmail.com','Argentina','2023-08-03'),
('Fernanda Silva','fer@gmail.com','México','2023-08-12');

-- ========================
-- 3) SUSCRIPCIONES
-- ========================
INSERT INTO suscripciones (usuario_id, plan_id, fecha_inicio, fecha_fin, estado) VALUES
(1,2,'2023-01-12','2024-01-11','activa'),
(2,1,'2023-02-05',NULL,'activa'),
(3,4,'2023-03-11','2024-03-10','activa'),
(4,2,'2023-04-02','2024-04-01','activa'),
(5,3,'2023-04-15','2024-04-14','activa'),
(6,2,'2023-05-20','2023-11-20','vencida'),
(7,2,'2023-06-01','2024-05-31','activa'),
(8,1,'2023-06-07',NULL,'activa'),
(9,3,'2023-06-20','2024-06-19','activa'),
(10,2,'2023-07-02','2024-07-01','activa'),
(11,2,'2023-07-10','2024-07-09','activa'),
(12,3,'2023-07-18','2024-07-17','activa'),
(13,2,'2023-07-25','2024-07-24','activa'),
(14,4,'2023-08-03','2024-08-02','activa'),
(15,1,'2023-08-12',NULL,'activa');

-- ========================
-- 4) ARTISTAS
-- ========================
INSERT INTO artistas (nombre, pais, genero_principal) VALUES
('Shakira','Colombia','Pop'),
('Bad Bunny','Puerto Rico','Reggaetón'),
('Coldplay','Reino Unido','Rock'),
('Dua Lipa','Reino Unido','Pop'),
('Maluma','Colombia','Reggaetón'),
('Bizarrap','Argentina','Electrónica'),
('Taylor Swift','EEUU','Pop'),
('Ed Sheeran','Reino Unido','Pop'),
('Karol G','Colombia','Reggaetón'),
('Arctic Monkeys','Reino Unido','Indie');

-- ========================
-- 5) ALBUMES
-- ========================
INSERT INTO albumes (artista_id, titulo, fecha_lanzamiento, genero) VALUES
(1,'Oral Fixation','2005-11-29','Pop'),
(2,'YHLQMDLG','2020-02-29','Reggaetón'),
(3,'Parachutes','2000-07-10','Rock'),
(4,'Future Nostalgia','2020-03-27','Pop'),
(5,'Papi Juancho','2020-08-21','Reggaetón'),
(6,'BZRP Sessions','2021-01-15','Electrónica'),
(7,'Midnights','2022-10-21','Pop'),
(8,'Divide','2017-03-03','Pop'),
(9,'KG0516','2021-03-26','Reggaetón'),
(10,'AM','2013-09-09','Indie');

-- ========================
-- 6) CANCIONES
-- ========================
INSERT INTO canciones (album_id, titulo, duracion_seg, num_reproducciones) VALUES
(1,'Hips Don’t Lie',220,1500),
(1,'La Tortura',200,1200),
(2,'Safaera',300,2500),
(2,'Yo Perreo Sola',210,2700),
(3,'Yellow',270,1900),
(3,'Trouble',260,800),
(4,'Don’t Start Now',180,2200),
(4,'Levitating',200,2100),
(5,'Hawái',220,2400),
(6,'Music Session #52',210,3000),
(7,'Anti-Hero',200,1800),
(8,'Shape of You',240,3500),
(9,'Tusa',230,2800),
(10,'Do I Wanna Know?',240,2600),
(10,'R U Mine?',250,900);

-- ========================
-- 7) PLAYLISTS
-- ========================
INSERT INTO playlists (usuario_id, nombre, fecha_creacion) VALUES
(1,'Favoritos Ana','2023-01-20'),
(2,'Mix Carlos','2023-02-10'),
(3,'Hits María','2023-03-15'),
(4,'Lo mejor de José','2023-04-10'),
(5,'Latinos Top','2023-04-20'),
(6,'Relax Beats','2023-05-25'),
(7,'Reggaetón Mix','2023-06-03'),
(8,'Electro Vibes','2023-06-10'),
(9,'Pop Party','2023-06-22'),
(10,'Indie Zone','2023-07-05'),
(11,'Workout','2023-07-12'),
(12,'Favoritos Raúl','2023-07-20'),
(13,'Chill Camila','2023-07-28'),
(14,'Top Javier','2023-08-05'),
(15,'Lo mejor de Fer','2023-08-15');

-- ========================
-- 8) PLAYLIST_CANCION
-- ========================
INSERT INTO playlist_cancion (playlist_id, cancion_id, fecha_agregado) VALUES
(1,1,'2023-01-20 10:00:00'),
(1,3,'2023-01-20 10:05:00'),
(2,4,'2023-02-10 12:00:00'),
(2,12,'2023-02-10 12:10:00'),
(3,5,'2023-03-15 09:00:00'),
(3,6,'2023-03-15 09:05:00'),
(4,7,'2023-04-10 11:00:00'),
(5,9,'2023-04-20 14:00:00'),
(6,10,'2023-05-25 15:00:00'),
(7,13,'2023-06-03 18:00:00'),
(8,10,'2023-06-10 20:00:00'),
(9,11,'2023-06-22 21:00:00'),
(10,14,'2023-07-05 19:00:00'),
(11,12,'2023-07-12 08:00:00'),
(12,2,'2023-07-20 17:00:00');

-- ========================
-- 9) HISTORIAL_REPRODUCCION
-- ========================
INSERT INTO historial_reproduccion (usuario_id, cancion_id, fecha_reproduccion) VALUES
(1,1,'2023-08-01 10:00:00'),
(1,3,'2023-08-01 10:05:00'),
(2,4,'2023-08-02 11:00:00'),
(3,5,'2023-08-03 12:00:00'),
(4,7,'2023-08-04 13:00:00'),
(5,9,'2023-08-05 14:00:00'),
(6,10,'2023-08-06 15:00:00'),
(7,13,'2023-08-07 16:00:00'),
(8,12,'2023-08-08 17:00:00'),
(9,11,'2023-08-09 18:00:00'),
(10,14,'2023-08-10 19:00:00'),
(11,12,'2023-08-11 20:00:00'),
(12,2,'2023-08-12 21:00:00'),
(13,6,'2023-08-13 22:00:00'),
(14,15,'2023-08-14 23:00:00');

-- ========================
-- 10) LIKES
-- ========================
INSERT INTO likes (usuario_id, cancion_id, fecha_like) VALUES
(1,1,'2023-08-01 10:10:00'),
(2,4,'2023-08-02 11:10:00'),
(3,5,'2023-08-03 12:10:00'),
(4,7,'2023-08-04 13:10:00'),
(5,9,'2023-08-05 14:10:00'),
(6,10,'2023-08-06 15:10:00'),
(7,13,'2023-08-07 16:10:00'),
(8,12,'2023-08-08 17:10:00'),
(9,11,'2023-08-09 18:10:00'),
(10,14,'2023-08-10 19:10:00'),
(11,12,'2023-08-11 20:10:00'),
(12,2,'2023-08-12 21:10:00'),
(13,6,'2023-08-13 22:10:00'),
(14,15,'2023-08-14 23:10:00'),
(15,3,'2023-08-15 09:10:00');

USE streaming_musical;

-- Q01: Listar todas las canciones con el nombre de su álbum y artista
SELECT c.titulo AS cancion, a.titulo AS album, ar.nombre AS artista
FROM canciones c
JOIN albumes a ON c.album_id = a.album_id
JOIN artistas ar ON a.artista_id = ar.artista_id;

-- Q02: Mostrar usuarios y el plan al que están suscritos
SELECT u.nombre, p.nombre AS plan, s.estado
FROM usuarios u
JOIN suscripciones s ON u.usuario_id = s.usuario_id
JOIN planes p ON s.plan_id = p.plan_id;

-- Q03: Ver playlists de cada usuario junto con cuántas canciones contiene
SELECT u.nombre AS usuario, pl.nombre AS playlist, COUNT(pc.cancion_id) AS num_canciones
FROM playlists pl
JOIN usuarios u ON pl.usuario_id = u.usuario_id
LEFT JOIN playlist_cancion pc ON pl.playlist_id = pc.playlist_id
GROUP BY u.nombre, pl.nombre;

-- Q04: Listar historial de reproducción con nombre de usuario y canción
SELECT u.nombre AS usuario, c.titulo AS cancion, h.fecha_reproduccion
FROM historial_reproduccion h
JOIN usuarios u ON h.usuario_id = u.usuario_id
JOIN canciones c ON h.cancion_id = c.cancion_id;

-- Q05: Mostrar canciones y si tienen “likes”, junto con el usuario que dio like
SELECT c.titulo AS cancion, u.nombre AS usuario, l.fecha_like
FROM canciones c
LEFT JOIN likes l ON c.cancion_id = l.cancion_id
LEFT JOIN usuarios u ON l.usuario_id = u.usuario_id;

-- Q06: Usuarios que tienen más de 1 playlist
SELECT u.nombre, COUNT(pl.playlist_id) AS total_playlists
FROM usuarios u
JOIN playlists pl ON u.usuario_id = pl.usuario_id
GROUP BY u.usuario_id
HAVING COUNT(pl.playlist_id) > 1;

-- Q07: Canciones con más reproducciones que el promedio global
SELECT titulo, num_reproducciones
FROM canciones
WHERE num_reproducciones > (SELECT AVG(num_reproducciones) FROM canciones);

-- Q08: Artistas con al menos un álbum que tenga más de 3 canciones
SELECT DISTINCT ar.nombre
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
GROUP BY ar.artista_id, a.album_id
HAVING COUNT(c.cancion_id) > 3;

-- Q09: Usuarios que dieron like a la canción más popular (más reproducida)
SELECT DISTINCT u.nombre, c.titulo
FROM likes l
JOIN usuarios u ON l.usuario_id = u.usuario_id
JOIN canciones c ON l.cancion_id = c.cancion_id
WHERE c.num_reproducciones = (SELECT MAX(num_reproducciones) FROM canciones);

-- Q10: Canciones reproducidas por más de 2 usuarios distintos
SELECT c.titulo, COUNT(DISTINCT h.usuario_id) AS oyentes
FROM historial_reproduccion h
JOIN canciones c ON h.cancion_id = c.cancion_id
GROUP BY c.cancion_id
HAVING COUNT(DISTINCT h.usuario_id) > 2;

-- Q11: Top 5 canciones más reproducidas
SELECT titulo, num_reproducciones
FROM canciones
ORDER BY num_reproducciones DESC
LIMIT 5;

-- Q12: Cantidad total de likes por artista
SELECT ar.nombre AS artista, COUNT(l.like_id) AS total_likes
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
LEFT JOIN likes l ON c.cancion_id = l.cancion_id
GROUP BY ar.artista_id;

-- Q13: Promedio de duración de canciones por género
SELECT a.genero, AVG(c.duracion_seg) AS promedio_duracion
FROM canciones c
JOIN albumes a ON c.album_id = a.album_id
GROUP BY a.genero;

-- Q14: Número de usuarios suscritos a cada plan
SELECT p.nombre AS plan, COUNT(DISTINCT s.usuario_id) AS num_usuarios
FROM planes p
LEFT JOIN suscripciones s ON p.plan_id = s.plan_id
GROUP BY p.plan_id;

-- Q15: El usuario con más reproducciones en el historial
SELECT u.nombre, COUNT(h.historial_id) AS total_reproducciones
FROM usuarios u
JOIN historial_reproduccion h ON u.usuario_id = h.usuario_id
GROUP BY u.usuario_id
ORDER BY total_reproducciones DESC
LIMIT 1;

-- Q16: Las 10 canciones más reproducidas
SELECT titulo, num_reproducciones
FROM canciones
ORDER BY num_reproducciones DESC
LIMIT 10;

-- Q17: Usuarios que tienen plan activo
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN suscripciones s ON u.usuario_id = s.usuario_id
WHERE s.estado = 'activa';

-- Q18: Listar las playlists con su cantidad respectiva de canciones
SELECT pl.nombre AS playlist, COUNT(pc.cancion_id) AS num_canciones
FROM playlists pl
LEFT JOIN playlist_cancion pc ON pl.playlist_id = pc.playlist_id
GROUP BY pl.playlist_id;

-- Q19: Listar las canciones reproducidas el último mes
SELECT DISTINCT c.titulo, h.fecha_reproduccion
FROM historial_reproduccion h
JOIN canciones c ON h.cancion_id = c.cancion_id
WHERE h.fecha_reproduccion >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- Q20: Usuarios que escucharon un mismo artista más de 2 veces
SELECT u.nombre, ar.nombre AS artista, COUNT(*) AS total_reproducciones
FROM historial_reproduccion h
JOIN usuarios u ON h.usuario_id = u.usuario_id
JOIN canciones c ON h.cancion_id = c.cancion_id
JOIN albumes a ON c.album_id = a.album_id
JOIN artistas ar ON a.artista_id = ar.artista_id
GROUP BY u.usuario_id, ar.artista_id
HAVING COUNT(*) > 2;

-- Q21: Canciones con duración mayor al promedio
SELECT titulo, duracion_seg
FROM canciones
WHERE duracion_seg > (SELECT AVG(duracion_seg) FROM canciones);

-- Q22: Álbum con más reproducciones totales
SELECT a.titulo, SUM(c.num_reproducciones) AS total_reproducciones
FROM albumes a
JOIN canciones c ON a.album_id = c.album_id
GROUP BY a.album_id
ORDER BY total_reproducciones DESC
LIMIT 1;

-- Q23: Género musical más popular según reproducciones
SELECT a.genero, SUM(c.num_reproducciones) AS total_reproducciones
FROM albumes a
JOIN canciones c ON a.album_id = c.album_id
GROUP BY a.genero
ORDER BY total_reproducciones DESC
LIMIT 1;

-- Q24: Usuario con más likes dados
SELECT u.nombre, COUNT(l.like_id) AS total_likes
FROM usuarios u
JOIN likes l ON u.usuario_id = l.usuario_id
GROUP BY u.usuario_id
ORDER BY total_likes DESC
LIMIT 1;

-- Q25: Canciones que nunca han sido reproducidas
SELECT c.titulo
FROM canciones c
LEFT JOIN historial_reproduccion h ON c.cancion_id = h.cancion_id
WHERE h.cancion_id IS NULL;

USE streaming_musical;

-- Q26: Playlists con canciones de más de 2 géneros diferentes
SELECT pl.nombre, COUNT(DISTINCT a.genero) AS generos_distintos
FROM playlists pl
JOIN playlist_cancion pc ON pl.playlist_id = pc.playlist_id
JOIN canciones c ON pc.cancion_id = c.cancion_id
JOIN albumes a ON c.album_id = a.album_id
GROUP BY pl.playlist_id
HAVING COUNT(DISTINCT a.genero) > 2;

-- Q27: Usuarios que escucharon canciones de al menos 3 artistas distintos
SELECT u.nombre, COUNT(DISTINCT ar.artista_id) AS artistas_distintos
FROM historial_reproduccion h
JOIN usuarios u ON h.usuario_id = u.usuario_id
JOIN canciones c ON h.cancion_id = c.cancion_id
JOIN albumes a ON c.album_id = a.album_id
JOIN artistas ar ON a.artista_id = ar.artista_id
GROUP BY u.usuario_id
HAVING COUNT(DISTINCT ar.artista_id) >= 3;

-- Q28: Ranking de artistas por número de oyentes únicos
SELECT ar.nombre AS artista, COUNT(DISTINCT h.usuario_id) AS oyentes_unicos
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
JOIN historial_reproduccion h ON c.cancion_id = h.cancion_id
GROUP BY ar.artista_id
ORDER BY oyentes_unicos DESC;

-- Q29: Plan con mayor ingreso generado (precio * suscriptores activos)
SELECT p.nombre, SUM(p.precio) AS ingresos_totales
FROM planes p
JOIN suscripciones s ON p.plan_id = s.plan_id
WHERE s.estado = 'activa'
GROUP BY p.plan_id
ORDER BY ingresos_totales DESC
LIMIT 1;

-- Q30: Canciones agregadas a playlists en los últimos 7 días
SELECT DISTINCT c.titulo, pc.fecha_agregado
FROM playlist_cancion pc
JOIN canciones c ON pc.cancion_id = c.cancion_id
WHERE pc.fecha_agregado >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- Q31: Listar los 5 artistas con mayor cantidad de canciones en la plataforma
SELECT ar.nombre, COUNT(c.cancion_id) AS total_canciones
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
GROUP BY ar.artista_id
ORDER BY total_canciones DESC
LIMIT 5;

-- Q32: Mostrar los álbumes lanzados después del año 2020 junto con su artista
SELECT a.titulo AS album, ar.nombre AS artista, a.fecha_lanzamiento
FROM albumes a
JOIN artistas ar ON a.artista_id = ar.artista_id
WHERE YEAR(a.fecha_lanzamiento) > 2020;

-- Q33: Obtener los usuarios que nunca han creado una playlist
SELECT u.nombre
FROM usuarios u
LEFT JOIN playlists pl ON u.usuario_id = pl.usuario_id
WHERE pl.playlist_id IS NULL;

-- Q34: Mostrar las canciones que aparecen en más de 2 playlists distintas
SELECT c.titulo, COUNT(DISTINCT pc.playlist_id) AS num_playlists
FROM canciones c
JOIN playlist_cancion pc ON c.cancion_id = pc.cancion_id
GROUP BY c.cancion_id
HAVING COUNT(DISTINCT pc.playlist_id) > 2;

-- Q35: Listar los artistas que tienen canciones con más de 1,000 reproducciones
SELECT DISTINCT ar.nombre
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
WHERE c.num_reproducciones > 1000;

-- Q36: Mostrar el top 3 de usuarios con más canciones reproducidas en total
SELECT u.nombre, COUNT(h.historial_id) AS total_reproducciones
FROM usuarios u
JOIN historial_reproduccion h ON u.usuario_id = h.usuario_id
GROUP BY u.usuario_id
ORDER BY total_reproducciones DESC
LIMIT 3;

-- Q37: Listar las playlists que contienen al menos una canción de cada género musical
SELECT pl.nombre
FROM playlists pl
JOIN playlist_cancion pc ON pl.playlist_id = pc.playlist_id
JOIN canciones c ON pc.cancion_id = c.cancion_id
JOIN albumes a ON c.album_id = a.album_id
GROUP BY pl.playlist_id
HAVING COUNT(DISTINCT a.genero) = (SELECT COUNT(DISTINCT genero) FROM albumes);

-- Q38: Mostrar los usuarios que tienen una suscripción vencida
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN suscripciones s ON u.usuario_id = s.usuario_id
WHERE s.estado = 'vencida';

-- Q39: Listar canciones que recibieron likes de más de 3 usuarios diferentes
SELECT c.titulo, COUNT(DISTINCT l.usuario_id) AS num_usuarios
FROM canciones c
JOIN likes l ON c.cancion_id = l.cancion_id
GROUP BY c.cancion_id
HAVING COUNT(DISTINCT l.usuario_id) > 3;

-- Q40: Mostrar los álbumes con la duración promedio de sus canciones
SELECT a.titulo AS album, AVG(c.duracion_seg) AS promedio_duracion
FROM albumes a
JOIN canciones c ON a.album_id = c.album_id
GROUP BY a.album_id;

-- Q41: Obtener los artistas que no tienen ningún álbum registrado
SELECT ar.nombre
FROM artistas ar
LEFT JOIN albumes a ON ar.artista_id = a.artista_id
WHERE a.album_id IS NULL;

-- Q42: Listar los usuarios que nunca han dado like a una canción
SELECT u.nombre
FROM usuarios u
LEFT JOIN likes l ON u.usuario_id = l.usuario_id
WHERE l.like_id IS NULL;

-- Q43: Mostrar las canciones más reproducidas por cada usuario (una por usuario)
SELECT u.nombre, c.titulo, COUNT(*) AS veces
FROM historial_reproduccion h
JOIN usuarios u ON h.usuario_id = u.usuario_id
JOIN canciones c ON h.cancion_id = c.cancion_id
GROUP BY u.usuario_id, c.cancion_id
HAVING COUNT(*) = (
  SELECT MAX(subcount) FROM (
    SELECT COUNT(*) AS subcount
    FROM historial_reproduccion h2
    WHERE h2.usuario_id = u.usuario_id
    GROUP BY h2.cancion_id
  ) AS subquery
);

-- Q44: Listar el top 5 de canciones más agregadas a playlists
SELECT c.titulo, COUNT(pc.playlist_id) AS veces_agregada
FROM canciones c
JOIN playlist_cancion pc ON c.cancion_id = pc.cancion_id
GROUP BY c.cancion_id
ORDER BY veces_agregada DESC
LIMIT 5;

-- Q45: Mostrar el plan con menor número de usuarios suscritos
SELECT p.nombre, COUNT(DISTINCT s.usuario_id) AS total_usuarios
FROM planes p
LEFT JOIN suscripciones s ON p.plan_id = s.plan_id
GROUP BY p.plan_id
ORDER BY total_usuarios ASC
LIMIT 1;

-- Q46: Listar las canciones reproducidas por usuarios de un país específico (ejemplo: México)
SELECT DISTINCT c.titulo, u.pais
FROM historial_reproduccion h
JOIN usuarios u ON h.usuario_id = u.usuario_id
JOIN canciones c ON h.cancion_id = c.cancion_id
WHERE u.pais = 'México';

-- Q47: Mostrar los artistas cuyo género principal coincide con el género más popular en reproducciones
SELECT DISTINCT ar.nombre, ar.genero_principal
FROM artistas ar
WHERE ar.genero_principal = (
  SELECT a.genero
  FROM albumes a
  JOIN canciones c ON a.album_id = c.album_id
  GROUP BY a.genero
  ORDER BY SUM(c.num_reproducciones) DESC
  LIMIT 1
);

-- Q48: Listar los usuarios que tienen al menos una playlist con más de 5 canciones
SELECT DISTINCT u.nombre
FROM usuarios u
JOIN playlists pl ON u.usuario_id = pl.usuario_id
JOIN playlist_cancion pc ON pl.playlist_id = pc.playlist_id
GROUP BY u.usuario_id, pl.playlist_id
HAVING COUNT(pc.cancion_id) > 5;

-- Q49: Mostrar los usuarios que comparten canciones en común en sus playlists
SELECT u1.nombre AS usuario1, u2.nombre AS usuario2, c.titulo AS cancion
FROM playlist_cancion pc1
JOIN playlists pl1 ON pc1.playlist_id = pl1.playlist_id
JOIN usuarios u1 ON pl1.usuario_id = u1.usuario_id
JOIN playlist_cancion pc2 ON pc1.cancion_id = pc2.cancion_id
JOIN playlists pl2 ON pc2.playlist_id = pl2.playlist_id
JOIN usuarios u2 ON pl2.usuario_id = u2.usuario_id
JOIN canciones c ON pc1.cancion_id = c.cancion_id
WHERE u1.usuario_id < u2.usuario_id;

-- Q50: Listar los artistas que tienen canciones en playlists de más de 5 usuarios diferentes
SELECT ar.nombre, COUNT(DISTINCT pl.usuario_id) AS usuarios_distintos
FROM artistas ar
JOIN albumes a ON ar.artista_id = a.artista_id
JOIN canciones c ON a.album_id = c.album_id
JOIN playlist_cancion pc ON c.cancion_id = pc.cancion_id
JOIN playlists pl ON pc.playlist_id = pl.playlist_id
GROUP BY ar.artista_id
HAVING COUNT(DISTINCT pl.usuario_id) > 5;




