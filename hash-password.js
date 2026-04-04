// Script untuk generate bcrypt hash password
// Install: npm install bcryptjs
// Usage: node hash-password.js

const bcrypt = require('bcryptjs');

async function hashPassword(password) {
  const salt = await bcrypt.genSalt(10);
  const hash = await bcrypt.hash(password, salt);
  console.log('Plain Password:', password);
  console.log('Hashed Password:', hash);
  console.log('\nCopy the hashed password above to insert into database');
}

// Change this password
const passwordToHash = 'password123';
hashPassword(passwordToHash);
