# Guía de Implementación - Gestión de Productos

## 📌 Pasos para poner en marcha la aplicación

### Paso 1: Configurar Supabase

#### 1.1 Crear cuenta y proyecto
1. Ve a [supabase.com](https://supabase.com)
2. Crea una nueva cuenta o inicia sesión
3. Crea un nuevo proyecto:
   - **Name**: `gestion-productos` (o el que prefieras)
   - **Database Password**: Crea una contraseña fuerte
   - **Region**: Elige la más cercana a tu ubicación

#### 1.2 Obtener credenciales
1. Ve a **Settings > API** en tu proyecto
2. Copia y guarda:
   - `Project URL` → `NEXT_PUBLIC_SUPABASE_URL`
   - `anon public` (debajo de "Project API keys") → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `service_role` (en "Service role key") → `SUPABASE_SERVICE_ROLE_KEY`

#### 1.3 Crear la base de datos

1. En Supabase, ve a **SQL Editor**
2. Haz clic en **"+ New Query"**
3. Copia todo el contenido de `sql/create_tables.sql` en tu proyecto local
4. Pégalo en el editor de SQL
5. Haz clic en **Run**
6. Espera a que se complete (debería tardar unos segundos)

✅ **Las tablas están creadas!**

### Paso 2: Insertar datos de productos

1. En **SQL Editor**, haz clic en **"+ New Query"** nuevamente
2. Copia el contenido de `sql/insert_productos.sql`
3. Pégalo en el editor
4. Haz clic en **Run**

✅ **Los productos están cargados!**

### Paso 3: Configurar la aplicación

#### 3.1 Variables de entorno

1. En tu proyecto local, copia `.env.example` a `.env.local`:
   ```bash
   cp .env.example .env.local
   ```

2. Abre `.env.local` y reemplaza:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   NEXT_PUBLIC_APP_URL=http://localhost:3000
   ```

#### 3.2 Instalar dependencias

```bash
npm install
```

#### 3.3 Iniciar la aplicación

```bash
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

---

## 🧪 Pruebas básicas

### Verificar conexión con Supabase

1. Abre la consola de navegador (F12)
2. Ve a la pestaña "Console"
3. Deberías ver que no hay errores de conexión a Supabase

### Prueba del formulario

1. En la pestaña **"📋 Formulario"**, busca "FRIGOR" o cualquier cliente
2. Selecciona un cliente
3. Deberías ver una tabla con los productos de ese cliente
4. Ingresa valores numéricos (ejemplo: 10.50) en algunos campos
5. Haz clic en **"Guardar Datos"**
6. Deberías ver un mensaje de éxito

### Verificar datos en Supabase

1. Ve a Supabase Dashboard
2. En **Table Editor**, abre `registros_mensuales`
3. Deberías ver tus datos guardados allí

### Prueba de la tabla resumen

1. Ve a la pestaña **"📊 Resumen"**
2. Deberías ver:
   - Total de clientes (133 si cargaste todo)
   - Clientes LLENO (con datos)
   - Clientes VACIO (sin datos)
   - Una tabla con todos los clientes y su estado

---

## 🔧 Troubleshooting

### ❌ "Cannot read properties of undefined (reading 'supabase')"

**Causa**: Variables de entorno no configuradas

**Solución**:
1. Verifica que `.env.local` existe
2. Verifica que contiene las credenciales correctas
3. Reinicia el servidor de desarrollo (`Ctrl+C` y `npm run dev`)

### ❌ "No se encuentran clientes"

**Causa**: Los datos no se cargaron en Supabase

**Solución**:
1. Abre Supabase Dashboard
2. Ve a **Table Editor** > **clientes**
3. Si está vacía, ejecuta nuevamente `sql/insert_productos.sql`

### ❌ "Error al guardar datos"

**Causa**: Posiblemente un problema de permisos de Supabase

**Solución**:
1. Verifica que tienes `SUPABASE_SERVICE_ROLE_KEY` configurado
2. En Supabase, ve a **Authentication > Policies**
3. Asegúrate de que las políticas RLS permiten inserts/updates

### ❌ "La tabla de productos está vacía"

**Causa**: El cliente no tiene productos asignados

**Solución**:
1. Necesitas ejecutar la segunda parte de `sql/insert_productos.sql`
2. O cargar más datos manualmente a través de la aplicación

---

## 📊 Estructura de datos esperada

### Clientes
- Total de clientes: 133
- Campos: cod_sucursal, nombre_sucursal, estado (VACIO/LLENO)

### Productos
- Total aprox: 150+
- Campos: cod_producto, nombre_producto, unidad_medida

### Registros mensuales
- Se crean cuando guardas datos desde el formulario
- Almacenan valores de enero a diciembre con 2 decimales

---

## 🚀 Próximos pasos (opcional)

### 1. Implementar autenticación
- Descomentar componentes de Login/SignUp
- Configurar Supabase Auth en el dashboard

### 2. Exportar datos
- Agregar funcionalidad para descargar CSV/Excel

### 3. Validación avanzada
- Rangos de valores permitidos
- Validación de unidades de medida

### 4. Histórico
- Guardar versiones anteriores de datos
- Comparar cambios entre periodos

### 5. Reportes
- Dashboards interactivos
- Gráficos de consumo
- Análisis de tendencias

---

## 📞 Soporte

Para reportar problemas:

1. Abre la consola del navegador (F12)
2. Copia los mensajes de error
3. Revisa el archivo `.env.local` para credenciales correctas
4. Verifica en Supabase Dashboard que los datos existen

## 📚 Recursos útiles

- [Documentación de Supabase](https://supabase.com/docs)
- [Documentación de Next.js](https://nextjs.org/docs)
- [Tailwind CSS](https://tailwindcss.com/)
- [React Hook Form](https://react-hook-form.com/)
- [Zod Validation](https://zod.dev/)
