import {useEffect,useState} from 'react';
import {api} from './api.js';
import {mediaUrl} from './media.js';
import snapshot from './public-snapshot.json';
const pending=new Map();
const cacheKey=key=>'amani_public_v1_'+key;
function initial(key,fallback){
  try{
    const cached=JSON.parse(localStorage.getItem(cacheKey(key)));
    if(cached&&cached.updatedAt>Date.parse(snapshot.generatedAt)&&Date.now()-cached.updatedAt<86400000)return cached.data;
  }catch{/* Storage may be unavailable. */}
  return snapshot.data[key]??fallback;
}
export function publicMediaUrl(value){return snapshot.media[value]||mediaUrl(value);}
export function usePublicData(key,fallback){
  const[data,setData]=useState(()=>initial(key,fallback));
  const[busy,setBusy]=useState(()=>snapshot.data[key]===undefined);
  const[error,setError]=useState('');
  useEffect(()=>{
    let active=true;
    if(!pending.has(key))pending.set(key,api.get('/public/'+key,{timeout:90000}).then(response=>{
      try{localStorage.setItem(cacheKey(key),JSON.stringify({updatedAt:Date.now(),data:response.data}));}catch{}
      return response.data;
    }).finally(()=>pending.delete(key)));
    pending.get(key).then(value=>{if(active)setData(value);}).catch(()=>{
      if(active&&snapshot.data[key]===undefined)setError('Les données sont momentanément indisponibles. Veuillez réessayer.');
    }).finally(()=>{if(active)setBusy(false);});
    return()=>{active=false;};
  },[key]);
  return {data,busy,error};
}
