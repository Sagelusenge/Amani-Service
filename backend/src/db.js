import mysql from 'mysql2/promise';
import {readFileSync} from 'node:fs';
import 'dotenv/config';
const ca=process.env.MYSQL_SSL_CA?.replace(/\\n/g,'\n')||(process.env.MYSQL_SSL_CA_PATH?readFileSync(process.env.MYSQL_SSL_CA_PATH,'utf8'):undefined);
if(process.env.NODE_ENV==='production'&&!ca)throw new Error('MYSQL_SSL_CA ou MYSQL_SSL_CA_PATH requis en production.');
export const db=mysql.createPool({host:process.env.MYSQL_HOST||'127.0.0.1',port:Number(process.env.MYSQL_PORT||3306),user:process.env.MYSQL_USER||'amani_app',password:process.env.MYSQL_PASSWORD||'',database:process.env.MYSQL_DATABASE||'amani_services',...(ca?{ssl:{ca,rejectUnauthorized:true}}:{}),waitForConnections:true,connectionLimit:10,decimalNumbers:true,dateStrings:true});
