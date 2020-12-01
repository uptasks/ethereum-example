<template>
  <div class="services">
    <div class="flex">
      <div class="flex-1 space-x-4">
        <div class="p-2 bg-white rounded shadow flex flex-col space-y-4">
          <div>
            <input 
              v-model="documentPath" 
              type="text"
              placeholder="IPFS Link"></div>
        </div>
        <div class="signers">
          <div class="flex">
            <input 
              v-model="newSigner" 
              type="text" 
              placeholder="Signer address">
            <button @click="addSigner">Add signer</button>
          </div>
          <div 
            v-for="(signer, index) in signers" 
            :key="index" 
            class="flex-1">
            {{ signer }}
          </div>
        </div>
        <button
          class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
          @click="loadContract()"
        >
          Add document
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "AddDocument",
  data() {
    return {
      documentPath: "",
      signers: [],
      newSigner: "",
    };
  },
  methods: {
    addSigner() {
      if (!this.newSigner) return alert("Signer address is required");
      this.signers.unshift(this.newSigner);
    },
    loadContract() {
      let self = this;
      if (!self.documentPath) return alert("Document is required");
      if (self.signers.length == 0)
        return alert("Atlease one signer is required");
      self.$store.getters.getContract.methods
        .addDocument(self.documentPath, self.signers)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Receipted", res);
        });
    },
  },
};
</script>