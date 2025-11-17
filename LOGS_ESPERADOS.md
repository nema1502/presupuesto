# 📊 Ejemplo de Logs Esperados

## Cuando Buscas un Cliente

### Logs en Consola:
```
Cargando productos para cliente: 550e8400-e29b-41d4-a716-446655440000
Productos obtenidos: Array(25)
  0: {cod_producto: "AS001", nombre_producto: "ÁCIDO SULFÚRICO 98%", ...}
  1: {cod_producto: "AH001", nombre_producto: "ÁCIDO CLORHÍDRICO 37%", ...}
  ...
  [25 más]

Registro guardado para ÁCIDO SULFÚRICO 98%: null
Registro guardado para ÁCIDO CLORHÍDRICO 37%: null
Registro guardado para NITRATO DE POTASIO: null
...
Cliente COMERCIAL ABC cargado exitosamente
```

### Explicación:
- ✅ `Cargando productos...` = Búsqueda iniciada
- ✅ `Productos obtenidos: 25` = Conexión a BD funciona
- ℹ️ `Registro guardado: null` = Normal para datos nuevos
- ✅ `Cliente cargado exitosamente` = Todo correcto

---

## Cuando Guardas Datos (Éxito)

### Logs en Consola:
```
Iniciando guardado para cliente: COMERCIAL ABC
Datos preparados para guardar: Array(25)
  0: {
    producto_id: "abc-123...",
    registros: {
      diciembre: null,
      enero: 10.5,
      febrero: null,
      ...
    }
  }
  1-24: [más productos con null en registros]

Resultado de guardado: Array(1)
  0: {
    id: "xyz-789...",
    cliente_id: "550e8400...",
    producto_id: "abc-123...",
    enero: 10.5,
    diciembre: 0,
    ...
    year: 2025
  }
```

### Explicación:
- ✅ `Iniciando guardado...` = Proceso comenzó
- ✅ `Datos preparados: Array(25)` = 25 productos enviados
- ✅ `Resultado de guardado: Array(1)` = 1 registro guardado
- ℹ️ El otro 24 se omitieron porque no tenían datos

---

## Cuando Buscas el Cliente NUEVAMENTE

### Logs en Consola:
```
Cargando productos para cliente: 550e8400-e29b-41d4-a716-446655440000
Productos obtenidos: Array(25)
  0: {cod_producto: "AS001", nombre_producto: "ÁCIDO SULFÚRICO 98%", ...}
  1: {cod_producto: "AH001", nombre_producto: "ÁCIDO CLORHÍDRICO 37%", ...}
  ...

Registro guardado para ÁCIDO SULFÚRICO 98%: Object
  diciembre: 0
  enero: 10.5
  febrero: 0
  marzo: 0
  ...
  year: 2025

Registro guardado para ÁCIDO CLORHÍDRICO 37%: null
Registro guardado para NITRATO DE POTASIO: null
...
Cliente COMERCIAL ABC cargado exitosamente
```

### Explicación:
- ✅ `Cargando productos...` = Búsqueda iniciada
- ✅ `Registro guardado: Object` = **¡ENCONTRÓ TUS DATOS!**
- ✅ `enero: 10.5` = El valor que guardaste está aquí
- ✅ Los otros productos siguen siendo `null` = Normal

---

## Cuando Hay Error (Falla)

### Logs en Consola (en ROJO):
```
Iniciando guardado para cliente: COMERCIAL ABC
Datos preparados para guardar: Array(25)

Error at guardar... (error message)
  message: "Insert/Update on table registros_mensuales violates foreign key constraint"
  code: "23503"
```

### Explicación:
- ❌ `Error at guardar...` = Algo falló
- ❌ `foreign key constraint` = IDs no coinciden
- **Acción:** Copia este error y envíamelo

---

## Casos Especiales

### Caso 1: Llenando Solo Algunos Meses

Logs:
```
Datos preparados para guardar: {
  producto_id: "abc-123...",
  registros: {
    diciembre: null,
    enero: 10.5,
    febrero: null,
    marzo: 25,
    abril: null,
    ...
  }
}
```

✅ Esto es correcto - solo guarda los meses con valores

---

### Caso 2: Llenando Múltiples Productos

Logs:
```
Datos preparados para guardar: Array(25)
  0: {producto_id: "AS001...", registros: {enero: 10.5, ...}}
  1: {producto_id: "AH001...", registros: {enero: null, ...}}
  2: {producto_id: "NK001...", registros: {enero: 15, ...}}
  ...

Resultado de guardado: Array(2)
  // Solo 2 registros porque los otros no tenían datos
```

✅ Esto es correcto - solo guarda productos con datos

---

### Caso 3: Sin Datos (Vacío)

Si intentas guardar sin rellenar nada:

Logs:
```
Iniciando guardado para cliente: COMERCIAL ABC
Datos preparados para guardar: Array(25)
  [25 productos, todos con null en registros]

Resultado de guardado: Array(0)
  // Array vacío - no se guardó nada
```

✅ Esto es correcto - no hay datos para guardar

---

## Resumen de Patrones

| Patrón | Significa |
|--------|-----------|
| `Array(25)` | Se procesaron 25 productos |
| `Array(1)` | Se guardó 1 registro |
| `Array(0)` | No se guardó nada (sin datos) |
| `null` | No hay datos guardados para ese producto |
| `Object` | Hay datos guardados - verás los valores |
| Error en ROJO | Algo falló - copia el error |

---

## ¿Cómo Confirmar que Funciona?

### ✅ Checklist Final:

1. [ ] Al buscar cliente veo "Productos obtenidos: XX"
2. [ ] Al guardar veo "Resultado de guardado: X"
3. [ ] Al buscar cliente nuevamente veo "Object" en lugar de "null"
4. [ ] Los valores que guardé aparecen en "enero: 10.5"
5. [ ] El formulario muestra el valor cuando cargas el cliente

**Si marcas todas las casillas → ¡FUNCIONA PERFECTAMENTE!** 🎉
