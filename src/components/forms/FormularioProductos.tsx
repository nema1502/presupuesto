'use client';

import { useState, useCallback } from 'react';
import { ClienteSearch } from './ClienteSearch';
import { LoadingSpinner, Alert } from '@/components/shared/Loading';
import { getProductosByCliente, getRegistroMensual } from '@/lib/database';
import type { Cliente, ClienteProducto } from '@/types';

const MESES = [
  { codigo: 'diciembre_2024', label: "DIC '24" },
  { codigo: 'enero_2025', label: "ENE '25" },
  { codigo: 'febrero_2025', label: "FEB '25" },
  { codigo: 'marzo_2025', label: "MAR '25" },
  { codigo: 'abril_2025', label: "ABR '25" },
  { codigo: 'mayo_2025', label: "MAY '25" },
  { codigo: 'junio_2025', label: "JUN '25" },
  { codigo: 'julio_2025', label: "JUL '25" },
  { codigo: 'agosto_2025', label: "AGO '25" },
  { codigo: 'septiembre_2025', label: "SEP '25" },
  { codigo: 'octubre_2025', label: "OCT '25" },
  { codigo: 'noviembre_2025', label: "NOV '25" },
];

export function FormularioProductos() {
  const [selectedCliente, setSelectedCliente] = useState<Cliente | null>(null);
  const [clienteProductos, setClienteProductos] = useState<ClienteProducto[]>([]);
  const [isLoadingProductos, setIsLoadingProductos] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitStatus, setSubmitStatus] = useState<'idle' | 'loading' | 'success' | 'error'>('idle');
  const [alertMessage, setAlertMessage] = useState<{ type: 'success' | 'error'; message: string } | null>(null);
  const [formData, setFormData] = useState<Record<string, Record<string, string>>>({});

  const handleSelectCliente = useCallback(async (cliente: Cliente) => {
    setSelectedCliente(cliente);
    setIsLoadingProductos(true);
    setFormData({});

    try {
      console.log(`Cargando productos para cliente: ${cliente.id}`);
      const productos = await getProductosByCliente(cliente.id);
      console.log(`Productos obtenidos:`, productos);
      setClienteProductos(productos);

      // Inicializar formData
      const newFormData: Record<string, Record<string, string>> = {};
      
      // Mapeo de número de mes a código
      const mesNumToCode: Record<number, string> = {
        12: 'diciembre_2024',
        1: 'enero_2025',
        2: 'febrero_2025',
        3: 'marzo_2025',
        4: 'abril_2025',
        5: 'mayo_2025',
        6: 'junio_2025',
        7: 'julio_2025',
        8: 'agosto_2025',
        9: 'septiembre_2025',
        10: 'octubre_2025',
        11: 'noviembre_2025',
      };
      
      await Promise.all(
        productos.map(async (prod: any) => {
          try {
            // Obtener TODOS los registros del año para este producto
            const registrosGuardados = await getRegistroMensual(cliente.id, prod.producto_id_uuid, 2025);
            console.log(`Registros guardados para ${prod.nombre_producto}:`, registrosGuardados);
            
            // Inicializar con valores vacíos
            const prodData: Record<string, string> = {
              producto_id: prod.producto_id_uuid,
              cod_producto: prod.cod_producto,
              nombre_producto: prod.nombre_producto,
              unidad_medida: prod.unidad_medida,
              diciembre_2024: '',
              enero_2025: '',
              febrero_2025: '',
              marzo_2025: '',
              abril_2025: '',
              mayo_2025: '',
              junio_2025: '',
              julio_2025: '',
              agosto_2025: '',
              septiembre_2025: '',
              octubre_2025: '',
              noviembre_2025: '',
            };
            
            // Llenar con los datos guardados
            if (Array.isArray(registrosGuardados)) {
              registrosGuardados.forEach((reg: any) => {
                const mesCode = mesNumToCode[reg.mes];
                if (mesCode && reg.cantidad) {
                  prodData[mesCode] = String(reg.cantidad);
                }
              });
            }
            
            newFormData[prod.producto_id_uuid] = prodData;
          } catch (err) {
            console.error(`Error cargando registro para ${prod.nombre_producto}:`, err);
            newFormData[prod.producto_id_uuid] = {
              producto_id: prod.producto_id_uuid,
              cod_producto: prod.cod_producto,
              nombre_producto: prod.nombre_producto,
              unidad_medida: prod.unidad_medida,
              diciembre_2024: '',
              enero_2025: '',
              febrero_2025: '',
              marzo_2025: '',
              abril_2025: '',
              mayo_2025: '',
              junio_2025: '',
              julio_2025: '',
              agosto_2025: '',
              septiembre_2025: '',
              octubre_2025: '',
              noviembre_2025: '',
            };
          }
        })
      );

      setFormData(newFormData);
      console.log(`Cliente ${cliente.nombre_sucursal} cargado exitosamente`);
    } catch (error) {
      console.error('Error loading productos:', error);
      setAlertMessage({
        type: 'error',
        message: 'Error al cargar los productos del cliente',
      });
    } finally {
      setIsLoadingProductos(false);
    }
  }, []);

  const handleInputChange = (productoId: string, mes: string, valor: string) => {
    try {
      // Validar que sea un número válido
      if (valor !== '' && isNaN(parseFloat(valor))) {
        console.error('Valor inválido:', valor);
        return;
      }
      
      setFormData((prev) => ({
        ...prev,
        [productoId]: {
          ...prev[productoId],
          [mes]: valor,
        },
      }));
    } catch (error) {
      console.error('Error al cambiar valor:', error);
      setAlertMessage({
        type: 'error',
        message: 'Error al editar el valor. Por favor intenta de nuevo.',
      });
    }
  };

  const handleFormSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    
    console.log('=== INICIANDO GUARDADO ===');
    console.log('Cliente seleccionado:', selectedCliente?.nombre_sucursal);
    console.log('Cliente ID:', selectedCliente?.id);
    console.log('FormData:', formData);
    
    if (!selectedCliente) {
      setAlertMessage({
        type: 'error',
        message: 'Por favor selecciona un cliente',
      });
      return;
    }

    try {
      setIsSubmitting(true);
      setSubmitStatus('loading');
      console.log('Preparando datos para guardar...');
      
      // Preparar datos para guardar en formato normalizado
      const productosParaGuardar = Object.values(formData)
        .map((prod) => {
          const meses: Record<number, number> = {};
          
          // Convertir cada mes a su número y cantidad
          const mesMap: Record<string, number> = {
            'diciembre_2024': 12,
            'enero_2025': 1,
            'febrero_2025': 2,
            'marzo_2025': 3,
            'abril_2025': 4,
            'mayo_2025': 5,
            'junio_2025': 6,
            'julio_2025': 7,
            'agosto_2025': 8,
            'septiembre_2025': 9,
            'octubre_2025': 10,
            'noviembre_2025': 11,
          };
          
          Object.entries(mesMap).forEach(([mesKey, mesNum]) => {
            const valor = (prod as any)[mesKey];
            if (valor && valor.toString().trim() !== '') {
              const numValue = parseFloat(valor);
              if (!isNaN(numValue) && numValue >= 0) {
                meses[mesNum] = numValue;
              }
            }
          });
          
          return {
            producto_id: (prod as any).producto_id,
            meses: meses,
          };
        })
        .filter((prod) => Object.keys(prod.meses).length > 0);

      console.log('Productos para guardar:', productosParaGuardar.length);
      console.log('Datos:', productosParaGuardar);

      // GUARDAR VÍA API (incluso si está vacío)
      const response = await fetch('/api/guardar-productos', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          clienteId: selectedCliente.id,
          productos: productosParaGuardar,
        }),
      });

      const resultado = await response.json();
      console.log('Respuesta:', resultado);

      if (!response.ok) {
        setSubmitStatus('error');
        // Mostrar errores detallados si están disponibles
        if (resultado.errores && resultado.errores.length > 0) {
          const detalles = resultado.errores.map((e: any) => `${e.producto_id}: ${e.error}`).join('\n');
          throw new Error(`Error al guardar:\n${detalles}`);
        }
        throw new Error(resultado.message || resultado.error || 'Error al guardar');
      }

      setSubmitStatus('success');
      setAlertMessage({
        type: 'success',
        message: `✅ Datos guardados exitosamente (${resultado.registrosGuardados?.length || 0} registros).`,
      });

      // Limpiar después de 2 segundos
      setTimeout(() => {
        setSelectedCliente(null);
        setFormData({});
        setClienteProductos([]);
        setAlertMessage(null);
        setSubmitStatus('idle');
      }, 2000);
      
    } catch (error: any) {
      console.error('Error:', error);
      setSubmitStatus('error');
      setAlertMessage({
        type: 'error',
        message: `Error: ${error?.message || 'Error desconocido'}`,
      });
      setTimeout(() => setSubmitStatus('idle'), 2000);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-2xl font-bold mb-6 text-gray-800">Ingreso de Datos Mensuales</h2>

      {alertMessage && (
        <div className={`mb-6 p-4 rounded-lg border-2 ${
          alertMessage.type === 'success'
            ? 'bg-green-50 border-green-300'
            : 'bg-red-50 border-red-300'
        }`}>
          <Alert
            type={alertMessage.type}
            message={alertMessage.message}
            onClose={() => setAlertMessage(null)}
          />
        </div>
      )}

      <form onSubmit={handleFormSubmit} className="space-y-6">
        {/* Búsqueda de cliente */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-2">
            Seleccionar Cliente
          </label>
          <ClienteSearch
            onSelect={handleSelectCliente}
            disabled={isLoadingProductos || isSubmitting}
            placeholder="Busca por nombre de cliente..."
          />
          {selectedCliente && (
            <p className="mt-2 text-sm text-blue-600">
              ✓ Cliente seleccionado: {selectedCliente.nombre_sucursal}
            </p>
          )}
        </div>

        {/* Tabla de productos */}
        {isLoadingProductos ? (
          <LoadingSpinner message="Cargando productos..." />
        ) : clienteProductos.length > 0 ? (
          <div className="table-container">
            <table className="w-full border-collapse shadow-lg rounded-lg overflow-hidden">
              <thead className="bg-slate-800 text-white sticky top-0">
                <tr>
                  <th className="px-4 py-3 text-left text-sm font-bold border-b-2 border-slate-700">
                    Código
                  </th>
                  <th className="px-4 py-3 text-left text-sm font-bold border-b-2 border-slate-700">
                    Producto
                  </th>
                  <th className="px-4 py-3 text-left text-sm font-bold border-b-2 border-slate-700">
                    Unidad
                  </th>
                  {MESES.map((mes) => (
                    <th
                      key={mes.codigo}
                      className="px-3 py-3 text-center text-xs font-bold border-b-2 border-slate-700"
                    >
                      {mes.label}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {clienteProductos.map((prod, index) => (
                  <tr key={prod.id} className={`${
                    index % 2 === 0 ? 'bg-slate-50' : 'bg-white'
                  } hover:bg-slate-100 border-b border-slate-200 transition-colors`}>
                    <td className="px-4 py-3 text-sm font-semibold text-slate-900">
                      {prod.cod_producto}
                    </td>
                    <td className="px-4 py-3 text-sm text-slate-800">
                      {prod.nombre_producto}
                    </td>
                    <td className="px-4 py-3 text-sm text-slate-800">
                      {prod.unidad_medida}
                    </td>
                    {MESES.map((mes) => (
                      <td
                        key={`${prod.producto_id}-${mes.codigo}`}
                        className="px-3 py-2"
                      >
                        <input
                          type="number"
                          step="0.01"
                          min="0"
                          value={(formData[prod.producto_id] && (formData[prod.producto_id] as any)[mes.codigo]) || ''}
                          onChange={(e) => {
                            let value = e.target.value;
                            // Limitar a 2 decimales
                            if (value && value.includes('.')) {
                              const parts = value.split('.');
                              if (parts[1]?.length > 2) {
                                value = `${parts[0]}.${parts[1].substring(0, 2)}`;
                              }
                            }
                            handleInputChange(prod.producto_id, mes.codigo, value);
                          }}
                          placeholder="0.00"
                          className="input-number text-sm bg-white text-slate-900 font-semibold text-center w-full"
                          disabled={isSubmitting}
                        />
                      </td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : selectedCliente ? (
          <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-md text-yellow-800">
            Este cliente no tiene productos asignados.
          </div>
        ) : (
          <div className="p-4 bg-blue-50 border border-blue-200 rounded-md text-blue-800">
            Selecciona un cliente para ver sus productos.
          </div>
        )}

        {/* Botones de acción */}
        {clienteProductos.length > 0 && (
          <div className="flex gap-4 pt-6 border-t">
            <button
              type="submit"
              disabled={isSubmitting || !selectedCliente}
              className="btn-primary"
            >
              {isSubmitting ? 'Guardando...' : 'Guardar Datos'}
            </button>
          </div>
        )}
      </form>

      {/* Overlay de carga/éxito */}
      {(submitStatus === 'loading' || submitStatus === 'success' || submitStatus === 'error') && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 backdrop-blur-sm">
          <div className={`bg-white rounded-2xl shadow-2xl p-8 text-center max-w-sm mx-4 ${
            submitStatus === 'loading' ? 'animate-pulse' : ''
          }`}>
            {submitStatus === 'loading' && (
              <>
                <div className="mb-6 flex justify-center">
                  <div className="w-16 h-16 border-4 border-gray-300 border-t-blue-600 rounded-full animate-spin"></div>
                </div>
                <h3 className="text-xl font-bold text-gray-800 mb-2">Guardando Datos</h3>
                <p className="text-gray-600">Por favor espera mientras se guardan los datos...</p>
              </>
            )}

            {submitStatus === 'success' && (
              <>
                <div className="mb-6 flex justify-center">
                  <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center animate-bounce">
                    <span className="text-4xl">✅</span>
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-green-700 mb-2">¡Guardado!</h3>
                <p className="text-green-600">Los datos se han guardado exitosamente</p>
              </>
            )}

            {submitStatus === 'error' && (
              <>
                <div className="mb-6 flex justify-center">
                  <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center">
                    <span className="text-4xl">❌</span>
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-red-700 mb-2">Error</h3>
                <p className="text-red-600">Ocurrió un error al guardar los datos</p>
              </>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
