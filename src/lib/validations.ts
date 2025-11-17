import { z } from 'zod';

// Validación de número con 2 decimales
const decimalSchema = z
  .string()
  .transform((val) => {
    if (val === '') return '';
    const num = parseFloat(val);
    if (isNaN(num)) return null;
    return num.toFixed(2);
  })
  .refine((val) => val === '' || val !== null, {
    message: 'Debe ser un número válido',
  });

// Producto en formulario
export const ProductoFormularioSchema = z.object({
  producto_id: z.string(),
  cod_producto: z.string(),
  nombre_producto: z.string(),
  unidad_medida: z.string(),
  enero: decimalSchema.optional().default(''),
  febrero: decimalSchema.optional().default(''),
  marzo: decimalSchema.optional().default(''),
  abril: decimalSchema.optional().default(''),
  mayo: decimalSchema.optional().default(''),
  junio: decimalSchema.optional().default(''),
  julio: decimalSchema.optional().default(''),
  agosto: decimalSchema.optional().default(''),
  septiembre: decimalSchema.optional().default(''),
  octubre: decimalSchema.optional().default(''),
  noviembre: decimalSchema.optional().default(''),
  diciembre: decimalSchema.optional().default(''),
});

export type ProductoFormulario = z.infer<typeof ProductoFormularioSchema>;

// Formulario completo
export const FormularioProductosSchema = z.object({
  cliente_id: z.string().min(1, 'Debe seleccionar un cliente'),
  cliente_nombre: z.string(),
  productos: z.array(ProductoFormularioSchema).min(1, 'Debe agregar al menos un producto'),
});

export type FormularioProductos = z.infer<typeof FormularioProductosSchema>;

// Login
export const LoginSchema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(6, 'La contraseña debe tener al menos 6 caracteres'),
});

export type Login = z.infer<typeof LoginSchema>;

// Registro
export const SignUpSchema = z.object({
  email: z.string().email('Email inválido'),
  password: z.string().min(8, 'La contraseña debe tener al menos 8 caracteres'),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: 'Las contraseñas no coinciden',
  path: ['confirmPassword'],
});

export type SignUp = z.infer<typeof SignUpSchema>;

// Búsqueda de cliente
export const BusquedaClienteSchema = z.object({
  query: z.string().min(1, 'Ingrese un término de búsqueda'),
});

export type BusquedaCliente = z.infer<typeof BusquedaClienteSchema>;
