const crud = require('../helpers/crud')
const crypter = require('../helpers/crypter')
const path = require("path"); // Untuk membangun path file secara aman
const fs = require('fs');
const Crud = require('../helpers/crud');
const moment = require('moment')
const cal = require('../helpers/calendarHelper')

module.exports = {
    monthlyInit: async (req, res) => {
        try {
            const month = req.body.month
            const toolDb = new crud
            let tools = await toolDb
                .join('left', 't_rank', 't_tools.rankId', 't_rank.rankId').get('t_tools')
            const breakDownMonth = await cal.monthBreakDown(month)
            tools = await Promise.all(tools.map(async (tool) => {
                const monthDb = new crud
                const toolDataDb = new crud
                tool.file = ""
                const fp = path.join(
                    __dirname,
                    "../uploads/checkimage/",
                    `${tool.toolId}.png`
                );

                if (fs.existsSync(fp)) {
                    const fileBuffer = fs.readFileSync(fp);
                    tool.file = `data:image/png;base64,${fileBuffer.toString("base64")}`;
                }
                tool.toolData = await toolDataDb.where('toolId', '=', tool.toolId).get('tooldata')
                let monthlyData = await monthDb
                    .where('month', '=', month)
                    .where('toolId', '=', tool.toolId)
                    .join('left', 't_user', 't_user.userId', 't_monthlyinspection.checkerId')
                    .get('t_monthlyinspection')
                monthlyData = await Promise.all(monthlyData.map(e => {
                    e.file = ""
                    const fp = path.join(
                        __dirname,
                        "../uploads/signs/",
                        `${e.userId}_signature.png`
                    );

                    if (fs.existsSync(fp)) {
                        const fileBuffer = fs.readFileSync(fp);
                        e.file = `data:image/png;base64,${fileBuffer.toString("base64")}`;
                    }
                    return e
                }))
                tool.monthlyData = monthlyData[0]
                tool.weeklyData = await Promise.all(breakDownMonth.weeks.map(async (arr) => {
                    const weekCode = arr.week
                    const dateArr = arr.days
                    const weekDb = new crud
                    let weekInspection = await weekDb
                        .select('*')
                        .select('userName as checkerName')
                        .join('left', 't_user', 't_user.userId', 't_weeklyinspection.checkerID')
                        .where('weekCode', '=', weekCode)
                        .where('toolId', '=', tool.toolId)
                        .get('t_weeklyinspection')

                    weekInspection = await Promise.all(weekInspection.map(e => {
                        const userId = e.checkerID
                        e.signfile = ""
                        const filePath = path.join(
                            __dirname,
                            "../uploads/signs/",
                            `${userId}_signature.png`
                        );

                        if (fs.existsSync(filePath)) {
                            const fileBuffer = fs.readFileSync(filePath);
                            e.signfile = `data:image/png;base64,${fileBuffer.toString("base64")}`;
                        }
                        return e
                    }))
                    const dailyData = await Promise.all(dateArr.map(async (date) => {
                        const dailyDb = new crud
                        const abnormalityDb = new crud

                        const reports = await abnormalityDb
                            .where('findingDate', '=', date)
                            .where('reportType', '=', 'Daily Finding')
                            .where('toolId', '=', tool.toolId)
                            .get('t_abnormalreports')

                        let daily = await dailyDb
                            .where('toolId', '=', tool.toolId)
                            .where('checkDate', '=', date)
                            .get('t_dailyinspection')

                        daily = daily.map(e => {
                            const decoded = crypter.decodeAndDecompress(e.instData)
                            e.instData = JSON.parse(decoded)
                            e.report = reports[0] ? reports[0] : null
                            return e
                        })
                        if (daily[0]) {
                            return daily[0]
                        }
                    }))
                    let weekData = {
                        weekCode,
                        dailyData
                    }

                    if (weekInspection.length > 0) {
                        weekData = {
                            weekCode,
                            dailyData,
                            ...weekInspection[0]
                        }
                    }
                    return weekData
                }))
                const mnthDailyDb = new crud
                tool.dailyData = await mnthDailyDb.where('toolId', '=', tool.toolId).where("DATE_FORMAT(checkDate,'%Y-%m')", '=', month).get('t_dailyinspection')

                tool.dailyData = await Promise.all(tool.dailyData.map(e => {
                    const decoded = crypter.decodeAndDecompress(e.instData)
                    const userId = e.checker

                    const filePath = path.join(
                        __dirname,
                        "../uploads/signs/",
                        `${userId}_signature.png`
                    );

                    e.fileBase64 = "";
                    if (fs.existsSync(filePath)) {
                        const fileBuffer = fs.readFileSync(filePath);
                        e.fileBase64 = `data:image/png;base64,${fileBuffer.toString("base64")}`;
                    }
                    e.instData = JSON.parse(decoded)
                    return e
                }))

                const abnDb = new crud
                tool.abnormals = await abnDb
                    .where('toolId', '=', tool.toolId)
                    .where("DATE_FORMAT(findingDate,'%Y-%m')", '=', month)
                    .get('t_abnormalreports')
                return tool
            }))
            return res.status(200).json(tools)

        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    monthlySign: async (req, res) => {
        try {
            let fd = { checkerId, toolId, checkDate, month } = req.body
            const sessionId = crypter.decryptObject(fd.checkerId)
            fd.checkerId = sessionId.userId
            const dupeDb = new crud
            const dupe = await dupeDb
                .where('month', '=', fd.month)
                .where('toolId', '=', fd.toolId)
                .get('t_monthlyinspection')
            if (dupe.length > 0) {
                throw {
                    text: 'This report is already signed!',
                    title: 'Duplicate Sign',
                    icon: 'error',
                    timer: 3000
                }
            }
            const insertDb = new crud
            await insertDb.insert('t_monthlyinspection', fd)
            return res.status(200).json({ message: 'success' })
        } catch (error) {
            console.log(error)
        }
    }
}


