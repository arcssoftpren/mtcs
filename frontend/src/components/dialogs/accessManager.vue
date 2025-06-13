<template>
  <v-card :title="'ACCESS MANAGER'" rounded="xl">
    <template v-slot:append>
      <v-btn @click="closeDialog" flat icon>
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-row>
        <v-col cols="6">
          <v-select
            hide-details=""
            v-model="data.division"
            item-title="divName"
            class="ma-2"
            item-value="divId"
            :items="data.divisions"
            label="Select Division"
            variant="outlined"
            rounded="pill"
            density="compact"
          ></v-select>
        </v-col>
        <v-col cols="6">
          <v-select
            hide-details=""
            v-model="data.role"
            item-title="roleName"
            class="ma-2"
            item-value="roleId"
            :items="data.roles"
            label="Select Role"
            variant="outlined"
            rounded="pill"
            density="compact"
          ></v-select>
        </v-col>
      </v-row>
      <v-divider class="my-2"></v-divider>
      <v-card v-if="show">
        <v-card-text>
          <v-divider class="my-2">Features</v-divider>
          <v-row>
            <v-col
              cols="6"
              v-for="(feature, index) in features"
              v-bind:key="index"
            >
              <v-checkbox
                hide-details=""
                @change="changeRights"
                v-model="accessRights"
                :label="feature.name"
                :value="feature.path"
              ></v-checkbox>
            </v-col>
          </v-row>

          <v-divider class="my-2">Configs</v-divider>
          <v-row>
            <v-col
              cols="6"
              v-for="(feature, index) in useAppStore().configs"
              v-bind:key="index"
            >
              <v-checkbox
                hide-details=""
                @change="changeRights"
                v-model="configRights"
                :label="feature.label"
                :value="feature.key"
              ></v-checkbox>
            </v-col>
          </v-row>
          <v-divider class="my-2">Setup</v-divider>
          <v-row>
            <v-col
              cols="6"
              v-for="(feature, index) in useAppStore().setups"
              v-bind:key="index"
            >
              <v-checkbox
                hide-details=""
                @change="changeRights"
                v-model="setupRights"
                :label="feature.label"
                :value="feature.key"
              ></v-checkbox>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>
    </v-card-text>
  </v-card>
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import { onBeforeMount, onBeforeUnmount, reactive, ref, watch } from "vue";

const show = ref(false);
const routers = router.getRoutes();
const home = routers.find((m) => m.path == "/home");
const features = home.children.filter((m) => m.name != null);

const store = useAppStore();
const selectValid = ref(false);
const data = reactive({
  roles: [],
  divisions: [],
  role: "",
  division: "",
});

const accessRights = ref([]);
const configRights = ref([]);
const setupRights = ref([]);

defineProps(["closeDialog"]);

const getAccess = async () => {
  const response = await store.ajax(
    {
      code: `${data.division}-${data.role}`,
    },
    "auth/getaccess",
    "post"
  );

  accessRights.value = response.access;
  setupRights.value = response.setups;
  configRights.value = response.configs;

  show.value = true;
};

const refresh = async () => {
  try {
    data.divisions = await store.ajax({}, "auth/getdivisions", "post");
    data.roles = await store.ajax({}, "auth/getroles", "post");
  } catch (error) {
    console.log(error);
  }
};

const changeRights = async () => {
  const reqData = {
    code: `${data.division}-${data.role}`,
    rights: accessRights.value,
    configs: configRights.value,
    setups: setupRights.value,
  };

  await store.ajax(reqData, "auth/setaccess", "post");
};

watch(data, (e) => {
  selectValid.value = e.role != "" && e.division != "";
  if (selectValid.value) {
    getAccess();
  }
});

onBeforeMount(() => {
  refresh();
});
</script>
