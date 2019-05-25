const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
import * as algoliasearch from 'algoliasearch';

const client = algoliasearch("9XJAPDF104", "a50ec3d30a67484b0f9e6aed65fe4e91");
const index = client.initIndex('route_search');

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

// Algolia
exports.indexAnimal = functions.firestore
  .document('routes/{routeId}')
  .onCreate((snap, context) => {
        const data = snap.data();
        const objectID = snap.id;

    // Add the data to the algolia index
    return index.addObject({
      objectID,
      ...data
    });
  });

exports.unindexAnimal = functions.firestore
  .document('routes/{routeId}')
  .onDelete((snap, context) => {
        const objectId = snap.id;

    // Delete an ID from the index
    return index.deleteObject(objectId);
  });

// exports.newRoute = functions.firestore.document('routes/{id}').onCreate((snap, context) => {
//   const route = snap.data();
//   queryRoute(route);
//   return 0;
// });

function mergeRoutes(oldRoute, newRoute) {
  const r = oldRoute;
  r.stars = Object.assign({}, oldRoute.stars, newRoute.stars);
  r.imageUrls = Object.assign({}, oldRoute.imageUrls, newRoute.imageUrls);
  r.types = [ ...oldRoute.types, ...newRoute.types ]
  r.types = [ ...new Set(r.types) ];
  r.arDiagrams = Object.assign({}, oldRoute.arDiagrams, newRoute.arDiagrams);
  r.comments = [ ...oldRoute.comments, ...newRoute.comments ]
  return r
}

function queryRoute(newRoute) {
  const query = admin.firestore()
    .collection('routes')
    .where('name', '==', 'Camel');

  query.get().then(snapshot => {
    snapshot.forEach(doc => { 
      const oldRoute = doc.data();
      if (oldRoute.id == newRoute.id) {
        return;
      }
      const dist = getDistanceFromLatLonInKm(newRoute.latitude, newRoute.longitude, oldRoute.latitude, oldRoute.longitude);
      if (dist < 1) {
        const route = mergeRoutes(oldRoute, newRoute); 
        admin.firestore().collection("routes").doc(newRoute.id).delete();
        admin.firestore().collection("routes").doc(route.id).set(route);
        console.log('merged route: ', route);
      }
    });
  })
  return 0;
}

function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2-lat1);  // deg2rad below
    var dLon = deg2rad(lon2-lon1); 
    var a = 
        Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
        Math.sin(dLon/2) * Math.sin(dLon/2)
      ; 
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    var d = R * c; // Distance in km
    return d;
}

function deg2rad(deg) {
    return deg * (Math.PI/180)
}
