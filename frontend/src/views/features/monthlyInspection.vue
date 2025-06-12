<template>
  <div class="w-100 pa-2 d-flex justify-center align-center h-100">
    <v-card
      class="w-100 h-100"
      title="MONTHLY CONTROL"
      subtitle="Weekly Inspection Tool Control"
    >
      <template v-slot:append>
        <v-text-field
          append-inner-icon="mdi-calendar"
          v-model="month"
          variant="outlined"
          rounded="pill"
          type="month"
          label="Month"
          hide-details
          density="compact"
        />
      </template>
      <v-card-text>
        <v-data-table
          :items="tools"
          select-all
          pagination.sync="pagination"
          :search="search"
        >
          <template v-slot:top>
            <v-text-field
              prepend-inner-icon="mdi-magnify"
              label="Search tools"
              variant="outlined"
              rounded="pill"
              v-model="search"
              hide-details
              density="compact"
            >
            </v-text-field>
          </template>
          <template v-slot:headers>
            <tr>
              <th>No</th>
              <th>Tool Name</th>
              <th>Register Number</th>
              <th class="text-center">Actions</th>
              <th class="text-center">PDF Report</th>
            </tr>
          </template>
          <template v-slot:item="{ item, index }">
            <tr>
              <td>{{ index + 1 }}</td>
              <td>{{ item.toolName }}</td>
              <td>{{ item.registerNumber }}</td>
              <td class="text-center">
                <v-btn
                  class="w-100"
                  @click="openDialog(item)"
                  :color="item.monthlyData ? 'success' : 'primary'"
                  rounded="pill"
                  :text="
                    item.monthlyData
                      ? `checked By: ${item.monthlyData.userName}`
                      : 'check'
                  "
                />
              </td>
              <td class="text-center">
                <v-btn
                  @click="viewPdf(item)"
                  block=""
                  :color="item.monthlyData ? 'success' : ''"
                  rounded="pill"
                  :text="item.monthlyData ? 'view' : 'Not Checked'"
                  :disabled="!item.monthlyData"
                />
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
    <v-dialog
      v-model="dialog"
      scrollable
      persistent
      :overlay="false"
      transition="dialog-transition"
    >
      <v-card
        rounded="xl"
        :title="`${selected.toolName} ${selected.registerNumber}`"
      >
        <template v-slot:append>
          <v-btn @click="closeDialog" flat icon>
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </template>
        <v-card-text>
          <MonthlyCheck
            :tool-id="selected.toolId"
            :weekly-data="selected.weeklyData"
            :month="month"
            :close-me="closeDialog"
            :monthly-data="selected.monthlyData"
          ></MonthlyCheck>
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="pdfDialog"
      scrollable
      fullscreen
      transition="dialog-transition"
    >
      <v-card>
        <PdfViewer
          :close-modal="
            () => {
              pdfDialog = false;
            }
          "
        ></PdfViewer>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import MonthlyCheck from "@/components/dialogs/checks/monthlyCheck.vue";
import PdfViewer from "@/components/misc/pdfViewer.vue";

import { useAppStore } from "@/store/app";
import moment from "moment";
import { nextTick, onMounted, ref, watch } from "vue";

const m = moment(new Date()).format("YYYY-MM");
const store = useAppStore();
const tools = ref([]);
const month = ref(m);
const dialog = ref(false);
const selected = ref(null);
const search = ref("");
const pdfDialog = ref(false);

const refresh = async () => {
  tools.value = await store.ajax(
    { month: month.value },
    "tool/monthlyinspection",
    "post"
  );
  store.preload = false;
};

watch(month, () => {
  refresh();
});

onMounted(() => {
  refresh();
});

const closeDialog = () => {
  dialog.value = false;
  refresh();
};

const viewPdf = (data) => {
  store.pdfdata.data = data;
  store.pdfdata.element = "monthlyInspection";
  pdfDialog.value = true;
};

const openDialog = (weeklyData) => {
  selected.value = weeklyData;
  dialog.value = true;
};
</script>
