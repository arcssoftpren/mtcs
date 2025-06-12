<template>
  <v-card :title="'ACCOUNT MANAGER'" rounded="xl">
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
        :items="users"
        :headers="headers"
      >
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search User"
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
                @click="openDialog('addUser', null)"
              >
                ADD USER
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.actions="{ item }">
          <div v-if="item.userId != 'system'">
            <v-btn
              @click="openDialog('editUser', item)"
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
              @click="openDialog('deleteUser', item)"
            >
              <v-icon color="error">mdi-delete</v-icon>
            </v-btn>

            <v-btn
              flat
              icon
              color="transparent"
              @click="openDialog('changePassword', item)"
            >
              <v-icon color="primary">mdi-key</v-icon>
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
    <AddUser :close-dialog="closeMyDialog" v-if="selectedDialog == 'addUser'" />
    <EditUser
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editUser'"
    />
    <ChangePassword
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'changePassword'"
    ></ChangePassword>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteUser'"
      :title="`You are going to delete ${selectedItem.userName.toUpperCase()}.`"
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
              @click="deleteUser"
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
import AddUser from "../forms/addUser.vue";
import EditUser from "../forms/editUser.vue";
import ChangePassword from "../forms/changePassword.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const users = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "User Name",
    key: "userName",
    align: "start",
  },
  {
    title: "NIK",
    key: "userId",
    align: "start",
  },
  {
    title: "Departmenet",
    key: "divName",
    align: "start",
  },
  {
    title: "Role",
    key: "roleName",
    align: "start",
  },

  {
    title: "Actions",
    key: "actions",
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
  refreshUsers();
};

const refreshUsers = async () => {
  users.value = await store.ajax({}, "auth/getusers", "post");
  users.value.forEach((user, index) => {
    users.value[index].actions = user.userId;
  });
  store.preload = false;
};

const deleteUser = async () => {
  try {
    selectedItem.value.signFile = null;
    await store.ajax(selectedItem.value, "auth/deleteuser", "post");
    alert.fire({
      title: "User deleted",
      text: "User deleted successfully",
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
