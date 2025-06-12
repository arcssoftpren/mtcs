<template>
  <div class="d-flex align-center fill-height justify-center" ref="container">
    <div class="pa-2" ref="stepper">
      <v-stepper v-model="step">
        <v-stepper-header fixed>
          <template v-for="(param, index) in parameters" :key="index">
            <v-stepper-item
              :title="param.pointString"
              :value="index + 1"
            ></v-stepper-item>
          </template>
        </v-stepper-header>

        <v-card class="ma-3">
          <v-card-text>
            <v-img :style="`height: ${scale}px;`" :src="dataUrl"></v-img>
          </v-card-text>
        </v-card>
        <v-stepper-window>
          <template v-for="(param, index) in parameters" :key="index">
            <v-stepper-window-item :value="index + 1">
              <v-list>
                <v-list-item
                  v-for="(method, mIndex) in param.methods"
                  :key="mIndex"
                >
                  <v-list-item-title>
                    <v-card>
                      <template v-slot:prepend v-if="param.pointNumber != 0">
                        <div
                          class="text-center"
                          style="
                            border-radius: 50%;
                            border: 1px solid black;
                            width: 40px;
                            height: 40px;
                            font-size: 25px;
                          "
                        >
                          {{ param.pointNumber }}
                        </div>
                      </template>
                      <template v-slot:subtitle>
                        {{ param.pointString }}
                        <span v-if="param.methods.length > 1">
                          [{{ mIndex + 1 }}]
                        </span>
                      </template>
                      <template v-slot:title>
                        <div class="text-wrap">
                          {{ method.methodString }}
                        </div>
                      </template>
                      <template v-slot:append>
                        <v-avatar
                          :color="
                            method.judgement == 'OK' ? 'success' : 'error'
                          "
                        >
                          <v-icon v-if="method.judgement == 'OK'" dark
                            >mdi-check</v-icon
                          >
                          <v-icon v-else dark>mdi-close</v-icon>
                        </v-avatar>
                      </template>
                      <v-card-text class="text-wrap">
                        <v-card class="w-100">
                          <v-btn-toggle
                            divided=""
                            density="compact"
                            class="w-100"
                            v-if="method.resultType == 1"
                            mandatory
                            v-model="method.value"
                            @update:model-value="
                              setValue($event, method.methodId)
                            "
                          >
                            <v-btn class="w-50" color="success" value="OK"
                              >OK
                            </v-btn>
                            <v-btn class="w-50" color="error" value="NG"
                              >NG
                            </v-btn>
                          </v-btn-toggle>
                        </v-card>
                        <!-- <v-select
                        @update:model-value="
                          setValue($event, method.methodId)
                        "
                        :items="optOKNG"
                        variant="outlined"
                        rounded="pill"
                        v-model="method.value"
                        v-if="method.resultType == 1"
                        :error="!method.value && showError"
                        :error-messages="
                          !method.value && showError
                            ? 'Please input inspection result!'
                            : ''
                        "
                      >
                      </v-select> -->
                        <v-text-field
                          @keyup="setValue($event, method.methodId)"
                          :error="!method.value && showError"
                          :error-messages="
                            !method.value && showError
                              ? 'Please input inspection result!'
                              : ''
                          "
                          hide-spin-buttons=""
                          v-model="method.value"
                          variant="outlined"
                          rounded="pill"
                          type="number"
                          label="Assasement Result"
                          v-if="
                            method.resultType != 1 && method.resultType != 2
                          "
                        >
                        </v-text-field>
                        <v-text-field
                          @keyup="setValue($event, method.methodId)"
                          :error="!method.value && showError"
                          :error-messages="
                            !method.value && showError
                              ? 'Please input inspection result!'
                              : ''
                          "
                          v-model="method.value"
                          variant="outlined"
                          rounded="pill"
                          type="text"
                          label="Assasement Result"
                          v-if="method.resultType == 2"
                        ></v-text-field>
                      </v-card-text>
                    </v-card>
                  </v-list-item-title>
                </v-list-item>
              </v-list>
            </v-stepper-window-item>
          </template>
        </v-stepper-window>

        <v-stepper-actions>
          <template v-slot:next>
            <v-btn
              @click="next()"
              color="success"
              append-icon="mdi-arrow-right"
              v-if="step < parameters.length"
              :disabled="!isStepValid() && step >= parameters.length"
            >
              Next
            </v-btn>

            <v-btn
              color="success"
              append-icon="mdi-arrow-right"
              v-if="step == parameters.length"
              :disabled="!isStepValid() && step <= parameters.length"
              @click="finish"
            >
              Finish
            </v-btn>
          </template>

          <template v-slot:prev>
            <v-btn
              @click="
                () => {
                  step--;
                  scaleView();
                }
              "
              color="success"
              prepend-icon="mdi-arrow-left"
              >Back</v-btn
            >
          </template>
        </v-stepper-actions>
      </v-stepper>
    </div>
  </div>
  <v-dialog
    v-model="confirmDialog"
    :overlay="false"
    scrollable=""
    transition="dialog-transition"
  >
    <v-card rounded="xl" title="Check Resume">
      <v-card-text>
        <v-table density="compact">
          <thead>
            <tr>
              <th>Tool Name</th>
              <th>: {{ tool.toolName }}</th>
              <th class="text-center">Checker</th>
              <th class="text-center">Judgement</th>
            </tr>
            <tr>
              <th>Reg. Number</th>
              <th>: {{ tool.registerNumber }}</th>
              <th rowspan="2">
                <div
                  class="d-flex align-center w-100 justify-center fill-height"
                >
                  <h1 class="text-h5 text-center">
                    {{ inspectionData.checkerName }}
                  </h1>
                </div>
              </th>
              <th rowspan="2">
                <div
                  :class="
                    inspectionData.judgement == 'NG'
                      ? 'd-flex align-center justify-center bg-pink fill-height w-100'
                      : 'd-flex align-center justify-center bg-success fill-height w-100'
                  "
                >
                  <h1 class="text-h3">
                    {{ inspectionData.judgement }}
                  </h1>
                </div>
              </th>
            </tr>
            <tr>
              <th>Check Date</th>
              <th>: {{ inspectionData.checkDate }}</th>
            </tr>
            <tr>
              <td colspan="3" class="text-center text-h5 text-uppercase">
                Inspection Data
              </td>
            </tr>
            <tr>
              <th class="text-center">Point Number</th>
              <th>Point Check</th>
              <th>Check Method</th>
              <th class="text-center">Check Result</th>
            </tr>
          </thead>
          <tbody>
            <template
              v-for="(item, index) in inspectionData.instData"
              :key="index"
            >
              <tr v-for="(method, i) in item.methods" :key="i">
                <td
                  class="text-center"
                  v-if="i === 0"
                  :rowspan="item.methods.length"
                >
                  {{ item.pointNumber == 0 ? "" : item.pointNumber }}
                </td>
                <td v-if="i === 0" :rowspan="item.methods.length">
                  {{ item.pointString }}
                </td>
                <td>{{ method.methodString }}</td>
                <td class="text-center" v-if="method.resultType == 1">
                  <v-chip
                    :color="method.judgement == 'OK' ? 'success' : 'error'"
                  >
                    {{ method.judgement }}
                  </v-chip>
                </td>
                <td class="text-center" v-else>
                  <v-chip
                    :color="method.judgement == 'OK' ? 'success' : 'error'"
                  >
                    {{ method.value }}
                  </v-chip>
                </td>
              </tr>
            </template>
          </tbody>
        </v-table>
        <v-divider class="my-5"></v-divider>
        <v-row>
          <v-col :cols="inspectionData.judgement == 'NG' ? '4' : '6'">
            <v-btn
              variant="outlined"
              rounded="pill"
              block
              prepend-icon="mdi-arrow-u-left-bottom"
              @click="confirmDialog = false"
              >Back</v-btn
            >
          </v-col>
          <v-col cols="4" v-if="inspectionData.judgement == 'NG'">
            <v-btn
              @click="abnormalityDialog = true"
              variant="outlined"
              rounded="pill"
              block
              color="error"
              dark
              >Submit Abnormal Report ?</v-btn
            >
          </v-col>
          <v-col :cols="inspectionData.judgement == 'NG' ? '4' : '6'">
            <v-btn
              :color="inspectionData.judgement == 'NG' ? 'error' : 'success'"
              variant="outlined"
              rounded="pill"
              block
              prepend-icon="mdi-check"
              @click="submitReport"
              >Submit Inspection</v-btn
            >
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>
  </v-dialog>
  <v-dialog
    v-model="abnormalityDialog"
    scrollable
    :overlay="false"
    max-width="700"
    transition="dialog-transition"
  >
    <v-card
      rounded="xl"
      :title="`Initiate Abnormality Report for ${tool.toolName} [${tool.registerNumber}]`"
      subtitle="Please provide your finding information below."
    >
      <template v-slot:append>
        <v-btn @click="abnormalityDialog = false" flat icon>
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
      <v-card-text>
        <AbnormalReportInit
          :tool="props.tool"
          :report="inspectionData"
          :finish-report="submitReport"
          :close-modal="
            () => {
              abnormalityDialog = false;
            }
          "
        />
      </v-card-text>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { nextTick, onMounted, ref } from "vue";
