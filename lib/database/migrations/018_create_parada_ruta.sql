-- Tabla parada_ruta (pivote ruta-parada con orden y sentido)
CREATE TABLE IF NOT EXISTS parada_ruta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ruta_id INT NOT NULL,
    parada_id INT NOT NULL,
    orden INT NOT NULL DEFAULT 0,
    sentido ENUM('Ida', 'Vuelta') NOT NULL DEFAULT 'Ida',
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ruta_id) REFERENCES ruta(id) ON DELETE CASCADE,
    FOREIGN KEY (parada_id) REFERENCES paradas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_ruta_parada_sentido (ruta_id, parada_id, sentido)
);
