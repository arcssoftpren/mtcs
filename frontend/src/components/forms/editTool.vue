<template>
  <v-card
    title="Edit Tool"
    rounded="xl"
    subtitle="Please provide your tool's informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-tools</v-icon>
    </template>
    <template v-slot:append>
      <v-btn @click="closeDialog" flat icon>
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-divider class="mb-3"></v-divider>
      <div class="d-flex my-2">
        <v-img height="300" :src="dataUrl"></v-img>
      </div>
      <v-text-field
        density="compact"
        type="text"
        variant="outlined"
        rounded="pill"
        label="Tool Name"
        v-model="formData.toolName"
        hint="Please insert the tool name"
        class="mb-3"
        :error-messages="validator.toolName.$errors.map((e) => e.$message)"
      >
      </v-text-field>

      <v-select
        density="compact"
        variant="outlined"
        rounded="pill"
        :items="ranks"
        v-model="formData.rankId"
        label="Select Rank"
        item-title="rankName"
        item-value="rankId"
        prepend-inner-icon="mdi-shield-account"
        :error-messages="validator.rankId.$errors.map((e) => e.$message)"
      />

      <v-text-field
        density="compact"
        type="text"
        variant="outlined"
        rounded="pill"
        label="Register Number"
        v-model="formData.registerNumber"
        hint="Please insert the tool name"
        class="mb-3"
        :error-messages="
          validator.registerNumber.$errors.map((e) => e.$message)
        "
      >
      </v-text-field>

      <v-select
        density="compact"
        variant="outlined"
        rounded="pill"
        :items="types"
        v-model="formData.typeId"
        label="Select Type"
        item-title="typeName"
        item-value="typeId"
        prepend-inner-icon="mdi-shield-account"
        :error-messages="validator.typeId.$errors.map((e) => e.$message)"
      />
      <v-file-input
        prepend-icon=""
        prepend-inner-icon="mdi-file-image"
        variant="outlined"
        rounded="pill"
        clearable=""
        icon="mdi-file-cad"
        density="compact"
        accept="image/*"
        label="Checking Point Image"
        v-model="formData.file"
        :error-messages="validator.file.$errors.map((e) => e.$message)"
      />
      <v-divider class="mb-3"></v-divider>
      <v-btn
        variant="outlined"
        rounded="pill"
        @click="submit"
        block
        color="primary"
        dark
        >EDIT</v-btn
      >
    </v-card-text>
  </v-card>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import { onMounted, reactive, ref, watch } from "vue";

const store = useAppStore();
const alert = store.alert;
const props = defineProps(["closeDialog", "tool"]);

const ranks = ref([]);
const types = ref([]);

const dataUrl = ref(props.tool.file);

const formData = reactive({
  toolName: props.tool.toolName,
  rankId: props.tool.rankId,
  typeId: props.tool.typeId,
  registerNumber: props.tool.registerNumber,
  toolId: props.tool.toolId,
  file: null,
});

const rules = {
  toolName: {
    required: helpers.withMessage("Tool name is required", required),
  },
  rankId: {
    required: helpers.withMessage("Please select a rank", required),
  },
  typeId: {
    required: helpers.withMessage("Please select a type", required),
  },
  registerNumber: {
    required: helpers.withMessage("Register number is required", required),
  },
  file: {
    required: helpers.withMessage("Checking point Image is required", required),
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
    const reqData = new FormData();

    for (const key in formData) {
      if (formData[key] instanceof File) {
        reqData.append(key, formData[key]); // Jika file, langsung append
      } else if (Array.isArray(formData[key])) {
        formData[key].forEach((item, index) => {
          reqData.append(`${key}[${index}]`, item);
        });
      } else {
        reqData.append(key, formData[key]); // Untuk string, number, dll.
      }
    }
    await store.ajax(reqData, "tool/edit", "post");
    alert.fire({
      title: "Tool Edited",
      text: "Tool edited successfully.",
      icon: "success",
      timer: 3000,
    });
    props.closeDialog();
  } catch (error) {
    console.log(error);
    alert.fire(error);
  }
};

onMounted(async () => {
  ranks.value = await store.ajax({}, "ranks", "post");
  types.value = await store.ajax({}, "type", "post");
  formData.file = store.dataUrlToFile(
    dataUrl.value,
    `${props.tool.toolId}.png`
  );
});

watch(
  () => formData.file,
  (e) => {
    console.log("File yang diterima:", e);

    // Cek apakah e adalah File atau Blob sebelum mengonversi
    if (e instanceof File || e instanceof Blob) {
      store.fileToDataURL(e).then((url) => {
        dataUrl.value = url;
      });
    } else {
      console.warn("e bukan File atau Blob!");
    }
  }
);
</script>
