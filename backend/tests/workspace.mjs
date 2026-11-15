// Integration test against the configured local database; temporary records are removed.
import 'dotenv/config';
import assert from 'node:assert/strict';
import jwt from 'jsonwebtoken';
import {db} from '../src/db.js';
const ids={};
const base=process.env.TEST_API_URL||'http://localhost:4000/api';
const [[admin]]=await db.query("SELECT u.id FROM users u JOIN roles r ON r.id=u.role_id WHERE r.name='admin' AND u.is_active=1 LIMIT 1");
assert.ok(admin,'An active administrator is required');
const token=jwt.sign({id:admin.id},process.env.JWT_SECRET,{expiresIn:'5m'});
async function call(url,method='GET',data,credential=token){const r=await fetch(base+url,{method,headers:{Authorization:'Bearer '+credential,'Content-Type':'application/json'},body:data?JSON.stringify(data):undefined});const body=await r.json().catch(()=>null);return {status:r.status,body}}
try {
 const [role]=await db.query("INSERT INTO roles(name,description) VALUES(?,'Temporary integration test')",['test_'+Date.now()]);ids.role=role.insertId;
 const [u]=await db.query("INSERT INTO users(full_name,email,password_hash,role_id,is_active) VALUES('Test',?,'unused',?,1)",['test'+Date.now()+'@example.invalid',ids.role]);ids.user=u.insertId;
 const restricted=jwt.sign({id:ids.user},process.env.JWT_SECRET,{expiresIn:'5m'});
 assert.equal((await call('/admin/data/clients','GET',null,restricted)).status,403);
 assert.equal((await call('/admin/role-access/'+ids.role,'PUT',{permissions:['clients:read']})).status,200);
 assert.equal((await call('/admin/data/clients','GET',null,restricted)).status,200);
 assert.equal((await call('/admin/data/clients','POST',{name:'Forbidden'},restricted)).status,403);
 assert.equal((await call('/admin/role-access','GET',null,restricted)).status,403);
 await db.query('UPDATE users SET is_active=0 WHERE id=?',[ids.user]);
 assert.equal((await call('/auth/me','GET',null,restricted)).status,401);
 const [q]=await db.query("INSERT INTO quotes(status) VALUES('brouillon')");ids.quote=q.insertId;
 assert.equal((await call(`/admin/documents/quotes/${ids.quote}/items`,'PUT',{items:[{label:'Test service',quantity:2,unit_price:12.5}]})).status,200);
 assert.equal(Number((await call(`/admin/documents/quotes/${ids.quote}`)).body.record.total_amount),25);
 assert.equal((await call(`/admin/data/quotes/${ids.quote}`,'PUT',{total_amount:99})).status,200);
 assert.equal(Number((await call(`/admin/documents/quotes/${ids.quote}`)).body.record.total_amount),25);
 assert.equal((await call('/admin/data/invoices','POST',{status:'publié'})).status,400);
 const [c]=await db.query("INSERT INTO contracts(title,status) VALUES('Temporary test','brouillon')");ids.contract=c.insertId;
 assert.equal((await call(`/admin/contracts/${ids.contract}/terms`,'PUT',{terms:'Conditions de test'})).status,200);
 assert.equal((await call(`/admin/documents/contracts/${ids.contract}`)).body.record.terms,'Conditions de test');
 const settings=await call('/admin/settings');assert.equal(settings.status,200);assert.ok(settings.body.some(r=>r.setting_key==='company_name'));
 assert.equal((await call('/admin/calendar?month=2026-11')).status,200);
 console.log('PASS: permissions, suspension, document totals, invalid status, contract terms, settings, calendar.');
} finally {
 for(const [entity,id] of [['quotes',ids.quote],['contracts',ids.contract]])if(id){await db.query('DELETE FROM audit_logs WHERE entity_name=? AND entity_id=?',[entity,id]);await db.query(`DELETE FROM ${entity} WHERE id=?`,[id])}
 if(ids.user)await db.query('DELETE FROM users WHERE id=?',[ids.user]);
 if(ids.role)await db.query('DELETE FROM roles WHERE id=?',[ids.role]);
 await db.end();
}
