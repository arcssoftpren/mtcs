<template>
  <v-card
    title="Edit Rank"
    rounded="xl"
    subtitle="Please provide your rank informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-chevron-triple-up</v-icon>
    </template>
    <template v-slot:append>
      <v-btn @click="closeDialog" flat icon>
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-divider class="mb-3"></v-divider>
      <div v-for="(item, index) in formStructure" :key="index">
        <v-text-field
          v-if="item.type == 'text'"
          :type="item.type"
          variant="outlined"
          rounded="pill"
          :label="item.label"
          v-model="formData[index]"
          :hint="item.hint"
          class="mb-3"
          :error-messages="validator[index].$errors.map((e) => e.$message)"
        />
        <v-textarea
          v-else
          @input="limitInput(index)"
          :type="item.type"
          variant="outlined"
          rounded="xl"
          counter=""
          max
          :label="item.label"
          v-model="formData[index]"
          :hint="item.hint"
          class="mb-3"
          :error-messages="validator[index].$errors.map((e) => e.$message)"
        />
      </div>

      <v-divider class="text-uppercase"
        >Inspection Tool Control List Collumns</v-divider
      >
      <v-row class="my-3">
        <v-col cols="3" v-for="item in collumns" :key="item.collumnId">
          <v-checkbox
            density="compact"
            hide-details=""
            color="primary"
            :label="item.collumnEnString"
            v-model="formData.collumns"
            :true-value="item.collumnId"
          />
        </v-col>
      </v-row>
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
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, maxLength, required } from "@vuelidate/validators";
import { onBeforeMount, reactive, ref } from "vue";

const store = useAppStore();
const alert = store.alert;
const props = defineProps(["closeDialog", "selectedItem"]);
const collumns = ref([]);

const formData = reactive({
  rankId: props.selectedItem.rankId,
  rankName: props.selectedItem.rankName,
  description: props.selectedItem.description,
  collumns: [],
  rankNameJp: props.selectedItem.rankNameJp,
});

console.log(formData);

const formStructure = reactive({
  rankName: {
    label: "Rank Name",
    hint: "Please enter a rank name.",
    type: "text",
  },
  rankNameJp: {
    label: "Rank Name Japanese",
    hint: "Please enter a rank name.",
    type: "text",
  },
  description: {
    label: "Description",
    hint: "Please enter the rank description.",
    type: "textarea",
  },
});

const rules = {
  rankName: {
    required: helpers.withMessage("Rank name is required", required),
  },
  rankNameJp: {
    required: helpers.withMessage("Rank name is required", required),
  },
  description: {
    required: helpers.withMessage("Description is required", required),
    maxLength: helpers.withMessage(
      "Only 256 characters are allowed",
      maxLength(256)
    ),
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
    await store.ajax(formData, "ranks/editrank", "post");
    alert.fire({
      title: "Rank Added",
      text: "Rank added successfully.",
      icon: "success",
      timer: 3000,
    });
    props.closeDialog();
  } catch (error) {
    console.log(error);
    alert.fire(error);
  }
};

const limitInput = (index) => {
  formData[index] = formData[index].slice(0, 256);
};

onBeforeMount(async () => {
  store.preload = true;
  collumns.value = await store.ajax({}, "ranks/collumns", "post");

  store.preload = false;
  const col = JSON.parse(props.selectedItem.collumns);

  col.forEach((element) => {
    formData.collumns.push(Number(element));
  });
});
</script>
