-- Tabla seguimiento_gps (posiciones GPS registradas)
CREATE TABLE IF NOT EXISTS seguimiento_gps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    control_recorrido_id INT NOT NULL,
    fecha_hora_gps DATETIME NOT NULL,
    latitud DECIMAL(10, 8) NOT NULL,
    longitud DECIMAL(11, 8) NOT NULL,
    velocidad DECIMAL(8, 2) NULL,
    fecha_hora_sincronizacion DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (control_recorrido_id) REFERENCES control_recorrido(id) ON DELETE CASCADE
);
