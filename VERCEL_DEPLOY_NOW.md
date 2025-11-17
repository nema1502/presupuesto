# 🚀 DESPLIEGUE EN VERCEL - PASOS RÁPIDOS

## ✅ Estado Actual
- ✅ Build: **EXITOSO** (npm run build)
- ✅ Código: **COMMITEADO** en git
- ✅ Variables de entorno: **CONFIGURADAS localmente**

## 📋 PRÓXIMOS PASOS (Haz esto en orden):

### PASO 1: Crear Repositorio en GitHub
1. Ve a https://github.com/new
2. Ingresa el nombre del repo (ej: `app-gestion-productos`)
3. Selecciona "Public" o "Private"
4. NO marques "Add a README" (ya lo tienes)
5. Click "Create repository"
6. Copia la URL que GitHub te muestra (algo como `https://github.com/TU_USUARIO/TU_REPO.git`)

### PASO 2: Push a GitHub
Ejecuta estos comandos en la terminal en tu proyecto:

```powershell
git remote add origin https://github.com/TU_USUARIO/TU_REPO.git
git branch -M main
git push -u origin main
```

**Reemplaza `TU_USUARIO` y `TU_REPO` con tus valores reales**

### PASO 3: Desplegar en Vercel
1. Ve a https://vercel.com/dashboard
2. Haz login con GitHub
3. Click "Add New" → "Project"
4. Vercel te mostrará tu repositorio
5. Selecciona tu repo
6. Click "Import"
7. Vercel detectará Next.js automáticamente
8. Click "Deploy"

### PASO 4: Configurar Variables de Entorno en Vercel
1. Espera a que se despliegue (toma 2-3 minutos)
2. Ve al dashboard del proyecto en Vercel
3. Click "Settings" → "Environment Variables"
4. Añade estas 3 variables (cópialas de tu .env.local):
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
5. Click "Save"
6. Ve a "Deployments" → Encuentra el deployment anterior
7. Click los 3 puntos → "Redeploy"

### PASO 5: Añadir Dominio a Supabase (IMPORTANTE)
1. Ve a tu Supabase dashboard
2. Project → Settings → Authentication
3. Busca "Authorized redirect URLs"
4. Añade: `https://tu-proyecto-nombre.vercel.app`
   (Reemplaza con tu URL real de Vercel)
5. Click "Save"

### ✅ LISTO
Tu app debería estar en vivo en:
`https://tu-proyecto-nombre.vercel.app`

---

## 🆘 Si algo falla:

**Error en build:** Verifica los logs en Vercel → Deployments
**Login no funciona:** Verifica Supabase redirect URLs
**Base de datos no conecta:** Verifica las env vars están correctas

---

## 📞 Comandos útiles después del deploy

```powershell
# Para hacer cambios futuros:
git add .
git commit -m "descripción"
git push origin main
# Vercel redeploy automáticamente

# Para ver logs:
vercel logs
```

---

¡Hazlo y avísame cuando esté en vivo! 🎉
