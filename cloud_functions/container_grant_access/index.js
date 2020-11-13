const functions = require('firebase-functions');
const {Firestore} = require('@google-cloud/firestore');
const fs = new Firestore();


exports.acceptInvitation = functions.https.onCall(async (data, context) => {
    let uid = context.auth.uid;
    let invitationId = data["invitationId"];

    let inviteRef = await fs.collection("invitations").doc(invitationId).get();
    let accepted = parseInt(inviteRef.data()["recipientAcceptedTime"]);
    let containerId = inviteRef.data()["subjectId"];

    let containerRef = await fs.collection("listContainers").doc(containerId).get();
    console.log("Accepting invitation from ", inviteRef.data()["senderEmail"], " for ", containerId, " at ", accepted);
    console.log("container", containerRef.data()["name"], containerRef.data()["typeName"], containerRef.data()["itemCount"]);
});
