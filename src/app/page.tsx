'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { supabase } from '@/lib/supabase-client';
import { FormularioProductos } from '@/components/forms/FormularioProductos';
import { TablaResumen } from '@/components/tables/TablaResumen';
import { Header } from '@/components/shared/Header';
import { LoadingSpinner } from '@/components/shared/Loading';

export default function Home() {
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<'formulario' | 'resumen'>('formulario');
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        console.log('🔍 Verificando autenticación en home...');
        const { data } = await supabase.auth.getSession();
        
        if (data.session) {
          console.log('✅ Usuario autenticado, mostrando home');
          setIsAuthenticated(true);
          setIsLoading(false);
        } else {
          console.log('❌ Sin sesión, redirigiendo a login');
          router.push('/auth/login');
        }
      } catch (error) {
        console.error('❌ Error al verificar sesión:', error);
        router.push('/auth/login');
      }
    };

    checkAuth();
  }, [router]);

  if (isLoading) {
    return <LoadingSpinner fullScreen message="Cargando..." />;
  }

  if (!isAuthenticated) {
    return <LoadingSpinner fullScreen message="Verificando autenticación..." />;
  }

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      {/* Header con logout */}
      <Header />

      {/* Tabs */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-6xl mx-auto px-4">
          <div className="flex gap-8">
            <button
              onClick={() => setActiveTab('formulario')}
              className={`py-4 px-2 border-b-2 font-medium transition-colors ${
                activeTab === 'formulario'
                  ? 'border-slate-700 text-slate-700'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              📋 Formulario
            </button>
            <button
              onClick={() => setActiveTab('resumen')}
              className={`py-4 px-2 border-b-2 font-medium transition-colors ${
                activeTab === 'resumen'
                  ? 'border-slate-700 text-slate-700'
                  : 'border-transparent text-gray-500 hover:text-gray-700'
              }`}
            >
              📊 Resumen
            </button>
          </div>
        </div>
      </div>

      {/* Content */}
      <main className="flex-1 max-w-6xl mx-auto w-full px-4 py-8">
        {activeTab === 'formulario' ? (
          <FormularioProductos />
        ) : (
          <TablaResumen />
        )}
      </main>

      {/* Footer */}
      <footer className="bg-slate-100 text-gray-600 mt-12 py-6 border-t border-gray-200">
        <div className="max-w-6xl mx-auto px-4 text-center text-sm">
          <p>© 2025 Dosificaciones - Presupuesto. Powered by Dpto. Análisis de Datos </p>
        </div>
      </footer>
    </div>
  );
}
