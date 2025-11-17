-- ============================================
-- EJEMPLO DE PRUEBA - DATOS MINIMOS
-- ============================================
-- Si no quieres cargar todos los productos,
-- aquí tienes un conjunto mínimo para probar

-- OPCION 1: Si las tablas están vacías, usa esto

INSERT INTO productos (cod_producto, nombre_producto, unidad_medida) VALUES
('WET1', 'WETBOIL 101', 'KG.'),
('WET7', 'WETBOIL 402', 'KG.'),
('WET20', 'WETCOOL 304', 'KG.'),
('WCL971', 'WETCLEAR 971', 'KG.')
ON CONFLICT DO NOTHING;

-- OPCION 2: Crear relaciones cliente-producto
-- (Después de ejecutar los inserts de create_tables.sql y products básicos)

INSERT INTO cliente_productos (cliente_id, producto_id, cod_sucursal, cod_producto, nombre_producto, unidad_medida)
SELECT 
  c.id,
  p.id,
  c.cod_sucursal,
  p.cod_producto,
  p.nombre_producto,
  p.unidad_medida
FROM clientes c, productos p
WHERE c.cod_sucursal = 4 -- FRIGOR S.A.
  AND p.cod_producto IN ('WET1', 'WET7', 'WET20')
ON CONFLICT DO NOTHING;

-- OPCION 3: Crear datos de prueba
-- Esto inserta datos mensuales de ejemplo para probar el flujo

INSERT INTO registros_mensuales (
  cliente_id, producto_id, 
  enero, febrero, marzo, abril, mayo, junio,
  julio, agosto, septiembre, octubre, noviembre,
  year
)
SELECT 
  c.id, p.id,
  10.50, 20.75, 15.25, 18.00, 22.50, 19.99,
  25.00, 21.50, 23.75, 26.00, 24.25,
  2025
FROM clientes c, productos p, cliente_productos cp
WHERE c.cod_sucursal = 4 -- FRIGOR S.A.
  AND cp.cliente_id = c.id
  AND cp.producto_id = p.id
  AND p.cod_producto IN ('WET1', 'WET7', 'WET20')
ON CONFLICT (cliente_id, producto_id, year) DO NOTHING;

-- OPCION 4: Actualizar estado a LLENO (si ya tienes datos)
UPDATE clientes SET estado = 'LLENO' WHERE cod_sucursal = 4;

-- ============================================
-- VERIFICAR DATOS
-- ============================================
-- Ejecuta estas queries para verificar

-- Ver clientes cargados
-- SELECT cod_sucursal, nombre_sucursal, estado FROM clientes LIMIT 5;

-- Ver productos
-- SELECT cod_producto, nombre_producto FROM productos LIMIT 5;

-- Ver datos mensuales cargados
-- SELECT 
--   c.nombre_sucursal,
--   p.nombre_producto,
--   rm.enero, rm.febrero, rm.marzo
-- FROM registros_mensuales rm
-- JOIN clientes c ON rm.cliente_id = c.id
-- JOIN productos p ON rm.producto_id = p.id
-- LIMIT 10;
