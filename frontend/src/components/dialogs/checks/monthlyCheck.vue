<template>
  <div>
    <v-stepper v-model="steps">
      <v-stepper-header>
        <template v-for="(item, index) in weeklyData" :key="index">
          <v-stepper-item :title="`WEEK ${index + 1}`"> </v-stepper-item>
        </template>
      </v-stepper-header>
      <v-stepper-window>
        <template v-for="(item, index) in weeklyData" :key="index">
          <v-stepper-window-item :value="index">
            <div>
              <v-table>
                <thead>
                  <tr>
                    <th>No.</th>
                    <th class="text-no-wrap">POINT CHECK</th>
                    <th>CHECK METHOD</th>
                    <th
                      v-for="day in weekDays(item.weekCode)"
                      :key="day"
                      class="text-center"
                    >
                      {{ day }}
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <template v-for="(param, t) in parameters" :key="t">
                    <tr v-for="(method, i) in param.methods" :key="i">
                      <td v-if="i === 0" :rowspan="param.methods.length">
                        {{ t + 1 }}
                      </td>
                      <td v-if="i === 0" :rowspan="param.methods.length">
                        {{ param.pointString }}
                      </td>
                      <td>{{ method.methodString }}</td>
                      <td
                        v-for="day in weekDays(item.weekCode)"
                        :key="day"
                        class="text-center text-no-wrap"
                      >
                        <v-chip
                          :color="
                            getDailyData(day, item.dailyData, method).color
                          "
                          v-if="getDailyData(day, item.dailyData, method)"
                        >
                          {{ getDailyData(day, item.dailyData, method).text }}
                        </v-chip>
                        <v-badge
                          v-if="
                            getDailyData(day, item.dailyData, method).report &&
                            getDailyData(day, item.dailyData, method)
                              .judgement == 'NG'
                          "
                          color="error"
                          floating
                          icon="mdi-information"
                        >
                        </v-badge>
                      </td>
                    </tr>
                  </template>

                  <tr>
                    <td colspan="3" class="text-no-wrap w-100">Checked By:</td>
                    <td colspan="7" class="text-center">
                      <v-btn
                        block
                        disabled
                        :color="item.checkerID ? 'success' : ''"
                        rounded="pill"
                      >
                        {{ item.checkerName }}</v-btn
                      >
                    </td>
                  </tr>
                </tbody>
              </v-table>
            </div>
          </v-stepper-window-item>
        </template>
      </v-stepper-window>
      <v-stepper-actions>
        <template v-slot:next>
          <v-btn
            class="w-50"
            variant="outlined"
            rounded="pill"
            color="primary"
            v-if="steps == weeklyData.length - 1"
            :disabled="monthlyData != null"
            @click="submitInit"
            :text="monthlyData ? 'already signed' : 'sign'"
          />

          <v-btn
            class="w-50"
            variant="outlined"
            rounded="pill"
            color="success"
            @click="steps++"
            v-else
            >NEXT</v-btn
          >
        </template>
        <template v-slot:prev>
          <v-btn
            class="w-50"
            variant="outlined"
            rounded="pill"
            color="success"
            @click="steps--"
            >BACK</v-btn
          >
        </template>
      </v-stepper-actions>
    </v-stepper>
  </div>
  <v-dialog
    v-model="submitDialog"
    scrollable
    persistent
    :overlay="false"
    max-width="500px"
    transition="dialog-transition"
  >
    <v-card
      rounded="xl"
      title="You are about to sign this report"
      subtitle="Please confirm your action"
    >
      <template v-slot:prepend>
        <v-icon size="50" color="warning">mdi-help</v-icon>
      </template>
      <v-card-text>
        <v-row>
          <v-col cols="6">
            <v-btn
              @click="submitDialog = false"
              prepend-icon="mdi-close"
              block=""
              variant="outlined"
              rounded="pill"
            >
              Cancel
            </v-btn>
          </v-col>
          <v-col cols="6">
            <v-btn
              prepend-icon="mdi-check"
              color="success"
              block=""
              variant="outlined"
              rounded="pill"
              @click="signReport"
            >
              Proceed
            </v-btn>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { onMounted, reactive, ref } from "vue";
const props = defineProps([
  "weeklyData",
  "toolId",
  "month",
  "closeMe",
  "monthlyData",
]);
const parameters = ref([]);
const steps = ref(0);
const store = useAppStore();
const submitDialog = ref(false);

const formData = reactive({
  checkerId: store.sessionId,
  toolId: props.toolId,
  month: props.month,
  checkDate: moment(new Date()).format("YYYY-MM-DD"),
});

const weekDays = (week) => {
  const selectedWeek = moment(week, "YYYY-[W]ww").week();
  return Array.from({ length: 7 }, (_, i) =>
    moment()
      .week(selectedWeek)
      .startOf("week")
      .add(i + 1, "days")
      .format("ddd DD")
  );
};

const submitInit = () => {
  submitDialog.value = true;
};

const getParams = () => {
  store
    .ajax(
      {
        toolId: props.toolId,
        sessionId: store.sessionId,
      },
      "tool/dailycheckinit",
      "post"
    )
    .then(async (e) => {
      parameters.value = e.pointChecks;
    });
};

const getDailyData = (day, data, method) => {
  day = moment(day, "DD").format("DD");
  const y = moment(props.month, "YYYY-MM").format("YYYY-MM");
  const date = moment(`${y}-${day}`, "YYYY-MM-DD").format("YYYY-MM-DD");
  data = data.find(
    (e) => e != null && moment(e.checkDate).format("YYYY-MM-DD") === date
  );

  let myResponse = {
    text: "-",
    color: "",
    report: null,
  };

  let myPoint;
  let myMethod;

  if (data) {
    if (data.judgement != "NOT USED") {
      myPoint = data.instData.find((e) => e.checkId == method.pointCheckId);
      if (myPoint) {
        myMethod = myPoint.methods.find((e) => e.methodId == method.methodId);
        myResponse.text = myMethod.value;
        myResponse.judgement = myMethod.judgement;
        myResponse.color = myMethod.judgement == "NG" ? "error" : "success";
      }
      myResponse.report = data.report?.reportId;
    } else {
      myResponse = {
        text: "NU",
        color: "warning",
        report: null,
      };
    }
  }

  return myResponse;
};

onMounted(() => {
  getParams();
});

const signReport = async () => {
  try {
    await store.ajax(formData, "tool/monthlysign", "post", false);

    props.closeMe();
  } catch (error) {
    console.log(error);
  }
};
</script>
