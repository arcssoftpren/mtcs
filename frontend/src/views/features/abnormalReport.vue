<template>
  <div>
    <v-card class="ma-2">
      <template v-slot:title> Abnormality Report </template>
      <template v-slot:subtitle> List of Abnormality </template>
      <template v-slot:append>
        <v-text-field
          label="Month"
          type="month"
          variant="outlined"
          rounded="pill"
          v-model="month"
        />
      </template>
      <v-card-text>
        <v-tabs color="info" v-model="tab" alignTabs="end">
          <v-tab :value="1">Daily Finding</v-tab>
          <v-tab :value="2">Calibration Finding</v-tab>
        </v-tabs>

        <v-tabs-window v-model="tab">
          <v-tabs-window-item :value="1">
            <v-card>
              <template v-slot:title> Daily Finding </template>
              <template v-slot:subtitle>
                List of daily abnormality finding
              </template>
              <v-card-text>
                <v-data-table :items="daily">
                  <template v-slot:headers>
                    <tr>
                      <th rowspan="2">No</th>
                      <th rowspan="2">Tool Name</th>
                      <th rowspan="2">Register Number</th>
                      <th rowspan="2">Report Date</th>
                      <th colspan="2" class="text-center">User</th>
                      <th colspan="2" class="text-center">QC</th>
                      <th class="text-center">User</th>
                      <th colspan="2" class="text-center">QC</th>
                    </tr>
                    <tr>
                      <th class="text-center">PIC</th>
                      <th class="text-center">GL/SV/Mgr</th>
                      <th class="text-center">PIC</th>
                      <th class="text-center">GL/SV/Mgr</th>
                      <th class="text-center">Confirmed</th>
                      <th class="text-center">Confirmed</th>
                      <th class="text-center">GL/SV/Mgr</th>
                    </tr>
                  </template>
                  <template v-slot:item="{ item, index }">
                    <tr>
                      <td>{{ index + 1 }}</td>
                      <td>{{ item.toolName }}</td>
                      <td>{{ item.regNumber }}</td>
                      <td>
                        {{ moment(item.findingDate).format("DD/MM/YYYY") }}
                      </td>
                      <td class="text-capitalize">
                        <v-chip color="info" density="compact">{{
                          item.founderPIC
                        }}</v-chip>
                      </td>
                      <td>
                        <v-btn
                          color="info"
                          density="compact"
                          rounded="pill"
                          v-if="!condition('userCheck', item).checked"
                          :disabled="!condition('userCheck', item).enabled"
                        >
                          Check
                        </v-btn>
                        <v-chip color="info" v-else density="compact">
                          {{ item.founderAuthor }}
                        </v-chip>
                      </td>
                      <td>
                        <v-btn
                          color="info"
                          density="compact"
                          rounded="pill"
                          v-if="!condition('qcReport', item).checked"
                          :disabled="!condition('qcReport', item).enabled"
                        >
                          Check
                        </v-btn>
                        <v-chip color="info" v-else density="compact">
                          {{ item.handlingPIC }}
                        </v-chip>
                      </td>
                      <td>
                        <v-btn
                          color="success"
                          density="compact"
                          rounded="pill"
                          v-if="!condition('qcCheck', item).checked"
                          :disabled="!condition('qcCheck', item).enabled"
                        >
                          Check
                        </v-btn>
                        <v-chip color="info" v-else density="compact">
                          {{ item.handlingAuthor }}
                        </v-chip>
                      </td>

                      <td>
                        <v-btn
                          color="success"
                          density="compact"
                          rounded="pill"
                          v-if="!condition('confirm', item).checked"
                          :disabled="!condition('confirm', item).enabled"
                        >
                          Check
                        </v-btn>
                        <v-chip color="info" v-else density="compact">
                          {{ item.handlingAuthor }}
                        </v-chip>
                      </td>
                    </tr>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-tabs-window-item>
          <v-tabs-window-item :value="2">
            <v-card>
              <template v-slot:title> Calibration Finding </template>
              <template v-slot:subtitle>
                List of calibration abnormality finding
              </template>
              <v-card-text>
                <v-data-table :headers="headers" :items="calibration">
                  <template v-slot:item.reportType="{ item }">
                    <v-chip
                      :color="
                        item.reportType == 'Daily Finding' ? 'info' : 'warning'
                      "
                    >
                      {{ item.reportType }}
                    </v-chip>
                  </template>
                </v-data-table>
              </v-card-text>
            </v-card>
          </v-tabs-window-item>
        </v-tabs-window>
      </v-card-text>
    </v-card>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { onBeforeMount, ref, watch } from "vue";

