<template>
  <!-- Wrapper untuk gambar agar tetap sticky -->
  <div class="sticky-container">
    <v-toolbar color="transparent">
      <template v-slot:append>
        <v-btn
          @click="openDialog('addPoint')"
          prepend-icon="mdi-plus"
          variant="outlined"
          rounded="pill"
          block
          color="primary"
          dark
        >
          Add Point Check
        </v-btn>
      </template>
    </v-toolbar>
    <div class="sticky-image">
      <v-img height="300" :src="dataUrl"></v-img>
    </div>
    <v-divider class="my-5"></v-divider>
  </div>
  <v-data-table :headers="headers" :items="options">
    <template v-slot:item.pointString="{ item }">
      <div class="text-no-wrap">
        {{ item.pointString }}
      </div>
    </template>
    <template v-slot:item.methods="{ item }">
      <div class="text-no-wrap">
        <v-btn
          :color="item.methods.length < 1 ? 'error' : 'success'"
          @click="openDialog('manageMethods', item)"
          rounded="pill"
          density="compact"
          prepend-icon="mdi-information-outline"
        >
          Check Methods ({{ item.methods.length }} methods)
        </v-btn>
      </div>
    </template>
    <template v-slot:item.pointNumber="{ item }">
      <div
        class="d-flex justify-center text-center w-100"
        v-if="item.pointNumber != 0"
      >
        <div
          style="
            border-radius: 50%;
            border: 1px solid black;
            width: 25px;
            height: 25px;
          "
        >
          {{ item.pointNumber }}
        </div>
      </div>
    </template>
    <template v-slot:item.checkId="{ item }">
      <v-btn
        flat
        icon
        color="transparent"
        @click="openDialog('editPoint', item)"
      >
        <v-icon color="primary">mdi-pencil</v-icon>
      </v-btn>
      <v-btn
        @click="openDialog('deletePoint', item)"
        flat
        icon
        color="transparent"
      >
        <v-icon color="error">mdi-delete</v-icon>
      </v-btn>
    </template>
  </v-data-table>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <AddPoint
      :tool="props.tool"
      :closeDialog="closeDialog"
      v-if="buttonAction == 'addPoint'"
    />
    <EditPoint
      v-if="buttonAction == 'editPoint'"
      :point="selectedItem"
      :close-dialog="closeDialog"
    />
    <v-card
      rounded="xl"
      v-if="buttonAction == 'deletePoint'"
      :title="`You are going to delete ${selectedItem.pointString}.`"
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
              @click="closeDialog"
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
              @click="deletePoint"
              >Delete</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
    <MethodManager
      v-if="buttonAction == 'manageMethods'"
      :point-methods="selectedItem"
      :close-dialog="closeDialog"
    />
  </v-dialog>
</template>
<script setup>
import { nextTick, onBeforeMount, ref } from "vue";
import AddPoint from "../forms/addPoint.vue";

import { useAppStore } from "@/store/app";
import EditPoint from "../forms/editPoint.vue";
import MethodManager from "./methodManager.vue";

const props = defineProps(["tool"]);
const buttonAction = ref(null);
const selectedItem = ref(null);
const dialog = ref(false);
const store = useAppStore();
const toolId = props.tool.toolId;
const options = ref([]);
const headers = [
  {
    key: "pointNumber",
    title: "Point Number",
    align: "center",
  },
  {
    key: "pointString",
    title: "Point Check",
    align: "start",
  },
  {
    key: "methods",
    title: "Open Methods",
    align: "center",
    sortable: false,
  },
  {
    key: "checkId",
    title: "Actions",
    align: "center",
    sortable: false,
  },
];

store.cachedImage = props.tool.file;

const dataUrl = ref(store.cachedImage);

const refreshoptions = async () => {
  options.value = await store.ajax({ toolId }, "type/getpoints", "post");
  store.preload = false;
};

const openDialog = async (action, item) => {
  console.log(item);
  if (item != undefined) {
    selectedItem.value = item;
  }
  buttonAction.value = action;
  await nextTick();
  dialog.value = true;
};

const closeDialog = () => {
  refreshoptions();
  dialog.value = false;
};

const deletePoint = async () => {
  await store.ajax(
    { checkId: selectedItem.value.checkId },
    "point/deletePoint",
    "post"
  );
  store.alert.fire({
    title: "Point Deleted",
    text: "Point deleted successfully!",
    icon: "success",
    timer: 3000,
  });
  closeDialog();
};

onBeforeMount(() => {
  store.preload = true;
  refreshoptions();
});
</script>
<style scoped>
/* Wrapper untuk gambar agar tetap sticky */
.sticky-container {
  position: sticky;
  top: 0;
  z-index: 10; /* Pastikan gambar tetap di atas */
  background: white; /* Supaya tidak transparan saat sticky */
  padding: 10px 0;
}

/* Styling untuk gambar */
.sticky-image {
  width: 100%;
  display: flex;
  justify-content: center;
}

/* Table harus bisa di-scroll di belakang */
.table-content {
  position: relative;
  z-index: 1;
}

/* Styling untuk elemen bulat */
.circle {
  border-radius: 50%;
  border: 1px solid black;
  width: 25px;
  height: 25px;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
