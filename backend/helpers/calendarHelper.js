function getWeekDates(weekStr) {
    const [yearStr, weekNumStr] = weekStr.split("-W");
    const year = parseInt(yearStr);
    const week = parseInt(weekNumStr);

    const result = [];

    // Cari hari Senin dari minggu tersebut
    const simple = new Date(year, 0, 1 + (week - 1) * 7);
    const dow = simple.getDay();
    const monday = new Date(simple);
    monday.setDate(simple.getDate() - (dow === 0 ? 6 : dow - 1));

    for (let i = 0; i < 7; i++) {
        const d = new Date(monday);
        d.setDate(monday.getDate() + i);
        result.push(formatDate(d));
    }

    return Promise.resolve(result);
}

function getISOWeekString(date) {
    const year = getWeekYear(date);
    const week = getWeekNumber(date);
    return `${year}-W${week.toString().padStart(2, '0')}`;
}

function getWeekNumber(date) {
    const temp = new Date(date.getTime());
    temp.setHours(0, 0, 0, 0);
    temp.setDate(temp.getDate() + 3 - ((temp.getDay() + 6) % 7));
    const week1 = new Date(temp.getFullYear(), 0, 4);
    return 1 + Math.round(((temp - week1) / 86400000 - 3 + ((week1.getDay() + 6) % 7)) / 7);
}

function getWeekYear(date) {
    const temp = new Date(date.getTime());
    temp.setDate(temp.getDate() + 3 - ((temp.getDay() + 6) % 7));
    return temp.getFullYear();
}

function formatDate(date) {
    const d = date.getDate().toString().padStart(2, '0');
    const m = (date.getMonth() + 1).toString().padStart(2, '0');
    const y = date.getFullYear();
    return `${y}-${m}-${d}`;
}

async function monthBreakDown(monthStr) {
    const [year, month] = monthStr.split('-').map(Number);
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0); // Hari terakhir bulan

    const weeksMap = new Map();
    const allDays = [];

    for (let day = new Date(startDate); day <= endDate; day.setDate(day.getDate() + 1)) {
        const dateStr = formatDate(day);
        allDays.push(dateStr);

        const weekKey = getISOWeekString(day);
        if (!weeksMap.has(weekKey)) {
            const weekDates = await getWeekDates(weekKey); // Asynchronous
            weeksMap.set(weekKey, weekDates);
        }
    }

    const weeks = Array.from(weeksMap.entries()).map(([week, days]) => ({ week, days }));

    return Promise.resolve({
        weeks,
        days: allDays
    });
}

async function getMonthWeeks(monthStr) {
    const [year, month] = monthStr.split("-").map(Number);
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0);

    const weeks = new Set();

    for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
        const week = getISOWeekString(d);
        weeks.add(week);
    }

    return Promise.resolve(Array.from(weeks));
}

module.exports = {
    monthBreakDown,
    getWeekDates,
    getMonthWeeks
};
