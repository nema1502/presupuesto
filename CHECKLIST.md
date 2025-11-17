# ✅ CHECKLIST DE CONFIGURACIÓN

Usa esta lista para verificar que todo está configurado correctamente.

## 📋 Paso 1: Configuración Inicial

- [ ] Clonaste el repositorio o tienes los archivos localmente
- [ ] Ejecutaste `npm install`
- [ ] Copiasteavatar `.env.example` a `.env.local`

## 🔐 Paso 2: Supabase

- [ ] Creaste cuenta en [supabase.com](https://supabase.com)
- [ ] Creaste un nuevo proyecto en Supabase
- [ ] Copiaste el URL del proyecto a `NEXT_PUBLIC_SUPABASE_URL`
- [ ] Copiaste la anon key a `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- [ ] Copiaste el service_role key a `SUPABASE_SERVICE_ROLE_KEY`

## 🗄️ Paso 3: Base de Datos

- [ ] Abriste **SQL Editor** en Supabase Dashboard
- [ ] Ejecutaste `sql/create_tables.sql`:
  - [ ] Copié el contenido del archivo
  - [ ] Lo pegué en el editor de SQL
  - [ ] Clickeé "Run"
  - [ ] Esperé a que se complete
- [ ] Ejecutaste `sql/insert_productos.sql`:
  - [ ] Copié el contenido del archivo
  - [ ] Lo pegué en el editor de SQL
  - [ ] Clickeé "Run"
  - [ ] Esperé a que se complete

## 🗄️ Paso 3b: Verificación de BD

- [ ] Abriste **Table Editor** en Supabase
- [ ] La tabla `clientes` existe y tiene datos (133 registros)
- [ ] La tabla `productos` existe y tiene datos
- [ ] La tabla `cliente_productos` existe (vacía inicialmente)
- [ ] La tabla `registros_mensuales` existe (vacía inicialmente)

## 💻 Paso 4: Desarrollo Local

- [ ] Ejecutaste `npm run dev`
- [ ] Abriste [http://localhost:3000](http://localhost:3000) en el navegador
- [ ] Viste la aplicación cargando correctamente
- [ ] No hay errores en la consola del navegador (F12)

## 🧪 Paso 5: Pruebas Funcionales

### Formulario
- [ ] Búsqueda de clientes funciona (autocompletado)
- [ ] Puedes seleccionar un cliente
- [ ] Se cargan los productos del cliente
- [ ] Puedes ingresar números en los campos mensuales
- [ ] Puedes hacer click en "Guardar Datos"
- [ ] Ves un mensaje de éxito o error

### Tabla Resumen
- [ ] La pestaña "Resumen" funciona
- [ ] Muestra estadísticas (total, LLENO, VACIO)
- [ ] Muestra tabla de clientes
- [ ] Actualiza después de guardar datos

### En Supabase
- [ ] Abriste **Table Editor > registros_mensuales**
- [ ] Ves los datos que guardaste desde el formulario
- [ ] Los valores tienen 2 decimales
- [ ] El estado del cliente cambió a "LLENO"

## 🚀 Paso 6: Deployment (Opcional)

- [ ] Subiste el código a GitHub (si lo hiciste)
- [ ] Conectaste el repositorio a Vercel/Railway
- [ ] Configuraste las variables de entorno en el servicio de deployment
- [ ] La aplicación está en vivo en producción

## 🔒 Seguridad - Checklist Final

- [ ] `.env.local` NO está en GitHub (está en .gitignore)
- [ ] No hay credenciales de Supabase en el código fuente
- [ ] Las credenciales son únicas para tu proyecto
- [ ] Cambiasteavatar la contraseña de Supabase (no es la predeterminada)

## 📊 Troubleshooting - Si algo no funciona

### "Cannot connect to Supabase"
- [ ] Verifica que `.env.local` tiene los valores correctos
- [ ] Verifica que el URL de Supabase es válido (empieza con https://)
- [ ] Verifica que la anon key no está vacía

### "No se encuentran clientes"
- [ ] Abre Supabase Dashboard > Table Editor > clientes
- [ ] ¿Hay datos allí? Si no, ejecuta `sql/create_tables.sql` nuevamente
- [ ] Verifica que los clientes están en estado "VACIO" (no "LLENO")

### "Tabla de productos vacía al seleccionar cliente"
- [ ] Ejecuta `sql/insert_productos.sql` en Supabase
- [ ] Verifica en Table Editor > cliente_productos que hay relaciones

### "Build falla al hacer `npm run build`"
- [ ] Ejecuta `npm install` nuevamente
- [ ] Elimina la carpeta `.next` y `.next` build
- [ ] Intenta `npm run build` de nuevo

### "Los datos no se guardan"
- [ ] Verifica en la consola (F12) si hay errores
- [ ] Verifica que el estado del cliente cambió a "LLENO" en la tabla resumen
- [ ] En Supabase, ve a **registros_mensuales** y busca tus datos

## ✨ Si llegaste aquí - ¡TODO FUNCIONA!

Felicidades! Tu aplicación está lista para usar.

### Próximos pasos recomendados:

1. **Familiarízate con la UI**
   - Prueba buscar diferentes clientes
   - Ingresa datos de prueba
   - Observa cómo cambian los estados

2. **Lee la documentación**
   - README.md - Características y documentación
   - SETUP_GUIDE.md - Guía detallada de configuración
   - PROJECT_SUMMARY.md - Resumen del proyecto

3. **Personaliza según necesites**
   - Modifica colores en `globals.css`
   - Agrega más clientes o productos
   - Implementa autenticación

4. **Deploy a producción**
   - Sigue DEPLOYMENT.md para subir a Vercel o tu servidor

---

## 📞 ¿Necesitas ayuda?

1. Revisa los archivos de documentación (.md)
2. Abre la consola del navegador (F12) para errores
3. Revisa los logs de Supabase
4. Verifica que todas las variables de entorno están correctas

---

**Estado**: ✅ Listo para usar
**Fecha**: Noviembre 14, 2025
**Versión**: 1.0.0
