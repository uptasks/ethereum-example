<template>
  <div class="services">
    <div 
      v-for="(contract, $index) in contracts" 
      :key="$index" 
      class="flex">
      <div class="flex-1">{{ contract.name }}</div>
      <div class="flex-1">
        <button @click="loadContract(contract.schema)">Start contract</button>
      </div>
    </div>
  </div>
</template>

<script>
// import Web3 from "web3";
import eWarrantContract from "./../../build/contracts/EWarranty.json";
export default {
  name: "Services",
  data() {
    return {
      contracts: [{ name: "eWarranty", schema: eWarrantContract }],
    };
  },
  methods: {
    async getAccounts(web3) {
      return await web3.eth.getAccounts();
    },
    async loadContract(contractJson) {
      let self = this;
      let web3 = window.web3;
      self.getAccounts(web3).then(function (accounts) {
        console.log("addr", accounts);
        var myContract = new web3.eth.Contract(
          contractJson.abi,
          "0x254dffcd3277C0b1660F6d42EFbB754edaBAbC2B",
          {
            // from: accounts[0],
            from: "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1",
            gasPrice: "200000000000", // default gas price in wei, 20 gwei in this case
          }
        );
        myContract.methods
          .addProduct("12x", "P1", 100)
          .send({ from: accounts[0] })
          .on("receipt", function (res) {
            console.log("Receipted", res);
          });
      });
    },
  },
};
</script>