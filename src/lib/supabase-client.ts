'use client';

import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Missing Supabase credentials. Please configure NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY');
}

// Client-side Supabase with session persistence
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: true,
    autoRefreshToken: true,
    detectSessionInUrl: true,
    storage:
      typeof window !== 'undefined'
        ? {
            getItem: (key: string) => {
              const value = localStorage.getItem(key);
              console.log(`🔍 localStorage.getItem('${key}'):`, value ? '✅ found' : '❌ not found');
              return value;
            },
            setItem: (key: string, value: string) => {
              console.log(`💾 localStorage.setItem('${key}'):`, value ? '✅ saved' : '❌ empty');
              localStorage.setItem(key, value);
            },
            removeItem: (key: string) => {
              console.log(`🗑️  localStorage.removeItem('${key}')`);
              localStorage.removeItem(key);
            },
          }
        : undefined,
  },
});
