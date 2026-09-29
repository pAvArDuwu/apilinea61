-- Tabla asignacion_turnos (operación diaria)
CREATE TABLE IF NOT EXISTS asignacion_turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    turno_id INT NOT NULL,
    ruta_id INT NOT NULL,
    micro_id INT NOT NULL,
    conductor_id INT NOT NULL,
    hora_salida TIME NULL,
    hora_llegada TIME NULL,
    estado ENUM('pendiente', 'en_curso', 'completado', 'retrasado', 'cancelado') DEFAULT 'pendiente',
    observaciones TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (turno_id) REFERENCES turno(id) ON DELETE CASCADE,
    FOREIGN KEY (ruta_id) REFERENCES ruta(id) ON DELETE CASCADE,
    FOREIGN KEY (micro_id) REFERENCES micro(id) ON DELETE CASCADE,
    FOREIGN KEY (conductor_id) REFERENCES conductor(id) ON DELETE CASCADE
);
