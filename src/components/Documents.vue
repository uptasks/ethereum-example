<template>
  <div class="documents flex p-6">
    <div class="flex-1 flex py-4 space-y-4 bg-white rounded shadow">
      <table class="flex-1">
        <thead>
          <tr>
            <th class="border-b border-gray-100 p-1 text-left">Owner</th>
            <th class="border-b border-gray-100 p-1 text-left">Document</th>
            <th class="border-b border-gray-100 p-1">All Signers</th>
            <th class="border-b border-gray-100 p-1">Signed</th>
            <th class="border-b border-gray-100 p-1">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="(doc, index) in documents"
            :key="index"
            class="hover:bg-gray-100"
          >
            <td class="border-b border-gray-100 p-1">
              <a
                :href="'https://goerli.etherscan.io/address/' + doc.publisher"
                class="text-blue-500"
                target="_blank"
              >
                {{ doc.publisher | truncate(20) }}</a
                >
            </td>
            <td class="border-b border-gray-100 p-1">
              <a
                :href="'http://ipfs.io/ipfs/' + doc.path"
                class="text-blue-500"
                target="_blank"
              >{{ doc.path | truncate(20) }}</a
              >
            </td>
            <td class="border-b border-gray-100 p-1 text-center">
              {{ doc.expectedSignatures }}
            </td>
            <td class="border-b border-gray-100 p-1 text-center">
              {{ doc.signatureCounts }}
            </td>
            <td class="border-b border-gray-100 p-1 text-center">
              <router-link
                :to="{ name: 'DocumentReview', params: {id: index} }"
                class="px-4 py-1 bg-gray-600 text-gray-100 rounded shadow focus:outline-none"
              >
                Review
              </router-link>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

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
                self.documents.push(res);
              });
          }
        });
    },
  },
};
</script>