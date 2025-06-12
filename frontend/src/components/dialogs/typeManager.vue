<template>
  <v-card :title="'TOOL TYPES MANAGER'" rounded="xl">
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
        :items="types"
        :headers="headers"
      >
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search Types"
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
                @click="openDialog('addType', null)"
              >
                ADD TYPE
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.typeId="{ item }">
          <v-btn
            @click="openDialog('editType', item)"
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
            @click="openDialog('deleteType', item)"
          >
            <v-icon color="error">mdi-delete</v-icon>
          </v-btn>
        </template>
        <template v-slot:item.points="{ item }">
          <v-btn
            variant="outlined"
            prepend-icon="mdi-information-outline"
            rounded="pill"
            @click="openDialog('managePoints', item)"
          >
            detail
          </v-btn>
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
    <v-card
      subtitle="Manage Point Checks in the tool types"
      :title="`${selectedItem.typeName}'s Points Detail '`"
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
        <PointManager :type-options="selectedItem"></PointManager>
      </v-card-text>
    </v-card>
    <AddType :close-dialog="closeMyDialog" v-if="selectedDialog == 'addType'" />
    <EditType
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editType'"
    >
    </EditType>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteType'"
      :title="`You are going to delete ${selectedItem.typeName.toUpperCase()}.`"
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
              @click="deleteType"
              >Delete</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import { onBeforeMount, onMounted, ref } from "vue";
import { useAppStore } from "@/store/app";
import AddType from "../forms/addType.vue";
import EditType from "../forms/editType.vue";
import PointManager from "./pointManager.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const types = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "Type Name",
    key: "typeName",
    align: "start",
  },
  {
    title: "Actions",
    key: "typeId",
    align: "center",
    sortable: false,
  },
];

defineProps(["closeDialog"]);

const openDialog = (key, item) => {
  selectedItem.value = item;
  selectedDialog.value = key;
  dialog.value = true;
};

const closeMyDialog = () => {
  dialog.value = false;
  refreshType();
};

const refreshType = async () => {
  types.value = await store.ajax({}, "type", "post");
  store.preload = false;
};

const deleteType = async () => {
  try {
    await store.ajax(selectedItem.value, "type/deletetype", "post");
    alert.fire({
      title: "Type deleted",
      text: "Type deleted successfully",
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
});

onMounted(() => {
  refreshType();
});
</script>
