-- ============================================
-- DATOS DE PRUEBA LIMPIOS Y VERIFICADOS
-- ============================================
-- Este script inserta datos de prueba para testear
-- EJECUTAR DESPUÉS DE RESET_CLEAN.sql

-- ============================================
-- INSERTAR CLIENTES DE PRUEBA
-- ============================================
INSERT INTO clientes (cod_sucursal, nombre_sucursal, estado) VALUES
(4, 'FRIGOR S.A.', 'VACIO'),
(3, 'PIL ANDINA S.A. SCZ', 'VACIO'),
(1081, 'OPERADORA COMERCIAL S.R.L.', 'VACIO')
ON CONFLICT (cod_sucursal) DO NOTHING;

-- ============================================
-- INSERTAR PRODUCTOS DE PRUEBA
-- ============================================
INSERT INTO productos (cod_producto, nombre_producto, unidad_medida) VALUES
-- Productos para FRIGOR S.A.
('WET1', 'WETBOIL 101', 'KG.'),
('WET3', 'WETBOIL 207', 'KG.'),
('WET7', 'WETBOIL 402', 'KG.'),
('WET20', 'WETCOOL 304', 'KG.'),
('WET62', 'WETCOOL 305', 'KG.'),
('WET64', 'WETOIL BIOCIDE 705', 'KG.'),
-- Productos para PIL ANDINA
('WCL933', 'WETCLEAR 933', 'KG.'),
('WCL971', 'WETCLEAR 971', 'KG.'),
('WCLEAN 1103', 'WETCLEAN 1103', 'KG.'),
('WET15', 'WETCOOL 201', 'KG.'),
('WET2', 'WETBOIL 201', 'KG.'),
('WET23', 'WETCOOL 703', 'KG.'),
('WET6', 'WETBOIL 401', 'KG.'),
('WET66', 'WETOSMO 104', 'KG.'),
('WET67', 'WETOSMO 1103', 'KG.'),
('WET69', 'WETOSMO 1106', 'KG.'),
('WETOSM701', 'WETOSMO 701', 'KG.'),
('WOS206', 'WETOSMO 206', 'KG.'),
-- Productos para OPERADORA COMERCIAL
('30539', 'WETCLEAN 1101', 'KG.')
ON CONFLICT (cod_producto) DO NOTHING;

-- ============================================
-- INSERTAR RELACIONES CLIENTE-PRODUCTO
-- ============================================

-- FRIGOR S.A. (cod_sucursal = 4)
INSERT INTO cliente_productos (cliente_id, producto_id, cod_sucursal, cod_producto, nombre_producto, unidad_medida)
SELECT 
  c.id,
  p.id,
  4,
  p.cod_producto,
  p.nombre_producto,
  p.unidad_medida
FROM clientes c, productos p
WHERE c.cod_sucursal = 4 AND p.cod_producto IN (
  'WET1', 'WET3', 'WET7', 'WET20', 'WET62', 'WET64'
)
ON CONFLICT (cliente_id, producto_id) DO NOTHING;

-- PIL ANDINA S.A. SCZ (cod_sucursal = 3)
INSERT INTO cliente_productos (cliente_id, producto_id, cod_sucursal, cod_producto, nombre_producto, unidad_medida)
SELECT 
  c.id,
  p.id,
  3,
  p.cod_producto,
  p.nombre_producto,
  p.unidad_medida
FROM clientes c, productos p
WHERE c.cod_sucursal = 3 AND p.cod_producto IN (
  'WCL933', 'WCL971', 'WCLEAN 1103', 'WET1', 'WET15', 'WET2',
  'WET20', 'WET23', 'WET6', 'WET62', 'WET66', 'WET67',
  'WET69', 'WETOSM701', 'WOS206'
)
ON CONFLICT (cliente_id, producto_id) DO NOTHING;

-- OPERADORA COMERCIAL S.R.L. (cod_sucursal = 1081)
INSERT INTO cliente_productos (cliente_id, producto_id, cod_sucursal, cod_producto, nombre_producto, unidad_medida)
SELECT 
  c.id,
  p.id,
  1081,
  p.cod_producto,
  p.nombre_producto,
  p.unidad_medida
FROM clientes c, productos p
WHERE c.cod_sucursal = 1081 AND p.cod_producto IN (
  '30539'
)
ON CONFLICT (cliente_id, producto_id) DO NOTHING;

-- ============================================
-- VERIFICAR DATOS
-- ============================================
SELECT 'Clientes' as tabla, COUNT(*) as cantidad FROM clientes
UNION ALL
SELECT 'Productos', COUNT(*) FROM productos
UNION ALL
SELECT 'Cliente-Productos', COUNT(*) FROM cliente_productos;
