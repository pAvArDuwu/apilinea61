-- Tabla control_recorrido (sesión de control del recorrido)
CREATE TABLE IF NOT EXISTS control_recorrido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    asignacion_turno_id INT NOT NULL,
    ruta_parada_id INT NULL,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('pendiente', 'cumplido', 'omitido', 'fuera_ruta', 'en_curso', 'completado', 'cancelado') DEFAULT 'pendiente',
    distancia_metros DECIMAL(10, 2) NULL,
    observacion TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (asignacion_turno_id) REFERENCES asignacion_turnos(id) ON DELETE CASCADE,
    FOREIGN KEY (ruta_parada_id) REFERENCES parada_ruta(id) ON DELETE SET NULL
);
