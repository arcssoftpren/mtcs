<template>
  <v-toolbar color="grey-darken-3" class="toolbar">
    <template v-slot:append>
      <v-btn flat icon color="" @click="closeModal()">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-row no-gutters>
      <v-col cols="2" class="ps-2">
        <v-text-field
          label="Document Number"
          v-model="docNumber"
          density="compact"
          hide-details
          variant="outlined"
          rounded="pill"
        >
        </v-text-field>
      </v-col>
      <v-col cols="3" offset="4">
        <v-text-field
          hide-details
          density="compact"
          variant="outlined"
          rounded="pill"
          v-model="fileNameTemplate"
          label="Nama File (gunakan [regNum], [month])"
        />
      </v-col>
      <v-col cols="3">
        <v-slider
          hide-details
          :max="2"
          :min="0.5"
          v-model="zoom"
          :step="0.05"
          label="Zoom"
          prepend-icon="mdi-magnify-minus"
          append-icon="mdi-magnify-plus"
          color="white"
          @mousedown="zoomSize = true"
          @mouseup="zoomSize = false"
        >
        </v-slider>
      </v-col>
    </v-row>
  </v-toolbar>

  <!-- Scrollable Area -->
  <div class="scrollContainer">
    <div
      class="scaledContainer"
      :style="{
        width: `${420 * zoom}mm`,
        height: `${297 * zoom}mm`,
      }"
    >
      <div v-if="zoomSize" class="position-fixed zoom-size">
        {{ (zoom * 100).toFixed(0) }}%
      </div>
      <div
        ref="printA"
        class="paperArea pa-5"
        :style="{
          transform: `scale(${zoom})`,
          transformOrigin: 'top left',
          fontFamily: selectedFont,
        }"
      >
        <div>({{ docNumber }})</div>
        <v-row>
          <v-col cols="9">
            <table class="mt-2">
              <thead>
                <tr>
                  <th>
                    <v-img width="1.8cm" src="@/assets/logo2.png"> </v-img>
                  </th>
                  <th class="text-no-wrap logo-text">
                    PT. SOFTPREN INDUSTRIES <br />
                    INDONESIA
                  </th>
                  <th class="text-capitalize doc-title">
                    <div class="w-100 text-center">
                      Lembar Pemeriksaan Harian Alat Ukur
                      {{ pdfData.rankName.toLowerCase() }}
                    </div>
                  </th>
                </tr>
              </thead>
            </table>

            <table class="ma-2 tableHeader">
              <tbody>
                <tr>
                  <td width="200px">MODEL / TYPE</td>
                  <td>:</td>
                  <td width="250px">
                    <strong>{{ pdfData.toolName }}</strong>
                  </td>
                  <td width="200px">AREA</td>
                  <td>:</td>

                  <td width="250px">
                    <strong>{{
                      pdfData.toolData.find((e) => e.columId == 8).dataValue
                    }}</strong>
                  </td>
                </tr>
                <tr>
                  <td width="200px">NO. CONTROL / NO. SERI</td>
                  <td>:</td>
                  <td width="250px">
                    <strong>{{ pdfData.registerNumber }}</strong>
                  </td>
                  <td width="200px">PERIODE BULAN/ TAHUN</td>
                  <td>:</td>

                  <td width="250px">
                    <strong>
                      {{ month.format("MMMM YYYY") }}
                    </strong>
                  </td>
                </tr>
              </tbody>
            </table>
          </v-col>
          <v-col cols="3">
            <table class="inspectionTable">
              <thead>
                <tr>
                  <th>Checked By</th>
                  <th>Approved By</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="approvalSign">
                    <div class="w-100 text-center d-flex justify-center">
                      <div style="width: 47px">
                        <v-img :src="pdfData.monthlyData.file" />
                      </div>
                    </div>
                  </td>
                  <td class="approvalSign"></td>
                </tr>
                <tr>
                  <td class="text-center">
                    {{ pdfData.monthlyData.userName }}
                  </td>
                  <td></td>
                </tr>
              </tbody>
            </table>
          </v-col>
        </v-row>
        <table class="inspectionTable" cellspacing="0" cellpadding="5">
          <thead>
            <tr>
              <th rowspan="2" class="text-center" width="30px">No.</th>
              <th rowspan="2">POINT CHECK</th>
              <th rowspan="2">CHECK METHOD</th>
              <th :colspan="datesArr.length">TANGGAL</th>
            </tr>
            <tr>
              <!-- Generate tanggal 1–31 -->
              <!-- Bisa pakai loop kalau di Vue/JS -->
              <th
                :style="{ width: `${68 / datesArr.length}%` }"
                v-for="(item, index) in datesArr"
                :key="index"
              >
                {{ item.format("D") }}
              </th>
            </tr>
          </thead>
          <tbody>
            <template v-for="(param, t) in parameters" :key="t">
              <tr v-for="(method, i) in param.methods" :key="i">
                <td
                  class="text-center"
                  v-if="i === 0"
                  :rowspan="param.methods.length"
                >
                  {{ t + 1 }}
                </td>
                <td
                  class="text-no-wrap"
                  v-if="i === 0"
                  :rowspan="param.methods.length"
                >
                  {{ param.pointString }}
                </td>
                <td>{{ method.methodString }}</td>
                <td
                  class="text-center"
                  v-for="(date, index) in datesArr"
                  :key="index"
                >
                  <strong
                    :style="{
                      color: `${
                        getResult(date, param, method).judgement
                          ? 'black'
                          : 'red'
                      }`,
                    }"
                  >
                    {{ getResult(date, param, method).value }}
                  </strong>
                  <!-- <div>O</div>
                  <div>X</div>
                  <div>
                    <v-icon>mdi-close-circle-outline</v-icon>
                  </div>
                  <div>-</div> -->
                </td>
              </tr>
            </template>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="3">Daily Check by Operator</td>
              <td
                class="text-center"
                v-for="(date, index) in datesArr"
                :key="index"
              >
                <v-img height="30px" :src="getSign(date)"></v-img>
              </td>
            </tr>
            <tr>
              <td colspan="3">Weekly checked by (GL/SPV/Mgr)</td>

              <template v-for="(item, index) in getWeeklyData()" :key="index">
                <td :colspan="item.length">
                  <div class="w-100 text-center d-flex justify-center">
                    <div style="width: 20px">
                      <v-img :src="item.signfile"></v-img>
                    </div>
                  </div>
                </td>
              </template>
            </tr>
          </tfoot>
        </table>
        <div class="docFooter mt-2">
          <v-row class="font-weight-bold text-center mb-0">
            <v-col cols="3" class="mb-0 pb-0"> O : OK </v-col>
            <v-col cols="3" class="mb-0 pb-0"> X : NG </v-col>
            <v-col cols="3" class="mb-0 pb-0">
              <v-icon>mdi-close-circle-outline</v-icon> : Repaired
            </v-col>
            <v-col cols="3" class="mb-0 pb-0"> - : Not Used </v-col>
          </v-row>
          <v-row class="mt-0">
            <v-col cols="4">
              <v-img :src="pdfData.file" />
            </v-col>
            <v-col cols="8" style="font-size: 10pt">
              <div class="mb-2">
                ATURAN PENGECEKAN
                <div>
                  1. Operator melakukan pengecekan setiap hari sebelum memulai
                  pekerjaan.
                </div>
                <div>
                  2. Operator harus memberi tanda garis (-) pada hari tersebut
                  jika alat ukur tidak digunakan (mesin tidak berproduksi atau
                  hari libur).
                </div>
                <div>
                  3. Operator wajib melaporkan kepada atasan jika menemukan
                  hasil pengecekan yang NG.
                </div>
                <div>
                  4. Jika alat ukur jatuh, operator harus mengembalikannya
                  kepada atasan quality untuk dicek kelayakannya.
                </div>
                <div>
                  5. Atasan departement penanggung jawab (GL/SPV/Mgr) melakukan
                  pengecekan sekali setiap minggu.
                </div>
                <div>
                  6. Atasan departemen penanggung jawab (GL/SPV/Mgr)
                  menandatangani kolom checked dan menyerahkannya check sheet ke
                  QC Dep setiap akhir bulan.
                </div>
              </div>
              <div>
                <table
                  class="inspectionTable"
                  style="font-size: 10pt !important"
                >
                  <thead>
                    <tr>
                      <th rowspan="3">No</th>
                      <th colspan="4">Catatan Perbaikan / Masalah</th>
                    </tr>
                    <tr>
                      <th colspan="2">Pengguna</th>
                      <th colspan="2">QC Dep</th>
                    </tr>
                    <tr>
                      <th>Tanggal</th>
                      <th>Masalah</th>
                      <th>Tindakan Perbaikan</th>
                      <th>Approved By</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr
                      v-for="(item, index) in abnormalArr"
                      :key="index"
                      style="height: 20pt"
                    >
                      <td class="text-center">{{ item.number }}</td>
                      <td class="text-center">
                        {{
                          moment(item.findingDate).format("DD/MM/YYYY") ==
                          "Invalid date"
                            ? ""
                            : moment(item.findingDate).format("DD/MM/YYYY")
                        }}
                      </td>
                      <td class="text-center">{{ item.abnormalDetail }}</td>
                      <td class="text-center">{{ item.countermeasure }}</td>
                      <td class="text-center">{{ item.approvalPIC }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </v-col>
          </v-row>
        </div>
      </div>
    </div>
  </div>
  <v-btn-group
    class="position-fixed"
    style="bottom: 10px; right: 20px; width: 200px"
    rounded="pill"
    density="compact"
  >
    <v-btn
      color="primary"
      icon="mdi-printer"
      class="w-50"
      @click="print(false)"
    ></v-btn>
    <v-btn
      color="black"
      icon="mdi-download"
      class="w-50"
      @click="print(true)"
    ></v-btn>
  </v-btn-group>
</template>

<script setup>
import { useAppStore } from "@/store/app";
import moment from "moment";
import { nextTick, onMounted, reactive, ref, watch } from "vue";
import jsPDF from "jspdf";
import html2canvas from "html2canvas";
defineProps(["closeModal"]);
const pdfData = useAppStore().pdfdata.data;
const store = useAppStore();
const zoom = ref(0.65);
const zoomSize = ref(false);
const docNumber = ref("Format-I7603-001");
const selectedFont = ref("MS PGothic");
const month = moment(pdfData.monthlyData.month);
const datesArr = ref([]);
const parameters = ref([]);
const fonts = ref([
  "Arial",
  "Courier New",
  "Georgia",
  "Times New Roman",
  "Verdana",
  "Tahoma",
  "Comic Sans MS",
  "MS PGothic",
]);
const printA = ref();
const paper = ref("a3");
const fileNameTemplate = ref("Daily_control_[regNum]_[month]");

const paperSize = reactive({
  a3: {
    w: 420,
    h: 297,
  },
  a4: {
    w: 297,
    h: 210,
  },
});

const abnormalArr = ref(
  Array(5).fill({
    number: "",
    abnormalDetail: "",
    countermeasure: "",
    approvalPIC: "",
    findingDate: "",
  })
);

const print = async (save) => {
  store.preload = true;
  await nextTick();
  setTimeout(() => {
    zoom.value = 2;
    html2canvas(printA.value, {
      scale: 5,
      allowTaint: false,
    }).then((canvas) => {
      const imgData = canvas.toDataURL("image/jpeg");
      const pdf = new jsPDF({
        // Unit pengukuran: mm, pt, in, px
        orientation: "landscape", // Bisa "portrait" atau "landscape"
        format: paper.value,
        unit: "mm",
      });
      pdf.addImage(
        imgData,
        "PNG",
        2.5,
        0,
        paperSize[paper.value].w,
        paperSize[paper.value].h
      );
      // Simpan sebagai Blob
      const pdfBlob = pdf.output("blob");

      // Buat URL dari Blob
      const pdfUrl = URL.createObjectURL(pdfBlob);
      if (save) {
        pdf.save(parseFileName(pdfData.registerNumber, month));
      } else {
        window.open(pdfUrl, "_blank");
      }
      zoom.value = 0.65;
      store.preload = false;
    });
  }, 500);
};

watch(zoom, () => {
  if (!zoomSize.value) {
    zoomSize.value = true;
    setTimeout(() => {
      zoomSize.value = false;
    }, 200);
  }
});
function parseFileName(registerNumber, monthDayjs) {
  const monthFormatted = monthDayjs.format("MMMM-YYYY"); // misalnya: April_2025
  return fileNameTemplate.value
    .replace(/\[regNum\]/gi, registerNumber)
    .replace(/\[month-year\]/gi, monthFormatted);
}

const getParams = () => {
  store
    .ajax(
      {
        toolId: pdfData.toolId,
        sessionId: store.sessionId,
      },
      "tool/dailycheckinit",
      "post"
    )
    .then(async (e) => {
      parameters.value = e.pointChecks;
    });

  store
    .ajax({ configKey: "montlyCheckDocNumber" }, "auth/getconfig", "post")
    .then((e) => {
      docNumber.value = e;
    });

  store
    .ajax(
      { configKey: "dailyControlFileNameTemplate" },
      "auth/getconfig",
      "post"
    )
    .then((e) => {
      fileNameTemplate.value = e;
    });
};

watch(docNumber, async (configValue) => {
  await store.ajax(
    { configValue, configKey: "montlyCheckDocNumber" },
    "auth/setconfig",
    "post"
  );
  store.preload = false;
});

watch(fileNameTemplate, async (configValue) => {
  await store.ajax(
    { configValue, configKey: "dailyControlFileNameTemplate" },
    "auth/setconfig",
    "post"
  );
  store.preload = false;
});

const refresh = () => {
  getParams();
  pdfData.abnormals.map((e, index) => {
    e.number = index + 1;
    abnormalArr.value[index] = e;
  });
};

const getDates = () => {
  const daysInMonth = month.daysInMonth();
  let dates = [];

  for (let day = 1; day <= daysInMonth; day++) {
    dates.push(moment(month).date(day));
  }

  return dates;
};

const getWeeklyData = () => {
  const data = pdfData.weeklyData;
  let arr = data.map((d) => {
    d.length = getDaysInMonthWeek(d.weekCode);
    d.dailyData = [];
    return d;
  });
  return arr;
};

onMounted(() => {
  datesArr.value = getDates();
  refresh();
});

const getResult = (date, point, method) => {
  let response = {
    judgement: "",
    value: "",
  };
  date = date.format("YYYY-MM-DD");
  const filtered = pdfData.dailyData.find(
    (e) => moment(e.checkDate).format("YYYY-MM-DD") == date
  );
  if (filtered) {
    if (filtered.judgement != "NOT USED" && filtered.judgement != "REPAIRED") {
      const p = filtered.instData.find((e) => e.checkId == point.checkId);
      const m = p?.methods.find((e) => e.methodId == method.methodId);

      switch (m.judgement) {
        case "OK":
          if (m.resultType == 1) {
            response.judgement = true;
            response.value = "O";
          } else {
            response.judgement = true;
            response.value = m.value;
          }
          break;
        case "NG":
          if (m.resultType == 1) {
            response.judgement = false;
            response.value = "X";
          } else {
            response.judgement = false;
            response.value = m.value;
          }
      }
    } else if (filtered.judgement == "NOT USED") {
      response.judgement = true;
      response.value = "-";
    }
  } else {
    response.judgement = true;
    response.value = "";
  }
  return response;
};

const getSign = (date) => {
  const myData = pdfData.dailyData.find(
    (e) => moment(e.checkDate).format("YYYY-MM-DD") == date.format("YYYY-MM-DD")
  );
  return myData?.fileBase64;
};

const getDaysInMonthWeek = (weekCode) => {
  {
    const [year, week] = weekCode.split("-W").map(Number);
    const [targetYear, targetMonth] = month
      .format("YYYY-MM")
      .split("-")
      .map(Number);

    const daysInWeek = [];

    // Cari hari pertama dari minggu ISO (Senin)
    const startOfWeek = getDateOfISOWeek(week, year);

    for (let i = 0; i < 7; i++) {
      const day = new Date(startOfWeek);
      day.setDate(day.getDate() + i);
      if (
        day.getFullYear() === targetYear &&
        day.getMonth() + 1 === targetMonth
      ) {
        daysInWeek.push(day);
      }
    }

    return daysInWeek.length;
  }
};

const getDateOfISOWeek = (week, year) => {
  const simple = new Date(year, 0, 1 + (week - 1) * 7);
  const dayOfWeek = simple.getDay();
  const ISOWeekStart = simple;

  if (dayOfWeek <= 4) {
    ISOWeekStart.setDate(simple.getDate() - simple.getDay() + 1); // Senin
  } else {
    ISOWeekStart.setDate(simple.getDate() + 8 - simple.getDay()); // Senin minggu berikut
  }

  return ISOWeekStart;
};
</script>

<style scoped>
.toolbar {
  position: sticky;
  top: 0;
  z-index: 10;
}

.zoom-size {
  right: 10px;
  top: 67px;
  font-size: xx-large;
}

.scrollContainer {
  height: calc(100vh - 64px);
  overflow: auto;
  background: #f0f0f0;

  display: flex;
  justify-content: center;
  align-items: flex-start;

  padding: 50px 0;
}

.scaledContainer {
  position: relative;
}

.logo-text {
  text-decoration: underline;
  color: #2e75b6;
  font-size: 12pt;
}

/* Halaman */
.paperArea {
  width: 420mm;
  height: 297mm;
  border: 1px solid black;
  background-color: white;
  position: absolute;
  top: 0;
  left: 0;
}

.doc-title {
  font-size: 26pt;
  width: 100%;
}
.approval-table {
  border-collapse: collapse;
}

.approval-table td {
  border: 1px, solid;
  padding: 5px;
}

.approval-table th {
  border: 1px, solid;
  padding: 10px;
}
.approvalSign {
  height: 80px;
}

.inspectionTable th {
  border: 1px, solid;
  padding: 0.5px;
  padding-left: 5px;
  padding-right: 5px;
}
.inspectionTable td {
  border: 1px, solid;
  padding: 0.5px;
  padding-left: 5px;
  padding-right: 5px;
}

.inspectionTable thead {
  border-bottom: double;
}

.inspectionTable {
  border-collapse: collapse;
  width: 100%;
  font-size: 11pt;
}
</style>
