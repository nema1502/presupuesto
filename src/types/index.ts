// Cliente (Sucursal)
export interface Cliente {
  id: string;
  cod_sucursal: number;
  nombre_sucursal: string;
  estado: 'VACIO' | 'LLENO';
  created_at: string;
  updated_at: string;
}

// Producto
export interface Producto {
  id: string;
  cod_producto: string;
  nombre_producto: string;
  unidad_medida: string;
  created_at: string;
}

// Cliente-Producto (relación)
export interface ClienteProducto {
  id: string;
  cliente_id: string;
  producto_id: string;
  cod_sucursal: number;
  cod_producto: string;
  nombre_producto: string;
  unidad_medida: string;
  created_at: string;
}

// Registro mensual
export interface RegistroMensual {
  id: string;
  cliente_id: string;
  producto_id: string;
  enero: number;
  febrero: number;
  marzo: number;
  abril: number;
  mayo: number;
  junio: number;
  julio: number;
  agosto: number;
  septiembre: number;
  octubre: number;
  noviembre: number;
  diciembre?: number;
  year: number;
  created_at: string;
  updated_at: string;
}

// Datos del formulario
export interface FormularioProductosData {
  cliente_id: string;
  cliente_nombre: string;
  productos: ProductoFormulario[];
}

export interface ProductoFormulario {
  producto_id: string;
  cod_producto: string;
  nombre_producto: string;
  unidad_medida: string;
  enero: string;
  febrero: string;
  marzo: string;
  abril: string;
  mayo: string;
  junio: string;
  julio: string;
  agosto: string;
  septiembre: string;
  octubre: string;
  noviembre: string;
  diciembre?: string;
}

// Respuesta de API
export interface ApiResponse<T> {
  data: T | null;
  error: string | null;
  success: boolean;
}

// Estado de carga
export interface LoadingState {
  isLoading: boolean;
  error: string | null;
  success: boolean;
}
