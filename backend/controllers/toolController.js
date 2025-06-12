const crud = require("../helpers/crud");
const crypter = require("../helpers/crypter");
const path = require("path"); // Untuk membangun path file secara aman
const fs = require("fs");
const moment = require("moment");

module.exports = {
  getTools: async (req, res) => {
    try {
      const db = new crud();
      let tools = await db
        .join("left", "t_rank", "t_rank.rankId", "t_tools.rankId")
        .join("left", "t_tooltype", "t_tooltype.typeId", "t_tools.typeId")
        .get("t_tools");

      tools = await Promise.all(
        tools.map(async (tool) => {
          const dbInstance = new crud();
          const data = await dbInstance
            .where("toolId", "=", Number(tool.toolId))
            .where("dataValue", "is not", null)
            .get("tooldata");

          // Path ke file gambar
          const filePath = path.join(
            __dirname,
            "../uploads/checkimage/",
            `${tool.toolId}.png`
          );

          let fileBase64 = "";
          if (fs.existsSync(filePath)) {
            const fileBuffer = fs.readFileSync(filePath);
            fileBase64 = `data:image/png;base64,${fileBuffer.toString(
              "base64"
            )}`;
          }

          if (req.body.date) {
            const date = req.body.date;
            let instData = await dbInstance
              .where("toolId", "=", tool.toolId)
              .where("checkDate", "=", date)
              .get("t_dailyinspection");

            tool.instData = await Promise.all(
              instData.map((e) => {
                const dec = crypter.decodeAndDecompress(e.instData);
                e.instData = JSON.parse(dec);
                return e;
              })
            );
          }

          if (req.body.week) {
            const week = req.body.week;
            const startDate = moment(week)
              .startOf("isoWeek")
              .format("YYYY-MM-DD");
            const endDate = moment(week).endOf("isoWeek").format("YYYY-MM-DD");

            tool.weeklysign = await dbInstance
              .where("weekCode", "=", week)
              .where("toolId", "=", tool.toolId)
              .get("t_weeklyinspection");

            let instData = await dbInstance
              .whereBetween("checkDate", startDate, endDate)
              .where("toolId", "=", tool.toolId)
              .get("t_dailyinspection");

            tool.instData = await Promise.all(
              instData.map(async (e) => {
                const newdb = new crud();
                const dec = crypter.decodeAndDecompress(e.instData);
                e.instData = JSON.parse(dec);
                const checkDate = e.checkDate;
                const toolId = e.toolId;
                const type = "daily finding";
                e.abnormalReports = await newdb
                  .select("*")
                  .select("founder.userName as founderName")
                  .select("author.userName as founderAuthorName")
                  .join(
                    "left",
                    "t_user as founder",
                    "founder.userId",
                    "t_abnormalreports.founderPIC"
                  )
                  .join(
                    "left",
                    "t_user as author",
                    "author.userId",
                    "t_abnormalreports.founderAuthor"
                  )
                  .join(
                    "left",
                    "t_user as handlingPIC",
                    "handlingPIC.userId",
                    "t_abnormalreports.handlingPIC"
                  )
                  .where("toolId", "=", toolId)
                  .where("findingDate", "=", checkDate)
                  .where("reportType", "=", type)
                  .get("t_abnormalreports");
                return e;
              })
            );
          }

          if (req.body.month) {
            const month = req.body.month;
            const startDate = moment(month)
              .startOf("month")
              .format("YYYY-MM-DD");
            const endDate = moment(month).endOf("month").format("YYYY-MM-DD");
            let instData = await dbInstance
              .whereBetween("checkDate", startDate, endDate)
              .where("toolId", "=", tool.toolId)
              .get("t_dailyinspection");
            tool.instData = await Promise.all(
              instData.map(async (e) => {
                const newdb = new crud();
                const dec = crypter.decodeAndDecompress(e.instData);
                e.instData = JSON.parse(dec);
                const checkDate = e.checkDate;
                const toolId = e.toolId;
                const type = "daily finding";
                e.abnormalReports = await newdb
                  .select("*")
                  .select("founder.userName as founderName")
                  .select("author.userName as founderAuthorName")
                  .join(
                    "left",
                    "t_user as founder",
                    "founder.userId",
                    "t_abnormalreports.founderPIC"
                  )
                  .join(
                    "left",
                    "t_user as author",
                    "author.userId",
                    "t_abnormalreports.founderAuthor"
                  )
                  .join(
                    "left",
                    "t_user as handlingPIC",
                    "handlingPIC.userId",
                    "t_abnormalreports.handlingPIC"
                  )
                  .where("toolId", "=", toolId)
                  .where("findingDate", "=", checkDate)
                  .where("reportType", "=", type)
                  .get("t_abnormalreports");
                return e;
              })
            );
            tool.weeklysign = [];
            const weeks = getWeeksInMonth(
              moment(month).format("YYYY"),
              moment(month).format("MM")
            );
            await Promise.all(
              weeks.map(async (week) => {
                const dbs = new crud();
                const signs = await dbs
                  .where("weekCode", "=", week)
                  .where("toolId", "=", tool.toolId)
                  .get("t_weeklyinspection");
                if (signs[0]) {
                  tool.weeklysign.push(signs[0]);
                }
              })
            );
          }

          return {
            ...tool,
            data,
            file: fileBase64, // Tambahkan gambar dalam format base64
          };
        })
      );

      return res.status(200).json(tools);
    } catch (error) {
      console.error("Error fetching tools:", error);
      return res.status(500).json({ message: "Internal Server Error" });
    }
  },
  addTool: async (req, res) => {
    try {
      const db = new crud();
      const data = req.body;
      const { registerNumber } = data;

      const duplicate = await db
        .where("registerNumber", "=", registerNumber)
        .where("disposed", "=", 0)
        .get("t_tools");

      if (duplicate.length > 0) {
        throw {
          title: "Duplicate Register Number",
          text: "The given tool name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      const insert = await db.insert("t_tools", data);
      if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send("No files were uploaded.");
      }

      const uploadedFile = req.files.file;
      const filePath = path.join(
        __dirname,
        "../uploads/checkimage/",
        `${insert.insertId}.png`
      );
      uploadedFile.mv(filePath, function (err) {
        if (err) {
          throw {
            title: "Upload Error",
            text: "the file is not uploaded, please try again from tools edit menu!",
            icon: "error",
            timer: 3000,
          };
        }
        return res.status(200).json({ message: "success" });
      });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  reqImage: async (req, res) => {
    try {
      const { toolId } = req.body; // Ambil toolId dari request
      const filePath = path.join(
        __dirname,
        "../uploads/checkimage/",
        `${toolId}.png`
      );

      // Periksa apakah file ada
      if (!fs.existsSync(filePath)) {
        return res.status(404).json({
          message: "File not found",
          path: filePath,
        });
      }

      // Kirim file ke klien
      res.sendFile(filePath);
    } catch (error) {
      console.error("Error sending file:", error);
      res.status(500).json({
        message: "Internal Server Error",
      });
    }
  },

  editTool: async (req, res) => {
    try {
      const db = new crud();
      const data = req.body;
      const { toolName, toolId, rankId, registerNumber } = data;

      const duplicate = await db
        .where("toolName", "=", toolName)
        .where("toolId", "!=", toolId)
        .where("disposed", "=", 0)
        .get("t_tools");

      if (duplicate.length > 0) {
        throw {
          title: "Duplicate Tool Name",
          text: "The given tool name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      const update = await db
        .where("toolId", "=", toolId)
        .update("t_tools", { toolName, toolId, rankId, registerNumber });

      if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send("No files were uploaded.");
      }

      const uploadedFile = req.files.file;
      const filePath = path.join(
        __dirname,
        "../uploads/checkimage/",
        `${toolId}.png`
      );
      uploadedFile.mv(filePath, function (err) {
        if (err) {
          throw {
            title: "Upload Error",
            text: "the file is not uploaded, please try again from tools edit menu!",
            icon: "error",
            timer: 3000,
          };
        }
        return res.status(200).json({ message: "success" });
      });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },

  deleteTool: async (req, res) => {
    try {
      const db = new crud();
      await db.where("toolId", "=", req.body.toolId).delete("t_tools");

      // Path file yang akan dihapus
      const filePath = path.join(
        __dirname,
        "../uploads/checkimage/",
        `${req.body.toolId}.png`
      );

      // Periksa apakah file ada sebelum dihapus
      if (fs.existsSync(filePath)) {
        fs.unlink(filePath, (err) => {
          if (err) {
            console.error("Gagal menghapus file:", err);
            return res.status(500).json({ message: "Gagal menghapus file" });
          }
          console.log("File berhasil dihapus:", filePath);
        });
      } else {
        console.log("File tidak ditemukan:", filePath);
      }

      return res.status(200).json({ message: "Success" });
    } catch (error) {
      console.error("Error saat menghapus:", error);
      return res.status(500).json({ message: "Terjadi kesalahan" });
    }
  },
  getData: async (req, res) => {
    try {
      const { toolId, collumns } = req.body;
      const col = Array.isArray(collumns) ? collumns : JSON.parse(collumns);
      const db = new crud();

      await db
        .where("toolId", "=", toolId)
        .where("dataValue", "is", null) // Hapus yang tidak ada di col
        .delete("tooldata");

      // Insert jika belum ada
      await Promise.all(
        col.map(async (element) => {
          try {
            const int = Number(element);
            const dupe = await db
              .where("toolId", "=", toolId)
              .where("columId", "=", int)
              .get("tooldata");

            if (dupe.length < 1) {
              await db.insert("tooldata", { toolId, columId: int });
            }
          } catch (err) {
            console.error("Error inserting data:", err);
          }
        })
      );

      // Ambil data terbaru dengan JOIN
      const response = await db
        .where("toolId", "=", toolId)
        .join("left", "t_collumns", "t_collumns.collumnId", "tooldata.columId")
        .get("tooldata");

      return res.status(200).json(response);
    } catch (error) {
      console.error("Error in getData:", error);
      return res.status(500).json({ error: "Internal Server Error" });
    }
  },
  updateData: async (req, res) => {
    const { dataId, dataValue } = req.body;
    const db = new crud();
    await db.where("dataId", "=", dataId).update("tooldata", { dataValue });
    return res.status(200).json({ message: "success" });
  },
  getColumn: async (req, res) => {
    const db = new crud();
    const column = await db.get("t_collumns");
    return res.status(200).json(column);
  },
  dailyCheckInit: async (req, res) => {
    try {
      const db = new crud();
      const { toolId, sessionId, toolName, registerNumber } = req.body;
      const decrypted = crypter.decryptObject(sessionId);
      const { userId, userName } = decrypted;
      let pointChecks = await db
        .where("toolId", "=", toolId)
        .get("t_pointcheck");
      if (pointChecks.length < 1) {
        throw {
          title: "Empty point check",
          text: `No point check found for ${toolName} - ${registerNumber}! Please contact admistartor to setup the check points!`,
          icon: "error",
          timer: 5000,
        };
      }

      pointChecks = await Promise.all(
        pointChecks.map(async (pc) => {
          const dbInstance = new crud();
          const methods = await dbInstance
            .where("pointCheckId", "=", pc.checkId)
            .join(
              "left",
              "t_pointcheck",
              "t_pointcheck.checkId",
              "t_checkmethod.pointCheckId"
            )
            .get("t_checkmethod");
          if (methods.length < 1) {
            throw {
              title: "Empty Check Method",
              text: `No check methods found for ${toolName} - ${registerNumber} - ${pc.pointString}! Please contact admistartor to setup the check methods!`,
              icon: "error",
              timer: 5000,
            };
          }

          pc.methods = methods;
          return pc;
        })
      );
      return res.status(200).json({
        pointChecks,
        checker: { userId, userName },
      });
    } catch (error) {
      console.log(error);
      return res.status(400).json(error);
    }
  },
  dailychecksubmit: async (req, res) => {
    try {
      const db = new crud();
      const { checkDate, judgement, checker, toolId, instData } = req.body;
      const dupe = await db
        .where("checkDate", "=", checkDate)
        .where("toolId", "=", toolId)
        .get("t_dailyinspection");

      if (dupe.length > 0) {
        throw {
          title: "Already Checked",
          text: "The tool is already checked for today!",
          icon: "error",
          timer: 3000,
        };
      }

      const cryptedData = crypter.compressAndEncode(JSON.stringify(instData));
      console.log(cryptedData.length);
      await db.insert("t_dailyinspection", {
        checkDate,
        judgement,
        checker,
        toolId,
        instData: cryptedData,
      });
      return res.status(200).json({ message: "success" });
    } catch (error) {
      console.log(error);
      return res.status(400).json(error);
    }
  },
  abnormalityInit: async (req, res) => {
    try {
      const { findingDate, reportType, toolId } = req.body;

      const db = new crud();
      db.where("findingDate", "=", findingDate);
      db.where("toolId", "=", toolId);
      db.where("reportType", "=", reportType);
      const dupe = await db.get("t_abnormalreports");

      if (dupe.length > 0) {
        throw {
          title: "Duplicate Report",
          text: "The report is already reported!",
          icon: "error",
          timer: 3000,
        };
      }

      await db.insert("t_abnormalreports", req.body);

      return res.status(200).json({ message: "success" });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  signweeklyreport: async (req, res) => {
    try {
      const db = new crud();
      const { checkerId, weekCode, toolId } = req.body;
      const dupe = await db
        .where("toolId", "=", toolId)
        .where("weekCode", "=", weekCode)
        .get("t_weeklyinspection");
      if (dupe.length > 0) {
        throw {
          title: "Report is Signed",
          text: "The weekly report for this tool on this week is already signed!",
          icon: "error",
          timer: 3000,
        };
      }

      await db.insert("t_weeklyinspection", { checkerId, toolId, weekCode });

      return res.status(200).json({ message: "success" });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  getMonthlyReports: async (req, res) => {
    const month = req.body.month.split("-")[1];
    const year = req.body.month.split("-")[0];
    const db = new crud();
    db.where("MONTH(checkDate)", "=", month);
    db.where("YEAR(checkDate)", "=", year);
    let dailyReport = await db.get("t_dailyinspection");
    dailyReport = dailyReport.map((e) => {
      e.instData = JSON.parse(crypter.decodeAndDecompress(e.instData));
      e.checkDate = moment(e.checkDate).format("YYYY-MM-DD");
      return e;
    });
    return res.status(200).json({
      dailyReport,
    });
  },
  getAbnormality: async (req, res) => {
    try {
      const db = new crud();
      const { month } = req.body;
      const mm = month.split("-")[1];
      const yy = month.split("-")[0];
      const abnormality = await db
        .where("month(findingDate)", "=", mm)
        .where("year(findingDate)", "=", yy)
        .get("t_abnormalreports");

      return res.status(200).json(abnormality);
    } catch (error) {
      console.log(error);
      return res.status(400).json(error);
    }
  },
};

function getWeeksInMonth(year, month) {
  let startDate = moment(`${year}-${month}-01`);
  let endDate = moment(startDate).endOf("month");
  let weeks = new Set();

  for (
    let date = startDate.clone();
    date.isBefore(endDate);
    date.add(1, "day")
  ) {
    let weekCode = `${date.format("YYYY")}-W${date
      .isoWeek()
      .toString()
      .padStart(2, "0")}`;
    weeks.add(weekCode);
  }

  return Array.from(weeks);
}
