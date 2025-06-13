<template>
  <v-list nav>
    <v-list-item
      v-show="useAppStore().cc.includes(item.key)"
      v-for="item in configs"
      :key="item.key"
      :title="item.label"
      :subtitle="item.subtitle"
      :active="config == item.key"
      @click="configOpen(item.key)"
    >
      <template v-slot:prepend>
        <v-icon size="30">{{ item.icon }}</v-icon>
      </template>
    </v-list-item>
    <v-list-item>
      <v-divider><v-icon>mdi-cogs</v-icon> SETUPS</v-divider>
    </v-list-item>

    <v-list-item
      v-show="useAppStore().ss.includes(item.key)"
      v-for="item in setups"
      :key="item.key"
      :title="item.label"
      :subtitle="item.subtitle"
      :active="config == item.key"
      @click="configOpen(item.key)"
    >
      <template v-slot:prepend>
        <v-icon size="30">{{ item.icon }}</v-icon>
      </template>
    </v-list-item>
  </v-list>
  <v-dialog
    v-model="configDialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <RoleManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'roleManager'"
    />
    <UserManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'accountManager'"
    />

    <RankManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'rankManager'"
    />
    <TypeManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'typeManager'"
    />
    <ToolsManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'toolManager'"
    ></ToolsManager>
    <DivisionManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'divisionManager'"
    ></DivisionManager>
    <AccessManager
      :close-dialog="
        () => {
          configDialog = false;
        }
      "
      v-if="config == 'accessManager'"
    ></AccessManager>
  </v-dialog>
</template>
<script setup>
import { ref } from "vue";
import RoleManager from "../dialogs/roleManager.vue";
import UserManager from "../dialogs/userManager.vue";
import RankManager from "../dialogs/rankManager.vue";
import TypeManager from "../dialogs/typeManager.vue";
import ToolsManager from "../dialogs/toolsManager.vue";
import DivisionManager from "../dialogs/divisionManager.vue";
import AccessManager from "../dialogs/accessManager.vue";
import { useAppStore } from "@/store/app";

const configDialog = ref(false);
const config = ref(null);
const configs = useAppStore().configs;
const setups = useAppStore().setups;

const configOpen = (key) => {
  config.value = key;
  configDialog.value = true;
};
</script>
