<template>
  <div class="add-document p-6">
    <div class="flex">
      <div class="flex-1 p-4 space-y-4 bg-white rounded shadow">
        <div class="p-2 flex flex-col space-y-4">
          <div class="flex flex-col space-y-2">
            <label>Upload document</label>
            <input
              type="file"
              placeholder="IPFS Link"
              @change="handleUpload($event.target.name, $event.target.files)"
            >
          </div>
        </div>
        <div class="signers bg-gray-100 p-2">
          <div
            v-for="(signer, index) in signers"
            :key="index"
            class="flex-1 border-t border-gray-200 p-2"
          >
            {{ signer }}
          </div>
          <div class="flex flex-row">
            <input
              v-model="newSigner"
              type="text"
              placeholder="Signer address"
              class="flex-1 py-2 px-4 focus:outline-none focus:border-gray-100 rounded"
            >
            <button 
              class="py-2 px-4 rounded shadow" 
              @click="addSigner">
              Add signer
            </button>
          </div>
        </div>
        <button
          class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
          @click="loadContract()"
        >
          Add document
        </button>
        documentPath: {{ documentPath }}
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
      ipfsNode: "",
    };
  },
  async created() {
    this.ipfsNode = await window.Ipfs.create();
  },
  async onBeforeUnmount() {
    alert("Unmounting")
    await this.ipfsNode.stop();
  },
  methods: {
    async addToIPFS(formData) {
      const { cid } = await this.ipfsNode.add(formData);
      this.documentPath = cid;
    },
    handleUpload(fieldName, fileList) {
      if (!fileList.length) return;
      const fileDetails = {
        path: fileList[0].name,
        content: fileList[0]
      }
      this.addToIPFS(fileDetails);
    },
    addSigner() {
      if (!this.newSigner) return alert("Signer address is required");
      this.signers.unshift(this.newSigner);
      this.newSigner = "";
    },
    loadContract() {
      let self = this;
      if (!self.documentPath) return alert("Document is required");
      if (self.signers.length == 0)
        return alert("Atleast one signer is required");
      let documentPath = self.documentPath.toString();
      self.$store.getters.getContract.methods
        .addDocument(documentPath, self.signers)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Receipted", res);
        });
    },
  },
};
</script>