<template>
  <div class="documents flex p-6">
    <div class="flex-1 flex py-4 space-y-4 bg-white rounded shadow">
      <input 
        type="text" 
        placeholder="Find document by contract address">
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
  },
};
</script>