<template>
  <div 
    id="app" 
    class="flex bg-gray-100">
    <div class="w-56 bg-white h-screen fixed">
      <side-bar />
    </div>
    <div class="flex-1 ml-56 min-h-screen">
      <router-view v-if="$store.getters.getContract" />
    </div>
  </div>
</template>

<script>
import contractJson from "./../build/contracts/DecentraDocuSign.json";
import Web3 from "web3";
import SideBar from "./components/SideBar.vue";
export default {
  name: "App",
  components: { SideBar },
  created() {
    var self = this;
    init().then(() => console.log("Loaded"));
    async function init() {
      window.addEventListener("load", async () => {
        if (window.web3) {
          window.web3 = new Web3(window.web3.currentProvider);
          console.log(window.ethereum);
          await window.web3.eth.requestAccounts();
        } else {
          window.web3 = new Web3(
            window.web3.givenProvider ||
              new Web3.providers.HttpProvider("http://localhost:8545")
          );
        }

        self.getAccounts(window.web3).then(function (accounts) {
          console.log("addr", accounts);
          var myContract = new window.web3.eth.Contract(
            contractJson.abi,
            "0x6e64d4907ef54a09d95e903c089bc2f1628c237b",
            {
              from: accounts[0],
              gasPrice: 20000000000,
              gasLimit: 210000,
            }
          );
          self.$store.commit("setAccount", accounts[0]);
          self.$store.commit("setContract", myContract);
        });
      });
    }
  },
  methods: {
    async getAccounts(web3) {
      return await web3.eth.getAccounts();
    },
  },
};
</script>
