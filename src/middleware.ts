import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname;

  // Rutas públicas que NO necesitan autenticación
  const publicRoutes = ['/auth/login', '/auth/signup', '/debug'];

  // Si está en una ruta pública, dejar pasar
  if (publicRoutes.some(route => pathname === route || pathname.startsWith(route))) {
    return NextResponse.next();
  }

  // Para todas las demás rutas (/) permitir acceso
  // El cliente manejará la redirección si no hay sesión válida
  return NextResponse.next();
}

export const config = {
  matcher: [
    '/((?!_next/static|_next/image|favicon.ico).*)',
  ],
};
