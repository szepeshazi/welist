const {Firestore} = require('@google-cloud/firestore');

// Create a new client
const fs = new Firestore();


/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */
exports.executeDelete = async (event, context) => {
    const message = event.data
        ? Buffer.from(event.data, 'base64').toString()
        : 'No message';
    console.log(message);

    const containerLimit = 10;
    const itemLimit = 100;
    const maxDeleteOperations = 1000;
    let deleteCount = 0;
    let docsToDelete = [];

    const containersSnapshot = await fs.collection('containers').where("accessLog.deleted", "==", true).limit(containerLimit).get();

    if (containersSnapshot.empty) {
        console.log('No containers found marked for deletion');
        return;
    }

    for (const container of containersSnapshot.docs) {
        docsToDelete.push(`container: ${container.id} (${container.data()['name']})`);
        deleteCount++;
        const itemsSnapshot = await container.ref.collection('items').limit(itemLimit).get();
        for (const item of itemsSnapshot.docs) {
            docsToDelete.push(`item: ${item.id} (${item.data()['name']})`);
            deleteCount++;
            if (deleteCount > maxDeleteOperations) break;
        }
        if (deleteCount > maxDeleteOperations) break;
    }

    console.log("documents to delete", deleteCount, docsToDelete.join(", "));
};
