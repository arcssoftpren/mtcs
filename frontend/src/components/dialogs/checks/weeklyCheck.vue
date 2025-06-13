<template>
  <v-card
    rounded="xl"
    :title="`${insData.toolName} [${insData.registerNumber}] Weekly Report`"
  >
    <template v-slot:append>
      <v-btn flat icon @click="closeModal">
        <v-icon>mdi-close</v-icon>
      </v-btn>
    </template>
    <v-card-text>
      <v-table>
        <thead>
          <tr>
            <th>No.</th>
            <th class="text-no-wrap">POINT CHECK</th>
            <th>CHECK METHOD</th>
            <th v-for="day in weekDays" :key="day" class="text-center">
              {{ day }}
            </th>
          </tr>
        </thead>
        <tbody>
          <template v-for="(item, index) in points" :key="index">
            <tr v-for="(method, i) in item.methods" :key="i">
              <td v-if="i === 0" :rowspan="item.methods.length">
                {{ index + 1 }}
              </td>
              <td v-if="i === 0" :rowspan="item.methods.length">
                {{ item.pointString }}
              </td>
              <td>{{ method.methodString }}</td>
              <td
                v-for="(day, index) in weekDays"
                :key="index"
                class="text-center text-no-wrap"
              >
                <v-chip
                  :color="getResult(day, method.methodId, item.checkId).color"
                >
                  {{ getResult(day, method.methodId, item.checkId).text }}
                </v-chip>
                <v-badge
                  @click="
                    reportInit(
                      getResult(day, method.methodId, item.checkId).reports
                    )
                  "
                  v-if="
                    getResult(day, method.methodId, item.checkId).reports
                      .length > 0 &&
                    getResult(day, method.methodId, item.checkId).color == 'red'
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
      <v-divider class="my-3"></v-divider>
      <v-btn
        @click="signReport"
        block
        color="primary"
        v-if="!insData.weeklysign[0]"
        dark
        >Sign Report</v-btn
      >
    </v-card-text>
  </v-card>
  <!-- <v-dialog
    v-model="reportsDialog"
    scrollable
    persistent=""
    max-width="880"
    :overlay="false"
    transition="dialog-transition"
  >
    <v-card title="Abnormality Report Viewer (Read Only)">
      <template v-slot:append>
        <v-btn flat icon @click="reportsDialog = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
      <v-card-text>
        <table
          class="text-center"
          style="font-size: 10pt"
          cellspacing="0"
          cellpadding="5"
        >
          <tbody>
            <tr>
              <td
                colspan="6"
                rowspan="6"
                class="text-start"
                style="font-size: 26pt"
              >
                Laporan Abnormality Alat Ukur
              </td>
              <td colspan="2">Dep. Penemu</td>
            </tr>
            <tr>
              <td
                rowspan="4"
                height="50"
                width="100"
                style="padding: 0px !important"
              >
                <v-img
                  height="45"
                  :src="getSign(report[0].founderAuthor).value"
                >
                </v-img>
              </td>
              <td rowspan="4" width="100" style="padding: 0px !important">
                <v-img height="45" :src="getSign(report[0].founderPIC).value">
                </v-img>
              </td>
            </tr>
            <tr></tr>
            <tr></tr>
            <tr></tr>
            <tr>
              <td class="input">{{ report[0].founderAuthorName }}</td>
              <td class="input">{{ report[0].founderName }}</td>
            </tr>
            <tr>
              <td colspan="8" height="8" style="padding: 0 !important"></td>
            </tr>
            <tr>
              <td width="100" height="100" rowspan="4" class="text-start">
                Deteksi Abnormal Process
              </td>
              <td width="160" colspan="2" rowspan="2" class="text-start input">
                <div>
                  <input
                    type="checkbox"
                    name=""
                    id="kalibrasiCb"
                    :checked="report[0].reportType == 'Calibration'"
                    disabled
                  />
                  <label for="kalibrasiCb" class="ms-1"
                    >Abnormal Kalibrasi</label
                  >
                </div>
              </td>
              <td colspan="5" class="text-start">Detail Temuan Abnormality</td>
            </tr>
            <tr>
              <td colspan="5" rowspan="3" class="text-start input">
                {{ report[0].abnormalDetail }}
              </td>
            </tr>
            <tr>
              <td width="160" colspan="2" rowspan="2" class="text-start input">
                <div>
                  <input
                    disabled
                    :checked="report[0].reportType == 'Daily Finding'"
                    type="checkbox"
                    name=""
                    id="dailyCb"
                  />
                  <label for="dailyCb" class="ms-1"> Pengecekan Harian</label>
                </div>
              </td>
            </tr>
            <tr></tr>
            <tr>
              <td colspan="8" height="8" style="padding: 0 !important"></td>
            </tr>
            <tr>
              <td width="100" height="100" rowspan="3" class="text-start">
                Kejadian Abnormality
              </td>
              <td style="border-right: 0px" class="text-start">
                Tanggal Ditemukan
              </td>
              <td width="12" class="titikDua">:</td>
              <td
                width="200px"
                style="border-left: 0px"
                class="text-start input"
              >
                {{ moment(report[0].findingDate).format("DD/MM/YYYY") }}
              </td>
              <td style="border-right: 0px" class="text-start">
                Tempat digunakan
              </td>
              <td width="12" class="titikDua">:</td>
              <td
                class="text-start input"
                width="200px"
                colspan="2"
                style="border-left: 0px"
              >
                {{ report[0].place }}
              </td>
            </tr>
            <tr>
              <td style="border-right: 0px" class="text-start">
                Nama Alat Ukur
              </td>
              <td width="12" class="titikDua">:</td>
              <td style="border-left: 0px" class="text-start input">
                {{ report[0].toolName }}
              </td>
              <td style="border-right: 0px" class="text-start">Dep Pengguna</td>
              <td width="12" class="titikDua">:</td>
              <td
                style="border-left: 0px"
                width="200px"
                colspan="2"
                class="text-start input"
              >
                {{ report[0].userDiv }}
              </td>
            </tr>
            <tr>
              <td style="border-right: 0px" class="text-start">No. Control</td>
              <td width="12" class="titikDua">:</td>
              <td style="border-left: 0px" class="text-start input">
                {{ report[0].regNumber }}
              </td>
              <td style="border-right: 0px" class="text-wrap text-start">
                Tgl. Kalibrasi Terakhir
              </td>
              <td width="12" class="titikDua">:</td>
              <td
                style="border-left: 0px"
                width="200px"
                colspan="2"
                class="text-start input"
              >
                {{ moment(report[0].lastCalibrationDate).format("DD/MM/YYYY") }}
              </td>
            </tr>
            <tr>
              <td colspan="8" height="8" style="padding: 0 !important"></td>
            </tr>
            <tr>
              <td width="100" height="100" class="text-start">Penyebab</td>
              <td colspan="7" class="text-start input">
                {{ report[0].cause }}
              </td>
            </tr>
            <tr>
              <td colspan="8" height="8" style="padding: 0 !important"></td>
            </tr>
            <tr>
              <td width="100" height="100" class="text-start">Perbaikan</td>
              <td colspan="7" class="text-start input">
                {{ report[0].countermeasure }}
              </td>
            </tr>
            <tr class="titikDua">
              <td
                colspan="8"
                height="8"
                style="padding: 0 !important"
                class="titikDua"
              ></td>
            </tr>

            <tr>
              <td rowspan="6" class="text-start">Perlakuan</td>
              <td colspan="7" class="text-start">Perlakuan Produk</td>
            </tr>
            <tr>
              <td colspan="7" height="100px" class="text-start input">
                {{ report[0].handlingNote }}
              </td>
            </tr>
            <tr>
              <td style="border-right: 0">Perlakuan Alat ukur</td>
              <td width="12" class="titikDua">:</td>
              <td class="titikDua text-start input">
                <div>
                  <input disabled type="checkbox" name="" id="dailyCb" />
                  <label for="dailyCb" class="ms-1"> Repaired</label>
                </div>
              </td>
              <td
                class="titikDua text-start input"
                colspan="2"
                style="border-left: 0"
              >
                <div>
                  <input disabled type="checkbox" name="" id="dailyCb" />
                  <label for="dailyCb" class="ms-1"> Disposal</label>
                </div>
              </td>
              <td colspan="2">Dep. QC</td>
            </tr>
            <tr>
              <td colspan="5" rowspan="3" class="text-start input">
                {{ report[0].handlingNote }}
              </td>
              <td>GL/SV/Mgr</td>
              <td>PIC</td>
            </tr>
            <tr>
              <td height="50">ttd</td>
              <td>ttd</td>
            </tr>
            <tr>
              <td class="input">{{ report[0].handlingAuthorName }}</td>
              <td class="input">{{ report[0].handlingPICName }}</td>
            </tr>
            <tr class="titikDua">
              <td
                colspan="8"
                height="8"
                style="padding: 0 !important"
                class="titikDua"
              ></td>
            </tr>
            <tr>
              <td colspan="7">Konfirmasi tindakan diatas :</td>
              <td>Dep. Pengguna</td>
            </tr>
            <tr>
              <td colspan="7" rowspan="3"></td>
              <td>GL/SV/Mgr</td>
            </tr>
            <tr>
              <td height="50">ttd</td>
            </tr>
            <tr>
              <td>test</td>
            </tr>

            <tr class="titikDua">
              <td
                colspan="8"
                height="8"
                style="padding: 0 !important"
                class="titikDua"
              ></td>
            </tr>
            <tr>
              <td colspan="6">
                Menyetujui dan mengkonfirmasi tindakan diatas :
              </td>
              <td colspan="2">Dep. QC</td>
            </tr>
            <tr>
              <td colspan="6" rowspan="3"></td>
              <td>GL/SV/Mgr</td>
              <td>Konfirmasi</td>
            </tr>
            <tr>
              <td height="50"></td>
              <td></td>
            </tr>
            <tr>
              <td>test</td>
              <td>test</td>
            </tr>
          </tbody>
        </table>
      </v-card-text>
    </v-card>
  </v-dialog> -->

  <v-dialog
    v-model="reportDialog"
    scrollable
    persistent
    :overlay="false"
    transition="dialog-transition"
  >
    <v-card title="Abnormal Report">
      <template v-slot:append>
        <v-btn flat icon @click="reportDialog = false">
          <v-icon>mdi-close</v-icon>
        </v-btn>
      </template>
      <v-card-text>
        <v-table>
          <thead>
            <tr>
              <th>Nama Tool</th>
              <th>:</th>
              <th>{{ report.toolName }}</th>
              <th>Nomor Registrasi</th>
              <th>:</th>
              <th>{{ report.regNumber }}</th>
            </tr>
            <tr>
              <th>Tanggal Temuan</th>
              <th>:</th>
              <th>{{ moment(report.findingDate).format("DD/MM/YYYY") }}</th>

              <th>User</th>
              <th>:</th>
              <th>{{ report.userDiv }}</th>
            </tr>

            <tr>
              <th>Temuan Abnormal</th>
              <th>:</th>
              <th colspan="4">{{ report.abnormalDetail }}</th>
            </tr>
            <tr>
              <th>Penyebab</th>
              <th>:</th>
              <th colspan="4">{{ report.cause }}</th>
            </tr>
            <tr>
              <th>Penanggulangan</th>
              <th>:</th>
              <th colspan="4">{{ report.countermeasure }}</th>
            </tr>
          </thead>
        </v-table>
      </v-card-text>
    </v-card>
  </v-dialog>
