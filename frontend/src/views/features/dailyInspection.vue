<template>
  <div class="w-100 pa-2 d-flex justify-center align-center h-100">
    <v-card
      class="w-100 h-100"
      title="DAILY CONTROL"
      subtitle="Daily Inspection Tool Control"
    >
      <template v-slot:append>
        <v-text-field
          append-inner-icon="mdi-calendar"
          v-model="date"
          variant="outlined"
          rounded="pill"
          type="date"
          label="Date"
          hide-details
          density="compact"
        />
      </template>
      <v-card-text>
        <v-divider class="mb-3"></v-divider>
        <v-data-table
          items-per-page="25"
          :headers="headers"
          :items="tools"
          :search="search"
        >
          <template v-slot:top>
            <v-row>
              <v-col cols="8">
                <h1 class="text-h5">Tool List</h1>
              </v-col>
              <v-col cols="4">
                <v-text-field
                  label="Search tools"
                  variant="outlined"
                  rounded="pill"
                  v-model="search"
                  hide-details
                  density="compact"
                >
                </v-text-field
              ></v-col>
            </v-row>
          </template>
          <template v-slot:item.toolId="{ item }">
            <v-btn-group
              rounded="pill"
              density="compact"
              class="w-100"
              v-if="item.instData.length < 1"
            >
              <v-btn
                @click="checkTool(item)"
                class="w-50"
                color="primary"
                prepend-icon="mdi-check"
              >
                Check
              </v-btn>
              <v-btn
                class="w-50"
                color="grey-lighten-2"
                prepend-icon="mdi-check"
                @click="unusedIit(item)"
              >
                Not Used
              </v-btn>
            </v-btn-group>
            <div v-else>
              <v-btn
                block
                rounded="pill"
                v-if="item.instData[0].judgement == 'OK'"
                color="success"
                dark
                >CHEKED: OK</v-btn
              >
              <v-btn
                block
                rounded="pill"
                v-if="item.instData[0].judgement == 'NG'"
                color="error"
                dark
                >CHEKED: ng</v-btn
              >
              <v-btn
                block
                rounded="pill"
                v-if="item.instData[0].judgement == 'NOT USED'"
                color="grey-lighten-2"
                dark
                >NOT USED</v-btn
              >
            </div>
          </template>
          <template v-slot:item.instData="{ item }">
            <VBtn
              disabled
              rounded="pill"
              color="primary"
              block=""
              v-if="item.instData.length > 0"
            >
              {{ item.instData[0].checker ? item.instData[0].checker : "" }}
            </VBtn>
            <VBtn rounded="pill" block disabled="" v-else>UNCHECKED</VBtn>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>
    <v-dialog
      ref="container"
      v-model="checkDialog"
      scrollable
      fullscreen
      persistent
      :overlay="true"
      transition="dialog-transition"
    >
      <v-card
        :title="`CHECKING ${selectedTool.toolName.toUpperCase()} - ${selectedTool.registerNumber.toUpperCase()}`"
      >
        <template v-slot:append>
          <v-btn @click="closeCheck" flat icon>
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </template>

        <v-card-text>
          <DailyCheck
            :inspection-date="date"
            :container-height="containerHeight"
            :tool="selectedTool"
            :close-dialog="closeCheck"
          >
          </DailyCheck>
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-dialog
      v-model="unuseDialog"
      scrollable
      persistent
      :overlay="false"
      max-width="500px"
      transition="dialog-transition"
    >
      <v-card rounded="xl" subtitle="Please confirm your action.">
        <template v-slot:title>
          <div class="text-wrap">
            {{
              `You are going to mark ${selectedItem.toolName.toUpperCase()} - ${selectedItem.registerNumber.toUpperCase()} unused.`
            }}
          </div>
        </template>
        <template v-slot:prepend>
          <v-icon size="50" color="warning">mdi-help</v-icon>
        </template>
        <v-card-text>
          <v-divider class="mb-3"></v-divider>
          <v-row>
            <v-col cols="6">
              <v-btn
                block
                variant="outlined"
                rounded="pill"
                prepend-icon="mdi-arrow-u-left-bottom"
                @click="unuseDialog = false"
                >cancel</v-btn
              >
            </v-col>
            <v-col cols="6">
              <v-btn
                block
                variant="outlined"
                rounded="pill"
                color="error"
                prepend-icon="mdi-delete"
                @click="unuseIt"
                >Yes</v-btn
              >
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>
<script setup>
import DailyCheck from "@/components/dialogs/checks/dailyCheck.vue";
import { useAppStore } from "@/store/app";
import moment from "moment";
import { nextTick, onBeforeMount, ref, watch } from "vue";

const search = ref("");
const checkDialog = ref(false);
const tools = ref([]);
const store = useAppStore();
const selectedTool = ref(null);
const container = ref(null);
const containerHeight = ref();
const unuseDialog = ref(false);
const selectedItem = ref(null);

const dd = new Date();
const date = ref(moment(dd).format("YYYY-MM-DD"));

const headers = [
  {
    key: "toolName",
    title: "Tool Name",
  },
  {
    key: "registerNumber",
    title: "Register Number",
  },
  {
    key: "instData",
    title: "Checker",
    align: "center",
    sortable: false,
  },
  {
    key: "toolId",
    title: "Actions",
    align: "center",
    sortable: false,
  },
];

const refresh = async () => {
  tools.value = await store.ajax({ date: date.value }, "tool", "post");
  store.preload = false;
};

const checkTool = (tool) => {
  selectedTool.value = tool;
  nextTick().then(() => {
    checkDialog.value = true;

    containerHeight.value = container.value?.$el.clientHeight;
  });
};

watch(date, () => {
  refresh();
});

const closeCheck = () => {
  refresh();
  nextTick().finally(() => {
    checkDialog.value = false;
  });
};

onBeforeMount(() => {
  refresh();
});

const unusedIit = (item) => {
  selectedItem.value = item;
  nextTick().finally(() => {
    unuseDialog.value = true;
  });
};

const unuseIt = () => {
  store
    .ajax({ sessionId: store.sessionId }, "auth/getmydata", "post")
    .then((e) => {
      const inspectionData = {
        checkDate: date.value,
        judgement: "NOT USED",
        checker: e.userId,
        toolId: selectedItem.value.toolId,
        instData: "[]",
      };

      console.log(inspectionData);
      store
        .ajax(inspectionData, "tool/dailychecksubmit", "post")
        .catch((error) => {
          store.alert.fire(error);
        })
        .then(() => {
          refresh();
          unuseDialog.value = false;
        });
    });
};
</script>
