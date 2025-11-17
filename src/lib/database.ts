import { supabase } from './supabase-client';
import type { Cliente, Producto, RegistroMensual, ClienteProducto } from '@/types';

// ============ CLIENTES ============
export async function getClientes() {
  const { data, error } = await supabase
    .from('clientes')
    .select('*')
    .order('nombre_sucursal', { ascending: true });

  if (error) {
    console.error('Error fetching clientes:', error);
    return null;
  }

  return data as Cliente[];
}

export async function getClienteById(id: string) {
  const { data, error } = await supabase
    .from('clientes')
    .select('*')
    .eq('id', id)
    .single();

  if (error) {
    console.error('Error fetching cliente:', error);
    return null;
  }

  return data as Cliente;
}

export async function searchClientes(query: string) {
  const { data, error } = await supabase
    .from('clientes')
    .select('*')
    .ilike('nombre_sucursal', `%${query}%`)
    .order('nombre_sucursal', { ascending: true });

  if (error) {
    console.error('Error searching clientes:', error);
    return [];
  }

  return data as Cliente[];
}

export async function updateClienteEstado(clienteId: string, estado: 'VACIO' | 'LLENO') {
  const { data, error } = await supabase
    .from('clientes')
    .update({ 
      estado,
      updated_at: new Date().toISOString()
    })
    .eq('id', clienteId)
    .select()
    .single();

  if (error) {
    console.error('Error updating cliente estado:', error);
    return null;
  }

  return data as Cliente;
}

// ============ PRODUCTOS ============
export async function getProductosByCliente(clienteId: string) {
  const { data, error } = await supabase
    .from('cliente_productos')
    .select('*, productos!producto_id(id)')
    .eq('cliente_id', clienteId)
    .order('nombre_producto', { ascending: true });

  if (error) {
    console.error('Error fetching productos:', error);
    return [];
  }

  // Mapear los resultados para incluir el producto_id real (UUID)
  return data.map((item: any) => ({
    ...item,
    producto_id_uuid: item.productos?.id, // ID real del producto
  })) as (ClienteProducto & { producto_id_uuid: string })[];
}

export async function getProductoByCodigo(codProducto: string) {
  const { data, error } = await supabase
    .from('productos')
    .select('*')
    .eq('cod_producto', codProducto)
    .single();

  if (error) {
    return null;
  }

  return data as Producto;
}

// ============ REGISTROS MENSUALES (NORMALIZADO) ============
export async function getRegistroMensual(clienteId: string, productoId: string, year: number = 2025, mes?: number) {
  let query = supabase
    .from('registros_mensuales')
    .select('*')
    .eq('cliente_id', clienteId)
    .eq('producto_id', productoId)
    .eq('year', year);

  if (mes !== undefined) {
    query = query.eq('mes', mes);
  }

  const { data, error } = await query;

  if (error && error.code !== 'PGRST116') {
    console.error('Error fetching registros mensuales:', error);
  }

  // Si busca un mes específico, devuelve un registro
  if (mes !== undefined) {
    return (data && data[0]) || null;
  }

  // Si no busca mes, devuelve todos los registros del año
  return data as RegistroMensual[] || [];
}

// Crear o actualizar registro mensual por mes individual
export async function upsertRegistroMensual(
  clienteId: string,
  productoId: string,
  year: number,
  mes: number,
  cantidad: number
) {
  try {
    console.log(`[upsertRegistroMensual] ${clienteId}/${productoId}/${year}/${mes}: ${cantidad}`);

    const { data, error } = await supabase
      .from('registros_mensuales')
      .upsert(
        [{
          cliente_id: clienteId,
          producto_id: productoId,
          year,
          mes,
          cantidad,
        }],
        { onConflict: 'cliente_id,producto_id,year,mes' }
      )
      .select()
      .single();

    if (error) {
      console.error('[upsertRegistroMensual] Error:', error);
      throw new Error(`Error: ${error.message}`);
    }

    console.log('[upsertRegistroMensual] ✓ Guardado');
    return data as RegistroMensual;
  } catch (err: any) {
    console.error('[upsertRegistroMensual] Exception:', err.message);
    throw err;
  }
}

export async function getRegistrosCliente(clienteId: string, year: number = 2025) {
  const { data, error } = await supabase
    .from('registros_mensuales')
    .select(`
      *,
      cliente_productos!producto_id(*)
    `)
    .eq('cliente_id', clienteId)
    .eq('year', year);

  if (error) {
    console.error('Error fetching registros cliente:', error);
    return [];
  }

  return data;
}

// ============ BATCH OPERATIONS ============
export async function saveProductosCliente(
  clienteId: string,
  productos: Array<{
    producto_id: string;
    meses: Record<number, number>; // { 1: 100.5, 2: 200.3, ... }
  }>
) {
  console.log('[saveProductosCliente] Iniciando con', productos.length, 'productos');
  const registros = [];
  let errores = [];

  for (const prod of productos) {
    try {
      console.log('[saveProductosCliente] Procesando producto:', prod.producto_id);
      
      // Verificar si hay al menos un valor para guardar
      const tieneValores = Object.keys(prod.meses).length > 0;

      if (!tieneValores) {
        console.log('[saveProductosCliente] Producto sin datos, saltando');
        continue;
      }

      // Guardar cada mes
      for (const [mesNum, cantidad] of Object.entries(prod.meses)) {
        if (cantidad !== null && cantidad !== undefined && cantidad !== 0) {
          const registro = await upsertRegistroMensual(
            clienteId,
            prod.producto_id,
            2025,
            parseInt(mesNum),
            cantidad
          );
          registros.push(registro);
        }
      }

      console.log('[saveProductosCliente] ✓ Producto guardado');
    } catch (errProd: any) {
      console.error('[saveProductosCliente] Error en producto:', errProd.message);
      errores.push(errProd.message);
    }
  }

  console.log('[saveProductosCliente] Guardados:', registros.length, 'Errores:', errores.length);

  // Actualizar estado del cliente
  if (registros.length > 0) {
    try {
      await updateClienteEstado(clienteId, 'LLENO');
      console.log('[saveProductosCliente] ✓ Estado del cliente actualizado');
    } catch (err: any) {
      console.error('[saveProductosCliente] Error al actualizar estado:', err.message);
    }
  }

  if (errores.length > 0) {
    throw new Error(`Se guardaron ${registros.length} registros pero hubo ${errores.length} errores: ${errores[0]}`);
  }

  return registros;
}
