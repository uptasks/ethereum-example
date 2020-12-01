<template>
  <div 
    v-if="document" 
    class="document-review flex flex-col p-6">
    <div class="flex-1 flex flex-col py-4 space-y-4 bg-white rounded shadow">
      <div class="flex px-6 justify-between">
        <div class="font-semibold">Owner</div>
        <div class="">
          <a
            :href="'https://goerli.etherscan.io/address/' + document.publisher"
            class="text-blue-500"
            target="_blank"
          >
            {{ document.publisher }}</a
            >
        </div>
      </div>
      <div class="flex px-6 justify-between">
        <div class="font-semibold">Document</div>
        <div class="">
          <a 
            :href="documentPath" 
            class="text-blue-500" 
            target="_blank">{{
              document.path | truncate(80)
            }}</a>
        </div>
      </div>
      <div class="flex px-6 justify-between">
        <div class="font-semibold">Progress</div>
        <div class="">
          {{ document.signatureCounts }} of {{ document.expectedSignatures }}
        </div>
      </div>
    </div>

    <!-- Embed Document -->
    <div class="flex-1">
      <embed
        :src="documentPath"
        type="application/pdf"
        width="100%"
        height="100%"
      >
    </div>

    <!-- Action panel -->
    <div class="fixed bottom-10 right-10 space-x-2">
      <button 
        class="px-4 py-2 bg-red-600 text-red-100 rounded shadow focus:outline-none" 
        @click="decline">Reject</button>
      <button 
        class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none" 
        @click="approveDocument">Sign</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "Documents",
  data() {
    return {
      document: "",
    };
  },
  computed: {
    documentID() {
      return this.$route.params.id;
    },
    documentPath() {
      return "http://ipfs.io/ipfs/" + this.document.path;
    },
  },
  created() {
    this.getDocument();
  },
  methods: {
    getDocument() {
      let self = this;
      self.$store.getters.getContract.methods
        .documents(this.documentID)
        .call()
        .then((res) => {
          self.document = res;
        });
    },
    approveDocument() {
      let self = this;
      self.$store.getters.getContract.methods
        .approve(self.documentID)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
    decline() {
      let self = this;
      self.$store.getters.getContract.methods
        .decline(self.documentID)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Declined", res);
        });
    },
  },
};
</script>