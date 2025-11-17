# 🚀 EJECUTAR SQL SCRIPTS - Instrucciones Paso a Paso

## ✅ Estado Actual
- ✅ `.env.local` **COMPLETAMENTE CONFIGURADO**
- ✅ Todas las credenciales de Supabase están listas
- ▶️ **PRÓXIMO:** Ejecutar los scripts SQL

---

## 📋 Dos Scripts a Ejecutar

### 1. `sql/create_tables.sql` (PRIMERO)
Crea: 4 tablas + 133 clientes precargados

### 2. `sql/insert_productos.sql` (SEGUNDO)  
Carga: 150+ productos + relaciones

---

## 🎯 Opción A: VÍA DASHBOARD (RECOMENDADO - 5 minutos)

### Paso 1: Abrir SQL Editor
1. Ve a https://supabase.com/dashboard
2. Selecciona tu proyecto **whzlgqefoubtasnbszxj**
3. Click en **SQL Editor** (menú izquierdo)

### Paso 2: Ejecutar create_tables.sql
1. Click en **+ New Query**
2. Dale un nombre: `1-CreateTables`
3. **COPIA TODO EL CONTENIDO** de `sql/create_tables.sql` (todo el archivo)
4. **PEGA** en el editor de Supabase
5. Click en **RUN** (botón azul arriba a la derecha)
6. ✅ Espera el mensaje: **"Success"**

**Resultado esperado:**
```
✓ Tables created successfully
✓ 133 clients inserted
✓ Indexes created
✓ RLS policies enabled
```

### Paso 3: Ejecutar insert_productos.sql
1. Click en **+ New Query**
2. Dale un nombre: `2-InsertProducts`
3. **COPIA TODO EL CONTENIDO** de `sql/insert_productos.sql`
4. **PEGA** en el editor
5. Click en **RUN**
6. ✅ Espera: **"Success"**

**Resultado esperado:**
```
✓ 150+ products inserted
✓ Client-product relationships created
✓ No conflicts detected
```

---

## 🎯 Opción B: VÍA TERMINAL (Alternativa)

Si prefieres línea de comandos:

```powershell
# Navega a tu proyecto
cd "d:\Usuario\Nicolas Mejia\Documentos\Nueva carpeta\desarrollo_op\proy"

# Instala Supabase CLI (si no lo tienes)
npm install -g @supabase/cli

# Login
supabase login

# Link tu proyecto
supabase link --project-ref whzlgqefoubtasnbszxj

# Ejecuta los scripts
supabase db push
```

---

## ✅ Verificar que Todo Funcionó

Una vez ejecutados los scripts, puedes verificar en SQL Editor de Supabase:

```sql
-- Ver cuántos clientes hay
SELECT COUNT(*) as total_clientes FROM clientes;
-- Resultado: 133

-- Ver cuántos productos hay
SELECT COUNT(*) as total_productos FROM productos;
-- Resultado: 150+

-- Ver primeros 5 clientes
SELECT cod_sucursal, nombre_sucursal, estado FROM clientes LIMIT 5;

-- Ver primeros 5 productos
SELECT cod_producto, nombre_producto, unidad_medida FROM productos LIMIT 5;
```

---

## 🚨 Si Algo Sale Mal

### Error: "relation "clientes" does not exist"
❌ **Problema:** Olvidaste ejecutar `create_tables.sql` primero  
✅ **Solución:** Ejecuta `create_tables.sql` antes de `insert_productos.sql`

### Error: "duplicate key value"
❌ **Problema:** Los scripts ya fueron ejecutados  
✅ **Solución:** No hay problema, el script usa `ON CONFLICT DO NOTHING`

### Error: "Permission denied"
❌ **Problema:** Las credenciales no están correctas  
✅ **Solución:** Verifica que `.env.local` tiene las 3 claves correctas:
```bash
cat .env.local
```

### Error en Supabase Dashboard
❌ **Problema:** El SQL tiene error de sintaxis  
✅ **Solución:** 
- Copia el script COMPLETO sin modificar
- Asegúrate de no dejar líneas sin terminar
- Haz RUN nuevamente

---

## ⏱️ Timeline Esperado

```
⏱️  Paso 1 (create_tables): ~5 segundos
⏱️  Paso 2 (insert_productos): ~3 segundos
⏱️  Total: ~10 segundos
```

---

## 🎉 Una Vez Completado

```bash
npm run dev
```

Abre: http://localhost:3000

Verás:
- ✅ Pestaña "Formulario" con búsqueda de clientes
- ✅ 133 clientes disponibles para seleccionar
- ✅ Tabla resumen con estadísticas
- ✅ Todos los 150+ productos listos para cargar

---

## 📞 Resumen de Archivos

| Archivo | Ubicación | Contenido |
|---------|-----------|----------|
| `.env.local` | Raíz | ✅ Credenciales completadas |
| `create_tables.sql` | sql/ | ✅ Listo para copiar/pegar |
| `insert_productos.sql` | sql/ | ✅ Listo para copiar/pegar |

**¡Listo para ejecutar los SQL scripts!** 🚀
