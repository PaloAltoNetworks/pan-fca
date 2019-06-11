// Passwords are only used in local mongo containers

db = db.getSiblingDB('admin');
db.createUser({
  user: 'fca_admin',
  pwd: '5LftaHCSSHuQLePH',
  roles: [{ role: 'userAdminAnyDatabase', db: 'admin' }]
});

db = db.getSiblingDB('fca');
db.createUser({
  user: 'fca',
  pwd: 'epqMBN5qLHT9CtC6',
  roles: [{ role: 'readWrite', db: 'fca' }]
});
