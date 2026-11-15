import 'dotenv/config';
import bcrypt from 'bcryptjs';
import {db} from './db.js';
const [,,email,pass,name='Administrateur Amani']=process.argv;
if(!email||!pass||pass.length<12){console.error('Usage: npm run admin -- admin@example.com "mot-de-passe-de-12-caractères-minimum" "Nom"');process.exit(1)}
try{const [[role]]=await db.query("SELECT id FROM roles WHERE name='admin' LIMIT 1");if(!role)throw Error('Importer database/01_schema.sql avant de créer le compte.');const hash=await bcrypt.hash(pass,12);await db.query('INSERT INTO users(email,full_name,password_hash,role_id,is_active) VALUES(?,?,?,?,1)',[email,name,hash,role.id]);console.log('Compte administrateur créé :',email)}catch(e){console.error(e.message);process.exitCode=1}finally{await db.end()}
