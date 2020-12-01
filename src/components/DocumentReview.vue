<template>
  <div class="document-review flex flex-col p-6 overflow-hidden h-screen">
    <div class="flex-1 flex flex-col py-4 space-y-4 bg-white rounded shadow">
      <div class="flex px-6 justify-between">
        <div class="font-semibold">Owner</div>
        <div class="">
          <a
            :href="'https://goerli.etherscan.io/address/' + owner"
            class="text-blue-500"
            target="_blank"
          >
            {{ owner }}</a
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
              path | truncate(80)
            }}</a>
        </div>
      </div>
      <div class="flex px-6 justify-between">
        <div class="font-semibold">Completed</div>
        <div class="">
          {{ completed }}
        </div>
      </div>

      <div>{{ signers }}</div>
      <div>{{ signatures }}</div>
    </div>

    <!-- Embed Document -->
    <div class="flex-1">
      <embed
        :src="documentPath"
        type="application/pdf"
        width="100%"
        height="100vh"
        class="h-screen"
      >
    </div>

    <!-- Action panel -->
    <div class="fixed bottom-10 right-10 space-x-2">
      <button
        class="px-4 py-2 bg-red-600 text-red-100 rounded shadow focus:outline-none"
        @click="decline"
      >
        Reject
      </button>
      <button
        class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
        @click="approve"
      >
        Sign
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: "Documents",
  data() {
    return {
      path: "",
      owner: "",
      completed: "",
      signers: [],
      signatures: [],
    };
  },
  computed: {
    documentID() {
      return this.$route.params.id;
    },
    documentPath() {
      return "http://ipfs.io/ipfs/" + this.path;
    },
  },
  created() {
    this.getDocumentDetails();
  },
  methods: {
    async getDocumentDetails() {
      let self = this;
      self.$store.getters.getContract.methods
        .document()
        .call()
        .then((res) => {
          self.path = res;
        });

      self.$store.getters.getContract.methods
        .owner()
        .call()
        .then((res) => {
          self.owner = res;
        });

      self.$store.getters.getContract.methods
        .completed()
        .call()
        .then((res) => {
          self.completed = res;
        });

      let signersCount =
        (await self.$store.getters.getContract.methods.signersCount().call()) ||
        0;

      for (let i = 0; i < signersCount; i++) {
        self.$store.getters.getContract.methods
          .signers(i)
          .call()
          .then((res) => {
            self.signers.push(res);
          });
      }

      for (let i = 0; i < signersCount; i++) {
        self.$store.getters.getContract.methods
          .signers(i)
          .call()
          .then((addr) => {
            self.$store.getters.getContract.methods
              .signatures(addr)
              .call()
              .then((signature) => {
                self.signatures.push(signature);
              });
          });
      }
    },
    approve() {
      let self = this;
      self.$store.getters.getContract.methods
        .approve()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
    decline() {
      let self = this;
      self.$store.getters.getContract.methods
        .decline()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Declined", res);
        });
    },
  },
};
</script>