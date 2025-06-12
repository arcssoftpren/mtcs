<template>
  <v-card max-width="400" class="ma-auto app_bg" rounded="xl" elevation="5">
    <template v-slot:title>
      <h1 class="text-h4 font-weight-bold my-2">SOFTPREN MTCS</h1>
    </template>
    <v-card-text class="text-start">
      <v-img height="200" src="../../assets/softpren.png" />
      <v-spacer class="mt-5"></v-spacer>
      <LoginForm></LoginForm>
    </v-card-text>
  </v-card>
</template>
<script setup>
import LoginForm from "@/components/forms/loginForm.vue";
</script>
