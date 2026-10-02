const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

const serviceAccountPath =
  process.env.FIREBASE_SERVICE_ACCOUNT_PATH ||
  path.resolve(__dirname, '../../petcare-75450-firebase-adminsdk-fbsvc-56e0edf315.json');

if (!admin.apps.length) {
  try {
    if (fs.existsSync(serviceAccountPath)) {
      const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
      });
      console.log(`[Firebase Admin] Successfully initialized with project ID: ${serviceAccount.project_id}`);
    } else {
      console.warn(`[Firebase Admin] Warning: Service account file not found at: ${serviceAccountPath}`);
      console.warn('[Firebase Admin] Attempting default application credentials...');
      admin.initializeApp();
    }
  } catch (error) {
    console.error('[Firebase Admin] Initialization failed:', error.message);
    throw error;
  }
}

const db = admin.firestore();
const messaging = admin.messaging();
const auth = admin.auth();

module.exports = {
  admin,
  db,
  messaging,
  auth,
};
