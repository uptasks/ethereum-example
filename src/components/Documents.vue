<template>
  <div class="documents">
    <div class="flex">
      <div class="flex-1 space-x-4">
        <table class="w-full">
          <thead>
            <tr>
              <th>Owner</th>
              <th>Document</th>
              <th>Expected Signatures</th>
              <th>Signed</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(doc, index) in documents" 
              :key="index">
              <td>{{ doc.publisher }}</td>
              <td>{{ doc.path }}</td>
              <td>{{ doc.expectedSignatures }}</td>
              <td>{{ doc.signatureCounts }}</td>
              <td>
                <button
                  class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
                  @click="approveDocument(index)">Sign</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
</div></template>

<script>
export default {
  name: "Documents",
  data() {
    return {
      documents: [],
    };
  },
  created() {
    this.getDocuments();
  },
  methods: {
    getDocuments() {
      let self = this;
      // { from: self.$store.getters.getAccount }
      self.$store.getters.getContract.methods
        .numOfDocuments()
        .call()
        .then((numOfDocuments) => {
          for (let i = 0; i < numOfDocuments; i++) {
            self.$store.getters.getContract.methods
              .documents(i)
              .call()
              .then((res) => {
                  self.documents.push(res)
              });
          }
        });
    },
    approveDocument(documentID) {
      let self = this;
      self.$store.getters.getContract.methods
        .approve(documentID)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
  },
};
</script>