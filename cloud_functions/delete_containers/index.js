/**
 * Remove containers marked for deletion
 */
const {Firestore} = require('@google-cloud/firestore');
const fs = new Firestore();

/**
 * Triggered by Cloud Pub/Sub 'deleteContainer' topic.
 */
exports.executeDelete = async (_, __) => {
    const containerLimit = 10;
    const itemLimit = 2;
    const maxDeleteOperations = 5;
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

        let hasMoreItems = true;
        let lastItemRef = null;
        while (hasMoreItems) {
            let itemsQuery = container.ref.collection('items').limit(itemLimit);
            if (lastItemRef != null) {
                itemsQuery = itemsQuery.startAfter(lastItemRef);
            }
            const itemsSnapshot = await itemsQuery.get();
            hasMoreItems = !itemsSnapshot.empty;
            lastItemRef = itemsSnapshot.docs[itemsSnapshot.docs.length -1];
            for (const item of itemsSnapshot.docs) {
                docsToDelete.push(`item: ${item.id} (${item.data()['name']})`);
                deleteCount++;
            }
        }
        if (deleteCount > maxDeleteOperations) break;
    }

    console.log("documents to delete", deleteCount, docsToDelete.join(", "));
};
