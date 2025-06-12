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
        <v-data-table :items="tools" select-all pagination.sync="pagination">
          <template v-slot:headers>
            <tr>
              <th>No</th>
              <th>Tool Name</th>
              <th>Reg Number</th>
              <th class="text-center">Actions</th>
            </tr>
          </template>
          <template v-slot:item="{ item, index }">
            <tr>
              <td>{{ index + 1 }}</td>
              <td>{{ item.toolName }}</td>
              <td>{{ item.registerNumber }}</td>
              <td class="text-center">
                <v-btn color="success" @click="openReport(item)">text</v-btn>
              </td>
            </tr>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
  </div>
  <v-dialog
    v-model="reportDialog"
    scrollable
    :overlay="false"
    transition="dialog-transition"
  >
    <v-card>
      <v-card-text>
        <v-table>
          <thead>
            <tr>
              <th rowspan="2">No</th>
              <th rowspan="2">Poin Check</th>
              <th rowspan="2">Check Method</th>
              <th colspan="31" class="text-center">Date</th>
            </tr>
            <tr>
              <th v-for="(item, index) in Array(31).fill('0')" :key="index">
                {{ index + 1 }}
              </th>
            </tr>
          </thead>
          <tbody>
            <template v-for="(point, index) in points" :key="index">
              <tr v-for="(method, i) in point.methods" :key="i">
                <td
                  class="text-center text-no-wrap"
                  v-if="i === 0"
                  :rowspan="point.methods.length"
                >
                  {{ point.pointNumber == 0 ? "" : point.pointNumber }}
                </td>
                <td
                  class="text-start text-no-wrap"
                  v-if="i === 0"
                  :rowspan="point.methods.length"
                >
                  {{ point.pointString }}
                </td>
                <td class="text-start text-no-wrap">
                  {{ method.methodString }}
                </td>

                <td v-for="(item, index) in Array(31).fill('0')" :key="index">
                  <v-chip
                    :color="
                      getResult(index + 1, method.methodId, point.checkId).color
                    "
                    close
                  >
                    {{
                      getResult(index + 1, method.methodId, point.checkId).text
                    }}
                  </v-chip>

                  <v-badge
                    v-if="
                      getResult(index + 1, method.methodId, point.checkId)
                        .reports[0] != undefined
                    "
                    color="error"
                    floating
                    icon="mdi-information"
                  >
                  </v-badge>
                </td>
              </tr>
            </template>
          </tbody>
        </v-table>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<style scoped>
table td,
th {
  padding: 10px;
}
</style>
<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { nextTick, onMounted, ref, watch } from "vue";

const store = useAppStore();
const tools = ref([]);
const reports = ref([]);
const month = ref(moment(new Date()).format("YYYY-MM"));
const selectedTool = ref({});
const reportDialog = ref(false);
const points = ref([]);

const refresh = async () => {
  tools.value = await store.ajax({ month: month.value }, "tool", "post");
  tools.value.file = null;
  reports.value = await store.ajax(
    { month: month.value },
    "tool/getmonthlyreports",
    "post"
  );
  store.preload = false;
};

const getResult = (day, methodId, checkId) => {
  let checkData = selectedTool.value.instData;
  let response = { color: "grey", text: "", reports: [] };
  const myData = checkData.filter(
    (e) => moment(e.checkDate).format("D") == day
  );

  if (myData.length > 0 && myData[0].instData) {
    if (myData[0].judgement !== "NOT USED") {
      const myPoint = myData[0].instData.find((d) => d.checkId == checkId);
      if (myPoint) {
        const myResult = myPoint.methods.find((m) => m.methodId == methodId);

        // if (myResult.report.length > 0) {
        //   response.reports = myResult.reports;
        // }
        switch (myResult.judgement) {
          case "OK":
            if (myResult.resultType == 1) {
              response.text = "O";
            } else {
              response.text = myResult.value;
            }
            response.color = "green";
            break;
          case "NG":
            if (myResult.resultType == 1) {
              response.text = "X";
            } else {
              response.text = myResult.value;
            }
            response.color = "red";
            response.reports = myData[0].abnormalReports;
            break;
          default:
            response = { text: "-", color: "grey", reports: [] };
        }
      }
    } else {
      response = { text: "-", color: "warning", reports: [] };
    }
  }
  return response;
};

const openReport = async (item) => {
  selectedTool.value = item;
  points.value = await store.ajax(
    { toolId: item.toolId },
    "type/getpoints",
    "post"
  );

  reportDialog.value = true;
};

watch(month, () => {
  refresh();
});

onMounted(() => {
  refresh();
});
</script>
