# ❓ PREGUNTAS FRECUENTES (FAQ)

## 🚀 Inicio y ejecución

### P: ¿Cómo inicio la aplicación?
**R**: Ejecuta `npm run dev` en la terminal. La aplicación estará en http://localhost:3000

### P: ¿Por qué no puedo acceder a localhost:3000?
**R**: Verifica que:
- `npm run dev` está ejecutando en la terminal
- No hay otro proceso en el puerto 3000
- El navegador es moderno (Chrome, Firefox, Safari, Edge)

### P: ¿Necesito Internet siempre?
**R**: Sí, necesitas conexión para conectar con Supabase. Sin Internet, la aplicación no funcionará.

---

## 🔐 Autenticación y variables de entorno

### P: ¿Dónde obtengo las credenciales de Supabase?
**R**: 
1. Ve a supabase.com
2. Crea un proyecto
3. Ve a Settings > API
4. Copia el URL y la anon key
5. Pégalas en `.env.local`

### P: ¿Qué es `.env.local`?
**R**: Un archivo que contiene variables secretas (credenciales). NO debe estar en GitHub.

### P: ¿Es seguro tener credenciales en `.env.local`?
**R**: Sí, porque:
- `.env.local` está en `.gitignore`
- No se sube a GitHub
- Solo tu computadora lo ve
- En producción, configuras variables en el servicio (Vercel, etc)

### P: ¿Qué significa "NEXT_PUBLIC_"?
**R**: Variables que se exponen al navegador. Las sin "NEXT_PUBLIC_" son solo del servidor.

---

## 💾 Base de datos

### P: ¿Cómo creo las tablas en Supabase?
**R**:
1. Abre Supabase Dashboard
2. Ve a SQL Editor
3. Copia el contenido de `sql/create_tables.sql`
4. Pega y ejecuta

### P: ¿Cuántos clientes hay por defecto?
**R**: 133 clientes cargados automáticamente. Puedes agregar más ejecutando INSERT.

### P: ¿Puedo modificar la estructura de la BD?
**R**: Sí, pero necesitas entender SQL y actualizar el código correspondiente.

### P: ¿Dónde se guardan los datos que ingreso?
**R**: En Supabase, tabla `registros_mensuales`. Puedes verlos en Table Editor.

### P: ¿Qué significa "estado VACIO/LLENO"?
**R**:
- VACIO = No tiene datos mensuales cargados
- LLENO = Ya tiene datos mensuales cargados

---

## 🎨 Interfaz y funcionalidad

### P: ¿Cómo busco un cliente?
**R**: 
1. Ve a la pestaña "Formulario"
2. Escribe el nombre (ej: "FRIGOR")
3. Selecciona de la lista

### P: ¿Por qué no aparecen productos al seleccionar un cliente?
**R**: Probable razón:
- No ejecutaste `sql/insert_productos.sql`
- El cliente no tiene productos asignados en la BD
- Hay un error de conexión

### P: ¿Puedo editar datos después de guardar?
**R**: Sí. Solo selecciona el cliente nuevamente, modifica y guarda.

### P: ¿Por qué los números deben tener 2 decimales?
**R**: Es el estándar para precisión en datos financieros/comerciales.

### P: ¿Puedo agregar más meses (diciembre)?
**R**: Sí, el campo diciembre existe pero es opcional. Actualiza el formulario si lo necesitas.

---

## 🧪 Testing

### P: ¿Cómo ejecuto los tests?
**R**: `npm test`

### P: ¿Hay muchos tests?
**R**: Hay tests básicos. En producción deberías agregar más.

### P: ¿Necesito tests para desarrollar?
**R**: No, pero es buena práctica. Para desarrollo rápido, puedes saltarlos.

---

## 🐛 Problemas y errores

### P: "Cannot read properties of undefined (reading 'supabase')"
**R**: `.env.local` no tiene credenciales válidas. Verifica y reinicia.

### P: "No se encuentran clientes"
**R**: No ejecutaste `sql/create_tables.sql`. Hazlo en Supabase SQL Editor.

### P: El formulario no guarda datos
**R**: Posibles razones:
- Supabase no está conectado
- No hay datos en `.env.local`
- Hay un error en la consola (F12)

### P: "Port 3000 already in use"
**R**: Otro proceso usa el puerto. Mata el proceso o usa otro puerto: `npm run dev -- -p 3001`

### P: La tabla está vacía al seleccionar cliente
**R**: Ejecuta `sql/insert_productos.sql` en Supabase.

---

## 🚀 Deployment y producción

### P: ¿Cómo subo la aplicación a Internet?
**R**: Sigue DEPLOYMENT.md. Recomendación: Usa Vercel (gratis y automático).

