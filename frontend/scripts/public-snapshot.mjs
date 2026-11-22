import {mkdir,writeFile} from 'node:fs/promises';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
const root=fileURLToPath(new URL('../',import.meta.url));
const api=process.env.VITE_API_URL;
if(!api||!/^https?:\/\//.test(api)){
  console.log('Local build: using the bundled public snapshot.');
  process.exit(0);
}
const snapshot={generatedAt:new Date().toISOString(),data:{},media:{}};
await Promise.all(['stats','services','settings','publications'].map(async key=>{
  const response=await fetch(`${api.replace(/\/$/,'')}/public/${key}`,{signal:AbortSignal.timeout(120000)});
  if(!response.ok)throw Error(`Public snapshot ${key}: HTTP ${response.status}`);
  snapshot.data[key]=await response.json();
}));
const values=[...Object.values(snapshot.data.settings),...snapshot.data.publications.map(p=>p.image_url)];
await mkdir(path.join(root,'public','public-media'),{recursive:true});
for(const value of new Set(values)){
  if(!/^\/api\/files\/[a-f0-9-]+\.(png|jpg|webp)$/.test(value||''))continue;
  const response=await fetch(new URL(value,api),{signal:AbortSignal.timeout(30000)});
  if(!response.ok){console.warn(`Public image unavailable: ${value} (${response.status})`);continue;}
  if(!response.headers.get('content-type')?.startsWith('image/'))throw Error('Unexpected image content type');
  const bytes=Buffer.from(await response.arrayBuffer());
  if(bytes.length>8*1024*1024)throw Error('Public image exceeds upload limit');
  const destination='/public-media/'+path.basename(value);
  await writeFile(path.join(root,'public',destination),bytes);
  snapshot.media[value]=destination;
}
await writeFile(path.join(root,'src','public-snapshot.json'),JSON.stringify(snapshot));
console.log('Public snapshot and images prepared.');
