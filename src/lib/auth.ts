import { supabase } from './supabase-client';

export interface LoginCredentials {
  email: string;
  password: string;
}

export interface SignUpCredentials extends LoginCredentials {
  displayName: string;
}

export async function login(credentials: LoginCredentials) {
  try {
    const { data, error } = await supabase.auth.signInWithPassword({
      email: credentials.email,
      password: credentials.password,
    });

    if (error) {
      console.error('Login error:', error);
      throw new Error(error.message);
    }

    console.log('Login successful:', data);
    return data;
  } catch (err: any) {
    console.error('Login exception:', err);
    throw err;
  }
}

export async function signup(credentials: SignUpCredentials) {
  try {
    const { data, error } = await supabase.auth.signUp({
      email: credentials.email,
      password: credentials.password,
      options: {
        data: {
          display_name: credentials.displayName,
        },
        emailRedirectTo: `${window.location.origin}/auth/login`,
      },
    });

    if (error) {
      console.error('Signup error:', error);
      throw new Error(error.message);
    }

    console.log('Signup successful:', data);
    return data;
  } catch (err: any) {
    console.error('Signup exception:', err);
    throw err;
  }
}

export async function logout() {
  try {
    const { error } = await supabase.auth.signOut();
    if (error) {
      throw new Error(error.message);
    }
  } catch (err: any) {
    console.error('Logout error:', err);
    throw err;
  }
}

export async function getCurrentUser() {
  try {
    const { data } = await supabase.auth.getSession();
    return data.session?.user || null;
  } catch (err: any) {
    console.error('GetCurrentUser error:', err);
    return null;
  }
}

export async function getAuthUser() {
  try {
    const {
      data: { user },
      error,
    } = await supabase.auth.getUser();
    
    if (error) {
      console.error('GetAuthUser error:', error);
      return null;
    }
    
    return user;
  } catch (err: any) {
    console.error('GetAuthUser exception:', err);
    return null;
  }
}

export async function checkAuthStatus() {
  try {
    const { data } = await supabase.auth.getSession();
    return !!data.session;
  } catch (err: any) {
    console.error('CheckAuthStatus error:', err);
    return false;
  }
}