import { useAppStore } from "@/store/app";
import $ from "jquery";
import AbnormalReportInit from "@/components/forms/abnormalReportInit.vue";

const abnormalityDialog = ref(false);
const stepper = ref(null);
const scale = ref(1);
const props = defineProps([
  "tool",
  "closeDialog",
  "containerHeight",
  "inspectionDate",
]);
const confirmDialog = ref(false);
const store = useAppStore();
const step = ref(1);
const parameters = ref([]);
const result = ref([]);
const showError = ref(false); // Untuk menampilkan error jika data kosong
const notGodArr = ref([]);
const container = ref(null);
const inspectionData = ref({});

// Fungsi validasi step saat ini
const isStepValid = () => {
  if (!parameters.value.length) return false;
  const currentStepMethods = parameters.value[step.value - 1]?.methods || [];
  return currentStepMethods.every((method) => method.value);
};

const dataUrl = ref(props.tool.file);

const scaleView = () => {
  nextTick().then(() => {
    setTimeout(() => {
      const stepperHeight = $(stepper.value).outerHeight(true);
      const screenHeight = $(container.value).outerHeight(true); // Ambil tinggi layar
      if (stepperHeight > screenHeight) {
        const stepperEl = stepper.value;
        scale.value = 300 * 0.8; // Sesuaikan skala berdasarkan tinggi
        stepperEl.scrollIntoView({ behavior: "smooth", block: "center" });
      } else {
        scale.value = 300 * 1; // Jika cukup, gunakan ukuran normal
      }
    }, 200);
  });
};

