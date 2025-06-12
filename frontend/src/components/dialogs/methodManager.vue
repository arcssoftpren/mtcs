<template>
  <v-card
    :title="`${pointMethods.pointString}'s Check Methods`"
    rounded="xl"
    subtitle="Manage check methods in the point check"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-function-variant</v-icon>
    </template>
    <template v-slot:append>
      <v-btn flat icon color="transparent" @click="closeDialog">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-data-table :headers="headers" :items="methods">
        <template v-slot:top>
          <v-row>
            <v-col cols="3" offset="9">
              <v-btn
                @click="openDialog('addMethod')"
                prepend-icon="mdi-plus"
                variant="outlined"
                rounded="pill"
                block
                color="primary"
                dark
                >Add Check Method</v-btn
              >
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.methodId="{ item }">
          <v-btn
            flat
            icon
            color="transparent"
            @click="openDialog('editMethod', item)"
          >
            <v-icon color="primary">mdi-pencil</v-icon>
          </v-btn>
          <v-btn
            @click="openDialog('deleteMethod', item)"
            flat
            icon
            color="transparent"
          >
            <v-icon color="error">mdi-delete</v-icon>
          </v-btn>
        </template>
      </v-data-table>
    </v-card-text>
  </v-card>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    max-width="500px"
    :overlay="false"
    transition="dialog-transition"
  >
    <AddMethod
      v-if="buttonAction == 'addMethod'"
      :close-dialog="closeMyDialog"
      :point="pointCheckId"
    ></AddMethod>

    <EditMethod
      v-if="buttonAction == 'editMethod'"
      :close-dialog="closeMyDialog"
      :method="selectedItem"
    ></EditMethod>

    <v-card
      rounded="xl"
      v-if="buttonAction == 'deleteMethod'"
      :title="`You are going to delete ${selectedItem.methodString}.`"
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
              @click="deleteMethod"
              >Delete</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { nextTick, onBeforeMount, ref } from "vue";
import AddMethod from "../forms/addMethod.vue";
import EditMethod from "../forms/editMethod.vue";
EditMethod;

const props = defineProps(["pointMethods", "closeDialog"]);
const pointCheckId = props.pointMethods.checkId;
const methods = ref([]);
const store = useAppStore();
const buttonAction = ref(null);
const selectedItem = ref(null);
const dialog = ref(false);

const refrehMethods = async () => {
  methods.value = await store.ajax(
    { pointCheckId },
    "point/getmethods",
    "post"
  );
  store.preload = false;
};

const headers = [
  {
    key: "methodString",
    title: "Check Method",
    align: "start",
  },
  {
    key: "typeLabel",
    title: "Result Type",
    align: "start",
  },
  {
    key: "methodId",
    title: "Actions",
    align: "center",
    sortable: false,
  },
];

const openDialog = async (action, item) => {
  console.log(item);
  if (item != undefined) {
    selectedItem.value = item;
  }
  buttonAction.value = action;
  await nextTick();
  dialog.value = true;
};
const closeMyDialog = () => {
  refrehMethods();
  dialog.value = false;
};

const deleteMethod = async () => {
  await store.ajax(
    { methodId: selectedItem.value.methodId },
    "point/deletemethod",
    "post"
  );
  store.alert.fire({
    title: "Method Deleted",
    text: "Method deleted successfully!",
    icon: "success",
    timer: 3000,
  });
  closeMyDialog();
};

onBeforeMount(() => {
  store.preload = true;
  refrehMethods();
});
</script>
