## 🔐 SOLUCIÓN: Login No Funciona Después del Registro

### 🎯 EL PROBLEMA
Registro funciona ✅, pero después no puedo iniciar sesión ❌

### 🔍 PRIMERO: VERIFICA LA CONFIGURACIÓN EN SUPABASE

1. **Ve a tu Dashboard de Supabase**
2. **Abre: Authentication → Email Provider**
3. **Busca: "Confirm email"** (o "Email verification")

**¿Está HABILITADA (ON)?**
- ✅ SÍ → El usuario debe confirmar email primero (verá un email con link)
- ❌ NO → El usuario puede loguear inmediatamente

---

## ✅ SOLUCIÓN RÁPIDA (DESARROLLO)

Si quieres que funcione ya mismo para probar:

### 1️⃣ En Supabase Dashboard:
```
Authentication → Email Provider → Confirm email → DESACTIVA
(Busca el switch/toggle y cámbialo a OFF)
```

### 2️⃣ Intenta de nuevo:
```
1. Crea cuenta nueva (signup)
2. Espera 2 segundos → Te redirige a login
3. Ingresa email y contraseña → ¡Debería funcionar!
```

---

## 🔍 SI AÚN NO FUNCIONA: DEBUGGING

### Opción A: Consola del navegador (F12)
```
Abre DevTools → Console tab

Cuando hagas login, deberías ver:
✅ "🔐 Intento de login con: tumail@example.com"
✅ "✅ Login exitoso: ..."

Si ves error, cópialo completo y mira "Opción C" abajo
```

### Opción B: Página de Debug (NUEVA)
```
Abre: http://localhost:3000/debug

Verás en tiempo real:
- ¿Hay sesión activa?
- ¿Cuál es el usuario logueado?
- ¿Hay usuarios en la tabla 'usuarios'?
- ¿Están las cookies configuradas?
```

### Opción C: Revisa la Tabla de Usuarios
```
En Supabase SQL Editor, ejecuta:

SELECT * FROM usuarios;
```

Deberías ver un registro con:
- email: el que usaste en signup
- display_name: el nombre que pusiste
- estado: 'ACTIVO'
- created_at: fecha de hoy

Si NO ves nada → El usuario no se registró bien
Si VES → El usuario existe, pero el login falla por otra razón

---

## 🚨 ERRORES COMUNES Y SOLUCIONES

### ❌ Error: "Invalid login credentials"
**Causa:** Email o contraseña incorrectos
**Solución:** 
- Verifica que escribas igual el email en signup y login
- Verifica que la contraseña sea la misma
- Prueba con mayúsculas/minúsculas (son sensibles)

### ❌ Error: "Email not confirmed"
**Causa:** La confirmación de email está habilitada
**Solución:**
```
1. Opción 1: Deshabilita confirmación en Supabase (arriba)
2. Opción 2: El usuario debe hacer click en el link del email
   (Revisa spam/promociones)
```

### ❌ Error: "User already registered"
**Causa:** Ese email ya existe
**Solución:**
- Usa un email diferente para probar
- O borra el usuario de Supabase y vuelve a registrarte

### ❌ No hay sesión después de login
**Causa:** Las cookies no se están guardando
**Solución:**
```
1. Abre http://localhost:3000/debug
2. Revisa "Cookies Auth": ¿dice "SÍ"?
3. Si dice "NO", hay problema con las cookies
4. Intenta: Ctrl+Shift+Delete → Borra cookies → Vuelve a intentar
```

### ❌ El usuario no aparece en tabla 'usuarios'
**Causa:** El trigger no ejecutó al registrarse
**Solución:**
```
1. Abre Supabase SQL Editor
2. Ejecuta este script:

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.usuarios (auth_id, email, display_name, estado)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    'ACTIVO'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

3. Vuelve a registrar un usuario
4. Verifica que aparezca en SELECT * FROM usuarios;
```

---

## 📋 CHECKLIST COMPLETO

- [ ] Fui a Supabase Dashboard
- [ ] Revisé si "Confirm email" está ON u OFF
- [ ] Probé signup → login con "Confirm email" OFF
- [ ] Abrí F12 y veo los logs "✅ Login exitoso"
- [ ] Abrí http://localhost:3000/debug
- [ ] La tabla "usuarios" tiene datos
- [ ] Las cookies están presentes (SÍ, SÍ)
- [ ] El Header muestra mi email/nombre cuando logueo
- [ ] Todo funciona ✅

---

## 🚀 PRÓXIMOS PASOS

Una vez que login/signup funcione:

1. **Intenta el flujo completo:**
   ```
   Login → Selecciona cliente → Carga datos → Guarda → Logout → Login → Verifica datos
   ```

2. **Verifica que la tabla 'registros_mensuales' reciba datos**
   ```sql
   SELECT COUNT(*) FROM registros_mensuales;
   ```

3. **Listo para producción:**
   - Habilita "Confirm email" en Supabase
   - Configura tu dominio en CORS
   - Deploy en Vercel o tu hosting

---

## 💬 ¿NECESITAS MÁS AYUDA?

Si aún no funciona:
1. Abre http://localhost:3000/debug
2. Copia el JSON de "Información Técnica"
3. Comparte conmigo qué error exacto ves

O dime:
- ¿Qué error ves en la consola (F12)?
- ¿"Confirm email" está ON u OFF?
- ¿Qué ves en http://localhost:3000/debug?
