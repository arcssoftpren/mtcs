<template>
  <v-row>
    <v-col
      class="ma-0 py-1"
      v-for="(item, index) in formStructure"
      :key="index"
      :cols="item.col"
    >
      <v-text-field
        :error-messages="
          validator[index]
            ? validator[index].$errors.map((e) => e.$message)
            : ''
        "
        density="compact"
        variant="outlined"
        rounded="pill"
        v-if="item.textfied"
        :type="item.type"
        :label="item.label"
        :hint="item.hint"
        :readonly="item.readonly"
        v-model="formData[index]"
      />
      <div v-else>
        <v-textarea
          :error-messages="
            validator[index]
              ? validator[index].$errors.map((e) => e.$message)
              : ''
          "
          variant="outlined"
          rounded="xl"
          v-if="item.type == 'textarea'"
          :label="item.label"
          :hint="item.hint"
          v-model="formData[index]"
          no-resize=""
          max-rows="3"
          rows="3"
        />
        <div v-else>
          <v-divider v-if="item.type == 'btnGroup'" class="my-5"
            >Finding Type</v-divider
          >
          <v-btn-toggle
            v-if="item.type == 'btnGroup'"
            density="compact"
            variant="outlined"
            rounded="pill"
            mandatory
            v-model="formData[index]"
            class="w-100"
          >
            <v-btn class="w-50" color="primary" value="Calibration"
              >Calibration Finding</v-btn
            >
            <v-btn class="w-50" color="primary" value="Daily Finding"
              >Daily Finding</v-btn
            >
          </v-btn-toggle>
          <v-select
            class="text-capitalize"
            item-value="divName"
            item-title="divName"
            v-if="item.type == 'select'"
            hide-details=""
            density="compact"
            variant="outlined"
            rounded="pill"
            :items="item.items"
            v-model="formData[index]"
            :label="item.label"
          />

          <v-divider v-if="item.type == 'btnGroup'" class="my-5"
            >Finding Data</v-divider
          >
        </div>
      </div>
    </v-col>
  </v-row>
  <v-divider class="my-3"></v-divider>
  <v-row>
    <v-col cols="6" md="">
      <v-btn
        density="compact"
        variant="outlined"
        rounded="pill"
        block
        prepend-icon="mdi-arrow-u-left-bottom"
        @click="closeModal"
        >Cancel</v-btn
      >
    </v-col>
    <v-col cols="6" md="">
      <v-btn
        density="compact"
        variant="outlined"
        rounded="pill"
        block
        color="success"
        @click="submit"
        >submit</v-btn
      >
    </v-col>
  </v-row>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import useVuelidate from "@vuelidate/core";
import { helpers, required } from "@vuelidate/validators";
import moment from "moment";
import { onMounted, reactive, ref } from "vue";

const getData = (id) => {
  const lastCalibrationDate = toolData.find((e) => e.columId === id);
  if (lastCalibrationDate) {
    return lastCalibrationDate.dataValue;
  } else {
    return "";
  }
};

const props = defineProps(["tool", "report", "closeModal", "finishReport"]);
const toolData = props.tool.data;
const store = useAppStore();
const formData = reactive({
  reportId: "",
  founderPIC: "",
  founderAuthor: "",
  reportType: props.report ? "Daily Finding" : "Calibration",
  abnormalDetail: "",
  findingDate: props.report
    ? moment(props.report.checkDate).format("YYYY-MM-DD")
    : moment(new Date()).format("YYYY-MM-DD"),
  toolName: props.tool.toolName,
  toolId: props.tool.toolId,
  regNumber: props.tool.registerNumber,
  place: getData(8),
  userDiv: "",
  lastCalibrationDate: getData(11),
  cause: "",
  countermeasure: "",
  handlingOfProduct: "",
  handlingOfTool: "",
  handlingNote: "",
  handlingPIC: "",
  handlingAuthor: "",
  confirmator: "",
  confirmationNote: "",
  approvalPIC: "",
  approvalAuthor: "",
  approvalNote: "",
});

const formStructure = reactive({
  reportType: {
    label: "Report Type",
    hint: "Please select report",
    textfied: false,
    type: "btnGroup",
    col: 12,
  },
  findingDate: {
    label: "Finding Date",
    hint: "Please select a date",
    textfied: true,
    type: "date",
    readonly: false,
    col: 6,
  },
  place: {
    label: "Tool Place",
    hint: "Please input a place",
    textfied: true,
    type: "text",
    readonly: true,
    col: 6,
  },
  toolName: {
    label: "Tool Name",
    hint: "Please input a place",
    textfied: true,
    type: "text",
    readonly: true,
    col: 6,
  },
  userDiv: {
    label: "User Department",
    hint: "Please input a department",
    textfied: false,
    type: "select",
    readonly: false,
    col: 6,
    items: [],
  },
  regNumber: {
    label: "Register Number",
    hint: "Please input a reg. number",
    textfied: true,
    type: "text",
    readonly: true,
    col: 6,
  },
  lastCalibrationDate: {
    label: "Last Calibration date",
    hint: "Please input a date",
    textfied: true,
    type: "date",
    readonly: true,
    col: 6,
  },
  abnormalDetail: {
    label: "Abnormality Description",
    hint: "Please provide a clear description of the abnormality",
    type: "textarea",
    col: 12,
  },
  cause: {
    label: "Abnormality Cause",
    hint: "Please provide a the cause of the abnormality",
    type: "textarea",
    col: 12,
  },
  countermeasure: {
    label: "Countermeasure",
    hint: "Please provide a the canuntermeasure for the abnormality",
    type: "textarea",
    col: 12,
  },
});

const rules = {
  userDiv: {
    req: helpers.withMessage("Please provide a department", required),
  },
  findingDate: {
    req: helpers.withMessage("Please provide a date", required),
  },
  abnormalDetail: {
    req: helpers.withMessage("Please provide a description", required),
  },
  cause: {
    req: helpers.withMessage("Please provide a cause", required),
  },
  countermeasure: {
    req: helpers.withMessage("Please provide a countermeasure", required),
  },
};

const validator = useVuelidate(rules, formData);

const submit = async () => {
  try {
    const valid = await validator.value.$validate();
    if (!valid) {
      throw {
        title: "Invalid input",
        text: "Please check your input!",
        icon: "error",
        timer: 3000,
      };
    }
    store
      .ajax({ sessionId: store.sessionId }, "auth/getmydata", "post")
      .then((e) => {
        formData.founderPIC = e.userId;
        store
          .ajax(formData, "tool/abnormalreportinit", "post")
          .then(props.finishReport());
      });
  } catch (error) {
    store.alert(error);
  }
};

onMounted(async () => {
  formStructure.userDiv.items = await store.ajax(
    {},
    "auth/getdivisions",
    "post"
  );
});
</script>
