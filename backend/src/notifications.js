const { messaging } = require('./firebaseAdmin');

/**
 * Send a notification to a specific device via FCM token
 * @param {string} registrationToken - The target device's FCM token
 * @param {string} title - Notification title
 * @param {string} body - Notification message
 * @param {Object} [dataPayload] - Optional key-value custom data payload
 */
async function sendToDevice(registrationToken, title, body, dataPayload = {}) {
  try {
    const message = {
      token: registrationToken,
      notification: {
        title,
        body,
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        ...dataPayload,
      },
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          channelId: 'pawcare_reminders',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    const response = await messaging.send(message);
    console.log('[FCM] Successfully sent notification to device:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('[FCM] Error sending message to device:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Send a notification to a topic (e.g., 'all_pet_parents' or 'community_updates')
 * @param {string} topic - The topic name
 * @param {string} title - Notification title
 * @param {string} body - Notification message
 * @param {Object} [dataPayload] - Optional key-value custom data payload
 */
async function sendToTopic(topic, title, body, dataPayload = {}) {
  try {
    const message = {
      topic,
      notification: {
        title,
        body,
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        ...dataPayload,
      },
    };

    const response = await messaging.send(message);
    console.log(`[FCM] Successfully broadcast notification to topic "${topic}":`, response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error(`[FCM] Error sending message to topic "${topic}":`, error);
    return { success: false, error: error.message };
  }
}

/**
 * Send a structured Vaccination Reminder notification
 * @param {string} registrationToken - Target device FCM token
 * @param {string} petName - Name of the pet
 * @param {string} vaccineName - Name of the vaccine (e.g. Rabies, DHPP)
 * @param {string} dueDate - Due date string (e.g. "Tomorrow at 10:00 AM")
 */
async function sendVaccinationReminder(registrationToken, petName, vaccineName, dueDate) {
  const title = `🐾 Vaccination Due for ${petName}!`;
  const body = `${petName}'s ${vaccineName} vaccine is scheduled for ${dueDate}. Don't forget to visit the clinic!`;
  
  return sendToDevice(registrationToken, title, body, {
    type: 'VACCINATION_REMINDER',
    petName,
    vaccineName,
    dueDate,
  });
}

/**
 * Send a structured Pet Care Alert (Food, Vet, Medication)
 * @param {string} registrationToken - Target device FCM token
 * @param {string} petName - Name of the pet
 * @param {string} reminderType - Reminder type (Medication, Vet Appointment, Grooming)
 * @param {string} details - Additional notes or time
 */
async function sendCareAlert(registrationToken, petName, reminderType, details) {
  const title = `⏰ ${reminderType} Alert for ${petName}`;
  const body = details || `It's time for ${petName}'s ${reminderType.toLowerCase()}!`;
  
  return sendToDevice(registrationToken, title, body, {
    type: 'CARE_ALERT',
    petName,
    reminderType,
  });
}

module.exports = {
  sendToDevice,
  sendToTopic,
  sendVaccinationReminder,
  sendCareAlert,
};
