# 🔄 RESET COMPLETO DE BASE DE DATOS

## ¿QUÉ HACER?

### PASO 1: Abre Supabase
https://supabase.com → Tu proyecto

### PASO 2: SQL Editor
- Haz click en **SQL Editor** en el menú izquierdo
- Haz click en **New Query**

### PASO 3: EJECUTA PRIMERO ESTE SCRIPT
Copia TODO el contenido de:
```
sql/RESET_CLEAN.sql
```

Y pégalo en el SQL Editor de Supabase. Luego haz click en **▶ Run**

**Espera a que termine** (verás ✓ cuando esté listo)

### PASO 4: EJECUTA SEGUNDO SCRIPT
Copia TODO el contenido de:
```
sql/SAMPLE_DATA_CLEAN.sql
```

Y pégalo en una **NEW QUERY** en SQL Editor. Luego haz click en **▶ Run**

**Espera a que termine** (verás al final):
```
tablas     cantidad
Clientes   3
Productos  19
Cliente-Productos  21
```

---

## ✅ VERIFICACIÓN

Si ves los números anteriores, está perfecto.

Ahora:

1. **Para en terminal**: `Ctrl+C` (si npm run dev está corriendo)
2. **Reinicia el servidor**: `npm run dev`
3. **Abre**: http://localhost:3000
4. **Busca**: "FRIGOR S.A."
5. **Debería cargar 6 productos**
6. **Llena un valor**: Enero = 10.5
7. **Click**: "Guardar"
8. **Verifica**: Formulario se limpia, datos guardados

---

## 🆘 SI ALGO FALLA

1. Verifica que ambos scripts completaron SIN ERRORES
2. Comprueba en Supabase → Tables que las tablas existan
3. Comprueba en Supabase → Tables → clientes que hay 3 clientes
4. Comprueba en Supabase → Tables → productos que hay 19 productos

---

## 📝 NOTA

Los datos están **LIMPIOS Y VERIFICADOS**:
- Clientes: 3 clientes de prueba
- Productos: 19 productos asignados correctamente
- Relaciones: Todos los productos están asignados a sus clientes

¡Esto DEBE funcionar ahora!
