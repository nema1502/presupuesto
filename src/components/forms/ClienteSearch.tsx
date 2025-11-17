'use client';

import { useState, useCallback, useEffect } from 'react';
import { searchClientes } from '@/lib/database';
import type { Cliente } from '@/types';

export interface ClienteSearchProps {
  onSelect: (cliente: Cliente) => void;
  onSearch?: (query: string) => void;
  placeholder?: string;
  disabled?: boolean;
}

export function ClienteSearch({
  onSelect,
  onSearch,
  placeholder = 'Buscar cliente...',
  disabled = false,
}: ClienteSearchProps) {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState<Cliente[]>([]);
  const [isOpen, setIsOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(false);

  const handleSearch = useCallback(
    async (searchQuery: string) => {
      setQuery(searchQuery);
      onSearch?.(searchQuery);

      if (searchQuery.length < 1) {
        setResults([]);
        setIsOpen(false);
        return;
      }

      setIsLoading(true);
      try {
        const data = await searchClientes(searchQuery);
        setResults(data);
        setIsOpen(true);
      } catch (error) {
        console.error('Error searching clientes:', error);
        setResults([]);
      } finally {
        setIsLoading(false);
      }
    },
    [onSearch]
  );

  const handleSelectCliente = (cliente: Cliente) => {
    setQuery(cliente.nombre_sucursal);
    setIsOpen(false);
    setResults([]);
    onSelect(cliente);
  };

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const target = event.target as HTMLElement;
      if (!target.closest('.cliente-search-container')) {
        setIsOpen(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  return (
    <div className="cliente-search-container relative w-full">
      <div className="relative">
        <input
          type="text"
          value={query}
          onChange={(e) => handleSearch(e.target.value)}
          placeholder={placeholder}
          disabled={disabled}
          className="w-full px-4 py-3 border-2 border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-slate-400 focus:border-slate-400 disabled:bg-gray-100 disabled:cursor-not-allowed font-medium text-slate-900"
          autoComplete="off"
        />
        {isLoading && (
          <div className="absolute right-3 top-2.5">
            <div className="spinner w-5 h-5 border-2 border-gray-300 border-t-blue-600 rounded-full"></div>
          </div>
        )}
      </div>

      {isOpen && results.length > 0 && (
        <div className="absolute z-10 w-full mt-1 bg-white border-2 border-slate-400 rounded-md shadow-xl">
          <ul className="max-h-64 overflow-y-auto">
            {results.map((cliente, index) => (
              <li key={cliente.id} className={index % 2 === 0 ? 'bg-slate-50' : 'bg-white'}>
                <button
                  type="button"
                  onClick={() => handleSelectCliente(cliente)}
                  className="w-full text-left px-4 py-3 hover:bg-slate-200 transition-colors flex justify-between items-center border-b border-gray-200 last:border-b-0"
                >
                  <span className="font-semibold text-slate-900">{cliente.nombre_sucursal}</span>
                  <span className="text-sm text-slate-600 font-medium">({cliente.cod_sucursal})</span>
                </button>
              </li>
            ))}
          </ul>
        </div>
      )}

      {isOpen && query.length > 0 && results.length === 0 && !isLoading && (
        <div className="absolute z-10 w-full mt-1 bg-slate-100 border-2 border-slate-400 rounded-md shadow-xl p-4 text-center font-semibold text-slate-700">
          No se encontraron clientes
        </div>
      )}
    </div>
  );
}
