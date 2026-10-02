const { db } = require('./firebaseAdmin');

/**
 * Add or update a Pet record in Firestore
 * @param {string} userId - Owner's Firebase Auth UID
 * @param {Object} petData - Pet details object
 */
async function savePet(userId, petData) {
  try {
    const petId = petData.id || db.collection('users').doc(userId).collection('pets').doc().id;
    const petRef = db.collection('users').doc(userId).collection('pets').doc(petId);

    const payload = {
      ...petData,
      id: petId,
      updatedAt: new Date().toISOString(),
    };

    await petRef.set(payload, { merge: true });
    console.log(`[Firestore] Pet "${petData.name || petId}" saved successfully.`);
    return { success: true, petId, data: payload };
  } catch (error) {
    console.error('[Firestore] Error saving pet:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Add a vaccination record to a pet
 * @param {string} userId - Owner UID
 * @param {string} petId - Pet ID
 * @param {Object} vaccinationData - Vaccination info
 */
async function addVaccinationRecord(userId, petId, vaccinationData) {
  try {
    const vacId = vaccinationData.id || db.collection('users').doc(userId).collection('pets').doc(petId).collection('vaccinations').doc().id;
    const vacRef = db.collection('users').doc(userId).collection('pets').doc(petId).collection('vaccinations').doc(vacId);

    const payload = {
      ...vaccinationData,
      id: vacId,
      createdAt: new Date().toISOString(),
    };

    await vacRef.set(payload, { merge: true });
    console.log(`[Firestore] Vaccination record added for pet ID ${petId}`);
    return { success: true, vaccinationId: vacId };
  } catch (error) {
    console.error('[Firestore] Error adding vaccination record:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Fetch all pets for a user
 * @param {string} userId - Owner UID
 */
async function getUserPets(userId) {
  try {
    const snapshot = await db.collection('users').doc(userId).collection('pets').get();
    const pets = [];
    snapshot.forEach((doc) => {
      pets.push({ id: doc.id, ...doc.data() });
    });
    return { success: true, pets };
  } catch (error) {
    console.error('[Firestore] Error fetching pets:', error);
    return { success: false, error: error.message };
  }
}

module.exports = {
  savePet,
  addVaccinationRecord,
  getUserPets,
};
