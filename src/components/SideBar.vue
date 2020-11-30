<template>
  <div class="side-bar">
    <div class="text-center py-4 font-semibold">DecentraWS</div>
    <ul class="my-4">
      <li 
        v-for="(menu, $index) in menus" 
        :key="$index">
        <router-link
          to="/"
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
        { title: "Services", link: "Services" },
        { title: "Assigned", link: "Assigned" },
        { title: "In Progress", link: "InProgress" },
        { title: "Completed", link: "Completed" },
        { title: "Users", link: "Users" },
      ],
    };
  },
};
</script>