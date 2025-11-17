import { getSupabaseClient } from '@/lib/supabase';
import { NextResponse } from 'next/server';

export async function GET() {
  try {
    const supabase = getSupabaseClient();
    console.log('=== TEST DATABASE CONNECTION ===');

    // Test 1: Check if Supabase is connected
    console.log('1. Testing Supabase connection...');
    const { data: clientesData, error: clientesError } = await supabase
      .from('clientes')
      .select('count')
      .limit(1);

    if (clientesError) {
      console.error('❌ Error connecting to clientes table:', clientesError);
      return NextResponse.json(
        {
          status: 'error',
          message: 'Cannot connect to clientes table',
          error: clientesError.message,
        },
        { status: 500 }
      );
    }

    console.log('✅ Supabase connection OK');

    // Test 2: Check ambiente variables
    console.log('2. Checking environment variables...');
    const hasUrl = !!process.env.NEXT_PUBLIC_SUPABASE_URL;
    const hasAnonKey = !!process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    const hasServiceRole = !!process.env.SUPABASE_SERVICE_ROLE_KEY;

    console.log(`  NEXT_PUBLIC_SUPABASE_URL: ${hasUrl ? '✅' : '❌'}`);
    console.log(`  NEXT_PUBLIC_SUPABASE_ANON_KEY: ${hasAnonKey ? '✅' : '❌'}`);
    console.log(`  SUPABASE_SERVICE_ROLE_KEY: ${hasServiceRole ? '✅' : '❌'}`);

    // Test 3: Get a real cliente for testing
    console.log('3. Getting a real cliente for testing...');
    const { data: clientesTest, error: clientesTestError } = await supabase
      .from('clientes')
      .select('id')
      .limit(1);

    if (clientesTestError || !clientesTest || clientesTest.length === 0) {
      console.error('❌ Error getting clientes:', clientesTestError);
      return NextResponse.json(
        {
          status: 'error',
          message: 'No clientes found in database',
          error: clientesTestError?.message,
        },
        { status: 500 }
      );
    }

    const testClienteId = clientesTest[0].id;
    console.log('✅ Using cliente:', testClienteId);

    // Test 4: Try to insert a test record
    console.log('4. Testing INSERT operation...');
    const testRecord = {
      cliente_id: testClienteId,
      producto_id: '00000000-0000-0000-0000-000000000001',
      enero: 99.99,
      febrero: null,
      marzo: null,
      abril: null,
      mayo: null,
      junio: null,
      julio: null,
      agosto: null,
      septiembre: null,
      octubre: null,
      noviembre: null,
      diciembre: null,
      year: 2025,
    };

    const { data: insertData, error: insertError } = await supabase
      .from('registros_mensuales')
      .insert([testRecord])
      .select();

    if (insertError) {
      console.error('❌ Insert error:', insertError);
      return NextResponse.json(
        {
          status: 'error',
          message: 'Cannot insert to registros_mensuales',
          error: insertError.message,
          code: insertError.code,
          details: insertError.details,
        },
        { status: 500 }
      );
    }

    console.log('✅ Insert test successful');

    // Test 5: Clean up test record
    if (insertData && insertData.length > 0) {
      const testId = insertData[0].id;
      await supabase.from('registros_mensuales').delete().eq('id', testId);
      console.log('✅ Cleaned up test record');
    }

    return NextResponse.json(
      {
        status: 'success',
        message: 'All database tests passed',
        environment: {
          hasUrl,
          hasAnonKey,
          hasServiceRole,
        },
      },
      { status: 200 }
    );
  } catch (error: any) {
    console.error('❌ Test failed:', error);
    return NextResponse.json(
      {
        status: 'error',
        message: error?.message || 'Unknown error',
        stack: error?.stack,
      },
      { status: 500 }
    );
  }
}
