-- ============================================
-- INSERT PRODUCTOS Y CLIENTE-PRODUCTOS
-- ============================================
-- Este script inserta todos los productos y las relaciones
-- cliente-producto basados en los datos proporcionados

-- Primero, limpiar datos previos (opcional)
-- TRUNCATE TABLE cliente_productos CASCADE;
-- TRUNCATE TABLE productos CASCADE;

-- ============================================
-- INSERTAR PRODUCTOS ÚNICOS
-- ============================================
INSERT INTO productos (cod_producto, nombre_producto, unidad_medida) VALUES
-- PIL ANDINA S.A. SCZ
('WCL933', 'WETCLEAR 933', 'KG.'),
('WCL971', 'WETCLEAR 971', 'KG.'),
('WCLEAN 1103', 'WETCLEAN 1103', 'KG.'),
('WET1', 'WETBOIL 101', 'KG.'),
('WET15', 'WETCOOL 201', 'KG.'),
('WET2', 'WETBOIL 201', 'KG.'),
('WET20', 'WETCOOL 304', 'KG.'),
('WET23', 'WETCOOL 703', 'KG.'),
('WET6', 'WETBOIL 401', 'KG.'),
('WET62', 'WETCOOL 305', 'KG.'),
('WET66', 'WETOSMO 104', 'KG.'),
('WET67', 'WETOSMO 1103', 'KG.'),
('WET69', 'WETOSMO 1106', 'KG.'),
('WETOSM701', 'WETOSMO 701', 'KG.'),
('WOS206', 'WETOSMO 206', 'KG.'),
-- FRIGOR S.A.
('WET3', 'WETBOIL 207', 'KG.'),
('WET64', 'WETOIL BIOCIDE 705', 'KG.'),
('WET7', 'WETBOIL 402', 'KG.'),
-- INDUSTRIAS DE ACEITE S.A.
-- Ya tiene WET1, WET2, WET66, WET7, WETOSM701
-- EMPRESA ELECTRICA ENDE GUARACACHI S.A.
-- Ya tiene WET66
-- EGSA PRODUCTOS VAPOR Y ENFRIAM
('60101LT', 'WETCOOL 319E', 'LT.'),
('CLORURO SODIO', 'CLORURO DE SODIO', 'KG.'),
('FLETE', 'RECARGO POR TRANSPORTE', 'UN.'),
('HCL', 'ACIDO CLORHIDRICO', 'LT.'),
('NAOHESCAMAS', 'HIDROXIDO DE SODIO', 'KG.'),
('SODA', 'SODA CAUSTICA', 'KG.'),
('WB209LT', 'WETBOIL 209E', 'LT.'),
('WC220ELT', 'WETCOOL 220E', 'LT.'),
('WC708LT', 'WETCOOL 708E', 'LT.'),
('WCL1189E', 'WETCLEAN 1189E', 'KG.'),
('WT408ELT', 'WETBOIL 408E', 'LT.'),
-- IND. FORESTAL CIMAL IMR
('K4520', 'CHEMETRICS DUREZA TOTAL 20-200 PPM K4520', 'KIT'),
('SAL IND', 'SAL INDUSTRIAL (CLORURO DE SODIO)', 'KG.'),
-- CLINICA LAS AMERICAS: SERVICIO
('ANAH2O', 'ANALISIS DE AGUA', 'UN.'),
-- AGRO TRANSFORMACION Y MERCADEO
('WET21', 'WETCOOL 701', 'KG.'),
('WET63', 'WETCOOL BIO 106', 'KG.'),
-- MARVAL
('WETCLEAR806', 'WETCLEAR 806', 'KG.'),
-- INGENIO SUCROALCOHOLERO AGUAI
('60106', 'WETBOIL 209', 'KG.'),
('AED1548', 'ANTIESPUMANTE KF550', 'KG.'),
('DFD1671', 'DISPERSANTE PARA FERMENTACION', 'KG.'),
('EZD5400', 'ENZIMA ALMIDON', 'KG.'),
('EZNDEX', 'ENZIMA DEXTRANA EZD 6000 GROUP DND', 'KG.'),
('LUBMASS', 'ANTICORROSIVO PARA MASA LMD 0525 GRUPO DND', 'KG.'),
('PAD0022', 'POLIMERO ANIONICO PROFLOC 932', 'KG.'),
('WB113', 'WETBOIL 113', 'KG.'),
('WB311', 'WETBOIL 311', 'KG.'),
('WB321', 'WETBOIL 321', 'KG.'),
('WB331', 'WETBOIL 331', 'KG.'),
('WET50', 'WETSUGAR CLEAR 901', 'KG.'),
('WET68', 'WETOSMO 1104', 'KG.'),
-- NUDELPA LIMITADA
('60617', 'WETCLEAN 1155', 'KG.'),
-- CORPORACION ACEROS AREQUIPA
('SALGRAN', 'SAL GRANULADA', 'KG.'),
('WC 728', 'WETCOOL 728', 'KG.'),
('WET109', 'WETCOOL 109', 'KG.'),
-- CAMEO SRL
('BH38', 'BH-38', 'KG.'),
-- ENDE ANDINA S.A.M.
('60602', 'WETCLEAR 916', 'KG.'),
('60613', 'WETCLEAN 1169', 'KG.'),
('AMOACUKG', 'AMONIACO ACUOSO AL 25%', 'KG.'),
('BISULFITO', 'BISULFITO DE SODIO AL 34%', 'LT.'),
('WET25', 'WETCOOL 708', 'KG.'),
('WO-101', 'WETOSMO 101', 'KG.'),
-- ENDE ANDINA AMONIACO
('SERVENDE', 'SERVICIO ENDE ANDINA S.A.M.', 'UN.'),
-- PROLEGA S.A.
('WC1050', 'WETCLEAR 958', 'KG.'),
('WC316', 'WETCOOL 316', 'KG.'),
('WCR953', 'WETCLEAR 953', 'KG.'),
-- COOPAGUAS
('TABCLOR', 'TABLETAS DE TRICLORO (BOMBONAS DE 50 KG)', 'KG.'),
-- INDUSTRIAS OLEAGINOSAS
('WOS105', 'WETOSMO 105', 'KG.'),
-- MARIA VICTORIA
('10118', 'SULFATO DE ALUMINIO', 'KG.'),
-- INDUSTRIAS BELEN
('WET16', 'WETCOOL 202', 'KG.'),
-- SINOSTEEL BOLIVIA
('WET1600', 'WETCLEAN PASSIVATOR', 'KG.'),
-- INDUSTRIAS AGRICOLAS DE BERMEJO
('WET49', 'WETSUGAR BIOCIDE 702', 'KG.'),
-- HOSPITAL
('IPA', 'ISOPROPANOL', 'LT.'),
('K0896', 'KIT DE PRODUCTOS PARA LIMPIEZA DE MEMBRANAS DE OSMOSIS', 'KIT'),
('SALIND', 'SAL INDUSTRIAL', 'BLS.'),
('SPA1', 'SPARCHLOR 7.5 1KL', 'KG.'),
('SPA2', 'SPARESTIL 340-5.5K', 'BIDÓN'),
('SPA3', 'SPARESTERIL 5E 5LTS', 'BIDÓN'),
('SPA4', 'SPAR-OPA 5LT', 'BIDÓN'),
-- ALCOHOSOL
('10541', 'ACIDO FOSFORICO (F.G.)', 'KG.'),
('SERV AGUA', 'SERVICIO DE AGUA', 'UN.'),
-- EMPACAR
('FBB1', 'FILTRO CARTUCHO DE POLIPROPILENO DE 4.5" X 20" DE 1 MICRON', 'UNI.'),
-- YPFB REFINACION: ENFRIAMIENTO
('SERV003', 'SERVICIO YPFB REF. PALMASOLA', 'UN.'),
-- EMIPA
('10569', 'ACIDO SULFURICO', 'KG.'),
('LIMPQUIM', 'SERVICIO LIMPIEZA QUIMICA', 'UN.'),
('WET33', 'WETMINING SC 103', 'KG.'),
-- VK TECNOLOGIA
('60607', 'WETCLEAR 949', 'KG.'),
-- INDUSTRIA METALURGICA FERROTODO
('WET1604', 'WETCLEAN CS', 'KG.'),
-- YACIMIENTOS PETROLIFEROS
('H2SO4LT', 'ACIDO SULFURICO AL 98%', 'LT.'),
('HIPO5LT', 'HIPOCLORITO DE SODIO', 'LT.'),
('LAVANDINA', 'HIPOCLORITO DE SODIO', 'LT.'),
('WC701LT', 'WETCOOL 701', 'LT.'),
-- UNAGRO
('30541', 'WETSUGAR SC 101', 'KG.'),
('WET74', 'WETSUGAR BIOCIDE 703', 'KG.'),
-- INDUSTRIA SJ
('WET306', 'WETCOOL 306', 'KG.'),
-- INDUSTRIASS FACRULESA
('60601', 'WETCOOL 707', 'KG.'),
('WET5', 'WETBOIL 304', 'KG.'),
-- INGENIERIA MEDICA
('AGDESIO', 'AGUA DESIONIZADA', 'LT.'),
('WC-319', 'WETCOOL 319', 'KG.'),
-- FABOCE
-- Ya tiene 60617
-- RAV ASOCIADOS
-- Ya tiene WET67
-- CARMEN YOLANDA
('TACC90', 'TRICLORO GRANULADO 90%', 'KG.'),
-- QUIMICOS CAVA
-- Ya tiene WCL971
-- MAR ADENTRO
-- Ya tiene 60602, TACC90
-- OILPRO
-- Ya tiene TABCLOR
-- MIPISCINA
-- Ya tiene TACC90
-- FERNANDO SANCHEZ
-- Ya tiene WCL971
-- FERNANDO ZELAYA
-- Ya tiene TABCLOR, WCL971
-- YESENIA TERRAZAS
-- Ya tiene TABCLOR, TACC90
-- TATIANA TERRAZAS
-- Ya tiene TACC90, WCL971
-- MULTIEQUIPOS
-- Ya tiene TACC90, WCL971
-- SAMUEL BOZO
-- Ya tiene TABCLOR, TACC90, WCL971
-- CASA AQUA GARDEN
-- Ya tiene TACC90, WCL971
-- YEHISON SILVA
-- Ya tiene 10118, WCL971
-- POOLKINGS
-- Ya tiene WCL971
-- DESTI-BOL
-- Ya tiene WET68
-- CERVECERIA BOLIVIANA
-- Ya tiene 10118
-- CURTIEMBRE SAUSALITO
-- Ya tiene 10569
-- EMIPA (duplicado)
-- Ya tiene WCL933
-- OPERADORA COMERCIAL
('30539', 'WETCLEAN 1101', 'KG.'),
-- VIBROTEC
('60612', 'WETCLEAN CP 1120', 'KG.'),
-- INDUSTRIAS KRAL
-- Ya tiene WET1, WET2, WET7
-- PAPERKERING
('WET61', 'WETBOIL 305', 'KG.'),
-- INGENIO SAN AURELIO
('WET9', 'WETBOIL RESIN CLEAN 1101', 'KG.'),
-- EMPACAR: SERVICIO
-- Ya tiene WET2, WET66, WET7, CLORURO SODIO, SAL IND, FBB1, SERV AGUA
-- EMBOLPACK
-- Ya tiene WET5, WET7
-- INDUSTRIAS VENADO
-- Ya tiene WET5, WET7
-- CASA REAL
('FB140', 'FILTRO CARTUCHO DE POLIPROPILENO DE 2.5" X 40" DE 1 MICRON', 'UNI.'),
-- EMBOL S.A. - TARIJA
-- Ya tiene WET20, WET25, WET62
-- KUPEL
('60113', 'WETOSMO 704', 'KG.'),
('SAL001', 'SAL COMUN', 'KG.'),
-- ADEL FARFÁN
('TACCMULTI', 'TABLETAS DE TRICLORO MULTIFUNCIONAL', 'KG.'),
-- YPFB REFINACION (duplicado)
('METOHTB', 'METANOL', 'TB'),
('METOH', 'METANOL', 'LT.'),
('NAOHPERLAS', 'SODA CAUSTICA EN PERLAS', 'KG.'),
('WC728LT', 'WETCOOL 728', 'LT.')
ON CONFLICT (cod_producto) DO NOTHING;

-- ============================================
-- INSERTAR RELACIONES CLIENTE-PRODUCTO
-- ============================================
-- Nota: Este proceso es más eficiente hacerlo en la aplicación
-- o usar un script auxiliar. Aquí mostramos el patrón para algunos.

-- Ejemplo para PIL ANDINA S.A. SCZ (cod_sucursal = 3)
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

-- Ejemplo para FRIGOR S.A. (cod_sucursal = 4)
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
  'WET1', 'WET20', 'WET3', 'WET62', 'WET64', 'WET7'
)
ON CONFLICT (cliente_id, producto_id) DO NOTHING;

-- ============================================
-- NOTA
-- ============================================
-- Para insertar todas las relaciones cliente-producto automáticamente,
-- deberías usar un script en la aplicación o cargar un archivo CSV
-- más completo. Este archivo muestra el patrón para hacerlo.
--
-- La mejor estrategia es:
-- 1. Crear todos los productos (ya hecho arriba)
-- 2. Usar la aplicación para cargar datos
-- 3. Las relaciones se crean automáticamente cuando se ingresa datos
