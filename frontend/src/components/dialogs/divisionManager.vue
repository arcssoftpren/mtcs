<template>
  <v-card :title="'DEPARTMENTS MANAGER'" rounded="xl">
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
        :items="divisions"
        :headers="headers"
      >
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search Divisions"
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
                @click="openDialog('addDivision', null)"
              >
                ADD department
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.divId="{ item }">
          <div v-if="item.divName != 'it developer'">
            <v-btn
              @click="openDialog('editDivision', item)"
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
              @click="openDialog('deleteDivision', item)"
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
    max-width="700px"
    transition="dialog-transition"
  >
    <AddDivision
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'addDivision'"
    />
    <EditDivision
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editDivision'"
    >
    </EditDivision>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteDivision'"
      :title="`You are going to delete ${selectedItem.divName.toUpperCase()}.`"
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
              @click="deleteDivision"
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
import AddDivision from "../forms/addDivision.vue";
import EditDivision from "../forms/editDivision.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const divisions = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "Division Name",
    key: "divName",
    align: "start",
  },
  {
    title: "Actions",
    key: "divId",
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
  refresh();
};

const refresh = async () => {
  divisions.value = await store.ajax({}, "auth/getdivisions", "post");
  store.preload = false;
};

const deleteDivision = async () => {
  try {
    const name = selectedItem.value.divName;
    if (name.toLowerCase() == "it developer") {
      throw {
        title: "Rejected",
        text: "IT Development department can not be deleted!",
        icon: "error",
        timer: 3000,
      };
    }

    await store.ajax(selectedItem.value, "auth/deletediv", "post");
    alert.fire({
      title: "Division deleted",
      text: "Division deleted successfully",
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
  refresh();
});
</script>
