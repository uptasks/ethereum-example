<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
import Web3 from "web3";
import contractJson from "./../build/contracts/EWarranty.json";
export default {
  name: "App",
  created() {
    init().then(() => console.log("Loaded"));
    async function init() {
      window.addEventListener("load", async () => {
        let web3 = {};
        if (window.web3) {
          window.web3 = new Web3(window.web3.currentProvider);
          console.log(window.ethereum);
          await window.web3.eth.requestAccounts();
          web3 = window.web3;
        } else {
          web3 = new Web3(
            web3.givenProvider ||
              new Web3.providers.HttpProvider("http://localhost:8545")
          );
        }
        async function getAccounts(web3) {
          return await web3.eth.getAccounts();
        }

        getAccounts(web3).then(function (accounts) {
          console.log("addr", accounts);
          var myContract = new web3.eth.Contract(
            contractJson.abi,
            "0x254dffcd3277C0b1660F6d42EFbB754edaBAbC2B",
            {
              from: accounts[0],
              // from: "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1", // default from address
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
      });
    }
  },
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
