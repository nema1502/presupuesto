# 📋 Instrucciones para Ejecutar SQL Scripts en Supabase

## ✅ Estado Actual

- ✅ `.env.local` configurado con NEXT_PUBLIC_SUPABASE_URL y NEXT_PUBLIC_SUPABASE_ANON_KEY
- ⏳ Falta: `SUPABASE_SERVICE_ROLE_KEY`
- 🚀 Próximo: Ejecutar SQL scripts

---

## 📊 Scripts a Ejecutar

### 1. `sql/create_tables.sql` (PRIMERO)
**Qué hace:** Crea la estructura de la base de datos
- ✅ 4 tablas normalizadas: `clientes`, `productos`, `cliente_productos`, `registros_mensuales`
- ✅ 133 clientes precargados (sucursales)
- ✅ Índices en campos clave (nombre, código, estado)
- ✅ Row Level Security (RLS) para seguridad
- ✅ Triggers para auto-timestamps (created_at, updated_at)
- **Tamaño:** 450+ líneas
- **Duración:** < 1 segundo

### 2. `sql/insert_productos.sql` (SEGUNDO)
**Qué hace:** Carga los productos y las relaciones cliente-producto
- ✅ 150+ productos químicos únicos
- ✅ Relaciones cliente-producto (qué cliente usa qué productos)
- **Tamaño:** 300+ líneas
- **Duración:** < 1 segundo

### 3. `sql/sample_data.sql` (OPCIONAL)
**Qué hace:** Datos de prueba adicionales (opcional para testing)
- Datos de ejemplo para desarrollo

---

## 🚀 Paso a Paso: Ejecutar en Supabase Dashboard

### Paso 1: Abrir SQL Editor
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto: **whzlgqefoubtasnbszxj**
3. En el menú izquierdo, haz clic en **SQL Editor**

### Paso 2: Crear nueva query
1. Haz clic en el botón **+ New Query**
2. Dale un nombre: `Setup - Create Tables`

### Paso 3: Copiar y ejecutar create_tables.sql
1. Abre el archivo: `sql/create_tables.sql`
2. Cópialo completo
3. Pégalo en el SQL Editor de Supabase
4. Haz clic en **RUN** (botón azul)
5. ✅ Espera a que muestre "Success"

**Qué verás después:**
```
✓ Created table clientes
✓ Created table productos
✓ Created table cliente_productos
✓ Created table registros_mensuales
✓ Created 2 policies for clientes
✓ Created triggers for timestamps
✓ Inserted 133 clients
```

### Paso 4: Crear nueva query para productos
1. Haz clic en **+ New Query**
2. Dale un nombre: `Setup - Insert Products`

### Paso 5: Copiar y ejecutar insert_productos.sql
1. Abre el archivo: `sql/insert_productos.sql`
2. Cópialo completo
3. Pégalo en el SQL Editor
4. Haz clic en **RUN**
5. ✅ Espera a que muestre "Success"

**Qué verás después:**
```
✓ Inserted 150+ unique products
✓ Inserted client-product relationships
✓ No conflicts (all unique)
```

---

## ⚠️ Si Encuentras Errores

### Error: "relation "clientes" does not exist"
**Causa:** Olvidaste ejecutar `create_tables.sql` primero
**Solución:** Ejecuta `create_tables.sql` antes de `insert_productos.sql`

### Error: "duplicate key value violates unique constraint"
**Causa:** El script ya fue ejecutado
**Solución:** No hay problema, el script usa `ON CONFLICT DO NOTHING` para evitar duplicados

### Error: "Permission denied"
**Causa:** Necesitas la service role key
**Solución:** Usa el anon key para lectura, o agrega la service role key a `.env.local`

---

## 🔑 Obtener Credenciales Faltantes

### SUPABASE_SERVICE_ROLE_KEY
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Haz clic en **Settings** (engranaje abajo a la izquierda)
4. En el menú, busca **API**
5. En la sección **Project API keys**, copia:
   - **Service role key** (es la segunda, debajo del anon key)
6. Pégala en `.env.local`:
   ```
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
   ```

---

## 📝 Verificar que Todo Funcionó

Después de ejecutar los scripts, puedes verificar en el SQL Editor:

```sql
-- Contar clientes
SELECT COUNT(*) FROM clientes;
-- Resultado esperado: 133

-- Contar productos
SELECT COUNT(*) FROM productos;
-- Resultado esperado: 150+

-- Ver primeros 5 clientes
SELECT cod_sucursal, nombre_cliente, estado FROM clientes LIMIT 5;

-- Ver primeros 5 productos
SELECT cod_producto, nombre_producto, unidad_medida FROM productos LIMIT 5;
```

---

## ✅ Próximo Paso

Una vez completado:
1. ✅ Credenciales en `.env.local` ← **EN PROGRESO**
2. ✅ SQL scripts ejecutados
3. ▶️ **Ejecutar**: `npm run dev`
4. Abre http://localhost:3000

---

## 📞 Comandos de Terminal (Alternativa)

Si prefieres usar terminal en lugar del dashboard:

```bash
# Instalar Supabase CLI (si no lo tienes)
npm install -g supabase

# Login a Supabase
supabase login

# Ejecutar scripts
supabase db push

# O manualmente con psql
psql -h db.whzlgqefoubtasnbszxj.supabase.co -U postgres -d postgres < sql/create_tables.sql
psql -h db.whzlgqefoubtasnbszxj.supabase.co -U postgres -d postgres < sql/insert_productos.sql
```

---

**¡Listo! Sigue estos pasos y tendrás la BD completamente configurada.** 🎉