</template>
<style scoped>
table tbody td {
  padding: 5px !important;
  border: 1px solid;
}
.titikDua {
  border-left: 0px !important;
  border-right: 0px !important;
}
.input {
  font-weight: bolder !important;
}
</style>

<script setup>
import { useAppStore } from "@/store/app";
import { computed, onMounted, ref } from "vue";
import moment from "moment";

const props = defineProps(["insData", "closeModal", "week"]);
const store = useAppStore();
const checkData = props.insData.instData;
const reportDialog = ref(false);
const report = ref({});
const userImageUrl = ref([]);

const reportInit = (r) => {
  report.value = r[0];
  reportDialog.value = true;
};

const getSign = (userId) => {
  const item = userImageUrl.value.find((e) => e.key == userId);
  if (item) {
    return item;
  } else {
    return {
      value: "",
    };
  }
};

// Data point check
const points = ref([]);

// Buat daftar hari dalam minggu yang dipilih
const weekDays = computed(() => {
  // Ambil nilai week number
  const selectedWeek = moment(props.week, "YYYY-[W]ww").week();

  return Array.from({ length: 7 }, (_, i) =>
    moment()
      .week(selectedWeek)
      .startOf("week")
      .add(i + 1, "days")
      .format("ddd DD")
  );
});

// Ambil data dari server
const refresh = async () => {
  try {
    const res = await store.ajax(
      {
        toolId: props.insData.toolId,
        sessionId: store.sessionId,
      },
      "tool/dailycheckinit",
      "post"
    );

    const users = await store.ajax({}, "auth/getusers", "post");
    userImageUrl.value = users.map((e) => {
      return {
        key: e.userId,
        value: e.signFile,
      };
    });

    points.value = res.pointChecks; // Pastikan jika data kosong tidak menyebabkan error
    store.preload = false;
  } catch (error) {
    console.error("Error fetching data:", error);
  }
};

// Fungsi untuk mendapatkan hasil pemeriksaan
const getResult = (day, methodId, checkId) => {
  let response = { color: "grey", text: "", reports: [] };
  const myData = checkData.filter(
    (e) => moment(e.checkDate).format("ddd DD") === day
  );

  if (myData.length > 0 && myData[0].instData) {
    if (myData[0].judgement !== "NOT USED") {
      const myPoint = myData[0].instData.find((d) => d.checkId == checkId);
      if (myPoint) {
        const myResult = myPoint.methods.find((m) => m.methodId == methodId);
        if (myData[0].abnormalReports.length > 0) {
          response.reports = myData[0].abnormalReports;
        }
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

const signReport = async () => {
  try {
    const myData = await store.ajax(
      { sessionId: store.sessionId },
      "auth/getmydata",
      "post"
    );
    const formData = {
      checkerId: myData.userId,
      weekCode: props.week,
      toolId: props.insData.toolId,
    };

    await store.ajax(formData, "tool/signweeklyreport", "post");
    props.closeModal();
  } catch (error) {
    store.alert.fire(error);
  }
};

onMounted(() => {
  refresh();
});
</script>
