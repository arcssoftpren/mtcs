<template>
  <v-row class="mt-3">
    <v-col cols="6" v-for="(item, index) in data" :key="index">
      <v-text-field
        variant="outlined"
        rounded="pill"
        v-model="item.dataValue"
        :type="item.dataType"
        name="name"
        :label="`${item.collumnEnString}`"
        id="id"
        @change="updateData(item)"
        @keyup="updateData(item)"
      />
    </v-col>
  </v-row>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import { onBeforeMount, ref } from "vue";

const props = defineProps(["tool"]);
const data = ref([]);
const store = useAppStore();
const refreshData = async () => {
  data.value = await store.ajax(props.tool, "tool/data", "post");
  store.preload = false;
};

const updateData = async (i) => {
  const changes = {
    dataId: i.dataId,
    dataValue: i.dataValue,
  };
  await store.ajax(changes, "tool/updatedata", "post");
};

onBeforeMount(() => {
  store.preload = true;
  refreshData();
});
</script>
