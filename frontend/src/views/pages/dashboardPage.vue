<template>
  <div></div>
</template>
<script setup>
import { useAppStore } from "@/store/app";

const store = useAppStore();
store.preload = false;
</script>
