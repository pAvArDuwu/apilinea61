-- Tabla conductores
CREATE TABLE IF NOT EXISTS conductor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    licencia VARCHAR(50) NULL,
    nombre VARCHAR(100) NULL,
    apellido VARCHAR(100) NULL,
    telefono VARCHAR(20) NULL,
    correo VARCHAR(100) NULL,
    ci VARCHAR(20) NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
