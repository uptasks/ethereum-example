<template>
  <div class="side-bar">
    <div class="text-center py-4 font-semibold">DocuSign</div>
    <ul class="my-4">
      <li 
        v-for="(menu, $index) in menus" 
        :key="$index">
        <router-link
          v-if="menu.linkType == 'internal'"
          :to="{ name: menu.link }"
          class="px-4 py-2 block text-gray-600 font-semibold hover:bg-gray-100"
        >{{ menu.title }}</router-link
        >
        <a
          v-if="menu.linkType == 'external'"
          :href="menu.link"
          class="px-4 py-2 block text-gray-600 font-semibold hover:bg-gray-100"
          target="_blank"
        >{{ menu.title }}</a
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
        { title: "Add Document", linkType: "internal", link: "AddDocument" },
        { title: "Documents", linkType: "internal", link: "Documents" },
        // { title: "Signed", linkType: "internal", link: "Signed" },
        {
          title: "Network",
          linkType: "external",
          link:
            "https://goerli.etherscan.io/address/0x20eb4c017f58481abe833f6ad2f732a3e1d6a085",
        },
      ],
    };
  },
};
</script>