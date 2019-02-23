const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.userNotification = functions.firestore.document('notifications/{id}').onCreate((snap, context) => {

  const notification = snap.data();

  const payload = {
    notification: {
      title: notification.title,
      body: notification.body
    }
  };

  admin.messaging().sendToTopic(notification.toUser, payload).then(function(response) {
    console.log('Notification sent successfully:', response);
  }).catch(function(error){
    console.log('Notification sent failed:', error);
  });

  return 0;
});

// exports.dmNotification = functions.firestore.document('messages/{id}').onUpdate((change, context) => {
//
//   console.log('after: ', change.after.data())
//   console.log('before: ', change.before.data())
//
//   // const notification = snap.data();
//   //
//   // const payload = {
//   //   notification: {
//   //     title: notification.title
//   //   }
//   // };
//   //
//   // admin.messaging().sendToTopic(notification.toUser, payload).then(function(response) {
//   //   console.log('Notification sent successfully:', response);
//   // }).catch(function(error){
//   //   console.log('Notification sent failed:', error);
//   // });
//
//   return 0;
// });
