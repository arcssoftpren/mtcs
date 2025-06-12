<template>
  <v-card
    title="Add New User"
    rounded="xl"
    subtitle="Please provide your user informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-account</v-icon>
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
          @input="limitInput(index)"
          :type="item.type"
          variant="outlined"
          rounded="pill"
          :label="item.label"
          v-model="formData[index]"
          :hint="item.hint"
          class="mb-3"
          :error-messages="validator[index].$errors.map((e) => e.$message)"
        >
          <template
            v-if="index == 'userPassword' || index == 'confirmPassword'"
            v-slot:append-inner
          >
            <v-icon @click="showPass = !showPass" v-if="showPass"
              >mdi-eye</v-icon
            >
            <v-icon @click="showPass = !showPass" v-else>mdi-eye-off</v-icon>
          </template>
        </v-text-field>
      </div>
      <v-select
        :error-messages="validator.divId.$errors.map((e) => e.$message)"
        class="text-capitalize"
        variant="outlined"
        rounded="pill"
        :items="divisions"
        v-model="formData.divId"
        label="Select Division"
        item-title="divName"
        item-value="divId"
        prepend-inner-icon="mdi-family-tree"
      />
      <v-select
        :error-messages="validator.roleId.$errors.map((e) => e.$message)"
        variant="outlined"
        rounded="pill"
        :items="roles"
        v-model="formData.roleId"
        label="Select Role"
        item-title="roleName"
        item-value="roleId"
        prepend-inner-icon="mdi-shield-account"
      />

      <v-img :src="dataUrl" height="200"></v-img>
      <v-file-input
        v-model="formData.signFile"
        prepend-icon=""
        prepend-inner-icon="mdi-file-image"
        variant="outlined"
        rounded="pill"
        accept="image/*"
        label="Signature"
        :error-messages="validator.signFile.$errors.map((e) => e.$message)"
      ></v-file-input>
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
import { helpers, maxLength, minLength, required } from "@vuelidate/validators";
import { onMounted, reactive, ref, watch } from "vue";

const showPass = ref(false);
const store = useAppStore();
const alert = store.alert;
const props = defineProps(["closeDialog"]);

const roles = ref([]);
const divisions = ref([]);

const dataUrl = ref(null);

const formData = reactive({
  userName: "",
  userId: "",
  roleId: "",
  userPassword: "",
  confirmPassword: "",
  divId: "",
  signFile: null,
});

const formStructure = reactive({
  userName: {
    label: "User Name",
    hint: "Please enter a user name.",
    type: "text",
  },
  userId: {
    label: "NIK",
    hint: "Please enter user NIK.",
    type: "text",
  },
  userPassword: {
    label: "User Password",
    hint: "Please enter a password.",
    type: "password",
  },
  confirmPassword: {
    label: "Confirm Password",
    hint: "Please re-enter password.",
    type: "password",
  },
});

const rules = {
  roleId: {
    required: helpers.withMessage("Please select a role", required),
  },
  userName: {
    required: helpers.withMessage("User name is required", required),
  },
  divId: {
    required: helpers.withMessage("Please select a division", required),
  },
  signFile: {
    required: helpers.withMessage("Signature file is required", required),
  },
  userId: {
    required: helpers.withMessage("NIK is required", required),
    noSpace: helpers.withMessage("White space is not allowed", () => {
      const str = formData.userId;
      return !str.includes(" ");
    }),
  },
  userPassword: {
    req: helpers.withMessage("password is required", required),
    minLength: helpers.withMessage(
      "password must be at least 8 characters long",
      minLength(8)
    ),
    maxLength: helpers.withMessage(
      "password must be at most 8 characters long",
      maxLength(8)
    ),
  },
  confirmPassword: {
    req: helpers.withMessage("password is required", required),
    match: helpers.withMessage("password is not match", () => {
      return formData.userPassword == formData.confirmPassword;
    }),
  },
};
const validator = useVuelidate(rules, formData);

const limitInput = (index) => {
  if (index != "userPassword" && index != "confirmPassword") {
    return;
  }
  formData[index] = formData[index].slice(0, 8);
};

watch(showPass, (e) => {
  if (e) {
    formStructure.userPassword.type = "text";
    formStructure.confirmPassword.type = "text";
  } else {
    formStructure.userPassword.type = "password";
    formStructure.confirmPassword.type = "password";
  }
});

watch(
  () => formData.signFile,
  async (signFile) => {
    dataUrl.value = await store.fileToDataURL(signFile);
    console.log(dataUrl.value);
  }
);

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
    await store.ajax(reqData, "auth/adduser", "post");
    alert.fire({
      title: "User Added",
      text: "User added successfully.",
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
  roles.value = await store.ajax({}, "auth/getroles", "post");
  divisions.value = await store.ajax({}, "auth/getdivisions", "post");
});
</script>
