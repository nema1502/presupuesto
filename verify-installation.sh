#!/bin/bash
# Script de verificación de instalación

echo "🔍 Verificando instalación de Gestión de Productos..."
echo ""

# Verificar Node.js
if command -v node &> /dev/null
then
    echo "✅ Node.js: $(node --version)"
else
    echo "❌ Node.js no está instalado"
    exit 1
fi

# Verificar npm
if command -v npm &> /dev/null
then
    echo "✅ npm: $(npm --version)"
else
    echo "❌ npm no está instalado"
    exit 1
fi

# Verificar archivos críticos
echo ""
echo "📁 Verificando archivos..."

files=(
    "package.json"
    "tsconfig.json"
    ".env.local"
    "src/app/page.tsx"
    "src/lib/supabase.ts"
    "src/lib/database.ts"
    "sql/create_tables.sql"
    "sql/insert_productos.sql"
)

for file in "${files[@]}"
do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file NO ENCONTRADO"
    fi
done

# Verificar carpetas
echo ""
echo "📂 Verificando carpetas..."

folders=(
    "src"
    "src/app"
    "src/components"
    "src/lib"
    "sql"
    "node_modules"
)

for folder in "${folders[@]}"
do
    if [ -d "$folder" ]; then
        echo "✅ $folder/"
    else
        echo "❌ $folder/ NO ENCONTRADA"
    fi
done

# Verificar variables de entorno
echo ""
echo "🔐 Verificando variables de entorno..."

if grep -q "NEXT_PUBLIC_SUPABASE_URL" .env.local 2>/dev/null
then
    echo "✅ NEXT_PUBLIC_SUPABASE_URL configurado"
else
    echo "⚠️  NEXT_PUBLIC_SUPABASE_URL no configurado"
fi

if grep -q "NEXT_PUBLIC_SUPABASE_ANON_KEY" .env.local 2>/dev/null
then
    echo "✅ NEXT_PUBLIC_SUPABASE_ANON_KEY configurado"
else
    echo "⚠️  NEXT_PUBLIC_SUPABASE_ANON_KEY no configurado"
fi

if grep -q "SUPABASE_SERVICE_ROLE_KEY" .env.local 2>/dev/null
then
    echo "✅ SUPABASE_SERVICE_ROLE_KEY configurado"
else
    echo "⚠️  SUPABASE_SERVICE_ROLE_KEY no configurado"
fi

echo ""
echo "════════════════════════════════════════════════"
echo "✨ Instalación verificada!"
echo "════════════════════════════════════════════════"
echo ""
echo "Próximos pasos:"
echo "1. Ejecutar scripts SQL en Supabase:"
echo "   - sql/create_tables.sql"
echo "   - sql/insert_productos.sql"
echo ""
echo "2. Iniciar servidor de desarrollo:"
echo "   npm run dev"
echo ""
echo "3. Abre http://localhost:3000"
echo ""
