import axios from 'axios';
export const api=axios.create({baseURL:import.meta.env.VITE_API_URL||'/api'});
api.interceptors.request.use(config=>{
  // Public reads need neither credentials nor a CORS preflight.
  const token=localStorage.getItem('amani_token');
  if(token&&!config.url?.startsWith('/public/'))config.headers.Authorization=`Bearer ${token}`;
  return config;
});
export function toast(message){window.dispatchEvent(new CustomEvent('amani-toast',{detail:message}));}
