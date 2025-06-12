<template>
  <v-card
    title="Add Method"
    rounded="xl"
    subtitle="Please provide your method informations"
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
      <v-divider class="mb-3"></v-divider>
      <v-textarea
        variant="outlined"
        rounded="xl"
        label="Check Method"
        v-model="formData.methodString"
        hint="Please insert a check method."
        class="mb-3"
        :error-messages="validator.methodString.$errors.map((e) => e.$message)"
      />
      <v-select
        :items="resultTypes"
        variant="outlined"
        rounded="pill"
        label="Select Result Type"
        item-title="typeLabel"
        item-value="typeId"
        v-model="formData.resultType"
        :error-messages="validator.resultType.$errors.map((e) => e.$message)"
      />
      <v-divider>Standard</v-divider>
      <v-row>
        <v-col cols="12" v-if="formData.resultType != 4">
          <v-text-field
            v-if="formData.resultType == 1 || formData.resultType == 2"
            variant="outlined"
            rounded="pill"
            label="Standard"
            :readonly="formData.resultType == 1"
            type="text"
            v-model="matchString"
            :error-messages="validator.standard.$errors.map((e) => e.$message)"
          >
          </v-text-field>
          <v-text-field
            v-if="
              formData.resultType == 3 ||
              formData.resultType == 5 ||
              formData.resultType == 6
            "
            hide-spin-buttons
            variant="outlined"
            rounded="pill"
            label="Standard"
            :readonly="formData.resultType == 1"
            type="number"
            v-model="matchNumber"
            :error-messages="validator.standard.$errors.map((e) => e.$message)"
          ></v-text-field>
        </v-col>
        <v-col cols="16" v-if="formData.resultType == 4">
          <v-text-field
            hide-spin-buttons
            variant="outlined"
            rounded="pill"
            label="Minimum Value"
            type="number"
            v-model="minNumber"
            :error-messages="validator.standard.$errors.map((e) => e.$message)"
          ></v-text-field>
        </v-col>
        <v-col cols="16" v-if="formData.resultType == 4">
          <v-text-field
            hide-spin-buttons
            variant="outlined"
            rounded="pill"
            label="Maximum Value"
            type="number"
            v-model="maxNumber"
            :error-messages="validator.standard.$errors.map((e) => e.$message)"
          ></v-text-field>
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
        >Add</v-btn
      >
    </v-card-text>
  </v-card>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { nextTick, onBeforeMount, reactive, ref, watch } from "vue";

const props = defineProps(["closeDialog", "point"]);
const pointCheckId = props.point;
const store = useAppStore();
const alert = store.alert;

const resultTypes = ref([]);
const formData = reactive({
  pointCheckId,
  methodString: "",
  resultType: "",
  standard: {
    name: "",
    arg: [],
  },
});

const setStandard = () => {
  const e = formData.resultType;
  switch (e) {
    case 1:
      matchString.value = "OK";
      formData.standard.name = "matchString";
      formData.standard.arg = [matchString.value];
      break;
    case 2:
      matchString.value = "";
      formData.standard.name = "matchString";
      formData.standard.arg = [matchString.value];
      break;
    case 3:
      formData.standard.name = "matchNumber";
      formData.standard.arg = [matchNumber.value];
      break;
    case 4:
      formData.standard.name = "numberRange";
      formData.standard.arg = [minNumber.value, maxNumber.value];
      break;
    case 5:
      formData.standard.name = "largerThan";
      formData.standard.arg = [matchNumber.value];
      break;
    case 6:
      formData.standard.name = "lessThan";
      formData.standard.arg = [matchNumber.value];
      break;
    default:
      formData.standard.name = "";
      formData.standard.arg = [];
      break;
  }
};

const matchString = ref("");
const matchNumber = ref();
const minNumber = ref();
const maxNumber = ref();

watch(() => formData.resultType, setStandard());

const rules = {
  methodString: {
    required: helpers.withMessage("Check method is required", required),
  },
  resultType: {
    required: helpers.withMessage("Please select a result type", required),
  },
  standard: {
    required: helpers.withMessage("Standard is required", () => {
      return formData.standard.name !== "" && formData.standard.arg.length > 0;
    }),
  },
};
const validator = useVuelidate(rules, formData);

const submit = async () => {
  try {
    setStandard();
    await nextTick();
    const valid = await validator.value.$validate();
    if (!valid) {
      throw {
        title: "Invalid input",
        text: "Please check your input!",
        icon: "error",
        timer: 3000,
      };
    }
    await store.ajax(formData, "point/addmethod", "post");
    props.closeDialog();
  } catch (error) {
    console.log(error);
    alert.fire(error);
  }
};
const refreshRank = async () => {
  resultTypes.value = await store.ajax({}, "type/resulttype", "post");
};

onBeforeMount(() => {
  refreshRank();
});
</script>