const store = useAppStore();
const today = moment().format("YYYY-MM");
const month = ref(today);
const list = ref([]);
const tab = ref(1);
const daily = ref([]);
const calibration = ref([]);
const myData = ref([]);
const divisions = ref([]);

const headers = [
  {
    key: "no",
    title: "No.",
  },
  {
    title: "Tool Name",
    key: "toolName",
  },
  {
    title: "Register Number",
    key: "regNumber",
  },
  {
    title: "Finding Type",
    key: "reportType",
  },
];

watch(month, () => {
  refresh();
});

const refresh = async () => {
  try {
    store.preload = false;
    list.value = await store.ajax(
      { month: month.value },
      "tool/abnormals",
      "post"
    );
    myData.value = await store.ajax(
      { sessionId: store.sessionId },
      "auth/getmydata",
      "post"
    );

    divisions.value = await store.ajax(
      { sessionId: store.sessionId },
      "auth/getdivisions",
      "post"
    );

    myData.value.divisions = divisions.value.find(
      (f) => f.divId == myData.value.divId
    );

    let n = 1;
    list.value = list.value.map((e) => {
      e.no = n++;
      return e;
    });

    daily.value = list.value.filter((e) => e.reportType == "Daily Finding");
    calibration.value = list.value.filter(
      (e) => e.reportType != "Daily Finding"
    );
  } catch (error) {
    console.error(error);
  }
};

onBeforeMount(() => {
  refresh();
});

const condition = (pos, item) => {
  const myDiv = myData.value.divId;
  const myRole = myData.value.roleId;
  console.log(myRole + "/" + myDiv);
  // founderAuthor: false,
  //     handlingPIC: false,
  //     handlingAuthor: false,
  //     confirmator: false,
  //     approvalPIC: false,
  //     approvalAuthor: false,
  const handler = {
    userCheck: () => {
      return {
        enabled: (myDiv == 1 && myRole != 5) || (myDiv == 2 && myRole != 5),
        checked: item.founderAuthor != "",
      };
    },
    qcReport: () => {
      return {
        enabled:
          (myDiv == 1 && item.founderAuthor != "") ||
          (myDiv == 3 && item.founderAuthor != ""),
        checked: item.handlingPIC != "",
      };
    },
    qcCheck: () => {
      return {
        enabled:
          (myDiv == 1 &&
            myRole != 5 &&
            item.founderAuthor != "" &&
            item.handlingPIC != "") ||
          (myDiv == 3 &&
            myRole != 5 &&
            item.founderAuthor != "" &&
            item.handlingPIC != ""),
        checked: item.handlingAuthor != "",
      };
    },
    confirm: () => {
      return {
        enabled:
          (myDiv == 1 &&
            myRole != 5 &&
            item.founderAuthor != "" &&
            item.handlingPIC != "" &&
            item.handlingAuthor != "") ||
          (myDiv == 2 &&
            myRole != 5 &&
            item.founderAuthor != "" &&
            item.handlingPIC != "" &&
            item.handlingAuthor != ""),
        checked: item.confirmator != "",
      };
    },
  };

  return handler[pos]();
};
</script>
