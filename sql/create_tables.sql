-- ============================================
-- SUPABASE DATABASE SETUP
-- ============================================
-- Este archivo contiene las instrucciones SQL para crear
-- la estructura de la base de datos en Supabase

-- ============================================
-- TABLA: CLIENTES (Sucursales)
-- ============================================
CREATE TABLE IF NOT EXISTS clientes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cod_sucursal INTEGER NOT NULL UNIQUE,
  nombre_sucursal VARCHAR(255) NOT NULL,
  estado VARCHAR(10) NOT NULL DEFAULT 'VACIO' CHECK (estado IN ('VACIO', 'LLENO')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índice para búsquedas por nombre
CREATE INDEX IF NOT EXISTS idx_clientes_nombre ON clientes(nombre_sucursal);
CREATE INDEX IF NOT EXISTS idx_clientes_cod_sucursal ON clientes(cod_sucursal);
CREATE INDEX IF NOT EXISTS idx_clientes_estado ON clientes(estado);

-- ============================================
-- TABLA: PRODUCTOS
-- ============================================
CREATE TABLE IF NOT EXISTS productos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cod_producto VARCHAR(50) NOT NULL UNIQUE,
  nombre_producto VARCHAR(255) NOT NULL,
  unidad_medida VARCHAR(50) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índice para búsquedas
CREATE INDEX IF NOT EXISTS idx_productos_cod ON productos(cod_producto);
CREATE INDEX IF NOT EXISTS idx_productos_nombre ON productos(nombre_producto);

-- ============================================
-- TABLA: RELACION CLIENTE-PRODUCTO
-- ============================================
CREATE TABLE IF NOT EXISTS cliente_productos (
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

-- Índices
CREATE INDEX IF NOT EXISTS idx_cliente_productos_cliente ON cliente_productos(cliente_id);
CREATE INDEX IF NOT EXISTS idx_cliente_productos_producto ON cliente_productos(producto_id);

-- ============================================
-- TABLA: REGISTROS MENSUALES
-- ============================================
CREATE TABLE IF NOT EXISTS registros_mensuales (
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

-- Índices
CREATE INDEX IF NOT EXISTS idx_registros_cliente ON registros_mensuales(cliente_id);
CREATE INDEX IF NOT EXISTS idx_registros_producto ON registros_mensuales(producto_id);
CREATE INDEX IF NOT EXISTS idx_registros_year ON registros_mensuales(year);

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

-- Triggers para actualizar updated_at
DROP TRIGGER IF EXISTS update_clientes_updated_at ON clientes;
CREATE TRIGGER update_clientes_updated_at
BEFORE UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_registros_updated_at ON registros_mensuales;
CREATE TRIGGER update_registros_updated_at
BEFORE UPDATE ON registros_mensuales
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- POLITICAS DE SEGURIDAD (RLS)
-- ============================================
-- Habilitar RLS para todas las tablas
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE cliente_productos ENABLE ROW LEVEL SECURITY;
ALTER TABLE registros_mensuales ENABLE ROW LEVEL SECURITY;

-- Política para permitir lectura a todos (sin autenticación por ahora)
-- Nota: En producción, deberías implementar autenticación proper

CREATE POLICY "Allow public read on clientes" ON clientes
FOR SELECT USING (true);

CREATE POLICY "Allow public read on productos" ON productos
FOR SELECT USING (true);

CREATE POLICY "Allow public read on cliente_productos" ON cliente_productos
FOR SELECT USING (true);

CREATE POLICY "Allow public read on registros_mensuales" ON registros_mensuales
FOR SELECT USING (true);

-- Políticas de escritura (modificar según necesidades de seguridad)
CREATE POLICY "Allow authenticated insert on registros_mensuales" ON registros_mensuales
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated update on registros_mensuales" ON registros_mensuales
FOR UPDATE USING (true);

CREATE POLICY "Allow authenticated insert on clientes" ON clientes
FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated update on clientes" ON clientes
FOR UPDATE USING (true);

-- ============================================
-- DATOS DE EJEMPLO - CLIENTES (Sucursales)
-- ============================================
-- Este insert los datos proporcionados
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

-- ============================================
-- NOTA IMPORTANTE
-- ============================================
-- Después de crear las tablas, necesitas insertar los productos
-- y las relaciones cliente-producto. Puedes hacerlo con un script
-- SQL adicional o a través de la aplicación.
-- 
-- Ver el archivo: sql/insert_productos.sql
