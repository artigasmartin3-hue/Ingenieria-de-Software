CREATE DATABASE hotel_rios_del_sur
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE hotel_rios_del_sur;

CREATE TABLE usuario (
    idUsuario       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    passwordHash    VARCHAR(255)    NOT NULL,
    rol             ENUM('RECEPCION','ADMINISTRACION') NOT NULL,
    turno           VARCHAR(50)     NULL,
    cargo           VARCHAR(100)    NULL,
    activo          TINYINT(1)      NOT NULL DEFAULT 1,
    fechaCreacion   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE cliente (
    idCliente       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    rut             VARCHAR(12)     NOT NULL UNIQUE,
    telefono        VARCHAR(20)     NULL,
    email           VARCHAR(150)    NULL,
    direccion       VARCHAR(200)    NULL,
    fechaCreacion   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE huesped (
    idHuesped       INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    rut             VARCHAR(12)     NOT NULL UNIQUE,
    telefono        VARCHAR(20)     NULL,
    email           VARCHAR(150)    NULL
) ENGINE=InnoDB;

CREATE TABLE habitacion (
    idHabitacion    INT AUTO_INCREMENT PRIMARY KEY,
    numero          VARCHAR(10)     NOT NULL UNIQUE,
    tipo            VARCHAR(50)     NOT NULL,
    capacidad       INT             NOT NULL,
    precio          DECIMAL(10,2)   NOT NULL,
    estado          ENUM('DISPONIBLE','OCUPADA','EN_MANTENCION')
                    NOT NULL DEFAULT 'DISPONIBLE',
    CONSTRAINT chk_capacidad CHECK (capacidad > 0),
    CONSTRAINT chk_precio     CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE reserva (
    idReserva       INT AUTO_INCREMENT PRIMARY KEY,
    idCliente       INT             NOT NULL,
    idUsuario       INT             NULL,
    fechaInicio     DATE            NOT NULL,
    fechaFin        DATE            NOT NULL,
    estado          ENUM('PENDIENTE','CONFIRMADA','CANCELADA')
                    NOT NULL DEFAULT 'PENDIENTE',
    fechaCreacion   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (idCliente) REFERENCES cliente(idCliente)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_reserva_usuario
        FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_fechas_reserva CHECK (fechaFin >= fechaInicio)
) ENGINE=InnoDB;

CREATE TABLE detalle_reserva (
    idDetalle       INT AUTO_INCREMENT PRIMARY KEY,
    idReserva       INT             NOT NULL,
    idHabitacion    INT             NOT NULL,
    fechaInicial    DATE            NOT NULL,
    fechaFinal      DATE            NOT NULL,
    cantidadPersonas INT            NOT NULL,
    precio          DECIMAL(10,2)   NOT NULL,
    CONSTRAINT fk_detalle_reserva
        FOREIGN KEY (idReserva) REFERENCES reserva(idReserva)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_detalle_habitacion
        FOREIGN KEY (idHabitacion) REFERENCES habitacion(idHabitacion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_personas CHECK (cantidadPersonas > 0),
    CONSTRAINT chk_fechas_detalle CHECK (fechaFinal >= fechaInicial)
) ENGINE=InnoDB;

CREATE TABLE detalle_huesped (
    idDetalle       INT             NOT NULL,
    idHuesped       INT             NOT NULL,
    PRIMARY KEY (idDetalle, idHuesped),
    CONSTRAINT fk_dh_detalle
        FOREIGN KEY (idDetalle) REFERENCES detalle_reserva(idDetalle)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_dh_huesped
        FOREIGN KEY (idHuesped) REFERENCES huesped(idHuesped)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX idx_habitacion_estado   ON habitacion(estado);
CREATE INDEX idx_reserva_fechas       ON reserva(fechaInicio, fechaFin);
CREATE INDEX idx_detalle_fechas       ON detalle_reserva(fechaInicial, fechaFinal);
CREATE INDEX idx_detalle_habitacion   ON detalle_reserva(idHabitacion);

CREATE INDEX idx_cliente_nombre   ON cliente(nombre);
CREATE INDEX idx_huesped_nombre   ON huesped(nombre);
CREATE INDEX idx_usuario_nombre   ON usuario(nombre);

INSERT INTO usuario (nombre, email, passwordHash, rol, turno, cargo) VALUES
('Ana Recepción', 'ana@hotelrios.cl', '\$2y\$10\$ejemploHashRecepcion', 'RECEPCION', 'Mañana', NULL),
('Carlos Admin',  'carlos@hotelrios.cl', '\$2y\$10\$ejemploHashAdmin', 'ADMINISTRACION', NULL, 'Jefe de Operaciones');

INSERT INTO cliente (nombre, rut, telefono, email, direccion) VALUES
('Pedro Soto',   '11111111-1', '+56911111111', 'pedro@mail.cl', 'Av. Alemania 123, Valdivia'),
('María Pérez',  '22222222-2', '+56922222222', 'maria@mail.cl', 'Los Castaños 456, Valdivia');

INSERT INTO huesped (nombre, rut, telefono, email) VALUES
('Pedro Soto',    '11111111-1', '+56911111111', 'pedro@mail.cl'),
('Juana Soto',    '33333333-3', '+56933333333', 'juana@mail.cl');

INSERT INTO habitacion (numero, tipo, capacidad, precio, estado) VALUES
('101', 'Individual', 1, 35000.00, 'DISPONIBLE'),
('102', 'Doble',      2, 55000.00, 'DISPONIBLE'),
('201', 'Suite',      4, 95000.00, 'EN_MANTENCION');

INSERT INTO reserva (idCliente, idUsuario, fechaInicio, fechaFin, estado) VALUES
(1, 1, '2026-11-10', '2026-11-13', 'CONFIRMADA');

INSERT INTO detalle_reserva (idReserva, idHabitacion, fechaInicial, fechaFinal, cantidadPersonas, precio) VALUES
(1, 2, '2026-11-10', '2026-11-13', 2, 55000.00);

INSERT INTO detalle_huesped (idDetalle, idHuesped) VALUES
(1, 1),
(1, 2);

SELECT * FROM cliente WHERE rut = '11111111-1';
SELECT * FROM huesped WHERE rut = '11111111-1';

SELECT * FROM cliente  WHERE nombre LIKE '%Soto%';
SELECT * FROM huesped  WHERE nombre LIKE '%Soto%';
SELECT * FROM usuario  WHERE nombre LIKE '%Ana%';

SELECT * FROM cliente
WHERE rut = '11111111-1'
  AND nombre LIKE '%Pedro%';

SELECT * FROM cliente
WHERE (:rut    IS NULL OR rut    = :rut)
  AND (:nombre IS NULL OR nombre LIKE CONCAT('%', :nombre, '%'));

SELECT * FROM huesped
WHERE (:rut    IS NULL OR rut    = :rut)
  AND (:nombre IS NULL OR nombre LIKE CONCAT('%', :nombre, '%'));
