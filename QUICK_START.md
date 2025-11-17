# 🚀 INICIO RÁPIDO - 5 MINUTOS

Esta es la guía más rápida para poner tu aplicación en funcionamiento.

## 1️⃣ Obtener credenciales de Supabase (2 min)

1. Ve a https://supabase.com → **New Project**
2. Completa el formulario (nombre, contraseña, región)
3. Espera a que se cree (1-2 minutos)
4. Abre **Settings > API**
5. Copia:
   - `Project URL` → Línea 1 de .env.local
   - `anon public` → Línea 2 de .env.local
   - `service_role` → Línea 3 de .env.local

## 2️⃣ Configurar .env.local (1 min)

```bash
# Abre .env.local y reemplaza:
NEXT_PUBLIC_SUPABASE_URL=https://xxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
```

## 3️⃣ Crear la base de datos (1 min)

En Supabase Dashboard:

1. Abre **SQL Editor** → **New Query**
2. Copia TODO el contenido de `sql/create_tables.sql`
3. Pega en el editor y haz click en **Run**
4. Espera a que termine

## 4️⃣ Cargar productos (1 min)

En Supabase Dashboard:

1. Abre **SQL Editor** → **New Query**
2. Copia TODO el contenido de `sql/insert_productos.sql`
3. Pega en el editor y haz click en **Run**
4. Espera a que termine

## 5️⃣ Ejecutar la aplicación (1 min)

En terminal:

```bash
npm install  # Si no lo hiciste antes
npm run dev
```

Abre: **http://localhost:3000**

---

## ✅ ¡LISTO!

Si ves la aplicación con:
- ✅ Campo de búsqueda de cliente
- ✅ Tabla con meses (Ene, Feb, Mar, etc)
- ✅ Pestaña "Resumen"

**¡TODO FUNCIONA!** 🎉

---

## 🆘 Si algo no funciona

| Problema | Solución |
|----------|----------|
| "Cannot read properties of undefined" | Reinicia: `Ctrl+C` en terminal y `npm run dev` |
| "No se encuentran clientes" | Ejecuta nuevamente `sql/create_tables.sql` |
| Error al guardar | Verifica que .env.local tiene las credenciales correctas |
| Localhost:3000 no carga | Verifica que `npm run dev` esté ejecutando |

---

## 📖 ¿Quieres aprender más?

- **README.md** - Características y documentación completa
- **SETUP_GUIDE.md** - Guía detallada paso a paso
- **PROJECT_SUMMARY.md** - Resumen del proyecto
- **DEPLOYMENT.md** - Cómo poner en producción

---

## 🎯 Flujo de uso

1. **Formulario** (pestaña 1)
   - Busca un cliente (ej: "FRIGOR")
   - Selecciona uno
   - Ingresa números en los meses
   - Click en "Guardar Datos"

2. **Resumen** (pestaña 2)
   - Ve el estado de todos los clientes
   - Mira estadísticas

¡Eso es todo! 🚀
