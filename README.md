# Aplicación de Gestión de Productos

Una aplicación web moderna para la gestión de datos mensuales de productos por cliente, construida con Next.js, Supabase y TypeScript.

## 🚀 Características

- **Autenticación segura**: Sistema de login con Supabase Auth
- **Gestión de clientes**: Búsqueda y selección con autocompletado
- **Ingreso de datos**: Formulario interactivo para datos mensuales (12 meses)
- **Validación**: Campos numéricos con precisión de 2 decimales
- **CRUD completo**: Crear, leer, actualizar datos
- **Tabla resumen**: Vista general del estado de todos los clientes
- **Base de datos relacional**: Supabase con estructura optimizada
- **Interfaz responsive**: Diseño mobile-friendly con Tailwind CSS
- **Testing**: Suite básica de pruebas

## 📋 Requisitos

- Node.js 18+
- npm o yarn
- Cuenta de Supabase (gratuita)
- Git

## 🛠️ Instalación

### 1. Clonar el repositorio

```bash
git clone <tu-repositorio>
cd proy
```

### 2. Instalar dependencias

```bash
npm install
```

### 3. Configurar Supabase

#### a. Crear cuenta en [Supabase](https://supabase.com)

#### b. Crear un nuevo proyecto

#### c. Obtener credenciales

En el Dashboard de Supabase:
1. Ve a **Settings > API**
2. Copia tu `Project URL` y `anon public key`
3. También necesitarás el `service_role key` (en Settings > API)

#### d. Configurar variables de entorno

Crea un archivo `.env.local` en la raíz del proyecto:

```bash
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Crear la base de datos

#### a. En el editor SQL de Supabase, ejecuta:

```sql
-- Copia el contenido de: sql/create_tables.sql
```

Este script creará:
- Tabla `clientes` (sucursales)
- Tabla `productos`
- Tabla `cliente_productos` (relaciones)
- Tabla `registros_mensuales` (datos mensuales)
- Índices y triggers automáticos

#### b. Insertar productos:

```sql
-- Copia el contenido de: sql/insert_productos.sql
```

## 🚀 Uso

### Iniciar servidor de desarrollo

```bash
npm run dev
```

Abre [http://localhost:3000](http://localhost:3000) en tu navegador.

### Compilar para producción

```bash
npm run build
npm start
```

### Ejecutar pruebas

```bash
npm test
```

## 📁 Estructura del proyecto

```
src/
├── app/                 # App Router de Next.js
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── components/
│   ├── forms/           # Componentes de formularios
│   │   ├── ClienteSearch.tsx
│   │   └── FormularioProductos.tsx
│   ├── tables/          # Componentes de tablas
│   │   └── TablaResumen.tsx
│   └── shared/          # Componentes compartidos
│       └── Loading.tsx
├── lib/
│   ├── supabase.ts      # Configuración de Supabase
│   ├── database.ts      # Funciones de base de datos
│   └── validations.ts   # Esquemas de validación (Zod)
├── types/
│   └── index.ts         # Tipos TypeScript
└── ...
```

## 🔑 Características técnicas

### Stack tecnológico
- **Frontend**: React 18, Next.js 14, TypeScript
- **Styling**: Tailwind CSS v4
- **Backend**: Supabase (PostgreSQL)
- **Validación**: Zod + React Hook Form
- **Testing**: Jest + React Testing Library

### Base de datos

#### Tabla: `clientes`
```
- id: UUID (PK)
- cod_sucursal: INTEGER (UNIQUE)
- nombre_sucursal: VARCHAR
- estado: VACIO | LLENO
- created_at, updated_at: TIMESTAMP
```

#### Tabla: `productos`
```
- id: UUID (PK)
- cod_producto: VARCHAR (UNIQUE)
- nombre_producto: VARCHAR
- unidad_medida: VARCHAR
- created_at: TIMESTAMP
```

#### Tabla: `registros_mensuales`
```
- id: UUID (PK)
- cliente_id: UUID (FK)
- producto_id: UUID (FK)
- enero-noviembre: NUMERIC(10,2)
- diciembre: NUMERIC(10,2) (opcional)
- year: INTEGER
- created_at, updated_at: TIMESTAMP
```

## 🔐 Seguridad

- Variables de entorno para credenciales sensibles
- Row Level Security (RLS) habilitado en Supabase
- Validación de datos en cliente y servidor
- SQL prepared statements para prevenir inyecciones

## 📱 Responsive

- Desktop: Tabla completa con scroll horizontal
- Tablet: Layout adaptativo
- Mobile: Interfaz optimizada (tabla con scroll)

## 🐛 Troubleshooting

### Problema: "Missing Supabase credentials"
**Solución**: Verifica que `.env.local` esté configurado correctamente con tus credenciales de Supabase.

### Problema: "Cannot connect to Supabase"
**Solución**: Asegúrate de que:
1. Las credenciales son correctas
2. Tu proyecto de Supabase está activo
3. Tu IP está permitida (si aplica restricciones)

### Problema: "Table not found"
**Solución**: Ejecuta los scripts SQL en el orden correcto:
1. `sql/create_tables.sql` (primero)
2. `sql/insert_productos.sql` (segundo)

## 📚 Documentación adicional

- [Documentación de Supabase](https://supabase.com/docs)
- [Documentación de Next.js](https://nextjs.org/docs)
- [React Hook Form](https://react-hook-form.com/)
- [Zod - TypeScript-first schema validation](https://zod.dev)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Para cambios mayores, abre un issue primero para discutir los cambios propuestos.

## 📄 Licencia

MIT

## 👤 Autor

Desarrollado con ❤️ para gestión eficiente de productos
