const { admin } = require('./firebaseAdmin');
const { sendToTopic, sendVaccinationReminder } = require('./notifications');

async function main() {
  console.log('========================================');
  console.log('🐾 PawCare Firebase Admin SDK Server 🐾');
  console.log('========================================');

  console.log('Firebase App initialized successfully:');
  console.log(' - Name:', admin.app().name);
  console.log(' - Project ID:', admin.app().options.credential.projectId || 'Ready');

  console.log('\nAvailable helpers:');
  console.log(' 1. FCM Push Notifications (sendToDevice, sendToTopic, sendVaccinationReminder, sendCareAlert)');
  console.log(' 2. Firestore Data Management (savePet, addVaccinationRecord, getUserPets)');
  console.log(' 3. Firebase Auth User Management');

  console.log('\nTo broadcast a test notification to all subscribed devices:');
  console.log(' > npm run send-notification');

  console.log('\nReady to execute tasks.');
}

if (require.main === module) {
  main().catch(console.error);
}

module.exports = { main };