const next = () => {
  if (isStepValid()) {
    showError.value = false;
    step.value++;
    scaleView();
  } else {
    showError.value = true;
  }
};

// Ambil parameter
const getCheckParameters = () => {
  store
    .ajax(
      {
        toolId: props.tool.toolId,
        sessionId: store.sessionId,
      },
      "tool/dailycheckinit",
      "post"
    )
    .then(async (e) => {
      parameters.value = e.pointChecks;
      result.value = await Promise.all(
        e.pointChecks.map((item) => {
          item.judegement = "";
          item.methods.forEach((element, index) => {
            element.value = "";
            let myMethods = {
              standard: element.standard,
              methodId: element.methodId,
              methodString: element.methodString,
              resultType: element.resultType,
              pointString: "Kalibrasi",
              pointNumber: 0,
              value: "",
              judgement: "",
            };

            item.methods[index] = myMethods;
          });
          let inspectionData = {
            pointNumber: item.pointNumber,
            checkId: item.checkId,
            pointString: item.pointString,
            methods: item.methods,
          };
          return inspectionData;
        })
      );
    });
};

const setValue = (e, methodId) => {
  const typeOf = typeof e;
  if (typeOf == "object") {
    e = e.target.value;
  }

  result.value.forEach((res, index) => {
    res.methods.forEach((method, ind) => {
      if (methodId == method.methodId) {
        const paramIndex = parameters.value.findIndex(
          (param) => res.checkId == param.checkId
        );

        method.value = e;
        result.value[index].methods[ind] = method;

        const standard = JSON.parse(method.standard);
        const r = store.validateMeasurement(standard.name, e, standard.arg);

        result.value[index].methods[ind].judgement = r ? "OK" : "NG";
        parameters.value[paramIndex].methods[ind].judgement = r ? "OK" : "NG";
        if (!r) {
          const exists = notGodArr.value.some(
            (f) => f.methodId === result.value[index].methods[ind].methodId
          );
          if (!exists) {
            notGodArr.value.push(result.value[index].methods[ind]);
          }
        } else {
          const itemIndex = notGodArr.value.findIndex(
            (f) => f.methodId === result.value[index].methods[ind].methodId
          );
          if (itemIndex !== -1) {
            notGodArr.value.splice(itemIndex, 1);
          }
        }
      }
    });
  });
};

const finish = async () => {
  store
    .ajax({ sessionId: store.sessionId }, "auth/getmydata", "post")
    .then((e) => {
      const NG = notGodArr.value.length > 0;
      inspectionData.value = {
        checkDate: props.inspectionDate,
        judgement: NG ? "NG" : "OK",
        checker: e.userId,
        checkerName: e.userName,
        toolId: props.tool.toolId,
        instData: result.value,
      };
      confirmDialog.value = true;
    });
};

const submitReport = () => {
  store
    .ajax(inspectionData.value, "tool/dailychecksubmit", "post")
    .catch((error) => {
      store.alert.fire(error);
    })
    .then(() => {
      props.closeDialog();
    });
};

onMounted(() => {
  getCheckParameters();
  scaleView();
});
</script>
