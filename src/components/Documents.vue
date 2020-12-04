<template>
  <div class="documents flex p-6">
    <form 
      class="flex-1 flex flex-col p-4 space-y-2 bg-white rounded shadow" 
      @submit.prevent="goToContract">
      <input 
        v-model="contractAddr" 
        type="text" 
        placeholder="Find document by contract address e.g 0xf81996eb82cf337b31abbd16fdb283e1cbc360f3" 
        class="flex-1 py-2 px-4 focus:outline-none border border-gray-100 rounded">
      <button 
        class="x-4 py-2 bg-indigo-600 text-indigo-100 font-semibold uppercase rounded shadow focus:outline-none" 
        type="submit">Open Document</button>
    </form>
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