'use client';

import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase-client';

export default function AuthDebugPage() {
  const [debugInfo, setDebugInfo] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function checkAuth() {
      try {
        // Obtener sesión actual
        const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
        
        // Obtener usuario autenticado
        const { data: userData, error: userError } = await supabase.auth.getUser();

        // Verificar usuarios en tabla
        const { data: usuariosDB, error: usuariosError } = await supabase
          .from('usuarios')
          .select('*');

        const info = {
          timestamp: new Date().toISOString(),
          session: {
            data: sessionData.session,
            error: sessionError?.message,
          },
          user: {
            data: userData.user,
            error: userError?.message,
          },
          usuariosDB: {
            data: usuariosDB,
            error: usuariosError?.message,
            count: usuariosDB?.length || 0,
          },
          cookies: {
            sbAccessToken: typeof document !== 'undefined' ? 
              document.cookie.includes('sb-access-token') ? 'SÍ' : 'NO' : 'N/A',
            sbRefreshToken: typeof document !== 'undefined' ? 
              document.cookie.includes('sb-refresh-token') ? 'SÍ' : 'NO' : 'N/A',
          },
        };

        setDebugInfo(info);
      } catch (err: any) {
        setDebugInfo({
          error: err.message,
          timestamp: new Date().toISOString(),
        });
      } finally {
        setLoading(false);
      }
    }

    checkAuth();

    // Re-verificar cada 5 segundos
    const interval = setInterval(checkAuth, 5000);
    return () => clearInterval(interval);
  }, []);

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 text-white p-8">
        <div className="max-w-4xl mx-auto">
          <h1 className="text-3xl font-bold mb-4">🔍 Debug de Autenticación</h1>
          <p className="text-gray-400">Cargando información...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-900 text-white p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-3xl font-bold mb-6">🔍 Debug de Autenticación</h1>

        <div className="bg-gray-800 rounded-lg p-6 mb-6">
          <h2 className="text-xl font-semibold mb-4 text-blue-400">📊 Estado Actual</h2>
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div className="bg-gray-700 p-3 rounded">
              <p className="text-gray-400">Sesión Activa</p>
              <p className="text-xl font-bold">
                {debugInfo?.session?.data ? '✅ SÍ' : '❌ NO'}
              </p>
            </div>
            <div className="bg-gray-700 p-3 rounded">
              <p className="text-gray-400">Usuario Logueado</p>
              <p className="text-xl font-bold">
                {debugInfo?.user?.data?.email || 'Ninguno'}
              </p>
            </div>
            <div className="bg-gray-700 p-3 rounded">
              <p className="text-gray-400">Tabla 'usuarios'</p>
              <p className="text-xl font-bold">
                {debugInfo?.usuariosDB?.count || 0} registros
              </p>
            </div>
            <div className="bg-gray-700 p-3 rounded">
              <p className="text-gray-400">Cookies Auth</p>
              <p className="text-sm">
                Access: {debugInfo?.cookies?.sbAccessToken} | 
                Refresh: {debugInfo?.cookies?.sbRefreshToken}
              </p>
            </div>
          </div>
        </div>

        {debugInfo?.session?.data && (
          <div className="bg-green-900 bg-opacity-30 border border-green-600 rounded-lg p-6 mb-6">
            <h2 className="text-lg font-semibold mb-3 text-green-400">✅ Sesión Activa</h2>
            <pre className="bg-black bg-opacity-50 p-3 rounded text-xs overflow-auto max-h-40">
              {JSON.stringify(debugInfo.session.data, null, 2)}
            </pre>
          </div>
        )}

        {debugInfo?.user?.error && (
          <div className="bg-red-900 bg-opacity-30 border border-red-600 rounded-lg p-6 mb-6">
            <h2 className="text-lg font-semibold mb-3 text-red-400">❌ Error de Usuario</h2>
            <p className="text-sm">{debugInfo.user.error}</p>
          </div>
        )}

        {debugInfo?.usuariosDB?.data && debugInfo.usuariosDB.data.length > 0 && (
          <div className="bg-blue-900 bg-opacity-30 border border-blue-600 rounded-lg p-6 mb-6">
            <h2 className="text-lg font-semibold mb-3 text-blue-400">👥 Usuarios Registrados</h2>
            <div className="overflow-x-auto">
              <table className="w-full text-xs">
                <thead className="text-gray-400 border-b border-gray-600">
                  <tr>
                    <th className="text-left py-2">Email</th>
                    <th className="text-left py-2">Nombre</th>
                    <th className="text-left py-2">Estado</th>
                    <th className="text-left py-2">Creado</th>
                  </tr>
                </thead>
                <tbody>
                  {debugInfo.usuariosDB.data.map((u: any) => (
                    <tr key={u.id} className="border-t border-gray-700">
                      <td className="py-2">{u.email}</td>
                      <td className="py-2">{u.display_name}</td>
                      <td className="py-2">
                        <span className="bg-green-600 px-2 py-1 rounded text-xs">
                          {u.estado}
                        </span>
                      </td>
                      <td className="py-2 text-gray-500">
                        {new Date(u.created_at).toLocaleDateString()}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}

        {debugInfo?.usuariosDB?.error && (
          <div className="bg-red-900 bg-opacity-30 border border-red-600 rounded-lg p-6 mb-6">
            <h2 className="text-lg font-semibold mb-3 text-red-400">❌ Error BD Usuarios</h2>
            <p className="text-sm">{debugInfo.usuariosDB.error}</p>
          </div>
        )}

        <div className="bg-gray-800 rounded-lg p-6">
          <h2 className="text-lg font-semibold mb-3 text-yellow-400">🔧 Información Técnica</h2>
          <pre className="bg-black bg-opacity-50 p-4 rounded text-xs overflow-auto max-h-60 text-gray-300">
            {JSON.stringify(debugInfo, null, 2)}
          </pre>
        </div>

        <div className="mt-6 text-center text-gray-500 text-sm">
          <p>Última actualización: {debugInfo?.timestamp}</p>
          <p>Se actualiza automáticamente cada 5 segundos</p>
        </div>

        <div className="mt-8">
          <a 
            href="/" 
            className="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded transition"
          >
            ← Volver al Sistema
          </a>
        </div>
      </div>
    </div>
  );
}
