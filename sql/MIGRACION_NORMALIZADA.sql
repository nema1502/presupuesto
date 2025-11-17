-- ============================================
-- MIGRACIÓN A ESTRUCTURA NORMALIZADA
-- ============================================
-- Este script refactoriza registros_mensuales
-- a una estructura escalable para análisis de datos

-- PASO 1: Borrar tabla antigua (si existe)
DROP TABLE IF EXISTS registros_mensuales CASCADE;

-- PASO 2: Crear tabla NORMALIZADA
-- Estructura: cliente + producto + año + mes + cantidad
-- Permite guardar datos de cualquier mes/año sin modificar esquema
CREATE TABLE registros_mensuales (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE CASCADE,
  producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE CASCADE,
  year INTEGER NOT NULL,
  mes INTEGER NOT NULL CHECK (mes >= 1 AND mes <= 12),
  cantidad DECIMAL(12, 2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT now(),
  updated_at TIMESTAMP DEFAULT now(),
  -- Índices para búsquedas rápidas
  UNIQUE(cliente_id, producto_id, year, mes),
  CONSTRAINT valid_quantity CHECK (cantidad >= 0)
);

-- PASO 3: Crear índices para mejor performance
CREATE INDEX idx_registros_cliente ON registros_mensuales(cliente_id);
CREATE INDEX idx_registros_producto ON registros_mensuales(producto_id);
CREATE INDEX idx_registros_year_mes ON registros_mensuales(year, mes);
CREATE INDEX idx_registros_cliente_year ON registros_mensuales(cliente_id, year);

-- PASO 4: Habilitar RLS (Row Level Security)
ALTER TABLE registros_mensuales ENABLE ROW LEVEL SECURITY;

-- PASO 5: Crear políticas de RLS
-- Primero eliminar políticas antiguas si existen
DROP POLICY IF EXISTS "Allow all authenticated users to view registros" ON registros_mensuales;
DROP POLICY IF EXISTS "Allow all authenticated users to insert registros" ON registros_mensuales;
DROP POLICY IF EXISTS "Allow all authenticated users to update registros" ON registros_mensuales;
DROP POLICY IF EXISTS "Allow all authenticated users to delete registros" ON registros_mensuales;

-- Permitir lectura a usuarios autenticados Y desde el servidor
CREATE POLICY "Allow all authenticated users to view registros"
  ON registros_mensuales FOR SELECT
  USING (true);

-- Permitir inserts desde cliente (autenticado) o desde servidor (service_role)
CREATE POLICY "Allow all authenticated users to insert registros"
  ON registros_mensuales FOR INSERT
  WITH CHECK (true);

-- Permitir updates desde cliente (autenticado) o desde servidor (service_role)
CREATE POLICY "Allow all authenticated users to update registros"
  ON registros_mensuales FOR UPDATE
  USING (true)
  WITH CHECK (true);

-- Permitir deletes desde cliente (autenticado) o desde servidor (service_role)
CREATE POLICY "Allow all authenticated users to delete registros"
  ON registros_mensuales FOR DELETE
  USING (true);

-- PASO 6: LIMPIAR DATOS ANTERIORES
TRUNCATE TABLE cliente_productos CASCADE;
TRUNCATE TABLE productos CASCADE;
TRUNCATE TABLE clientes CASCADE;

-- PASO 7: Insertar todos los CLIENTES
INSERT INTO clientes (cod_sucursal, nombre_sucursal, estado) VALUES
(3, 'PIL ANDINA S.A. SCZ', 'VACIO'),
(4, 'FRIGOR S.A.', 'VACIO'),
(5, 'INDUSTRIAS DE ACEITE S.A. - PI SCZ', 'VACIO'),
(6, 'EMPRESA ELECTRICA ENDE GUARACACHI S.A.', 'VACIO'),
(7, 'EGSA PRODUCTOS VAPOR Y ENFRIAM', 'VACIO'),
(11, 'IND. FORESTAL CIMAL IMR -SC', 'VACIO'),
(12, 'EMPACAR: SERVICIO TQ', 'VACIO'),
(13, 'CLINICA LAS AMERICAS: SERVICIO', 'VACIO'),
(14, 'INDUSTRIAS VENADO S.A.', 'VACIO'),
(15, 'CIA. DE INVERSIONES LAS BRISAS S.A.', 'VACIO'),
(16, 'SOCIEDAD GRANELERA GRANOSOL S.A.', 'VACIO'),
(18, 'COMPAÑIA DE ALIMENTOS LTDA SC', 'VACIO'),
(19, 'TOTAI CITRUS S.A.', 'VACIO'),
(20, 'AGRO TRANSFORMACION Y MERCADEO AGROTRAM SRL', 'VACIO'),
(27, 'MARVAL - SC', 'VACIO'),
(28, 'ALIMENTO SOCIEDAD ANONIMA', 'VACIO'),
(29, 'INDUPLASTICAS SC SRL', 'VACIO'),
(30, 'EMBOL S.A.', 'VACIO'),
(31, 'INGENIO SUCROALCOHOLERO AGUAI S.A.', 'VACIO'),
(32, 'COPELME S.A. - SC', 'VACIO'),
(33, 'NUDELPA LIMITADA', 'VACIO'),
(34, 'INDUSTRIAS KRAL SRL', 'VACIO'),
(35, 'CORPORACION ACEROS AREQUIPA SRL', 'VACIO'),
(37, 'CAMEO SRL', 'VACIO'),
(38, 'ENDE ANDINA S.A.M.', 'VACIO'),
(39, 'ENDE ANDINA AMONIACO', 'VACIO'),
(40, 'PAPERKING SRL', 'VACIO'),
(41, 'PROLEGA S.A.', 'VACIO'),
(42, 'BEBIDAS BOLIVIANAS BBO S.A.', 'VACIO'),
(43, 'COOPAGUAS R.L.', 'VACIO'),
(48, 'FUNDACION COLONIA PIRAI', 'VACIO'),
(49, 'INDUSTRIAS OLEAGINOSAS S.A. RICO', 'VACIO'),
(55, 'MARIA VICTORIA YSAASC RIZZO', 'VACIO'),
(56, 'FABRICA DE MERMELADAS Y CARAMELOS WATTS CASAL S.R', 'VACIO'),
(57, 'INGENIO AZUCARERO GUABIRA SOCIEDAD ANONIMA IAG S.A', 'VACIO'),
(58, 'CHACO ENERGIAS S.A.', 'VACIO'),
(59, 'COOPAPPI RL', 'VACIO'),
(60, 'UNAGRO S.A.', 'VACIO'),
(61, 'INDUSTRIA SJ SRL', 'VACIO'),
(62, 'SAGUATERRA SOCIEDAD CIVIL', 'VACIO'),
(64, 'EMPRESA DE ALIMENTOS HAMACAS LTDA.', 'VACIO'),
(65, 'TECNA BOLIVIA S.A.', 'VACIO'),
(67, 'YPFB REFINACION: ENFRIAMIENTO', 'VACIO'),
(68, 'YPFB REFINACION: VAPOR', 'VACIO'),
(69, 'YPFB REF BIODIESEL: ENFRIAMIEN', 'VACIO'),
(70, 'YPFB REF BIODIESEL: VAPOR', 'VACIO'),
(79, 'OVOPROT INTERNACIONAL S.R.L.', 'VACIO'),
(83, 'HUGO SPECHAR GONZALES', 'VACIO'),
(84, 'INDUSTRIA METALURGICA FERROTODO S.A.', 'VACIO'),
(87, 'YACIMIENTOS PETROLIFEROS FISCALES BOLIVIANOS', 'VACIO'),
(88, 'INDUSTRIAS BELEN SRL', 'VACIO'),
(93, 'SINOSTEEL BOLIVIA LTDA.', 'VACIO'),
(94, 'INDUSTRIAS AGRICOLAS DE BERMEJO S.A.', 'VACIO'),
(96, 'HOSPITAL DE TERCER NIVEL "MONTERO"', 'VACIO'),
(99, 'DAVID REYNAGA', 'VACIO'),
(101, 'WINNER INDUSTRIA & COMERCIO S.A.', 'VACIO'),
(102, 'EMBOLPACK EMPRESA BOLIVIANA DE EMPAQUE S.R.L.', 'VACIO'),
(103, 'SAMUEL PEÑA FLORES', 'VACIO'),
(104, 'INDUSTRIAS FACRULESA S.A.', 'VACIO'),
(105, 'INGENIERIA MEDICA INGEVIDA S.R.L.', 'VACIO'),
(106, 'FABOCE S.R.L.', 'VACIO'),
(107, 'RAV ASOCIADOS S.R.L', 'VACIO'),
(108, 'CARMEN YOLANDA RIVERO DE CUELLAR (R Y C)', 'VACIO'),
(109, 'QUIMICOS CAVA (MARIO CARRASCO)', 'VACIO'),
(110, 'MAR ADENTRO (CLOUDSA INVERSIONES)', 'VACIO'),
(111, 'OILPRO S.R.L.', 'VACIO'),
(112, 'MIPISCINA.COM', 'VACIO'),
(113, 'FERNANDO SANCHEZ MORALES', 'VACIO'),
(114, 'FERNANDO ZELAYA ARANCIBIA', 'VACIO'),
(115, 'YESENIA TERRAZAS ROJAS', 'VACIO'),
(116, 'TATIANA TERRAZAS ROJAS', 'VACIO'),
(117, 'MULTIEQUIPOS S.R.L.', 'VACIO'),
(118, 'SAMUEL BOZO', 'VACIO'),
(119, 'CASA AQUA GARDEN LTDA', 'VACIO'),
(120, 'YEHISON SILVA', 'VACIO'),
(121, 'POOLKINGS', 'VACIO'),
(280, 'DESTI-BOL S.R.L.', 'VACIO'),
(291, 'CERVECERIA BOLIVIANA NACIONAL S.A.', 'VACIO'),
(307, 'CURTIEMBRE SAUSALITO S.R.L.', 'VACIO'),
(312, 'ALCOHOSOL SRL', 'VACIO'),
(314, 'EVELIN VACA CASTILLO', 'VACIO'),
(315, 'HERLAND DANNY QUISBERTH GARCIA', 'VACIO'),
(316, 'RICHARD CRISTIAN EUGENIO SOLA', 'VACIO'),
(317, 'CARMIÑA ROJAS', 'VACIO'),
(318, 'FREDY CRUZ ANDIA', 'VACIO'),
(319, 'SERGIO DENIS CHOQUE CUELLAR', 'VACIO'),
(320, 'HILARION ZUÑIGA HERRERA', 'VACIO'),
(321, 'WILVER LLANOS PORTALES', 'VACIO'),
(359, 'JUAN PABLO GOMEZ', 'VACIO'),
(424, 'INGENIO SAN AURELIO (FCT. CIAS', 'VACIO'),
(440, 'EMIPA S.A.', 'VACIO'),
(485, 'VK TECNOLOGIA S.R.L.', 'VACIO'),
(532, 'FAUSTO MARTINEZ VALERIANO', 'VACIO'),
(581, 'MINOIL S.A.', 'VACIO'),
(706, 'EDIL OSINAGA', 'VACIO'),
(777, 'INVERSIONES INMOBILIARIAS INDACO S.A.', 'VACIO'),
(879, 'EMBOL S.A. - TARIJA', 'VACIO'),
(891, 'KUPEL', 'VACIO'),
(892, 'ADEL FARFÁN JURADO', 'VACIO'),
(901, 'JHON FERNANDO MITA QUISBERT', 'VACIO'),
(913, 'KALOMAI', 'VACIO'),
(914, 'CASA REAL - SOCIEDAD AGROINDUS', 'VACIO'),
(916, 'YPFB REFINACION', 'VACIO'),
(938, 'VERÓNICA CABEZAS LARA', 'VACIO'),
(944, 'JOSE TICONA', 'VACIO'),
(946, 'WENDY GUAMAN', 'VACIO'),
(947, 'MARIA CECILIA CORSO MOLINA', 'VACIO'),
(949, 'GERALDINE DORIS CHOQUE MORALES', 'VACIO'),
(950, 'GONZALO VELASQUEZ VARGAS', 'VACIO'),
(952, 'COSIMBO R.L.', 'VACIO'),
(958, 'JHASMIN ALEJANDRA VARGAS ROMER', 'VACIO'),
(971, 'ENDE ANDINA ACIDO CLORHIDRICO', 'VACIO'),
(974, 'EMPACAR', 'VACIO'),
(981, 'MIGUEL GÓMEZ', 'VACIO'),
(992, 'XIMENA CABEZAS', 'VACIO'),
(993, 'AMILCAR RICHARD EUGENIO FERNANDEZ', 'VACIO'),
(1002, 'ORLANDO CABEZAS', 'VACIO'),
(1011, 'MAURICIO VEIZAGA ORTIZ', 'VACIO'),
(1015, 'LENNY OQUENDO MONTENEGRO', 'VACIO'),
(1017, 'CHINA MACHINERY ENGINEERING CORPORATION', 'VACIO'),
(1018, 'MIGUEL ALBERTO HUAYHUA SONCO', 'VACIO'),
(1025, 'MARIA EUGENIA ARUQUIPA', 'VACIO'),
(1036, 'VIBROTEC ELECTROMECANICA', 'VACIO'),
(1044, 'RONALD CAMACHO CHAVEZ', 'VACIO'),
(1053, 'BOVINSA LTDA', 'VACIO'),
(1055, 'POLAR', 'VACIO'),
(1056, 'EMPRESA SIDEDÚRGICA DEL MUTÚN', 'VACIO'),
(1058, 'INDUSTRIAS DE ACEITE S.A. - WARNES', 'VACIO'),
(1061, 'VIDRIOS LAMINADOS SRL.', 'VACIO'),
(1066, 'HILDA SUAREZ GALVEZ DE VERDUN', 'VACIO'),
(1081, 'OPERADORA COMERCIAL S.R.L.', 'VACIO'),
(1096, 'KEVIN RODRIGO MEDRANO NAVIA', 'VACIO'),
(1110, 'SCANBIOTEK S.R.L.', 'VACIO'),
(1112, 'BAYE OF CHINA SUCURSAL BOLIVIA', 'VACIO'),
(1121, 'COSPAIL R.L.', 'VACIO'),
(1126, 'ARIEL PUMA', 'VACIO'),
(1129, 'JUAN MANUEL VELÁSQUEZ FARFÁN', 'VACIO'),
(1132, 'HIDEMI MIYAZONO MIZOTO', 'VACIO')
ON CONFLICT (cod_sucursal) DO NOTHING;

-- PASO 8: Insertar todos los PRODUCTOS (sin cambios)
INSERT INTO productos (cod_producto, nombre_producto, unidad_medida) VALUES
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
('WET3', 'WETBOIL 207', 'KG.'),
('WET64', 'WETOIL BIOCIDE 705', 'KG.'),
('WET7', 'WETBOIL 402', 'KG.'),
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
('K4520', 'CHEMETRICS DUREZA TOTAL 20-200 PPM K4520', 'KIT'),
('SAL IND', 'SAL INDUSTRIAL (CLORURO DE SODIO)', 'KG.'),
('ANAH2O', 'ANALISIS DE AGUA', 'UN.'),
('WET21', 'WETCOOL 701', 'KG.'),
('WET63', 'WETCOOL BIO 106', 'KG.'),
('WETCLEAR806', 'WETCLEAR 806', 'KG.'),
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
('60617', 'WETCLEAN 1155', 'KG.'),
('SALGRAN', 'SAL GRANULADA', 'KG.'),
('WC 728', 'WETCOOL 728', 'KG.'),
('WET109', 'WETCOOL 109', 'KG.'),
('BH38', 'BH-38', 'KG.'),
('60602', 'WETCLEAR 916', 'KG.'),
('60613', 'WETCLEAN 1169', 'KG.'),
('AMOACUKG', 'AMONIACO ACUOSO AL 25%', 'KG.'),
('BISULFITO', 'BISULFITO DE SODIO AL 34%', 'LT.'),
('WET25', 'WETCOOL 708', 'KG.'),
('WO-101', 'WETOSMO 101', 'KG.'),
('SERVENDE', 'SERVICIO ENDE ANDINA S.A.M.', 'UN.'),
('WC1050', 'WETCLEAR 958', 'KG.'),
('WC316', 'WETCOOL 316', 'KG.'),
('WCR953', 'WETCLEAR 953', 'KG.'),
('TABCLOR', 'TABLETAS DE TRICLORO (BOMBONAS DE 50 KG)', 'KG.'),
('WOS105', 'WETOSMO 105', 'KG.'),
('10118', 'SULFATO DE ALUMINIO', 'KG.'),
('WET16', 'WETCOOL 202', 'KG.'),
('WET1600', 'WETCLEAN PASSIVATOR', 'KG.'),
('WET49', 'WETSUGAR BIOCIDE 702', 'KG.'),
('IPA', 'ISOPROPANOL', 'LT.'),
('K0896', 'KIT DE PRODUCTOS PARA LIMPIEZA DE MEMBRANAS DE OSMOSIS', 'KIT'),
('SALIND', 'SAL INDUSTRIAL', 'BLS.'),
('SPA1', 'SPARCHLOR 7.5 1KL', 'KG.'),
('SPA2', 'SPARESTIL 340-5.5K', 'BIDÓN'),
('SPA3', 'SPARESTERIL 5E 5LTS', 'BIDÓN'),
('SPA4', 'SPAR-OPA 5LT', 'BIDÓN'),
('10541', 'ACIDO FOSFORICO (F.G.)', 'KG.'),
('SERV AGUA', 'SERVICIO DE AGUA', 'UN.'),
('FBB1', 'FILTRO CARTUCHO DE POLIPROPILENO DE 4.5" X 20" DE 1 MICRON', 'UNI.'),
('SERV003', 'SERVICIO YPFB REF. PALMASOLA', 'UN.'),
('10569', 'ACIDO SULFURICO', 'KG.'),
('LIMPQUIM', 'SERVICIO LIMPIEZA QUIMICA', 'UN.'),
('WET33', 'WETMINING SC 103', 'KG.'),
('60607', 'WETCLEAR 949', 'KG.'),
('WET1604', 'WETCLEAN CS', 'KG.'),
('H2SO4LT', 'ACIDO SULFURICO AL 98%', 'LT.'),
('HIPO5LT', 'HIPOCLORITO DE SODIO', 'LT.'),
('LAVANDINA', 'HIPOCLORITO DE SODIO', 'LT.'),
('WC701LT', 'WETCOOL 701', 'LT.'),
('30541', 'WETSUGAR SC 101', 'KG.'),
('WET74', 'WETSUGAR BIOCIDE 703', 'KG.'),
('WET306', 'WETCOOL 306', 'KG.'),
('60601', 'WETCOOL 707', 'KG.'),
('WET5', 'WETBOIL 304', 'KG.'),
('AGDESIO', 'AGUA DESIONIZADA', 'LT.'),
('WC-319', 'WETCOOL 319', 'KG.'),
('TACC90', 'TRICLORO GRANULADO 90%', 'KG.'),
('30539', 'WETCLEAN 1101', 'KG.'),
('60612', 'WETCLEAN CP 1120', 'KG.'),
('WET61', 'WETBOIL 305', 'KG.'),
('WET9', 'WETBOIL RESIN CLEAN 1101', 'KG.'),
('FB140', 'FILTRO CARTUCHO DE POLIPROPILENO DE 2.5" X 40" DE 1 MICRON', 'UNI.'),
('60113', 'WETOSMO 704', 'KG.'),
('SAL001', 'SAL COMUN', 'KG.'),
('TACCMULTI', 'TABLETAS DE TRICLORO MULTIFUNCIONAL', 'KG.'),
('METOHTB', 'METANOL', 'TB'),
('METOH', 'METANOL', 'LT.'),
('NAOHPERLAS', 'SODA CAUSTICA EN PERLAS', 'KG.'),
('WC728LT', 'WETCOOL 728', 'LT.'),
('WET24', 'WETCOOL 704', 'KG.'),
('WC705', 'WETCOOL 705', 'KG.'),
('WETB206', 'WETBOIL 206', 'KG.'),
('HCLKG', 'ACIDO CLORHIDRICO', 'KG.'),
('WET135', 'WETBOIL 135', 'KG.'),
('WET8', 'WETBOIL 801', 'KG.'),
('BISNASOLID', 'BISULFITO DE SODIO', 'KG.'),
('EQUIPOS', 'SERVICIO DE INSTALACION', 'UN.')
ON CONFLICT (cod_producto) DO NOTHING;

-- PASO 9: Crear RELACIONES CLIENTE-PRODUCTO
INSERT INTO cliente_productos (cliente_id, producto_id, cod_sucursal, cod_producto, nombre_producto, unidad_medida)
SELECT 
  c.id, p.id, c.cod_sucursal, p.cod_producto, p.nombre_producto, p.unidad_medida
FROM clientes c, productos p
WHERE 
  (c.cod_sucursal = 3 AND p.cod_producto IN ('WCL933', 'WCL971', 'WCLEAN 1103', 'WET1', 'WET15', 'WET2', 'WET20', 'WET23', 'WET6', 'WET62', 'WET66', 'WET67', 'WET69', 'WETOSM701', 'WOS206')) OR
  (c.cod_sucursal = 4 AND p.cod_producto IN ('WET1', 'WET20', 'WET3', 'WET62', 'WET64', 'WET7')) OR
  (c.cod_sucursal = 5 AND p.cod_producto IN ('WET1', 'WET2', 'WET66', 'WET7', 'WETOSM701')) OR
  (c.cod_sucursal = 6 AND p.cod_producto IN ('WET66')) OR
  (c.cod_sucursal = 7 AND p.cod_producto IN ('60101LT', 'CLORURO SODIO', 'FLETE', 'HCL', 'NAOHESCAMAS', 'SODA', 'WB209LT', 'WC220ELT', 'WC708LT', 'WCL1189E', 'WT408ELT')) OR
  (c.cod_sucursal = 11 AND p.cod_producto IN ('K4520', 'SAL IND', 'WET1', 'WET2', 'WET7')) OR
  (c.cod_sucursal = 12 AND p.cod_producto IN ('CLORURO SODIO', 'FBB1', 'SERV AGUA', 'WET2', 'WET66', 'WET7')) OR
  (c.cod_sucursal = 13 AND p.cod_producto IN ('ANAH2O')) OR
  (c.cod_sucursal = 14 AND p.cod_producto IN ('WET5', 'WET7')) OR
  (c.cod_sucursal = 15 AND p.cod_producto IN ('SAL IND', 'WCL971', 'WCLEAN 1103', 'WET20', 'WET21', 'WET24')) OR
  (c.cod_sucursal = 16 AND p.cod_producto IN ('WC 728', 'WC705', 'WCL971', 'WET1', 'WET20', 'WET21', 'WET3', 'WET62', 'WET7')) OR
  (c.cod_sucursal = 18 AND p.cod_producto IN ('WET61', 'WET7')) OR
  (c.cod_sucursal = 19 AND p.cod_producto IN ('SAL IND', 'WCL971', 'WET1', 'WET3', 'WET7')) OR
  (c.cod_sucursal = 20 AND p.cod_producto IN ('WCL971', 'WET1', 'WET2', 'WET21', 'WET63', 'WET7')) OR
  (c.cod_sucursal = 27 AND p.cod_producto IN ('WETCLEAR806')) OR
  (c.cod_sucursal = 28 AND p.cod_producto IN ('WET1', 'WET2')) OR
  (c.cod_sucursal = 29 AND p.cod_producto IN ('WET15', 'WET21')) OR
  (c.cod_sucursal = 30 AND p.cod_producto IN ('WET1', 'WET15', 'WET2', 'WET20', 'WET62', 'WET7')) OR
  (c.cod_sucursal = 31 AND p.cod_producto IN ('60106', 'AED1548', 'DFD1671', 'EZD5400', 'EZNDEX', 'LUBMASS', 'NAOHESCAMAS', 'PAD0022', 'WB113', 'WB311', 'WB321', 'WB331', 'WET2', 'WET50', 'WET66', 'WET68', 'WET69', 'WETOSM701')) OR
  (c.cod_sucursal = 32 AND p.cod_producto IN ('WET1', 'WET109', 'WET7', 'WETB206')) OR
  (c.cod_sucursal = 33 AND p.cod_producto IN ('60617', 'WET1', 'WET66', 'WET7')) OR
  (c.cod_sucursal = 34 AND p.cod_producto IN ('WET1', 'WET2', 'WET7')) OR
  (c.cod_sucursal = 35 AND p.cod_producto IN ('SAL IND', 'SALGRAN', 'WC 728', 'WCL971', 'WET109', 'WET20', 'WET21')) OR
  (c.cod_sucursal = 37 AND p.cod_producto IN ('BH38', 'WET66')) OR
  (c.cod_sucursal = 38 AND p.cod_producto IN ('60602', '60613', 'AMOACUKG', 'BISULFITO', 'WET109', 'WET20', 'WET25', 'WET63', 'WO-101')) OR
  (c.cod_sucursal = 39 AND p.cod_producto IN ('SERVENDE')) OR
  (c.cod_sucursal = 40 AND p.cod_producto IN ('WET61', 'WET7')) OR
  (c.cod_sucursal = 41 AND p.cod_producto IN ('WC1050', 'WC316', 'WCR953')) OR
  (c.cod_sucursal = 42 AND p.cod_producto IN ('WET66')) OR
  (c.cod_sucursal = 43 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 48 AND p.cod_producto IN ('WET61', 'WET7')) OR
  (c.cod_sucursal = 49 AND p.cod_producto IN ('WOS105')) OR
  (c.cod_sucursal = 55 AND p.cod_producto IN ('10118', 'SAL IND', 'WCL971')) OR
  (c.cod_sucursal = 56 AND p.cod_producto IN ('WET1', 'WET2', 'WET7')) OR
  (c.cod_sucursal = 57 AND p.cod_producto IN ('WCL971', 'WET109', 'WET135', 'WET2', 'WET20', 'WET23', 'WET25', 'WET49', 'WET68', 'WET69', 'WET7', 'WET8', 'WOS105')) OR
  (c.cod_sucursal = 58 AND p.cod_producto IN ('HCLKG', 'WET109', 'WET20', 'WET21', 'WET24', 'WET63')) OR
  (c.cod_sucursal = 59 AND p.cod_producto IN ('TABCLOR')) OR
  (c.cod_sucursal = 60 AND p.cod_producto IN ('30541', 'WCL971', 'WET23', 'WET24', 'WET74')) OR
  (c.cod_sucursal = 61 AND p.cod_producto IN ('WET15', 'WET21', 'WET25', 'WET306')) OR
  (c.cod_sucursal = 62 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 64 AND p.cod_producto IN ('SAL IND', 'WET69', 'WO-101')) OR
  (c.cod_sucursal = 65 AND p.cod_producto IN ('TABCLOR')) OR
  (c.cod_sucursal = 67 AND p.cod_producto IN ('SERV003')) OR
  (c.cod_sucursal = 68 AND p.cod_producto IN ('SERV003')) OR
  (c.cod_sucursal = 69 AND p.cod_producto IN ('SERV003')) OR
  (c.cod_sucursal = 70 AND p.cod_producto IN ('SERV003')) OR
  (c.cod_sucursal = 79 AND p.cod_producto IN ('WCL971', 'WET1')) OR
  (c.cod_sucursal = 83 AND p.cod_producto IN ('60602', 'WCL971', 'WET1', 'WET109', 'WET20', 'WET21', 'WET25', 'WET8')) OR
  (c.cod_sucursal = 84 AND p.cod_producto IN ('60613', '60617', 'WET109', 'WET1604', 'WET20', 'WET23', 'WET25')) OR
  (c.cod_sucursal = 87 AND p.cod_producto IN ('10569', 'H2SO4LT', 'HIPO5LT', 'LAVANDINA', 'WC701LT', 'WC708LT')) OR
  (c.cod_sucursal = 88 AND p.cod_producto IN ('WET16', 'WET23')) OR
  (c.cod_sucursal = 93 AND p.cod_producto IN ('60617', 'SAL IND', 'WET1600')) OR
  (c.cod_sucursal = 94 AND p.cod_producto IN ('WET49')) OR
  (c.cod_sucursal = 96 AND p.cod_producto IN ('IPA', 'K0896', 'SALIND', 'SPA1', 'SPA2', 'SPA3', 'SPA4')) OR
  (c.cod_sucursal = 99 AND p.cod_producto IN ('WET7')) OR
  (c.cod_sucursal = 101 AND p.cod_producto IN ('WET61', 'WET7')) OR
  (c.cod_sucursal = 102 AND p.cod_producto IN ('WET5', 'WET7')) OR
  (c.cod_sucursal = 103 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 104 AND p.cod_producto IN ('60601', 'WET109', 'WET25', 'WET5')) OR
  (c.cod_sucursal = 105 AND p.cod_producto IN ('AGDESIO', 'WC-319', 'WET23')) OR
  (c.cod_sucursal = 106 AND p.cod_producto IN ('60617')) OR
  (c.cod_sucursal = 107 AND p.cod_producto IN ('WET67')) OR
  (c.cod_sucursal = 108 AND p.cod_producto IN ('TACC90', 'WCL971')) OR
  (c.cod_sucursal = 109 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 110 AND p.cod_producto IN ('60602', 'TACC90')) OR
  (c.cod_sucursal = 111 AND p.cod_producto IN ('TABCLOR')) OR
  (c.cod_sucursal = 112 AND p.cod_producto IN ('TACC90')) OR
  (c.cod_sucursal = 113 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 114 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 115 AND p.cod_producto IN ('TABCLOR', 'TACC90')) OR
  (c.cod_sucursal = 116 AND p.cod_producto IN ('TACC90', 'WCL971')) OR
  (c.cod_sucursal = 117 AND p.cod_producto IN ('TACC90', 'WCL971')) OR
  (c.cod_sucursal = 118 AND p.cod_producto IN ('TABCLOR', 'TACC90', 'WCL971')) OR
  (c.cod_sucursal = 119 AND p.cod_producto IN ('TACC90', 'WCL971')) OR
  (c.cod_sucursal = 120 AND p.cod_producto IN ('10118', 'WCL971')) OR
  (c.cod_sucursal = 121 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 280 AND p.cod_producto IN ('WET68')) OR
  (c.cod_sucursal = 291 AND p.cod_producto IN ('10118')) OR
  (c.cod_sucursal = 307 AND p.cod_producto IN ('10569')) OR
  (c.cod_sucursal = 312 AND p.cod_producto IN ('10541', 'ANAH2O', 'SAL IND', 'SERV AGUA', 'TABCLOR', 'WET109', 'WET20', 'WET21', 'WET25', 'WET5', 'WET61', 'WET62', 'WET7')) OR
  (c.cod_sucursal = 314 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 315 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 316 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 317 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 318 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 319 AND p.cod_producto IN ('TABCLOR', 'TACC90', 'WCL971')) OR
  (c.cod_sucursal = 320 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 321 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 359 AND p.cod_producto IN ('SAL IND')) OR
  (c.cod_sucursal = 424 AND p.cod_producto IN ('WET9')) OR
  (c.cod_sucursal = 440 AND p.cod_producto IN ('10569', 'LIMPQUIM', 'NAOHESCAMAS', 'WCL933', 'WET33')) OR
  (c.cod_sucursal = 485 AND p.cod_producto IN ('60607')) OR
  (c.cod_sucursal = 532 AND p.cod_producto IN ('WETCLEAR806')) OR
  (c.cod_sucursal = 581 AND p.cod_producto IN ('WET1', 'WET2', 'WET7')) OR
  (c.cod_sucursal = 706 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 777 AND p.cod_producto IN ('TACC90')) OR
  (c.cod_sucursal = 879 AND p.cod_producto IN ('WET20', 'WET25', 'WET62')) OR
  (c.cod_sucursal = 891 AND p.cod_producto IN ('60113', '60602', 'SAL IND', 'SAL001', 'WET1', 'WET2', 'WET306', 'WET66', 'WET7')) OR
  (c.cod_sucursal = 892 AND p.cod_producto IN ('TACCMULTI')) OR
  (c.cod_sucursal = 901 AND p.cod_producto IN ('TABCLOR')) OR
  (c.cod_sucursal = 913 AND p.cod_producto IN ('TABCLOR', 'TACC90')) OR
  (c.cod_sucursal = 914 AND p.cod_producto IN ('FB140', 'SAL IND', 'WET66')) OR
  (c.cod_sucursal = 916 AND p.cod_producto IN ('10569', 'CLORURO SODIO', 'LAVANDINA', 'METOH', 'METOHTB', 'NAOHESCAMAS', 'NAOHPERLAS', 'WC728LT', 'WCL971')) OR
  (c.cod_sucursal = 938 AND p.cod_producto IN ('TACC90', 'WCL971')) OR
  (c.cod_sucursal = 944 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 946 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 947 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 949 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 950 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 952 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 958 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 971 AND p.cod_producto IN ('SERVENDE')) OR
  (c.cod_sucursal = 974 AND p.cod_producto IN ('30539', 'EQUIPOS')) OR
  (c.cod_sucursal = 981 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 992 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 993 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1002 AND p.cod_producto IN ('SAL IND')) OR
  (c.cod_sucursal = 1011 AND p.cod_producto IN ('TABCLOR', 'WCL971')) OR
  (c.cod_sucursal = 1015 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1017 AND p.cod_producto IN ('WET1')) OR
  (c.cod_sucursal = 1018 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1025 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1036 AND p.cod_producto IN ('60612')) OR
  (c.cod_sucursal = 1044 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1053 AND p.cod_producto IN ('SAL IND', 'SALGRAN', 'WCL971')) OR
  (c.cod_sucursal = 1055 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1056 AND p.cod_producto IN ('60602', 'BISNASOLID', 'SAL IND', 'WCR953')) OR
  (c.cod_sucursal = 1058 AND p.cod_producto IN ('10569')) OR
  (c.cod_sucursal = 1061 AND p.cod_producto IN ('TABCLOR', 'WET109', 'WET20')) OR
  (c.cod_sucursal = 1066 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1081 AND p.cod_producto IN ('30539')) OR
  (c.cod_sucursal = 1096 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1110 AND p.cod_producto IN ('LIMPQUIM', 'TABCLOR', 'WET1', 'WET109', 'WET15', 'WET2', 'WET20', 'WET21', 'WET25', 'WET7')) OR
  (c.cod_sucursal = 1112 AND p.cod_producto IN ('WET1600')) OR
  (c.cod_sucursal = 1121 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1126 AND p.cod_producto IN ('60113', 'WET68', 'WET69')) OR
  (c.cod_sucursal = 1129 AND p.cod_producto IN ('WCL971')) OR
  (c.cod_sucursal = 1132 AND p.cod_producto IN ('WCL971'))
ON CONFLICT (cliente_id, producto_id) DO NOTHING;

-- VERIFICAR RESULTADO
SELECT 'Clientes' as tabla, COUNT(*) as cantidad FROM clientes
UNION ALL
SELECT 'Productos', COUNT(*) FROM productos
UNION ALL
SELECT 'Cliente-Productos', COUNT(*) FROM cliente_productos
UNION ALL
SELECT 'Registros Mensuales', COUNT(*) FROM registros_mensuales;
