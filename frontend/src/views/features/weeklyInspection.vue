<template>
  <div class="w-100 pa-2 d-flex justify-center align-center h-100">
    <v-card
      class="w-100 h-100"
      title="WEEKLY CONTROL"
      subtitle="Weekly Inspection Tool Control"
    >
      <template v-slot:append>
        <v-text-field
          append-inner-icon="mdi-calendar"
          v-model="week"
          variant="outlined"
          rounded="pill"
          type="week"
          label="Date"
          hide-details
          density="compact"
        />
      </template>
      <v-card-text>
        <v-divider class="mb-3"></v-divider>
        <v-data-table items-per-page="25" :items="tools" :search="search">
          <template v-slot:top>defaultcontent</template>
          <template v-slot:headers="{ props }">
            <tr>
              <th rowspan="2">Tool Name</th>
              <th rowspan="2">Register Number</th>
              <th colspan="7" class="text-center">Week Days</th>
              <th rowspan="2" class="text-center">Checker</th>
              <th rowspan="2" class="text-center">Actions</th>
            </tr>
            <tr>
              <th v-for="day in weekDays" :key="day" class="text-center">
                {{ day }}
              </th>
            </tr>
          </template>
          <template v-slot:item="{ item }">
            <tr>
              <td>{{ item.toolName }}</td>
              <td>{{ item.registerNumber }}</td>
              <td
                class="text-center"
                v-for="(day, index) in weekDays"
                :key="index"
              >
                <v-btn
                  disabled=""
                  :color="getResult(item.instData, day).color"
                  >{{ getResult(item.instData, day).text }}</v-btn
                >
              </td>
              <td>
                <v-chip
                  class="w-100 text-center"
                  v-if="!item.weeklysign[0]"
                  close
                >
                  Un-checked</v-chip
                >
                <v-chip class="w-100 text-center" v-else color="green" close>
                  {{ item.weeklysign[0].checkerID }}
                </v-chip>
              </td>
              <td class="text-center">
                <v-btn
                  v-if="item.instData.length > 0"
                  class="w-100"
                  variant="outlined"
                  rounded="pill"
                  :color="item.weeklysign[0] ? 'success' : 'primary'"
                  @click="checkReport(item)"
                  :text="item.weeklysign[0] ? 'checked' : 'check report'"
                ></v-btn>
                <div v-else>NO DATA</div>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </div>
  <v-dialog
    v-model="reportsDialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <WeeklyCheck
      :ins-data="report"
      :close-modal="closeCheck"
      :week="week"
    ></WeeklyCheck>
  </v-dialog>
</template>

<script setup>
import { ref, computed, watch, onBeforeMount, nextTick } from "vue";
import moment from "moment";
import { useAppStore } from "@/store/app";
import WeeklyCheck from "@/components/dialogs/checks/weeklyCheck.vue";

const store = useAppStore();
const search = ref("");
const tools = ref([]);
const week = ref(moment().format("YYYY-[W]ww")); // Default ke minggu sekarang
const reportsDialog = ref(false);
const report = ref(null);

// ✅ **PERBAIKAN: `weekDays` Jadi Computed Property**
const weekDays = computed(() => {
  // Ambil nilai week number
  const selectedWeek = moment(week.value, "YYYY-[W]ww").week();

  return Array.from({ length: 7 }, (_, i) =>
    moment()
      .week(selectedWeek)
      .startOf("week")
      .add(i + 1, "days")
      .format("ddd DD")
  );
});

// ✅ **Refresh Data Saat Week Number Berubah**
const refresh = async () => {
  tools.value = await store.ajax({ week: week.value }, "tool", "post");

  store.preload = false;
};

watch(week, () => {
  refresh();
});

onBeforeMount(() => {
  store.preload = true;
  refresh();
});

const getResult = (checks, day) => {
  let result = {
    text: "",
    color: "",
  };
  const myData = checks.find(
    (check) => moment(check.checkDate).format("ddd DD") == day
  );

  if (myData) {
    switch (myData.judgement) {
      case "OK":
        result.color = "success";
        result.text = "O";
        break;
      case "NG":
        result.color = "error";
        result.text = "X";
        break;
      case "NOT USED":
        result.color = "warning";
        result.text = "-";
        break;
    }
  }

  return result;
};

const closeCheck = () => {
  refresh();
  reportsDialog.value = false;
};

const checkReport = async (item) => {
  report.value = item;
  await nextTick();
  reportsDialog.value = true;
};
</script>
