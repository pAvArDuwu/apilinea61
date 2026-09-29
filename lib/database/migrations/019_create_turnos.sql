-- Tabla turno (catálogo de horarios)
CREATE TABLE IF NOT EXISTS turno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre ENUM('mañana', 'tarde', 'noche') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    descripcion TEXT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
