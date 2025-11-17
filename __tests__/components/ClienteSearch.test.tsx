import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { ClienteSearch } from '@/components/forms/ClienteSearch';

// Mock de la función searchClientes
jest.mock('@/lib/database', () => ({
  searchClientes: jest.fn(),
  getClientes: jest.fn(),
  getProductosByCliente: jest.fn(),
}));

describe('ClienteSearch Component', () => {
  const mockOnSelect = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders the search input', () => {
    render(<ClienteSearch onSelect={mockOnSelect} />);
    const input = screen.getByPlaceholderText('Buscar cliente...');
    expect(input).toBeInTheDocument();
  });

  it('disables input when disabled prop is true', () => {
    render(<ClienteSearch onSelect={mockOnSelect} disabled={true} />);
    const input = screen.getByPlaceholderText('Buscar cliente...') as HTMLInputElement;
    expect(input.disabled).toBe(true);
  });

  it('calls onSelect when a cliente is selected', async () => {
    const cliente = {
      id: '1',
      cod_sucursal: 4,
      nombre_sucursal: 'FRIGOR S.A.',
      estado: 'VACIO' as const,
      created_at: new Date().toISOString(),
      updated_at: new Date().toISOString(),
    };

    const { searchClientes } = require('@/lib/database');
    searchClientes.mockResolvedValue([cliente]);

    render(<ClienteSearch onSelect={mockOnSelect} />);
    const input = screen.getByPlaceholderText('Buscar cliente...');

    fireEvent.change(input, { target: { value: 'FRIGOR' } });

    await waitFor(() => {
      expect(searchClientes).toHaveBeenCalledWith('FRIGOR');
    });

    const clienteButton = await screen.findByText('FRIGOR S.A.');
    fireEvent.click(clienteButton);

    expect(mockOnSelect).toHaveBeenCalledWith(cliente);
  });
});
