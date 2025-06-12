<template>
  <v-dialog
    v-model="dialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <div class="d-flex w-100 text-center justify-center">
      <v-container
        class="d-flex align-center flex-column justify-center"
        width="700"
      >
        <v-img width="300" src="../../assets/softpren.png" />

        <v-spacer class="my-5"></v-spacer>

        <div class="text-body-1 font-weight-light mb-5">Welcome to</div>
        <h1 class="text-h3">SOFTPREN MTCS</h1>
        <div class="font-weight-bold text-body-1">
          SOFTPREN Measurement Tool Control System
        </div>
        <v-spacer class="my-5"></v-spacer>
        <v-progress-linear
          rounded="pill"
          striped
          class="pa-2"
          height="25"
          color="primary"
          indeterminate
        >
          <div class="my-2 text-white">{{ text }}</div>
        </v-progress-linear>
      </v-container>
    </div>
  </v-dialog>
</template>
<script setup>
import router from "@/router";
import { useAppStore } from "@/store/app";
import { nextTick, ref } from "vue";
const dialog = ref(false);
const text = ref("");

setTimeout(() => {
  dialog.value = true;
  useAppStore().preload = false;
  setTimeout(() => {
    text.value = "Preparing...";
    setTimeout(() => {
      text.value = "Loading script...";
      setTimeout(() => {
        text.value = "Getting your system ready...";
      }, 2500);
    }, 1500);
  }, 500);
}, 500);
setTimeout(async () => {
  dialog.value = false;
  await nextTick();
  router.push("/login");
}, 5500);
</script>
