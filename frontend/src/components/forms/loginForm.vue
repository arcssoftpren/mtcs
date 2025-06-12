<template>
  <div class="my-2" v-for="(item, index) in formStructure" :key="index">
    <v-text-field
      :label="item.label"
      :hint="item.hint"
      :type="item.type"
      v-model="formData[index]"
      variant="outlined"
      rounded="pill"
      :error-messages="validator[index].$errors.map((e) => e.$message)"
      @input="limitInput(index)"
    >
      <template v-if="index == 'userPassword'" v-slot:append-inner>
        <v-icon @click="showPass = !showPass" v-if="showPass">mdi-eye</v-icon>
        <v-icon @click="showPass = !showPass" v-else>mdi-eye-off</v-icon>
      </template>
    </v-text-field>
  </div>
  <v-divider class="mb-2"></v-divider>
  <v-btn
    @click="submit"
    block
    color="primary"
    variant="outlined"
    rounded="pill"
    text="login"
    prepend-icon="mdi-login"
  />
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, maxLength, minLength, required } from "@vuelidate/validators";
import { nextTick, onMounted, reactive, ref, watch } from "vue";

const showPass = ref(false);
const store = useAppStore();

watch(showPass, (e) => {
  if (e) {
    formStructure.userPassword.type = "text";
  } else {
    formStructure.userPassword.type = "password";
  }
});
const limitInput = (index) => {
  if (index != "userPassword") {
    return;
  }
  formData[index] = formData[index].slice(0, 8);
};

const formData = reactive({
  userId: "",
  userPassword: "",
});

const formStructure = reactive({
  userId: {
    label: "NIK",
    hint: "Please enter your NIK",
    type: "text",
  },
  userPassword: {
    label: "Password",
    hint: "Please enter your password",
    type: "password",
  },
});

const rules = {
  userId: {
    req: helpers.withMessage("NIK is required", required),
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
    const sessionId = await store.ajax(formData, "auth/login", "post");
    useAppStore().sessionId = sessionId;
    store.alert.fire({
      title: "Login Success",
      text: "Loged in succesfully, now routing you to your dashboard!",
      icon: "success",
    });
    await nextTick();
    router.push("/home/dashboard");
  } catch (error) {
    store.alert.fire(error);
  }
};

onMounted(() => {
  useAppStore().preload = false;
});
</script>
