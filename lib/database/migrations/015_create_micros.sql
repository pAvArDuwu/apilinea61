-- Tabla micro
CREATE TABLE IF NOT EXISTS micro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propietario_id INT NOT NULL,
    interno_id INT NULL,
    placa VARCHAR(20) NULL,
    chasis VARCHAR(50) NULL,
    anio_fabricacion INT NULL,
    modelo VARCHAR(50) NULL,
    marca VARCHAR(50) NULL,
    capacidad_pasajeros INT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (propietario_id) REFERENCES propietarios(id) ON DELETE CASCADE,
    FOREIGN KEY (interno_id) REFERENCES interno(id) ON DELETE SET NULL
);
