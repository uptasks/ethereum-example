<template>
  <div class="side-bar">
    <div class="text-center py-4 font-semibold">DocuSign</div>
    <ul class="my-4">
      <li 
        v-for="(menu, $index) in menus" 
        :key="$index">
        <router-link
          :to="{name: menu.link}"
          class="px-4 py-2 block text-gray-600 font-semibold hover:bg-gray-100"
        >{{ menu.title }}</router-link
        >
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: "SideBar",
  data() {
    return {
      menus: [
        { title: "Add Document", link: "AddDocument" },
        { title: "Documents", link: "Documents" },
        { title: "Signed", link: "Signed" },
        { title: "Network", link: "Network" },
      ],
    };
  },
};
</script>