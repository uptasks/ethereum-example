<template>
  <div class="documents flex p-6">
    <div class="flex-1 flex py-4 space-y-4 bg-white rounded shadow">
      <input 
        v-model="contractAddr" 
        type="text" 
        placeholder="Find document by contract address">
      <button @click="goToContract">Open Document</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "Documents",
  data() {
    return {
      contractAddr: ""
    };
  },
  created() {
  },
  methods: {
    goToContract() {
      if (!this.contractAddr) return alert("Contract address is required")
      window.location.href = '/#/document/'+this.contractAddr
    }
  },
};
</script>