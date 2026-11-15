import {readFile} from 'node:fs/promises';
import {db} from './db.js';

// Explicit one-time initialization; never run destructive schema SQL on an existing database.
try {
  const [tables] = await db.query('SHOW TABLES');
  if (tables.length) throw new Error('Base non vide : import annulé pour préserver les données existantes.');
  const sql = await readFile(new URL('../../database/01_schema.sql', import.meta.url), 'utf8');
  let delimiter = ';', statement = '', count = 0;
  const connection = await db.getConnection();
  try {
    for (const line of sql.split(/\r?\n/)) {
      if (/^CREATE DATABASE\b|^USE\b/i.test(line)) continue;
      const directive = line.match(/^DELIMITER\s+(\S+)/i);
      if (directive) { delimiter = directive[1]; continue; }
      statement += line + '\n';
      if (statement.trimEnd().endsWith(delimiter)) {
        await connection.query(statement.trimEnd().slice(0, -delimiter.length));
        statement = '';
        count++;
      }
    }
    if (statement.trim()) throw new Error('Instruction SQL incomplète.');
    console.log(`Schéma importé : ${count} instructions.`);
  } finally { connection.release(); }
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
} finally { await db.end(); }