### P: ¿Necesito servidor propio?
**R**: No. Vercel, Railway o cualquier servicio de Node.js es suficiente.

### P: ¿Cuánto cuesta?
**R**: Gratis hasta cierto tráfico. Después, pagos según uso.

### P: ¿Se pierden datos al hacer deploy?
**R**: No. Los datos están en Supabase, que es independiente del frontend.

---

## 🔄 Actualización y cambios

### P: ¿Cómo agrego nuevas funciones?
**R**: 
1. Modifica los archivos en `src/`
2. Los cambios se aplican en vivo (hot reload)
3. No necesitas reiniciar

### P: ¿Cómo cambio los colores de la app?
**R**: Modifica `src/app/globals.css` o los estilos Tailwind en componentes.

### P: ¿Cómo agrego nuevos campos al formulario?
**R**: Edita `src/components/forms/FormularioProductos.tsx`

### P: ¿Cómo agrego nuevos clientes?
**R**: Ejecuta INSERT en Supabase o a través de la aplicación (si implementas esa funcionalidad).

---

## 📚 Documentación

### P: ¿Dónde está la documentación?
**R**: 
- README.md - Completo
- QUICK_START.md - 5 minutos
- SETUP_GUIDE.md - Detallado
- PROJECT_SUMMARY.md - Resumen
- CHECKLIST.md - Verificación
- HOW_TO_RUN.md - Cómo ejecutar

### P: ¿Qué archivo debo leer primero?
**R**: QUICK_START.md si estás apurado, SETUP_GUIDE.md si quieres entender todo.

---

## 💪 Funcionalidades avanzadas

### P: ¿Cómo agrego autenticación de usuario?
**R**: Esta es una mejora futura (Fase 2). Requiere:
- Implementar Supabase Auth
- Crear UI de login
- Configurar permisos por usuario

### P: ¿Cómo exporto datos a Excel?
**R**: No está implementado. Podrías usar librerías como `xlsx` o `react-excel`.

### P: ¿Cómo creo gráficos de datos?
**R**: Puedes usar librerías como `recharts`, `chart.js` o `plotly`.

### P: ¿Cómo hago backups?
**R**: Supabase tiene backups automáticos. También puedes exportar SQL manualmente.

---

## 🤝 Soporte y ayuda

### P: ¿A quién contacto si hay problemas?
**R**: 
1. Revisa los archivos de documentación
2. Abre la consola (F12) para ver errores
3. Verifica Supabase Dashboard
4. Revisa CHECKLIST.md para problemas comunes

### P: ¿Hay un chat de soporte?
**R**: No hay chat. Usa los recursos de documentación y GitHub issues si tienes el repo.

### P: ¿Puedo modificar el código?
**R**: Completamente. Es tu proyecto. Modifica como necesites.

---

## 📊 Datos y migración

### P: ¿Cómo importo datos desde otro lugar?
**R**: Necesitarías crear un script SQL para importar. O usar Supabase Data Import.

### P: ¿Cómo hago backup de mis datos?
**R**: En Supabase Dashboard > Settings > Backups. O exporta SQL manualmente.

### P: ¿Puedo tener múltiples ambientes (desarrollo, producción)?
**R**: Sí. Crea múltiples proyectos en Supabase y cambia `.env.local` según el ambiente.

---

## ⚡ Performance

### P: ¿Es rápida la aplicación?
**R**: Sí. Está optimizada con:
- Next.js (compilación a servidor)
- Índices en BD
- Caching automático

### P: ¿Cuántos usuarios puede soportar?
**R**: Miles. Supabase escala automáticamente. Costo aumenta con uso.

### P: ¿Cómo mejoro la velocidad?
**R**: 
- Agrega más índices en BD
- Implementa paginación
- Usa caché
- Optimiza imágenes

---

## 🎓 Aprendizaje

### P: ¿Dónde puedo aprender Next.js?
**R**: 
- nextjs.org/learn
- YouTube
- Cursos en Udemy

### P: ¿Dónde puedo aprender Supabase?
**R**: 
- supabase.com/docs
- YouTube
- Discord Supabase

### P: ¿Es difícil entender el código?
**R**: No. Es JavaScript moderno con comentarios. Dedica 1-2 horas y entenderás.

---

## ✅ Resumen

**La mayoría de preguntas se responden en los archivos de documentación.**

Antes de contactar a alguien o publicar en un foro, verifica:
1. QUICK_START.md
2. SETUP_GUIDE.md
3. CHECKLIST.md
4. Este archivo (FAQ)

---

**Si tu pregunta no está aquí**, revisa los otros archivos de documentación o abre la consola (F12) para ver el error específico.

¡Buen código! 🚀
