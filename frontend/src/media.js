// Uploaded files live on the API; bundled /images assets stay on the frontend.
export function mediaUrl(value) {
  const api = import.meta.env.VITE_API_URL || '/api';
  if (typeof value !== 'string' || !value.startsWith('/api/files/') || !/^https?:\/\//.test(api)) return value;
  return new URL(value, api).href;
}
