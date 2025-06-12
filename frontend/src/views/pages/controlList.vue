<template>
  <div class="ma-2">
    <div class="d-flex w-100 fill-height">
      <div
        ref="scroller"
        :style="`width:1500px!important;height:768px!important;
  overflow-x: auto;
  overflow-y: auto;`"
      >
        <div
          ref="printA"
          class="a3 pa-6"
          :style="{
            transform: `scale(${scale})`,
            fontFamily: selectedFont,
          }"
        >
          <v-row class="pa-0 ma-0">
            <v-col cols="9" class="pa-0 ma-0">
              <div
                class="text-capitalize"
                :style="`font-size:${
                  fontSize * 2
                }pt!important;margin-bottom:${fontSize}pt`"
              >
                Inspection Tool Control List
                {{ selectedRank.rankName }}
                <br />
                {{ selectedRank.rankNameJp }}計測器管理台帳
              </div>
              <div
                :style="`font-size:${
                  fontSize * 1.3
                }pt!important;margin-bottom:${fontSize}pt`"
              >
                {{ selectedRank.description }}
              </div>
              <div class="" :style="`font-size:${fontSize * 1.2}pt!important`">
                Date of Issue : {{ issuedD.format("DD/MMM/YYYY") }}
              </div>
            </v-col>
            <v-col cols="3" class="pa-0 ma-0">
              <v-img src="../../assets/image.png"> </v-img>
            </v-col>
          </v-row>

          <div class="mt-2">
            <table
              ref="myTable"
              class="itc_table text-no-wrap"
              :style="{ fontSize: fontSize + 'px' }"
            >
              <thead>
                <tr>
                  <th>No</th>
                  <th class="borderLeft">Equipment Name <br />機器名称</th>
                  <th class="borderLeft">
                    Regis No.<br />
                    機種固有Ｎo.
                  </th>
                  <th
                    class="borderLeft text-wrap"
                    v-for="(item, index) in collumns"
                    :key="index"
                    v-show="selectedCol.includes(item.collumnId)"
                  >
                    <div>
                      {{ item.collumnEnString }} <br />
                      <div class="text-no-wrap">
                        {{ item.columnJpString }}
                      </div>
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody :style="{ fontSize: fontSize + 1 + 'px' }">
                <tr
                  class="borderLeft"
                  v-for="(item, index) in selectedTools"
                  :key="index"
                >
                  <td class="text-center">{{ index + 1 }}</td>
                  <td class="text-no-wrap">{{ item.toolName }}</td>
                  <td class="text-no-wrap">{{ item.registerNumber }}</td>
                  <td
                    class="text-center text-no-wrap"
                    v-for="(itm, i) in collumns"
                    :key="i"
                  >
                    {{ getValue(item, itm) }}
                  </td>
                </tr>

                <tr v-for="(item, index) in empty" :key="index">
                  <td class="text-white"></td>
                  <td class="text-no-wrap text-white">""</td>
                  <td class="text-no-wrap text-white">""</td>
                  <td
                    class="text-center text-white"
                    v-for="(itm, i) in selectedCol"
                    :key="i"
                  >
                    ""
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <v-row>
        <v-col cols="12">
          <v-card class="fill-height">
            <v-card-text>
              <v-text-field
                v-model="issued"
                class="my-5"
                variant="outlined"
                rounded="pill"
                density="compact"
                type="date"
                label="Date if Issue"
                hide-details=""
              />

              <v-slider
                class="w-90"
                v-model="scale"
                step="0.01"
                :max="1"
                min="0.65"
                hide-details=""
              >
                <template v-slot:append>
                  <v-btn
                    @click="fitToPage"
                    variant="outlined"
                    rounded="pill"
                    density="compact"
                    prepend-icon="mdi-fit-to-page"
                    color="primary"
                    >fit</v-btn
                  >
                </template>
                <template v-slot:prepend>
                  <v-icon>mdi-magnify</v-icon>
                </template>
              </v-slider>

              <v-text-field
                hide-spin-buttons=""
                type="number"
                variant="outlined"
                class="mt-3"
                v-model="fontSize"
                label="Font Size"
                hide-details=""
              >
                <template v-slot:prepend-inner>
                  <v-icon>mdi-format-size</v-icon>
                </template>
              </v-text-field>
              <div class="d-flex justify-center w-100">
                <v-btn-group density="compact" class="my-5">
                  <v-btn
                    color="transparent"
                    @click="
                      () => {
                        fontSize = Number(fontSize) - 0.5;
                      }
                    "
                  >
                    <v-icon color="error">mdi-format-font-size-decrease</v-icon>
                  </v-btn>
                  <v-btn
                    color="transparent"
                    @click="
                      () => {
                        fontSize = 8;
                      }
                    "
                  >
                    <v-icon color="success">mdi-restart</v-icon>
                  </v-btn>
                  <v-btn
                    @click="
                      () => {
                        fontSize = Number(fontSize) + 0.5;
                      }
                    "
                    color="transparent"
                  >
                    <v-icon color="primary"
                      >mdi-format-font-size-increase</v-icon
                    >
                  </v-btn>
                </v-btn-group>
              </div>
              <v-select
                hide-details=""
                density="compact"
                variant="outlined"
                rounded="pill"
                :items="fonts"
                v-model="selectedFont"
                label="Select Font"
              ></v-select>

              <v-btn
                class="my-5"
                v-for="item in ranks"
                :key="item.rankId"
                :active="selectedRank == item"
                @click="setRank(item)"
                block
                color="primary"
                variant="outlined"
                rounded="pill"
              >
                {{ item.rankName }}
              </v-btn>
            </v-card-text>
            <v-card-actions>
              <v-btn
                prepend-icon="mdi-printer"
                block=""
                variant="outlined"
                rounded="pill"
                color="success"
                @click="print"
              >
                Print
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-col>
      </v-row>
    </div>
  </div>
</template>
<script setup>
import { useAppStore } from "@/store/app";
import jsPDF from "jspdf";
import moment from "moment";
import {
  computed,
  nextTick,
  onBeforeMount,
  onMounted,
  reactive,
  ref,
  watch,
} from "vue";
import html2canvas from "html2canvas";
import $ from "jquery";

const issuedD = ref(moment(new Date()));
const myTable = ref(null);
const fontSize = ref(8);
const paper = ref("a4");
const issued = ref(issuedD.value.format("YYYY-MM-DD"));
const scale = ref(0.5);
const scroller = ref(null);
const tools = ref([]);
const empty = ref([]);
const store = useAppStore();
const ranks = ref([]);
const collumns = ref([]);
const selectedRank = ref({});
const selectedTools = ref([]);
const selectedCol = ref([]);
const printA = ref(null);
const row = ref(22);
const selectedFont = ref("MS PGothic");
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
const factor = row.value / fontSize.value; // Faktor skala dari percobaanmu

const papers = reactive({
  a3: { w: 420, h: 297, s: 1, sc: 1 }, // Perbaiki ukuran A3
  a4: { w: 297, h: 210, s: 1, sc: 1 }, // Perbaiki ukuran A4
});
const getValue = (item, itm) => {
  const data = item.data.find((e) => e.columId == itm.collumnId);
  if (!data) {
    return "-";
  }
  return data.dataValue;
};
const refreshData = async () => {
  ranks.value = await store.ajax({}, "ranks", "post");
  ranks.value = ranks.value.map((r) => {
    r.rankName = r.rankName.toLowerCase();
    return r;
  });
  tools.value = await store.ajax({}, "tool", "post");
  collumns.value = await store.ajax({}, "tool/getcollumn", "post");
  setRank(ranks.value[0]);
};

watch(issued, (e) => {
  issuedD.value = moment(e);
});

const setRank = (rank) => {
  selectedRank.value = rank;
  selectedCol.value = JSON.parse(rank.collumns);
  selectedCol.value = selectedCol.value.map((element) => {
    return Number(element);
  });
  selectedTools.value = tools.value.filter((e) => e.rankId == rank.rankId);

  const l = row.value - selectedTools.value.length;
  empty.value = Array(l).fill("");
};

onBeforeMount(() => {
  refreshData();
});

onMounted(async () => {
  fitToPage();

  $(printA.value).css("height", `${papers[paper.value].h}mm`);
  $(printA.value).css("width", `${papers[paper.value].w}mm`);

  store.preload = false;
});

const fitToPage = async () => {
  scale.value = 0.65;
  const container = scroller.value;
  await nextTick();
  if (container) {
    container.scrollLeft = (container.scrollWidth - container.clientWidth) / 2;
    container.scrollTop = (container.scrollHeight - container.clientHeight) / 2;
  }
};

const rowCount = computed(() => {
  return Math.floor(row.value / (fontSize.value / 8)); // Hitung row berdasarkan skala font
});

watch(fontSize, (newSize) => {
  const l = rowCount.value - selectedTools.value.length;
  empty.value = Array(l).fill("");
  console.log(`Font Size: ${newSize}px, Rows: ${rowCount.value}`);
});

watch(printA, (e) => {
  console.log(e);
});

watch(paper, async () => {
  if (!printA.value) return;
  // Set ukuran elemen sesuai pilihan kertas
  $(printA.value).css({
    height: `${papers[paper.value].h}mm`,
    width: `${papers[paper.value].w}mm`,
  });
  await nextTick();
  fitToPage();
});

const print = async () => {
  store.preload = true;
  await nextTick();
  scale.value = 2;
  await nextTick();
  html2canvas(printA.value, {
    scale: 3,
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
      0,
      0,
      papers[paper.value].w,
      papers[paper.value].h
    );
    // Simpan sebagai Blob
    const pdfBlob = pdf.output("blob");

    // Buat URL dari Blob
    const pdfUrl = URL.createObjectURL(pdfBlob);

    // Buka di tab baru
    window.open(pdfUrl, "_blank");
    fitToPage();
    store.preload = false;
  });
};
</script>

<style scoped>
.a3 {
  -webkit-user-drag: element;
  user-select: none;
  background: white;
  border: 1px solid #ccc; /* Opsional */
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* Opsional */
  margin: auto;
}
.itc_table {
  width: 100% !important;
  border-collapse: collapse; /* Menghilangkan celah antar border */
}

.itc_table th {
  border: 0.5pt solid black !important; /* Pastikan border seragam */
  padding: 5px;
}

.itc_table td {
  border: 0.5pt solid black !important; /* Pastikan border seragam */
  padding: 5px;
}

.borderLeft {
  border-left: 0.5pt solid black !important; /* Pastikan border kiri tidak terputus */
}

td.borderLeft {
  border-left: 0.5pt solid black !important; /* Pastikan border kiri tidak terputus */
}
</style>
