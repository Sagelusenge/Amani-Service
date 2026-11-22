import {db} from './db.js';

// Small uploads are persisted in the existing managed database, not Render's
// ephemeral filesystem. The 8 MB upload limit is enforced before this module.
export async function initializeUploads(){
  await db.query(`CREATE TABLE IF NOT EXISTS stored_uploads (
    name VARCHAR(80) PRIMARY KEY,
    mime_type VARCHAR(100) NOT NULL,
    content MEDIUMBLOB NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
  )`);
}
export async function storeUpload(name,bytes,mime){
  await db.query('INSERT INTO stored_uploads(name,mime_type,content) VALUES(?,?,?)',[name,mime,bytes]);
}
export async function deleteUpload(name){await db.query('DELETE FROM stored_uploads WHERE name=?',[name]);}
export async function serveUpload(req,res,next){
  if(!/^[a-f0-9-]{36}\.(png|jpg|webp|pdf)$/.test(req.params.name))return res.sendStatus(404);
  try{
    const [[file]]=await db.query('SELECT mime_type,content FROM stored_uploads WHERE name=?',[req.params.name]);
    if(!file)return next(); // Compatibility with existing local uploads.
    res.set({'Content-Type':file.mime_type,'Cache-Control':'public, max-age=31536000, immutable','Cross-Origin-Resource-Policy':'cross-origin','X-Content-Type-Options':'nosniff','Content-Security-Policy':"default-src 'none'; sandbox"});
    res.send(file.content);
  }catch(error){next(error);}
}
