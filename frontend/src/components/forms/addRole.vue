<template>
  <v-card
    title="Add New Role"
    rounded="xl"
    subtitle="Please provide your role informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-shield-account</v-icon>
    </template>
    <template v-slot:append>
      <v-btn @click="closeDialog" flat icon>
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-divider class="mb-3"></v-divider>
      <v-text-field
        variant="outlined"
        rounded="pill"
        label="Role Name"
        v-model="formData.roleName"
        hint="Please insert a role name."
        class="mb-3"
        :error-messages="validator.roleName.$errors.map((e) => e.$message)"
      />
      <v-select
        prepend-inner-icon="mdi-monitor-dashboard"
        label="Select Dashboard"
        variant="outlined"
        rounded="pill"
        :items="dashboardPages"
        item-title="name"
        item-value="path"
        v-model="formData.dashboardPage"
        :error-messages="validator.dashboardPage.$errors.map((e) => e.$message)"
      />
      <v-divider class="mb-3"></v-divider>
      <v-btn
        variant="outlined"
        rounded="pill"
        @click="submit"
        block
        color="primary"
        dark
        >Add</v-btn
      >
    </v-card-text>
  </v-card>
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { reactive } from "vue";

let dashboardPages = router.getRoutes();
const store = useAppStore();
const alert = store.alert;
dashboardPages = dashboardPages.filter((e) => e.name != undefined);
const props = defineProps(["closeDialog"]);
const formData = reactive({
  roleName: "",
  dashboardPage: "",
});
const rules = {
  roleName: {
    required: helpers.withMessage("Role name is required", required),
  },
  dashboardPage: {
    required: helpers.withMessage("Please select a dashboard page", required),
  },
};
const validator = useVuelidate(rules, formData);
const submit = async () => {
  try {
    const valid = await validator.value.$validate();
    if (!valid) {
      throw {
        title: "Invalid input",
        text: "Please check your input!",
        icon: "error",
        timer: 3000,
      };
    }
    await store.ajax(formData, "auth/addrole", "post");
    alert.fire({
      title: "Role Added",
      text: "Role added successfully.",
      icon: "success",
      timer: 3000,
    });
    props.closeDialog();
  } catch (error) {
    console.log(error);
    alert.fire(error);
  }
};
</script>
