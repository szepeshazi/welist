/**
 * Remove list items marked for deletion
 */
const {Firestore} = require('@google-cloud/firestore');
const fs = new Firestore();

/**
 * Triggered by Cloud Pub/Sub 'deleteItem' topic.
 */
exports.executeDelete = async (_, __) => {
    const itemLimit = 2;
    const maxDeleteOperations = 5;
    let deleteCount = 0;
    let docsToDelete = [];
    let hasMoreItems = true;
    let lastItemRef = null;

    while (hasMoreItems && deleteCount < maxDeleteOperations) {
        let itemsQuery = fs.collectionGroup('items').where("access.deleted", "==", true).limit(itemLimit);
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
    console.log("documents to delete", deleteCount, docsToDelete.join(", "));
};
