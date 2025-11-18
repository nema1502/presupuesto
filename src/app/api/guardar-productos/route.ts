import { getSupabaseClient } from '@/lib/supabase';
import { NextResponse } from 'next/server';

interface ProductoGuardar {
  producto_id: string;
  meses: Record<number, number>; // { 1: 100, 2: 200, ... }
}

export async function POST(request: Request) {
  try {
    const supabase = getSupabaseClient();
    const body = await request.json();
    let { clienteId, productos } = body;

    console.log('=== API GUARDAR PRODUCTOS ===');
    console.log('Cliente ID recibido:', clienteId);
    console.log('Productos:', productos?.length || 0);

    // Validar que clienteId existe, pero permitir productos vacío
    if (!clienteId) {
      return NextResponse.json(
        { error: 'Missing clienteId' },
        { status: 400 }
      );
    }

    // Asegurar que productos es un array
    if (!Array.isArray(productos)) {
      productos = [];
    }

    // VALIDAR que el cliente existe
    console.log('Validando que cliente existe...');
    const { data: clienteExistente, error: clienteError } = await supabase
      .from('clientes')
      .select('id, nombre_sucursal')
      .eq('id', clienteId)
      .single();

    if (clienteError || !clienteExistente) {
      console.error('❌ Cliente no encontrado:', clienteId);
      console.error('Error:', clienteError);
      return NextResponse.json(
        {
          error: `Cliente no encontrado: ${clienteId}`,
          details: clienteError?.message,
        },
        { status: 404 }
      );
    }

    console.log('✅ Cliente válido:', clienteExistente.nombre_sucursal);

    const registrosGuardados: any[] = [];
    const errores: any[] = [];

    // Procesar cada producto
    for (const prod of productos) {
      try {
        console.log(`Procesando producto: ${prod.producto_id}`);
        console.log(`Meses a guardar:`, prod.meses);

        // Verificar si tiene valores
        const tieneValores = Object.keys(prod.meses).length > 0;

        if (!tieneValores) {
          console.log('  → Sin valores, saltando');
          continue;
        }

        // Guardar cada mes
        for (const [mesNum, cantidad] of Object.entries(prod.meses)) {
          if (cantidad !== null && cantidad !== undefined) {
            const mesNumero = parseInt(mesNum);
            console.log(`  → Guardando mes ${mesNumero}: ${cantidad}`);

            const { data: registros, error: upsertError } = await supabase
              .from('registros_mensuales')
              .upsert(
                [{
                  cliente_id: clienteId,
                  producto_id: prod.producto_id,
                  year: 2025,
                  mes: mesNumero,
                  cantidad: cantidad,
                }],
                { onConflict: 'cliente_id,producto_id,year,mes' }
              )
              .select();

            if (upsertError) {
              console.error(`    Error en upsert: ${upsertError.message}`);
              throw new Error(`Error guardando mes ${mesNumero}: ${upsertError.message}`);
            }

            if (registros && registros.length > 0) {
              registrosGuardados.push(registros[0]);
              console.log(`  ✅ Mes ${mesNumero} guardado`);
            } else {
              console.warn(`  ⚠️  Mes ${mesNumero} sin respuesta del upsert`);
            }
          }
        }

        console.log('  ✅ Producto completado');
      } catch (err: any) {
        console.error(`  ❌ Error con producto ${prod.producto_id}:`, err);
        errores.push({
          producto_id: prod.producto_id,
          error: err.message || JSON.stringify(err),
        });
      }
    }

    console.log(`Total guardados: ${registrosGuardados.length}, Errores: ${errores.length}`);

    // Si no hay productos, ELIMINAR todos los registros del cliente
    if (productos.length === 0) {
      console.log('✅ Eliminando todos los registros del cliente...');
      
      const { error: deleteError } = await supabase
        .from('registros_mensuales')
        .delete()
        .eq('cliente_id', clienteId);

      if (deleteError) {
        console.error('Error eliminando registros:', deleteError);
        return NextResponse.json(
          {
            status: 'error',
            message: `Error al limpiar datos: ${deleteError.message}`,
          },
          { status: 500 }
        );
      }

      // Actualizar estado a VACIO
      try {
        await supabase
          .from('clientes')
          .update({ estado: 'VACIO' })
          .eq('id', clienteId);
        console.log('✅ Estado cliente actualizado a VACIO');
      } catch (err: any) {
        console.error('Error actualizando estado cliente:', err.message);
      }

      console.log('✅ Todos los datos del cliente eliminados');
      return NextResponse.json(
        {
          status: 'success',
          message: 'Datos eliminados correctamente',
          registrosGuardados: [],
        },
        { status: 200 }
      );
    }

    // Actualizar estado del cliente si hay éxito
    if (registrosGuardados.length > 0) {
      try {
        await supabase
          .from('clientes')
          .update({ estado: 'LLENO' })
          .eq('id', clienteId);
        console.log('✅ Estado cliente actualizado');
      } catch (err: any) {
        console.error('Error actualizando estado cliente:', err.message);
      }
    }

    if (errores.length > 0) {
      return NextResponse.json(
        {
          status: 'partial',
          message: `${registrosGuardados.length} registros guardados, ${errores.length} errores`,
          registrosGuardados,
          errores,
        },
        { status: 207 }
      );
    }

    return NextResponse.json(
      {
        status: 'success',
        message: `${registrosGuardados.length} registros guardados exitosamente`,
        registrosGuardados,
      },
      { status: 200 }
    );
  } catch (error: any) {
    console.error('❌ Error en API:', error);
    return NextResponse.json(
      {
        status: 'error',
        message: error?.message || 'Error desconocido',
        error: error?.message,
      },
      { status: 500 }
    );
  }
}
