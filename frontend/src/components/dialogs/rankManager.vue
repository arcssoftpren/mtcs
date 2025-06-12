<template>
  <v-card :title="'RANK MANAGER'" rounded="xl">
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
        :items="ranks"
        :headers="headers"
      >
        <template v-slot:item.rankName="{ item }">
          {{ item.rankName }} || {{ item.rankNameJp }}
        </template>
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search Rank"
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
                @click="openDialog('addRank', null)"
              >
                ADD RANK
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.rankId="{ item }">
          <v-btn
            @click="openDialog('editRank', item)"
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
            @click="openDialog('deleteRank', item)"
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
    :overlay="false"
    max-width=""
    transition="dialog-transition"
  >
    <AddRank :close-dialog="closeMyDialog" v-if="selectedDialog == 'addRank'" />
    <EditRank
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editRank'"
    >
    </EditRank>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteRank'"
      :title="`You are going to delete ${selectedItem.rankName.toUpperCase()}.`"
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
              @click="deleteRank"
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
import AddRank from "../forms/addRank.vue";
import EditRank from "../forms/editRank.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const ranks = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "Rank Name",
    key: "rankName",
    align: "start",
  },
  {
    title: "Description",
    key: "description",
    align: "start",
  },

  {
    title: "Actions",
    key: "rankId",
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
  refreshRank();
};

const refreshRank = async () => {
  ranks.value = await store.ajax({}, "ranks", "post");
  store.preload = false;
};

const deleteRank = async () => {
  try {
    await store.ajax(selectedItem.value, "ranks/deleterank", "post");
    alert.fire({
      title: "Rank deleted",
      text: "Rank deleted successfully",
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
    refreshRank();
  });
</script>
