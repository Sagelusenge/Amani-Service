import {db} from './db.js';
import {entities} from './entities.js';
export const modules=[...Object.keys(entities),'reports'];
export const actions=['read','create','update','delete','print','archive','reply'];
export const can=(user,module,action='read')=>user.role==='admin'||user.permissions?.includes(`${module}:${action}`)||(['create','update'].includes(action)&&user.permissions?.includes(`${module}:write`))||(action==='write'&&(user.permissions?.includes(`${module}:create`)||user.permissions?.includes(`${module}:update`)));
export async function permissionsFor(roleId){const [rows]=await db.query('SELECT p.name FROM permissions p JOIN role_permissions rp ON rp.permission_id=p.id WHERE rp.role_id=?',[roleId]);return rows.map(r=>r.name)}
export async function initializeAccess(){
 for(const module of modules)for(const action of [...actions,'write']){const name=`${module}:${action}`;await db.query('INSERT INTO permissions(name,description) SELECT ?,? WHERE NOT EXISTS(SELECT 1 FROM permissions WHERE name=?)',[name,`${action==='read'?'Consulter':'Modifier'} ${module}`,name])}
 const [[marker]]=await db.query("SELECT id FROM site_settings WHERE setting_key='access_initialized'");
 if(!marker){const [roles]=await db.query('SELECT id,name FROM roles');for(const role of roles){const allowed=role.name==='manager'?modules.filter(m=>!['users','roles','permissions','site_settings'].includes(m)):role.name==='editor'?['publications','campaigns','editorial_events','media_assets','categories','site_pages','banners','communication_requests']:[];for(const module of allowed)await db.query('INSERT IGNORE INTO role_permissions(role_id,permission_id) SELECT ?,id FROM permissions WHERE name IN (?,?)',[role.id,`${module}:read`,`${module}:write`])}await db.query("INSERT INTO site_settings(setting_key,setting_value) VALUES('access_initialized','1')")}
 const defaults={company_name:'AMANI SERVICES',company_address:'',company_email:'',company_phone:'',company_registration:'',currency:'USD',document_footer:'Merci pour votre confiance.',contract_terms:'',hero_image:'/images/hero-meeting.jpg',about_image:'/images/about-meeting.jpg'};
 for(const [key,value]of Object.entries(defaults))await db.query('INSERT IGNORE INTO site_settings(setting_key,setting_value) VALUES(?,?)',[key,value]);
}
