<template>
  <v-card :title="'TOOLS MANAGER'" rounded="xl">
    <template v-slot:append>
      <v-btn @click="closeDialog" flat icon>
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-data-table
        hover=""
        class="text-uppercase"
        :search="Search"
        :items="tools"
        :headers="headers"
      >
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search Tools"
                prepend-inner-icon="mdi-magnify"
                hide-details=""
                density="compact"
                v-model="Search"
              />
            </v-col>
            <v-col cols="2">
              <v-btn
                variant="outlined"
                rounded="pill"
                class="fill-height"
                block
                dark
                prepend-icon="mdi-plus"
                @click="openDialog('addTool', null)"
              >
                ADD TOOL
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.toolId="{ item }">
          <div>
            <v-btn
              @click="openDialog('managePoints', item)"
              variant="outlined"
              rounded="pill"
              prepend-icon="mdi-information-outline"
            >
              Manage Point Check
            </v-btn>
          </div>
        </template>

        <template v-slot:item.init="{ item }">
          <div>
            <v-btn
              @click="openDialog('manageData', item)"
              variant="outlined"
              rounded="pill"
              prepend-icon="mdi-information-outline"
            >
              Manage Tool Data
            </v-btn>
          </div>
        </template>

        <template v-slot:item.actions="{ item }">
          <div>
            <v-btn
              @click="openDialog('editTool', item)"
              flat
              icon
              color="transparent"
            >
              <v-icon color="primary">mdi-pencil</v-icon>
            </v-btn>

            <v-btn
              flat
              icon
              color="transparent"
              @click="openDialog('deleteTool', item)"
            >
              <v-icon color="error">mdi-delete</v-icon>
            </v-btn>
          </div>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <AddTool :close-dialog="closeMyDialog" v-if="selectedDialog == 'addTool'" />
    <EditTool
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editTool'"
      :tool="selectedItem"
    ></EditTool>
    <v-card
      subtitle="Manage Point Checks in the tool types"
      :title="`${selectedItem.toolName}'s Points Detail`"
      rounded="xl"
      v-if="selectedDialog == 'managePoints'"
    >
      <template v-slot:prepend>
        <v-icon size="50">mdi-checkbox-outline</v-icon>
      </template>

      <template v-slot:append>
        <v-btn flat icon color="transparent" @click="closeMyDialog">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
      <v-card-text>
        <PointManager :tool="selectedItem"></PointManager>
      </v-card-text>
    </v-card>

    <v-card
      subtitle="Manage tool's Data"
      :title="`${selectedItem.toolName}'s Detail`"
      rounded="xl"
      v-if="selectedDialog == 'manageData'"
    >
      <template v-slot:prepend>
        <v-icon size="50">mdi-checkbox-outline</v-icon>
      </template>

      <template v-slot:append>
        <v-btn flat icon color="transparent" @click="closeMyDialog">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
      <v-card-text>
        <DataManager :tool="selectedItem"></DataManager>
      </v-card-text>
    </v-card>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteTool'"
      :title="`You are going to delete ${selectedItem.toolName.toUpperCase()}.`"
      subtitle="Please confirm your action."
    >
      <template v-slot:prepend>
        <v-icon size="50" color="warning">mdi-help</v-icon>
      </template>
      <v-card-text>
        <v-divider class="mb-3"></v-divider>
        <v-row>
          <v-col cols="6">
            <v-btn
              block
              variant="outlined"
              rounded="pill"
              prepend-icon="mdi-arrow-u-left-bottom"
              @click="closeMyDialog"
              >cancel</v-btn
            >
          </v-col>
          <v-col cols="6">
            <v-btn
              block
              variant="outlined"
              rounded="pill"
              color="error"
              prepend-icon="mdi-delete"
              @click="deleteTool"
              >Delete</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import { nextTick, onBeforeMount, onMounted, ref } from "vue";
import { useAppStore } from "@/store/app";
import AddTool from "../forms/addTool.vue";
import EditTool from "../forms/editTool.vue";
import PointManager from "./pointManager.vue";
import DataManager from "./dataManager.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const tools = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "Tool Name",
    key: "toolName",
    align: "start",
  },
  {
    title: "Rank",
    key: "rankName",
    align: "start",
  },
  {
    title: "Type",
    key: "typeName",
    align: "start",
  },
  {
    title: "Point Check",
    key: "toolId",
    align: "center",
    sortable: false,
  },
  {
    title: "Initial Data",
    key: "init",
    align: "center",
    sortable: false,
  },
  {
    title: "Actions",
    key: "actions",
    align: "center",
    sortable: false,
  },
];

defineProps(["closeDialog"]);

const openDialog = async (key, item) => {
  selectedItem.value = item;
  selectedDialog.value = key;
  await nextTick();
  dialog.value = true;
};

const closeMyDialog = () => {
  dialog.value = false;
  refreshUsers();
};

const refreshUsers = async () => {
  tools.value = await store.ajax({}, "tool", "post");
  tools.value.forEach((tool, index) => {
    tools.value[index].actions = tool.userId;
    tools.value[index].init = tool.userId;
  });

  store.preload = false;
};

const deleteTool = async () => {
  try {
    selectedItem.value.file = "";
    await store.ajax(selectedItem.value, "tool/delete", "post");
    alert.fire({
      title: "Tool deleted",
      text: "Tool deleted successfully",
      icon: "success",
      timer: 3000,
    });
    closeMyDialog();
  } catch (error) {
    console.error(error);
    alert.fire(error);
  }
};

onBeforeMount(() => {
  store.preload = true;
}),
  onMounted(() => {
    refreshUsers();
  });
</script>
