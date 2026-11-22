import test from 'node:test';
import assert from 'node:assert/strict';
import {db} from '../src/db.js';
import {serveUpload} from '../src/uploads.js';
const original=db.query;
const response=()=>({headers:{},set(h){Object.assign(this.headers,h);return this;},send(value){this.body=value;},sendStatus(status){this.status=status;}});
test('stored uploads survive absent local files and are cacheable across origins',async()=>{
 const bytes=Buffer.from('image bytes');
 db.query=async(sql,args)=>{assert.match(sql,/stored_uploads/);assert.equal(args[0],'8032a04f-2003-4713-9836-b8ec373b6143.webp');return [[{mime_type:'image/webp',content:bytes}]];};
 try{const res=response();await serveUpload({params:{name:'8032a04f-2003-4713-9836-b8ec373b6143.webp'}},res,error=>{throw error||Error('Unexpected fallback');});assert.equal(res.body,bytes);assert.equal(res.headers['Content-Type'],'image/webp');assert.equal(res.headers['Cross-Origin-Resource-Policy'],'cross-origin');assert.match(res.headers['Cache-Control'],/immutable/);}finally{db.query=original;}
});
test('invalid paths never reach storage',async()=>{db.query=()=>{throw Error('Unexpected query');};try{const res=response();await serveUpload({params:{name:'../secret'}},res,()=>{});assert.equal(res.status,404);}finally{db.query=original;}});
test('legacy files can fall back to the local file handler',async()=>{db.query=async()=>[[]];try{let fallback=false;await serveUpload({params:{name:'8032a04f-2003-4713-9836-b8ec373b6143.webp'}},response(),()=>{fallback=true;});assert.equal(fallback,true);}finally{db.query=original;}});
test('storage errors are passed to the error handler',async()=>{const failure=Error('offline');db.query=async()=>{throw failure;};try{let caught;await serveUpload({params:{name:'8032a04f-2003-4713-9836-b8ec373b6143.webp'}},response(),e=>{caught=e;});assert.equal(caught,failure);}finally{db.query=original;}});
