<template>
  <v-card
    title="Add New Point Check"
    rounded="xl"
    subtitle="Please provide your method informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-checkbox-outline</v-icon>
    </template>
    <template v-slot:append>
      <v-btn flat icon color="transparent" @click="closeDialog">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <div class="d-flex my-2">
        <v-img height="300" :src="dataUrl"></v-img>
      </div>
      <v-row>
        <v-col cols="6">
          <v-text-field
            class="mt-2"
            label="Point Check"
            variant="outlined"
            rounded="pill"
            v-model="formData.pointString"
            :error-messages="
              validator.pointString.$errors.map((e) => e.$message)
            "
          />
        </v-col>
        <v-col cols="6">
          <v-text-field
            hide-spin-buttons
            type="number"
            class="mt-2"
            hint="Let it empty if no number in image"
            label="Point Number"
            variant="outlined"
            rounded="pill"
            v-model="formData.pointNumber"
        /></v-col>
      </v-row>

      <v-divider class="my-3"></v-divider>
      <v-btn
        variant="outlined"
        rounded="pill"
        @click="submit"
        block
        color="primary"
        prepend-icon="mdi-plus"
        >Edit</v-btn
      >
    </v-card-text>
  </v-card>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { reactive, ref } from "vue";

const props = defineProps(["point", "closeDialog"]);
const store = useAppStore();
const formData = reactive({
  pointNumber: props.point.pointNumber,
  pointString: props.point.pointString,
  checkId: props.point.checkId,
});
const rules = {
  pointString: {
    req: helpers.withMessage("Point check is required", required),
  },
};

const dataUrl = ref(store.cachedImage);

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
    await store.ajax(formData, "point/editpoint", "post");
    store.alert.fire({
      title: "Point Added",
      text: "Point added successfully!",
      icon: "success",
      timer: 3000,
    });
    props.closeDialog();
  } catch (error) {
    store.alert.fire(error);
  }
};
</script>
