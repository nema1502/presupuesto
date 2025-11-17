'use client';

import { useState, useEffect } from 'react';
import { LoadingSpinner, Alert } from '@/components/shared/Loading';
import { getClientes } from '@/lib/database';
import type { Cliente } from '@/types';

export function TablaResumen() {
  const [clientes, setClientes] = useState<Cliente[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    const loadClientes = async () => {
      try {
        setIsLoading(true);
        setError(null);
        const data = await getClientes();
        setClientes(data || []);
      } catch (err) {
        console.error('Error loading clientes:', err);
        setError('Error al cargar los clientes');
      } finally {
        setIsLoading(false);
      }
    };

    loadClientes();

    // Actualizar cada 30 segundos
    const interval = setInterval(loadClientes, 30000);
    return () => clearInterval(interval);
  }, []);

  const estadoLlenoCount = clientes.filter((c) => c.estado === 'LLENO').length;
  const estadoVacioCount = clientes.filter((c) => c.estado === 'VACIO').length;

  // Filtrar clientes por nombre de cliente o código
  const clientesFiltrados = clientes.filter((cliente) =>
    cliente.nombre_sucursal.toLowerCase().includes(searchTerm.toLowerCase()) ||
    cliente.cod_sucursal.toString().includes(searchTerm)
  );

  const estadoLlenoCountFiltrado = clientesFiltrados.filter((c) => c.estado === 'LLENO').length;
  const estadoVacioCountFiltrado = clientesFiltrados.filter((c) => c.estado === 'VACIO').length;

  const getEstadoBadge = (estado: 'VACIO' | 'LLENO') => {
    return estado === 'LLENO'
      ? 'bg-green-100 text-green-800 px-3 py-1 rounded-full text-sm font-medium'
      : 'bg-red-100 text-red-800 px-3 py-1 rounded-full text-sm font-medium';
  };

  if (isLoading) {
    return <LoadingSpinner message="Cargando clientes..." />;
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <h2 className="text-2xl font-bold mb-6 text-gray-800">Resumen de Clientes</h2>

      {error && <Alert type="error" message={error} />}

      {/* Buscador de Clientes */}
      <div className="mb-6">
        <input
          type="text"
          placeholder="🔍 Buscar por nombre de cliente o código..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent text-gray-700 placeholder-gray-500"
        />
        {searchTerm && (
          <p className="text-sm text-gray-600 mt-2">
            Se encontraron <strong>{clientesFiltrados.length}</strong> de <strong>{clientes.length}</strong> clientes
          </p>
        )}
      </div>

      {/* Estadísticas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div className="bg-slate-50 p-4 rounded-lg border-2 border-slate-300 shadow-sm">
          <p className="text-sm text-slate-700 font-semibold">Total de Clientes</p>
          <p className="text-4xl font-bold text-slate-900 mt-2">{clientesFiltrados.length}</p>
          {searchTerm && <p className="text-xs text-slate-600 mt-1">De {clientes.length} total</p>}
        </div>
        <div className="bg-emerald-50 p-4 rounded-lg border-2 border-emerald-400 shadow-sm">
          <p className="text-sm text-emerald-700 font-semibold">Clientes LLENO</p>
          <p className="text-4xl font-bold text-emerald-900 mt-2">{estadoLlenoCountFiltrado}</p>
          <p className="text-sm text-emerald-700 font-medium mt-1">
            {clientesFiltrados.length > 0 ? ((estadoLlenoCountFiltrado / clientesFiltrados.length) * 100).toFixed(1) : 0}%
          </p>
        </div>
        <div className="bg-orange-50 p-4 rounded-lg border-2 border-orange-400 shadow-sm">
          <p className="text-sm text-orange-700 font-semibold">Clientes VACIO</p>
          <p className="text-4xl font-bold text-orange-900 mt-2">{estadoVacioCountFiltrado}</p>
          <p className="text-sm text-orange-700 font-medium mt-1">
            {clientesFiltrados.length > 0 ? ((estadoVacioCountFiltrado / clientesFiltrados.length) * 100).toFixed(1) : 0}%
          </p>
        </div>
      </div>

      {/* Tabla */}
      {clientesFiltrados.length > 0 ? (
        <div className="table-container overflow-x-auto">
          <table className="w-full border-collapse shadow-lg rounded-lg overflow-hidden">
            <thead className="bg-slate-800 text-white sticky top-0">
              <tr>
                <th className="px-6 py-4 text-left text-sm font-bold border-b-2 border-slate-700">
                  Código Sucursal
                </th>
                <th className="px-6 py-4 text-left text-sm font-bold border-b-2 border-slate-700">
                  Nombre Cliente
                </th>
                <th className="px-6 py-4 text-left text-sm font-bold border-b-2 border-slate-700">
                  Estado
                </th>
                <th className="px-6 py-4 text-left text-sm font-bold border-b-2 border-slate-700">
                  Actualizado
                </th>
              </tr>
            </thead>
            <tbody>
              {clientesFiltrados.map((cliente, index) => (
                <tr 
                  key={cliente.id} 
                  className={`${
                    index % 2 === 0 ? 'bg-slate-50' : 'bg-white'
                  } hover:bg-slate-100 border-b border-slate-200 transition-colors`}
                >
                  <td className="px-6 py-3 text-sm font-semibold text-slate-900">
                    {cliente.cod_sucursal}
                  </td>
                  <td className="px-6 py-3 text-sm text-slate-800">
                    {cliente.nombre_sucursal}
                  </td>
                  <td className="px-6 py-3">
                    <span className={getEstadoBadge(cliente.estado)}>
                      {cliente.estado}
                    </span>
                  </td>
                  <td className="px-6 py-3 text-sm text-slate-700">
                    {new Date(cliente.updated_at).toLocaleDateString('es-ES', {
                      year: 'numeric',
                      month: '2-digit',
                      day: '2-digit',
                      hour: '2-digit',
                      minute: '2-digit',
                    })}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      ) : (
        <div className="p-4 bg-amber-50 border-2 border-amber-300 rounded-md text-amber-900 font-medium">
          {searchTerm ? 'No se encontraron clientes que coincidan con tu búsqueda.' : 'No hay clientes registrados. Configura la base de datos en Supabase primero.'}
        </div>
      )}
    </div>
  );
}
