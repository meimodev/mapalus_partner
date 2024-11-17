const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = functions.https.onCall(async (req) => {
    let destination = {topic: req.data.destination};
    if (req.data.destination.length > 40) {
        destination = {token: req.data.destination};
    }
    const payload = {
        notification: {
            title: req.data.title, body: req.data.body,
        },
    }
    try {

        const response = await admin.messaging().send({...payload, ...destination})

        return {
            success: true, response: response, errorMessage: null, destination
        }
    } catch (error) {
        return {
            success: false, response: null, message: error.message, destination
        }
    }
})