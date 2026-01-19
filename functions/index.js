const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Scheduled function: Runs every day at 10:00 AM
exports.sendBillReminders = functions.pubsub.schedule("every day 10:00")
  .timeZone("Asia/Dhaka")
  .onRun(async (context) => {
    const db = admin.firestore();
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    
    // Normalize to YYYY-MM-DD for comparison if stored as string, 
    // or use start/end of day for Timestamps.
    // simpler implementation: Query all active bills and check locally or better DB design
    // Ideally: collectionGroup query if possible, or iterate users (slow for scale)
    // For MVP/Demo: We assume a 'reminders' collection or we just log it.
    
    // Efficient strategy: store 'nextReminderDate' on the bill.
    // Query users/{uid}/recurring_bills where nextDueDate usually needs collectionGroup index
    // But recurring_bills is a subcollection. 
    
    const billsSnapshot = await db.collectionGroup("recurring_bills")
      .where("isActive", "==", true)
      // .where("nextDueDate", ">=", startOfTomorrow) ... 
      .get();

    const promises = [];
    
    billsSnapshot.forEach(doc => {
      const bill = doc.data();
      const nextDueDate = bill.nextDueDate.toDate(); // timestamp to date
      
      if (isTomorrow(nextDueDate)) {
         // Get User to find FCM token
         // Parent of u/{uid}/recurring_bills/{id} is u/{uid}
         const userRef = doc.ref.parent.parent;
         
         const p = userRef.get().then(userDoc => {
             const userData = userDoc.data();
             if (userData && userData.fcmTokens) {
                 const payload = {
                     notification: {
                         title: "Bill Reminder 💸",
                         body: `Don't forget to pay ${bill.title}: ৳${bill.amount}`,
                     }
                 };
                 // Send to all tokens
                 return admin.messaging().sendToDevice(userData.fcmTokens, payload);
             }
         });
         promises.push(p);
      }
    });

    return Promise.all(promises);
});

function isTomorrow(date) {
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    return date.getDate() === tomorrow.getDate() && 
           date.getMonth() === tomorrow.getMonth() &&
           date.getFullYear() === tomorrow.getFullYear();
}
