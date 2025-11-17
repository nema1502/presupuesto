-- ============================================
-- SCRIPT DE LIMPIEZA COMPLETA - EJECUTAR PRIMERO
-- ============================================
-- Este script elimina todas las tablas y relaciones
-- para poder empezar de cero limpio

-- Deshabilitar triggers antes de borrar
DROP TRIGGER IF EXISTS update_registros_updated_at ON registros_mensuales;
DROP TRIGGER IF EXISTS update_clientes_updated_at ON clientes;

-- Función de actualización
DROP FUNCTION IF EXISTS update_updated_at_column();

-- Eliminar tablas (cascada elimina las relaciones automáticamente)
DROP TABLE IF EXISTS registros_mensuales CASCADE;
DROP TABLE IF EXISTS cliente_productos CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- Eliminar índices (si alguno quedó)
DROP INDEX IF EXISTS idx_clientes_nombre;
DROP INDEX IF EXISTS idx_clientes_cod_sucursal;
DROP INDEX IF EXISTS idx_clientes_estado;
DROP INDEX IF EXISTS idx_productos_cod;
DROP INDEX IF EXISTS idx_productos_nombre;
DROP INDEX IF EXISTS idx_cliente_productos_cliente;
DROP INDEX IF EXISTS idx_cliente_productos_producto;
DROP INDEX IF EXISTS idx_registros_cliente;
DROP INDEX IF EXISTS idx_registros_producto;
DROP INDEX IF EXISTS idx_registros_year;

-- ============================================
-- AHORA RECREAR TODO LIMPIO
-- ============================================

-- ============================================
-- TABLA: CLIENTES (Sucursales)
-- ============================================
CREATE TABLE clientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cod_sucursal INTEGER NOT NULL UNIQUE,
  nombre_sucursal VARCHAR(255) NOT NULL,
  estado VARCHAR(10) NOT NULL DEFAULT 'VACIO' CHECK (estado IN ('VACIO', 'LLENO')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_clientes_nombre ON clientes(nombre_sucursal);
CREATE INDEX idx_clientes_cod_sucursal ON clientes(cod_sucursal);
CREATE INDEX idx_clientes_estado ON clientes(estado);

-- ============================================
-- TABLA: PRODUCTOS
-- ============================================
CREATE TABLE productos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cod_producto VARCHAR(50) NOT NULL UNIQUE,
  nombre_producto VARCHAR(255) NOT NULL,
  unidad_medida VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_productos_cod ON productos(cod_producto);
CREATE INDEX idx_productos_nombre ON productos(nombre_producto);

-- ============================================
-- TABLA: RELACION CLIENTE-PRODUCTO
-- ============================================
CREATE TABLE cliente_productos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
  producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
  cod_sucursal INTEGER NOT NULL,
  cod_producto VARCHAR(50) NOT NULL,
  nombre_producto VARCHAR(255) NOT NULL,
  unidad_medida VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(cliente_id, producto_id)
);

CREATE INDEX idx_cliente_productos_cliente ON cliente_productos(cliente_id);
CREATE INDEX idx_cliente_productos_producto ON cliente_productos(producto_id);

-- ============================================
-- TABLA: REGISTROS MENSUALES
-- ============================================
CREATE TABLE registros_mensuales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
  producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
  enero NUMERIC(10, 2) DEFAULT 0.00,
  febrero NUMERIC(10, 2) DEFAULT 0.00,
  marzo NUMERIC(10, 2) DEFAULT 0.00,
  abril NUMERIC(10, 2) DEFAULT 0.00,
  mayo NUMERIC(10, 2) DEFAULT 0.00,
  junio NUMERIC(10, 2) DEFAULT 0.00,
  julio NUMERIC(10, 2) DEFAULT 0.00,
  agosto NUMERIC(10, 2) DEFAULT 0.00,
  septiembre NUMERIC(10, 2) DEFAULT 0.00,
  octubre NUMERIC(10, 2) DEFAULT 0.00,
  noviembre NUMERIC(10, 2) DEFAULT 0.00,
  diciembre NUMERIC(10, 2) DEFAULT 0.00,
  year INTEGER DEFAULT 2025,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(cliente_id, producto_id, year)
);

CREATE INDEX idx_registros_cliente ON registros_mensuales(cliente_id);
CREATE INDEX idx_registros_producto ON registros_mensuales(producto_id);
CREATE INDEX idx_registros_year ON registros_mensuales(year);

-- ============================================
-- FUNCIÓN DE ACTUALIZACIÓN DE TIMESTAMP
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER update_clientes_updated_at
BEFORE UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_registros_updated_at
BEFORE UPDATE ON registros_mensuales
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE cliente_productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros_mensuales ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read on clientes" ON clientes
FOR SELECT USING (true);

CREATE POLICY "Allow public read on productos" ON productos
FOR SELECT USING (true);

CREATE POLICY "Allow public read on cliente_productos" ON cliente_productos
FOR SELECT USING (true);

CREATE POLICY "Allow public read on registros_mensuales" ON registros_mensuales
FOR SELECT USING (true);

CREATE POLICY "Allow insert on registros_mensuales" ON registros_mensuales
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on registros_mensuales" ON registros_mensuales
FOR UPDATE USING (true);

CREATE POLICY "Allow insert on clientes" ON clientes
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow update on clientes" ON clientes
FOR UPDATE USING (true);
