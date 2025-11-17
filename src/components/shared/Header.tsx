'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { logout, getAuthUser } from '@/lib/auth';
import { supabase } from '@/lib/supabase-client';

export function Header() {
  const router = useRouter();
  const [userName, setUserName] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const loadUser = async () => {
      const user = await getAuthUser();
      if (user) {
        setUserName(user.user_metadata?.display_name || user.email);
      }
    };

    loadUser();

    // Escuchar cambios de autenticación
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        setUserName(null);
      } else if (session?.user) {
        setUserName(session.user.user_metadata?.display_name || session.user.email);
      }
    });

    return () => subscription?.unsubscribe();
  }, []);

  const handleLogout = async () => {
    setIsLoading(true);
    try {
      await logout();
      router.push('/auth/login');
      router.refresh();
    } catch (error) {
      console.error('Error al cerrar sesión:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <header className="bg-gradient-to-r from-slate-800 to-slate-900 text-white shadow-lg">
      <div className="container mx-auto px-6 py-4 flex justify-between items-center">
        <div className="flex items-center space-x-3">
          <h1 className="text-2xl font-bold">Sistema de Gestión</h1>
          <span className="text-sm text-slate-300">Productos & Registros</span>
        </div>

        {userName && (
          <div className="flex items-center space-x-4">
            <div className="flex items-center space-x-2">
              <div className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
                <span className="text-sm font-bold">{userName.charAt(0).toUpperCase()}</span>
              </div>
              <span className="text-sm font-medium">{userName}</span>
            </div>
            <button
              onClick={handleLogout}
              disabled={isLoading}
              className="bg-red-600 hover:bg-red-700 disabled:bg-red-400 text-white px-4 py-2 rounded-lg transition duration-200 text-sm font-medium"
            >
              {isLoading ? 'Cerrando...' : 'Cerrar Sesión'}
            </button>
          </div>
        )}
      </div>
    </header>
  );
}
