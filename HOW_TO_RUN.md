# 🎯 CÓMO INICIAR LA APLICACIÓN

## ⚡ Comando rápido

```bash
npm run dev
```

Eso es todo lo que necesitas. La aplicación estará en **http://localhost:3000**

---

## 📋 Paso a paso

### 1. Terminal abierta en la carpeta del proyecto

```bash
cd /ruta/a/tu/proyecto
```

### 2. Verificar que dependencias están instaladas

```bash
npm install
```

(Si ya ejecutaste esto antes, puedes saltarlo)

### 3. Iniciar servidor

```bash
npm run dev
```

### 4. Abre en navegador

- **URL**: http://localhost:3000
- **Navegador**: Chrome, Firefox, Safari, Edge (cualquiera)

---

## 🎨 Qué verás

```
┌─────────────────────────────────────┐
│  Gestión de Productos              │
│  Ingreso y control de datos         │
├─────────────────────────────────────┤
│ [📋 Formulario] [📊 Resumen]       │
├─────────────────────────────────────┤
│                                     │
│ Seleccionar Cliente               │
│ [Buscar cliente...]                │
│                                     │
│ [Tabla con productos y meses]      │
│                                     │
│ [Guardar Datos] [Limpiar]          │
│                                     │
└─────────────────────────────────────┘
```

---

## ⚙️ Comandos útiles

### Desarrollo
```bash
npm run dev              # Inicia servidor en http://localhost:3000
```

### Producción
```bash
npm run build            # Compila la aplicación
npm start                # Inicia servidor compilado
```

### Testing
```bash
npm test                 # Ejecuta tests
npm run test:watch       # Modo watch
```

### Linting
```bash
npm run lint             # Verifica código
```

---

## 🛠️ Si el servidor no inicia

### Error: "Port 3000 already in use"
```bash
# Matar el proceso en el puerto 3000
# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux:
lsof -ti:3000 | xargs kill -9
```

### Error: "Cannot find module"
```bash
npm install
npm run dev
```

### Error: "Module not found '@/lib/supabase'"
```bash
# Limpia el cache
rm -rf .next
npm run dev
```

---

## 📱 Acceso desde otros dispositivos

Si quieres acceder desde otro dispositivo en la misma red:

```bash
npm run dev -- -H 0.0.0.0 -p 3000
```

Luego accede usando la IP de tu computadora:
```
http://192.168.1.XXX:3000
```

(Reemplaza XXX con tu IP)

---

## 🔍 Modo debug

### En el navegador (F12)
1. Abre DevTools (`F12`)
2. Ve a **Console** para ver errores
3. Ve a **Network** para ver requests a Supabase
4. Ve a **Application > Local Storage** para ver datos guardados

### En VS Code
1. Abre Debug > Run and Debug
2. Selecciona "Node"
3. El servidor se ejecutará en modo debug

---

## ⏸️ Detener el servidor

En la terminal donde ejecutas `npm run dev`:
```bash
Ctrl + C  (Windows, Mac, Linux)
```

---

## 🔄 Reiniciar servidor

Si realizas cambios y necesitas reiniciar:

1. Presiona `Ctrl + C` en la terminal
2. Ejecuta `npm run dev` nuevamente
3. F5 en el navegador para refrescar

En la mayoría de casos, Next.js detecta cambios automáticamente (Hot Reload).

---

## 📊 Variable de entorno para desarrollo

Si necesitas modo debug adicional, agrega a `.env.local`:

```env
DEBUG=*
NODE_ENV=development
```

---

## ✅ Verificar que funciona correctamente

1. ✅ Servidor iniciado en http://localhost:3000
2. ✅ Página carga sin errores 404
3. ✅ Puedes escribir en la búsqueda de clientes
4. ✅ No hay errores rojos en la consola (F12)
5. ✅ Puedes ver la lista de clientes

Si todo eso funciona, **¡tu aplicación está lista!** 🚀

---

## 💡 Tips útiles

1. **Hot Reload**: Los cambios se cargan automáticamente (no necesitas reiniciar)
2. **DevTools**: Abre `F12` para ver errores y logs
3. **Network**: En DevTools, tab "Network" para ver requests a Supabase
4. **Console**: Tab "Console" para ver errores de JavaScript

---

## 🎯 Próximo paso

Una vez que el servidor esté corriendo:

1. Ve a **Formulario**
2. Busca "FRIGOR" o cualquier cliente
3. Selecciona uno
4. Ingresa algunos números
5. Click en "Guardar Datos"
6. Ve a **Resumen** para ver los cambios

¡Listo! Ya estás usando la aplicación. 🎉

---

**Cualquier duda**: Revisa los archivos de documentación:
- QUICK_START.md - 5 minutos
- SETUP_GUIDE.md - Detallado
- CHECKLIST.md - Problemas comunes
