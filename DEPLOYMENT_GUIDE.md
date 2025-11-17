# 🚀 Guía de Despliegue en Vercel

## Paso 1: Preparar para GitHub

### 1.1 Inicializar repositorio Git (si no está hecho)
```bash
git init
git add .
git commit -m "Initial commit: App de gestión de productos"
```

### 1.2 Crear repositorio en GitHub
1. Ve a https://github.com/new
2. Crea un nuevo repositorio con el nombre que desees
3. NO inicialices con README (ya lo tienes)
4. Copia el comando que GitHub te muestra

### 1.3 Conectar y subir a GitHub
```bash
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git branch -M main
git push -u origin main
```

---

## Paso 2: Desplegar en Vercel

### 2.1 Opción A: Desde el panel de Vercel (Recomendado)
1. Ve a https://vercel.com
2. Haz login con tu cuenta GitHub
3. Click en "Add New" → "Project"
4. Selecciona tu repositorio
5. Vercel detectará Next.js automáticamente
6. Click en "Deploy"

### 2.2 Opción B: Usar Vercel CLI
```bash
npm install -g vercel
vercel
```
Sigue las instrucciones interactivas.

---

## Paso 3: Configurar Variables de Entorno en Vercel

Una vez que el proyecto esté creado en Vercel:

1. Ve a tu proyecto en Vercel dashboard
2. Click en "Settings" → "Environment Variables"
3. Añade estas variables:

```
NEXT_PUBLIC_SUPABASE_URL = tu_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY = tu_anon_key
SUPABASE_SERVICE_ROLE_KEY = tu_service_role_key
```

4. Click "Save"
5. Ve a "Deployments" y redeploy el último deployment

---

## Paso 4: Verificar Despliegue

- ✅ Accede a tu dominio de Vercel (algo como `tu-proyecto.vercel.app`)
- ✅ Prueba el login/signup
- ✅ Verifica que todo funciona

---

## Troubleshooting

### Error: `Build failed`
- Revisa los logs en Vercel
- Asegúrate que todas las env vars estén configuradas
- Ejecuta `npm run build` localmente para verificar

### Error: `Auth not working`
- Verifica que los env vars sean correctos
- En Supabase, añade tu dominio de Vercel a "Authorized redirect URLs"
- Ve a Supabase → Settings → Auth → URL Configuration
- Añade: `https://tu-proyecto.vercel.app`

### Error: `Database connection issues`
- Verifica las RLS policies en Supabase
- Asegúrate que la tabla `usuarios` existe y tiene triggers

---

## URLs Importantes

- **Vercel Dashboard**: https://vercel.com/dashboard
- **Supabase Console**: https://supabase.com/dashboard
- **Tu App en Vercel**: https://tu-proyecto.vercel.app
- **GitHub Repo**: https://github.com/TU_USUARIO/TU_REPOSITORIO

---

## Comandos Rápidos

```bash
# Compilar localmente para verificar
npm run build

# Verificar errores
npm run lint

# Ejecutar tests
npm test

# Push a GitHub
git add .
git commit -m "mensaje"
git push origin main

# Vercel redeploy
vercel --prod
```

---

¡Listo! Tu app debería estar en vivo en Vercel 🎉
