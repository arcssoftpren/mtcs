<template>
  <v-card
    title="Edit Type"
    rounded="xl"
    subtitle="Please provide your type informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-wrench-cog</v-icon>
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
        label="Type Name"
        v-model="formData.typeName"
        hint="Please insert a type name."
        class="mb-3"
        :error-messages="validator.typeName.$errors.map((e) => e.$message)"
      />
      <v-divider class="mb-3"></v-divider>
      <v-btn
        variant="outlined"
        rounded="pill"
        @click="submit"
        block
        color="primary"
        dark
        >Edit</v-btn
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

const store = useAppStore();
const alert = store.alert;
const props = defineProps(["closeDialog", "selectedItem"]);
const formData = reactive({
  typeName: props.selectedItem.typeName,
  typeId: props.selectedItem.typeId,
});
const rules = {
  typeName: {
    required: helpers.withMessage("Type name is required", required),
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
    await store.ajax(formData, "type/edittype", "post");
    alert.fire({
      title: "Type Edited",
      text: "Type edited successfully.",
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
