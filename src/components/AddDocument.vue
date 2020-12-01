<template>
  <div class="services">
    <div 
      v-for="(contract, $index) in contracts" 
      :key="$index" 
      class="flex">
      <div class="flex-1">{{ contract.name }}</div>
      <div class="flex-1">
        <button @click="loadContract()">Start contract</button>
        <button @click="approveDocument()">Sign</button>
      </div>
    </div>
    <li 
      v-for="(doc, index) in documents" 
      :key="index">
      {{ doc }}
    </li>
  </div>
</template>

<script>
export default {
  name: "AddDocument",
  data() {
    return {
      contracts: [{ name: "DocuSign" }],
      documents: [],
    };
  },
  methods: {
    async loadContract() {
      let self = this;
      self.$store.getters.getContract.methods
        .addDocument("QmR1gdpqEKp4K7uRBnopfwgBJ99XgNg1SDH2q3dLQDMt2U", [
          "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1",
          "0x22d491Bde2303f2f43325b2108D26f1eAbA1e32b",
        ])
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Receipted", res);
        });
    },
    approveDocument() {
      let self = this;
      self.$store.getters.getContract.methods
        .approve(0)
        .send({ from: self.$store.getters.getAccount })
        .on("receipt", function (res) {
          console.log("Signed", res);
        });
    },
  },
};
</script>