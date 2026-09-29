-- Tabla interno
CREATE TABLE IF NOT EXISTS interno (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_interno VARCHAR(20) NOT NULL UNIQUE,
    fecha_ingreso TIMESTAMP NULL,
    observaciones TEXT NULL,
    estado ENUM('disponible', 'asignado', 'inactivo') DEFAULT 'disponible',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
