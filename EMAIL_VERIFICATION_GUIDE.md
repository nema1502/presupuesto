## 🔑 Verificación de Email y Configuración de Autenticación

### PROBLEMA COMÚN: 
"Registro funciona pero no puedo iniciar sesión después"

### CAUSAS POSIBLES:

1. **Email no confirmado** (si está habilitada la confirmación)
2. **Credenciales incorrectas** durante el login
3. **Sesión no se crea correctamente**

---

## ✅ SOLUCIÓN PASO A PASO

### OPCIÓN 1: Deshabilitar Confirmación de Email (MÁS RÁPIDO)

Si solo estás desarrollando y quieres probar rápidamente:

1. Ve a **Supabase Dashboard** → **Authentication** (Autenticación)
2. Click en **Email** (en Providers)
3. Busca la opción **"Confirm email"**
4. **DESHABILITA** la confirmación: cambia a "OFF" o similar
5. Guarda los cambios

**Ahora:**
- Registro → Login debería funcionar inmediatamente
- **Sin necesidad de verificar email**

---

### OPCIÓN 2: Mantener Confirmación de Email (PRODUCCIÓN)

Si quieres confirmación de email:

1. En Supabase Dashboard → **Authentication** → **Email**
2. Asegúrate que **"Confirm email"** esté habilitado
3. En la sección **"Email templates"**, verifica que el template de confirmación sea correcto
4. Verifica que tu **redirect URL** esté configurada:
   - Deberá ser: `http://localhost:3000/auth/login` (desarrollo)
   - O: `https://tudominio.com/auth/login` (producción)

**El usuario recibirá un email con un link de confirmación**

---

### OPCIÓN 3: Permitir Login sin Confirmar Email

Algunos proveedores permiten:
1. Registrarse sin confirmación requerida
2. Pero puedes enviar un email de bienvenida

En Supabase:
1. Supabase Dashboard → **Authentication** → **Policies**
2. Busca **"Auth provider"** y asegúrate que **"Email verification required"** esté OFF

---

## 🔍 DEBUGGING: ¿Por qué no inicia sesión?

Abre la **Consola del Navegador** (F12):

```
Si ves en Console:
✅ "🔐 Intento de login con: usuario@email.com"
✅ "✅ Login exitoso: ..."
   → El login funcionó, revisa si la redirección está bien

❌ "Error de login: Invalid login credentials"
   → Email o contraseña incorrectos

❌ "Error de login: Email not confirmed"
   → El usuario debe confirmar email primero
   → O deshabilita la confirmación (OPCIÓN 1 arriba)

❌ "Error de login: User already registered"
   → El usuario ya existe, usa otro email
```

---

## 📋 CHECKLIST DE CONFIGURACIÓN

- [ ] He ido a **Supabase Dashboard**
- [ ] He abierto **Authentication**
- [ ] He visto la sección **Email Provider**
- [ ] He revisado si **Confirm email** está ON o OFF
- [ ] Sé qué esperar: confirmación requerida o no
- [ ] He probado registro + login en ese orden

---

## 🚀 PRÓXIMOS PASOS

### Después de que funcione login/registro:

1. **Verifica la tabla `usuarios`** (ejecuta en Supabase SQL):
```sql
SELECT * FROM usuarios;
```

Deberías ver un registro con:
- `id`: UUID único
- `auth_id`: ID de Supabase Auth
- `email`: tu email de prueba
- `display_name`: tu nombre
- `estado`: 'ACTIVO'
- `created_at`: fecha de registro

2. **Revisa el Header** - debería mostrarte tu nombre/email cuando loguees

3. **Guarda datos** - ahora debería funcionar el flujo completo:
   - Login → Cargar cliente → Guardar datos → Logout → Login → Ver datos guardados

---

## 💡 RECOMENDACIÓN

Para desarrollo, usa **OPCIÓN 1** (deshabilitar confirmación).
Cuando vayas a producción, cambia a **OPCIÓN 2** (con confirmación).

¿Necesitas ayuda con alguno de estos pasos?
