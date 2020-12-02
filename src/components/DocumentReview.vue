<template>
  <div
    v-if="contract"
    class="document-review flex flex-col p-6 overflow-hidden h-screen"
  >
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
import contractJson from "./../../build/contracts/DecentraDocuSign.json";
export default {
  name: "DocumentReview",
  data() {
    return {
      path: "",
      owner: "",
      completed: "",
      signers: [],
      signatures: [],
      contract: "",
    };
  },
  computed: {
    contractHash() {
      return this.$route.params.hash;
    },
    documentPath() {
      return "http://ipfs.io/ipfs/" + this.path;
    },
  },
  created() {
    this.loadContract();
    if (this.contract) {
      this.getDocumentDetails();
    }
  },
  methods: {
    loadContract() {
      let self = this;
      this.contract = new window.web3.eth.Contract(
        contractJson.abi,
        this.contractHash,
        {
          from: self.$store.getters.getAccount,
          gasPrice: 20000000000,
          gasLimit: 210000,
        }
      );
    },
    async getDocumentDetails() {
      let self = this;
      self.contract.methods
        .document()
        .call()
        .then((res) => {
          self.path = res;
        });

      self.contract.methods
        .owner()
        .call()
        .then((res) => {
          self.owner = res;
        });

      self.contract.methods
        .completed()
        .call()
        .then((res) => {
          self.completed = res;
        });

      let signersCount =
        (await self.contract.methods.signersCount().call()) || 0;

      for (let i = 0; i < signersCount; i++) {
        self.contract.methods
          .signers(i)
          .call()
          .then((res) => {
            self.signers.push(res);
          });
      }

      for (let i = 0; i < signersCount; i++) {
        self.contract.methods
          .signers(i)
          .call()
          .then((addr) => {
            self.contract.methods
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
      self.contract.methods
        .approve()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
    decline() {
      let self = this;
      self.contract.methods
        .decline()
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Declined", res);
        });
    },
  },
};
</script>