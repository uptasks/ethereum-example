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
        <div class="my-2">
          We've added a fee of 0.0001Eth which is equivalent to $0.51 USD, as service
          fee for us to continue maintaining this platform.
        </div>
        <button
          class="px-4 py-2 bg-indigo-600 text-indigo-100 rounded shadow focus:outline-none"
          @click="addDocumentAction()"
        >
          Add document
        </button>
        documentPath: {{ documentPath }}
      </div>
    </div>
  </div>
</template>

<script>
import contractJson from "./../../build/contracts/DecentraDocuSign.json";
export default {
  name: "AddDocument",
  data() {
    return {
      documentPath: "",
      signers: [],
      newSigner: "",
      ipfsNode: "",
      contract: "",
    };
  },
  async created() {
    this.ipfsNode = await window.Ipfs.create();
  },
  async onBeforeUnmount() {
    alert("Unmounting");
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
        content: fileList[0],
      };
      this.addToIPFS(fileDetails);
    },
    addSigner() {
      if (!this.newSigner) return alert("Signer address is required");
      this.signers.unshift(this.newSigner);
      this.newSigner = "";
    },
    addDocumentAction() {
      let self = this;
      if (!self.documentPath) return alert("Document is required");
      if (self.signers.length == 0)
        return alert("Atleast one signer is required");

      let documentPath = self.documentPath.toString();
      const myContract = new window.web3.eth.Contract(contractJson.abi);
      myContract
        .deploy({
          data: contractJson.bytecode,
          arguments: [documentPath, self.signers],
        })
        .send(
          {
            value: 1000000000000000,
            from: self.$store.getters.getAccount,
            gas: 4700000,
          },
          (err, res) => {
            if (err) {
              console.err(err);
            }
            if (res) {
              window.open("https://goerli.etherscan.io/tx/" + res, "_blank");
              window.location.href = "/#/documents/";
            }
          }
        );
    },
  },
};
</script>