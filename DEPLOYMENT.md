# 🚀 Guía de Deployment

## Opciones de deployment para tu aplicación

### Opción 1: Vercel (Recomendado) ⭐

Vercel es la mejor opción para Next.js y es muy sencillo.

#### Pasos:

1. **Crea una cuenta en Vercel**
   - Ve a https://vercel.com
   - Inicia sesión con GitHub/GitLab/Bitbucket

2. **Sube tu código a GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/tuusuario/gestion-productos.git
   git push -u origin main
   ```

3. **Importa el proyecto en Vercel**
   - En Vercel Dashboard, haz clic en "New Project"
   - Selecciona tu repositorio
   - No necesita configuración especial (Vercel detecta Next.js automáticamente)

4. **Configura variables de entorno**
   - En Project Settings > Environment Variables
   - Agrega todas tus variables de `.env.local`:
     ```
     NEXT_PUBLIC_SUPABASE_URL
     NEXT_PUBLIC_SUPABASE_ANON_KEY
     SUPABASE_SERVICE_ROLE_KEY
     NEXT_PUBLIC_APP_URL
     ```

5. **Deploy**
   - Haz clic en Deploy
   - Vercel compilará y desplegará automáticamente
   - Tu app estará en: `https://tuproyecto.vercel.app`

**Tiempo**: ~2 minutos
**Costo**: Gratis para hobby projects
**Ventajas**: Automático, rápido, escalable

---

### Opción 2: Railway

Otra opción moderna y sencilla.

#### Pasos:

1. **Crea cuenta en Railway**
   - Ve a https://railway.app

2. **Conecta tu repositorio de GitHub**

3. **Railway detectará que es Next.js**

4. **Agrega variables de entorno** en Railway Dashboard

5. **Deploy automático**

**Costo**: $5/mes (gratis los primeros meses)

---

### Opción 3: Docker + Cualquier servidor

Si quieres más control, puedes usar Docker.

#### Crear Dockerfile:

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY .next ./.next
COPY public ./public

EXPOSE 3000

CMD ["npm", "start"]
```

#### Build:
```bash
npm run build
docker build -t gestion-productos .
docker run -p 3000:3000 gestion-productos
```

---

### Opción 4: Servidor propio (DigitalOcean, AWS, etc)

#### Pasos generales:

1. **Crear instancia Linux**
   - Ubuntu 22.04 o similar

2. **Instalar Node.js**
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs
   ```

3. **Clonar código**
   ```bash
   git clone https://github.com/tuusuario/gestion-productos.git
   cd gestion-productos
   npm install
   ```

4. **Configurar variables**
   ```bash
   nano .env.local
   # Agregar todas las variables
   ```

5. **Build y start**
   ```bash
   npm run build
   npm start
   ```

6. **Usar PM2 para mantener activo**
   ```bash
   npm install -g pm2
   pm2 start npm --name "gestion-productos" -- start
   pm2 startup
   pm2 save
   ```

7. **Configurar Nginx como reverse proxy**
   ```nginx
   server {
       listen 80;
       server_name tudominio.com;
       
       location / {
           proxy_pass http://localhost:3000;
       }
   }
   ```

8. **SSL con Let's Encrypt**
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d tudominio.com
   ```

---

## 🔒 Checklist de seguridad antes de deployment

- [ ] Variables de entorno configuradas correctamente
- [ ] No hay credenciales en el código
- [ ] .env.local está en .gitignore
- [ ] Supabase RLS está habilitado
- [ ] Se usa HTTPS en producción
- [ ] Las contraseñas de Supabase son fuertes
- [ ] Se ha probado en ambiente de staging

---

## 📊 Monitoreo post-deployment

### Recomendaciones:

1. **Sentry** (Manejo de errores)
   ```bash
   npm install @sentry/nextjs
   ```

2. **Logrocket** (Debugging)
   - LogRocket.init('app-id');

3. **Analytics**
   - Google Analytics
   - Vercel Analytics (automático en Vercel)

---

## ⚡ Performance

### Optimizaciones recomendadas:

1. **CDN para Supabase**
   - Ya incluido automáticamente

2. **Image optimization**
   - Ya incluido en Next.js

3. **Caching**
   ```typescript
   // En next.config.ts
   headers: [{
     source: '/api/:path*',
     headers: [{
       key: 'Cache-Control',
       value: 'public, max-age=60'
     }]
   }]
   ```

---

## 📈 Escalabilidad

Tu aplicación está diseñada para crecer:

- ✅ Supabase escala automáticamente
- ✅ Next.js + Vercel maneja miles de usuarios
- ✅ Base de datos índices optimizados
- ✅ RLS para seguridad

---

## 💾 Backups

### Supabase backups:

1. Ve a **Settings > Backups**
2. Habilita backups automáticos
3. Supabase guarda backups diarios

### Backup manual:
```bash
# Exportar datos
pg_dump your_database > backup.sql
```

---

## 🎯 Resumen de deployment

| Opción | Costo | Setup | Mantenimiento | Recomendado |
|--------|-------|-------|---------------|------------|
| Vercel | Gratis | 5 min | Automático | ✅ Mejor |
| Railway | $5/mes | 5 min | Automático | ✅ Bueno |
| Docker | Variable | 20 min | Manual | Avanzado |
| Servidor | $10+/mes | 1 hora | Manual | Flexibilidad |

**Mi recomendación**: Usa Vercel. Es gratis, rápido y automático. 🚀

---

## 🔗 Recursos

- [Vercel Deployment](https://vercel.com/docs)
- [Next.js Production Checklist](https://nextjs.org/docs/going-to-production)
- [Supabase Security](https://supabase.com/docs/guides/platform/security)
