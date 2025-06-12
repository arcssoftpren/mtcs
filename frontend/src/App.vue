<template>
  <router-view />
  <v-dialog
    v-model="preload"
    scrollable
    fullscreen
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card>
      <v-container
        class="d-flex fill-height align-center flex-column justify-center align-center"
        width="700"
      >
        <v-progress-circular
          size="500"
          indeterminate
          width="15"
          color="primary"
        >
          <template v-slot:default>
            <v-img width="250" src="./assets/softpren.png"
          /></template>
        </v-progress-circular>
      </v-container>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { computed } from "vue";
import { useAppStore } from "./store/app";

const preload = computed(() => useAppStore().preload);
//
</script>
