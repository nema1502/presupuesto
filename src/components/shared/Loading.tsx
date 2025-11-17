'use client';

export interface LoadingSpinnerProps {
  message?: string;
  fullScreen?: boolean;
}

export function LoadingSpinner({ message = 'Cargando...', fullScreen = false }: LoadingSpinnerProps) {
  const containerClass = fullScreen
    ? 'fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50'
    : 'flex items-center justify-center p-4';

  return (
    <div className={containerClass}>
      <div className="flex flex-col items-center gap-4">
        <div className="spinner w-8 h-8 border-4 border-gray-300 border-t-blue-600 rounded-full"></div>
        {message && <p className="text-gray-600 text-sm">{message}</p>}
      </div>
    </div>
  );
}

export interface AlertProps {
  type: 'success' | 'error' | 'info' | 'warning';
  message: string;
  onClose?: () => void;
}

export function Alert({ type, message, onClose }: AlertProps) {
  const bgColorMap = {
    success: 'bg-green-50',
    error: 'bg-red-50',
    info: 'bg-blue-50',
    warning: 'bg-yellow-50',
  };

  const borderColorMap = {
    success: 'border-green-200',
    error: 'border-red-200',
    info: 'border-blue-200',
    warning: 'border-yellow-200',
  };

  const textColorMap = {
    success: 'text-green-800',
    error: 'text-red-800',
    info: 'text-blue-800',
    warning: 'text-yellow-800',
  };

  return (
    <div className={`${bgColorMap[type]} ${borderColorMap[type]} ${textColorMap[type]} px-4 py-3 rounded border`}>
      <div className="flex justify-between items-start">
        <p className="text-sm">{message}</p>
        {onClose && (
          <button
            onClick={onClose}
            className="text-lg leading-none cursor-pointer hover:opacity-70"
          >
            ×
          </button>
        )}
      </div>
    </div>
  );
}
