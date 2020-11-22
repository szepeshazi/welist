import 'package:firebase_functions_interop/firebase_functions_interop.dart';
import 'package:welist_common/common.dart';

Future<void> deleteContainers(ExpressHttpRequest request) async {
  final app = FirebaseAdmin.instance.initializeApp();
  final fs = app.firestore();

  const int containerLimit = 10;
  const int itemLimit = 2;
  const int maxDeleteOperations = 5;

  int deleteCount = 0;
  List<String> docsToDelete = [];

  QuerySnapshot containersSnapshot = await fs
      .collection(ListContainer.collectionName)
      .where("accessLog.deleted", isEqualTo: true)
      .limit(containerLimit)
      .get();

  if (containersSnapshot.isEmpty) {
    print('No containers found marked for deletion');
    return;
  }

  for (final container in containersSnapshot.documents) {
    docsToDelete.add("container: ${container.documentID} (${container.data.toMap()['name']})");
    deleteCount++;

    bool hasMoreItems = true;
    DocumentSnapshot lastItemSnapshot;

    while (hasMoreItems) {
      var itemsQuery = container.reference.collection(ListItem.collectionName).limit(itemLimit);
      if (lastItemSnapshot != null) {
        itemsQuery = itemsQuery.startAfter(snapshot: lastItemSnapshot);
      }
      var itemsSnapshot = await itemsQuery.get();
      hasMoreItems = itemsSnapshot.isNotEmpty;
      lastItemSnapshot = itemsSnapshot.documents[itemsSnapshot.documents.length - 1];
      for (var item in itemsSnapshot.documents) {
        docsToDelete.add("item: ${item.documentID} (${item.data.toMap()['name']})");
        deleteCount++;
      }
      if (deleteCount > maxDeleteOperations) break;
    }
  }

  print("documents to delete $deleteCount, ${docsToDelete.join(', ')}");
}
