<template>
  <div>
    <MonthlyInspection
      :close-modal="closeModal"
      v-if="(store.pdfdata.element = 'monthlyInspection')"
    ></MonthlyInspection>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import MonthlyInspection from "../pdfs/monthlyInspection.vue";

const store = useAppStore();
defineProps(["closeModal"]);
</script>
