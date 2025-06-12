<template>
  <v-list nav>
    <v-list-item
      v-for="item in menus"
      :key="item.path"
      :title="item.name"
      :active="getActivePath(item.path)"
      @click="router.push(item.path)"
      density="compact"
    >
    </v-list-item>
  </v-list>
</template>
<script setup>
import router from "@/router";

const path = router.currentRoute;
const getActivePath = (p) => {
  return path.value.path == p;
};

const routers = router.getRoutes();
const home = routers.find((m) => m.path == "/home");
const menus = home.children.filter((m) => m.name != null);
console.log(home);
// const menus = [
//   {
//     label: "Inpection Tool Control",
//     subtitle: "Inspection tool control list",
//     icon: "mdi-view-list",
//     key: "/home/dashboard",
//   },
//   {
//     label: "Daily inspection",
//     subtitle: "Daily tool control",
//     icon: "mdi-view-day",
//     key: "/home/daily",
//   },
//   {
//     label: "Weekly inspection",
//     subtitle: "Weekly tool control",
//     icon: "mdi-view-week",
//     key: "/home/weekly",
//   },
//   {
//     label: "Monthly inspection",
//     subtitle: "Monthly tool control",
//     icon: "mdi-calendar",
//     key: "/home/monthly",
//   },
// ];
</script>
