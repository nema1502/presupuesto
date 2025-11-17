# 🚀 GUÍA RÁPIDA - Persistencia de Datos

## ✅ Estado Actual

- ✅ **Servidor activo:** http://localhost:3001
- ✅ **Código compilado:** Sin errores TypeScript
- ✅ **Base de datos:** Conectada y funcionando
- ✅ **Logging:** Implementado para rastrear cada operación

---

## 🎯 Test Rápido (5 minutos)

### Paso 1: Busca un Cliente
1. Abre http://localhost:3001
2. En "Búsqueda de cliente", escribe "COMERCIAL"
3. Selecciona uno de la lista
4. Espera que carguen los productos

✅ **Resultado esperado:** Se cargan 25+ productos

---

### Paso 2: Rellena UN Dato
1. Busca el primer producto
2. Busca la columna "ENE '25" (enero 2025)
3. Ingresa el valor: `10.5`
4. **No rellenes más campos**

✅ **Resultado esperado:** El campo muestra "10.5"

---

### Paso 3: Guardar
1. Click en botón "Guardar Datos" (abajo de la tabla)
2. Espera 3 segundos para el mensaje de éxito

✅ **Resultado esperado:** Ves mensaje verde "Datos guardados exitosamente"

---

### Paso 4: Verifica Persistencia
1. Limpia la búsqueda de cliente
2. Busca el MISMO cliente nuevamente
3. Selecciona de la lista
4. Mira el campo enero del primer producto

✅ **Resultado esperado:** El valor `10.5` sigue ahí

---

## 📊 Si Algo Falla

### ❌ No ves los productos
**Posible causa:** Problema de conexión a BD
- Abre Consola (F12 → Console)
- Busca cliente nuevamente
- Copia los errores rojos
- **Envíamelos**

### ❌ El guardado no responde
**Posible causa:** Error en la BD o en los datos
- Abre Consola (F12 → Console)
- Click Guardar nuevamente
- Mira los logs
- **Envíame los logs**

### ❌ El dato no aparece después de guardar
**Posible causa:** Problema de carga de datos guardados
- Verifica en Consola que sí se guardó (línea "Resultado de guardado")
- Si se guardó pero no aparece → hay problema en carga
- **Envíame los logs de carga**

---

## 💻 Consola - Qué Buscar

### Logs Exitosos:

```
✓ Cargando productos para cliente: [uuid]
✓ Productos obtenidos: 25
✓ Cliente ABC cargado exitosamente
```

```
✓ Iniciando guardado para cliente: ABC
✓ Datos preparados para guardar: [...]
✓ Resultado de guardado: 1 registros
```

### Logs de Error (en rojo):

```
❌ Error at loading productos
❌ Error saving datos
❌ PGRST ERROR
```

Si ves esto → cópialo y envíamelo

---

## 🔍 Debugging

### Abrir Consola del Navegador
- **Windows/Linux:** F12 o Ctrl+Shift+I
- **Mac:** Cmd+Option+I
- Tab "Console" para ver logs

### Copiar Todos los Logs
1. Consola abierta
2. Ctrl+A (selecciona todo)
3. Ctrl+C (copia)
4. Pega en mensaje

---

## 📞 Reportar Problema

Incluye:
1. **¿Qué hiciste?** (pasos exactos)
2. **¿Qué esperabas?**
3. **¿Qué pasó en realidad?**
4. **Logs de Consola** (F12)
5. **Captura de pantalla** (opcional)

---

## ⚡ Comandos Útiles

### Reiniciar servidor
```powershell
# En la terminal donde corre el servidor
Ctrl+C  # Detiene el servidor
npm run dev  # Lo reinicia
```

### Ver logs en tiempo real
```
F12 → Console tab → Busca cliente → Verás logs en vivo
```

### Limpiar Consola
```
En Consola: Ctrl+L o click botón basura
```

---

## 🎉 Si Todo Funciona

¡Excelente! El sistema está listo para:
- ✅ Guardar datos de múltiples clientes
- ✅ Almacenar datos parciales (no todos los meses)
- ✅ Recuperar datos cuando buscas cliente nuevamente
- ✅ Manejar errores de forma robusta

---

## 📝 Notas Importantes

- **Año:** Todos los datos se guardan para 2025
- **Meses:** Soporta de diciembre 2024 a noviembre 2025
- **Precisión:** Hasta 2 decimales (10.50, 5.25, etc.)
- **Clientes:** 133 clientes pre-cargados
- **Productos:** 150+ productos disponibles

---

## 🚀 Próximas Características (Futuro)

- [ ] Exportar datos a Excel
- [ ] Múltiples años (2025, 2026, etc.)
- [ ] Filtros y búsquedas avanzadas
- [ ] Dashboard de resúmenes
- [ ] Autenticación de usuarios

**Por ahora, enfoquémonos en que la persistencia funcione perfectamente.** ✨
