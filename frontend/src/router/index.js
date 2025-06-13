// Composables
import { useAppStore } from "@/store/app";
import { nextTick } from "vue";
import { createRouter, createWebHistory } from "vue-router";

const routes = [
  {
    path: "/",
    component: () => import("@/layouts/defaultLayout"),
    children: [
      {
        path: "",
        component: () => import("@/views/pages/landingPage.vue"),
      },
      {
        path: "/login",
        component: () => import("@/views/pages/loginPage.vue"),
      },
    ],
  },
  {
    path: "/home",
    component: () => import("@/layouts/mainLayout.vue"),
    children: [
      // {
      //   path: "/home/list",
      //   name: "Tool Control List",
      //   component: () => import("@/views/pages/controlList.vue"),
      // },
      {
        path: "/home/daily",
        name: "Daily Control",
        component: () => import("@/views/features/dailyInspection.vue"),
      },
      {
        path: "/home/weekly",
        name: "Weekly Control",
        component: () => import("@/views/features/weeklyInspection.vue"),
      },
      {
        path: "/home/monthly",
        name: "Monthly Control",
        component: () => import("@/views/features/monthlyInspection.vue"),
      },
      // {
      //   path: "/home/abnormalityReport",
      //   name: "Abnormality Report",
      //   component: () => import("@/views/features/abnormalReport.vue"),
      // },
    ],
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;

router.beforeEach(async (e) => {
  const store = useAppStore();
  const path = e.path;
  const sessionId = store.sessionId;
  store.preload = true;

  if (path == "/" || path == "/login") {
    if (sessionId != "") {
      const home = await store.ajax({ sessionId }, "auth/gethome", "post");
      router.push(home);
      return;
    }
  } else {
    if (sessionId == "") {
      router.push("/login");
      return;
    } else {
      const match = e.matched.length;
      if (match < 1) {
        const home = await store.ajax({ sessionId }, "auth/gethome", "post");
        router.push(home);
        return;
      }

      useAppStore()
        .ajax({ sessionId: useAppStore().sessionId }, "auth/getmydata", "post")
        .then((e) => {
          const accesscode = `${e.divId}-${e.roleId}`;
          useAppStore()
            .ajax({ code: accesscode }, "auth/getaccess", "post")
            .then((e) => {
              useAppStore().features = e.access;
              useAppStore().cc = e.configs;
              useAppStore().ss = e.setups;
              if (!e.access.includes(path)) {
                useAppStore()
                  .ajax({ sessionId }, "auth/gethome", "post")
                  .then((home) => {
                    router.push(home);
                  });
              }
            });
        });
    }
  }
});
router.afterEach(async () => {
  const store = useAppStore();
  await router.isReady();
  await nextTick();
});
