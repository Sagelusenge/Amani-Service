import {fileURLToPath} from 'node:url';
import fs from 'node:fs/promises';
import {build} from 'esbuild';
import {renderToString} from 'react-dom/server';
import React from 'react';
import {MemoryRouter} from 'react-router-dom';
const source=await fs.readFile(new URL('./src/main.jsx',import.meta.url),'utf8');
const input=source.slice(0,source.indexOf("createRoot(document"))+ '\nexport {Home,News,Login,Admin,Reports,DataPage};';
await build({stdin:{contents:input,loader:'jsx',resolveDir:fileURLToPath(new URL('./src',import.meta.url))},bundle:true,packages:'external',format:'esm',outfile:fileURLToPath(new URL('./.verify-render.mjs',import.meta.url)),loader:{'.css':'empty'},define:{'import.meta.env':'{}'}});
globalThis.localStorage={getItem:()=>null};
try{const c=await import('./.verify-render.mjs');globalThis.window={addEventListener(){},removeEventListener(){},location:{pathname:'/admin',search:''}};for(const [name,props] of [['Home',{}],['News',{}],['Login',{}],['Admin',{user:{role:'admin',full_name:'Test'},onLogout(){}}],['Reports',{}],...['clients','quotes','invoices','tasks','appointments','users','contact_messages','publications','campaigns','leads','contracts','documents'].map(table=>['DataPage',{table,user:{role:'admin'}}])]){const html=renderToString(React.createElement(MemoryRouter,{initialEntries:['/']},React.createElement(c[name],props)));if(!html.length)throw Error(name+' empty');console.log('PASS render '+name+' '+(props.table||''))}}finally{await fs.unlink(new URL('./.verify-render.mjs',import.meta.url))}
