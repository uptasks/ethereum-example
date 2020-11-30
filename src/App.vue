<template>
  <div 
    id="app" 
    class="flex bg-gray-100">
    <div class="w-56 bg-white h-screen fixed">
      <side-bar />
    </div>
    <div class="flex-1 ml-56 min-h-screen">
      <router-view />
    </div>
  </div>
</template>

<script>
import Web3 from "web3";
import SideBar from "./components/SideBar.vue";
export default {
  name: "App",
  components: { SideBar },
  created() {
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
      });
    }
  },
};
</script>
