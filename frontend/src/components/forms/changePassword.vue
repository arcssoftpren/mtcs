<template>
  <v-card
    title="Change User Password"
    rounded="xl"
    subtitle="Please provide your user informations"
  >
    <template v-slot:prepend>
      <v-icon size="50">mdi-account-key</v-icon>
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
          <template v-slot:append-inner>
            <v-icon @click="showPass = !showPass" v-if="showPass">
              mdi-eye
            </v-icon>
            <v-icon @click="showPass = !showPass" v-else>mdi-eye-off</v-icon>
          </template>
        </v-text-field>
      </div>
      <v-divider class="mb-3"></v-divider>
      <v-btn
        variant="outlined"
        rounded="pill"
        @click="submit"
        block
        color="primary"
        dark
        prepend-icon="mdi-check"
      >
        change
      </v-btn>
    </v-card-text>
  </v-card>
</template>

<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, maxLength, minLength, required } from "@vuelidate/validators";
import { reactive, ref, watch } from "vue";

const props = defineProps(["closeDialog", "selectedItem"]);
const showPass = ref(false);
const store = useAppStore();
const alert = store.alert;

const formData = reactive({
  userPassword: "",
  confirmPassword: "",
  userId: props.selectedItem.userId,
});

const formStructure = reactive({
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

watch(showPass, (e) => {
  if (e) {
    formStructure.userPassword.type = "text";
    formStructure.confirmPassword.type = "text";
  } else {
    formStructure.userPassword.type = "password";
    formStructure.confirmPassword.type = "password";
  }
});

const limitInput = (index) => {
  if (index != "userPassword" && index != "confirmPassword") {
    return;
  }
  formData[index] = formData[index].slice(0, 8);
};

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
    await store.ajax(formData, "auth/changepass", "post");
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
</script>
