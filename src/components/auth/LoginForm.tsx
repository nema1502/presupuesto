'use client';

import { useState } from 'react';
import { login } from '@/lib/auth';
import { supabase } from '@/lib/supabase-client';
import { useRouter } from 'next/navigation';
import { Alert } from '@/components/shared/Loading';

export function LoginForm() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    setError(null);
    setIsLoading(true);

    try {
      console.log('🔐 Intento de login con:', email);
      const result = await login({ email, password });
      console.log('✅ Login exitoso:', result);
      
      // Esperar a que la sesión esté lista verificando que exista
      let sessionReady = false;
      let attempts = 0;
      const maxAttempts = 10;
      
      while (!sessionReady && attempts < maxAttempts) {
        const { data } = await supabase.auth.getSession();
        if (data.session) {
          sessionReady = true;
          console.log('✅ Sesión confirmada, redirigiendo...');
          break;
        }
        attempts++;
        await new Promise(resolve => setTimeout(resolve, 200));
      }
      
      if (sessionReady) {
        console.log('↪️ Navegando a home...');
        // Esperar para asegurar que todo esté sincronizado
        await new Promise(resolve => setTimeout(resolve, 500));
        // Usar router.push() para navegar en el cliente, NO recarga
        router.push('/');
      } else {
        throw new Error('No se pudo establecer la sesión');
      }
    } catch (err: any) {
      console.error('❌ Error de login:', err);
      setError(err.message || 'Error al iniciar sesión. Verifica tu email y contraseña.');
      setIsLoading(false);
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gradient-to-br from-slate-900 to-slate-800">
      <div className="w-full max-w-md">
        <div className="bg-white rounded-lg shadow-xl p-8">
          <h1 className="text-3xl font-bold text-center text-gray-800 mb-2">
            Sistema de Gestión
          </h1>
          <p className="text-center text-gray-600 mb-8">
            Productos & Registros Mensuales
          </p>

          {error && (
            <div className="mb-6">
              <Alert type="error" message={error} onClose={() => setError(null)} />
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Correo Electrónico
              </label>
              <input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="tu@email.com"
                required
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition text-gray-900 placeholder-gray-500"
                disabled={isLoading}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Contraseña
              </label>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="••••••••"
                required
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition text-gray-900 placeholder-gray-500"
                disabled={isLoading}
              />
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="w-full bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white font-bold py-3 px-4 rounded-lg transition duration-200"
            >
              {isLoading ? 'Iniciando sesión...' : 'Iniciar Sesión'}
            </button>
          </form>

          <p className="text-center text-gray-600 text-sm mt-6">
            ¿No tienes cuenta?{' '}
            <a href="/auth/signup" className="text-blue-600 hover:underline font-medium">
              Regístrate aquí
            </a>
          </p>
        </div>
      </div>
    </div>
  );
}
