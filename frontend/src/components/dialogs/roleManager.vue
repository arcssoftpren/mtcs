<template>
  <v-card :title="'ROLES MANAGER'" rounded="xl">
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
        :items="roles"
        :headers="headers"
      >
        <template v-slot:top>
          <v-row>
            <v-col cols="10">
              <v-text-field
                variant="outlined"
                rounded="pill"
                label="Search Roles"
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
                @click="openDialog('addRole', null)"
              >
                ADD ROLE
              </v-btn>
            </v-col>
          </v-row>
        </template>
        <template v-slot:item.roleId="{ item }">
          <v-btn
            @click="openDialog('editRole', item)"
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
            @click="openDialog('deleteRole', item)"
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
    max-width="700px"
    transition="dialog-transition"
  >
    <AddRole :close-dialog="closeMyDialog" v-if="selectedDialog == 'addRole'" />
    <EditRole
      :selected-item="selectedItem"
      :close-dialog="closeMyDialog"
      v-if="selectedDialog == 'editRole'"
    >
    </EditRole>
    <v-card
      rounded="xl"
      v-if="selectedDialog == 'deleteRole'"
      :title="`You are going to delete ${selectedItem.roleName.toUpperCase()}.`"
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
              @click="deleteRole"
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
import AddRole from "../forms/addRole.vue";
import { useAppStore } from "@/store/app";
import EditRole from "../forms/editRole.vue";

const store = useAppStore();
const alert = store.alert;
const dialog = ref(false);
const selectedDialog = ref(null);
const roles = ref([]);
const Search = ref("");
const selectedItem = ref(null);

const headers = [
  {
    title: "Role Name",
    key: "roleName",
    align: "start",
  },
  {
    title: "Dashboard Page",
    key: "dashboardPage",
    align: "start",
  },

  {
    title: "Actions",
    key: "roleId",
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
  refreshRoles();
};

const refreshRoles = async () => {
  roles.value = await store.ajax({}, "auth/getroles", "post");
  store.preload = false;
};

const deleteRole = async () => {
  try {
    const name = selectedItem.value.roleName;
    if (name.toLowerCase() == "administrator") {
      throw {
        title: "Rejected",
        text: "Administrator role can not be deleted!",
        icon: "error",
        timer: 3000,
      };
    }

    await store.ajax(selectedItem.value, "auth/deleterole", "post");
    alert.fire({
      title: "Roles deleted",
      text: "Role deleted successfully",
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
    refreshRoles();
  });
</script>
