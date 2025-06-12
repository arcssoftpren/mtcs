const fs = require("fs");
const path = require("path");
const readline = require("readline");
const { execSync } = require("child_process");
const os = require("os");

// Fungsi untuk membaca input dari user
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

function askQuestion(query) {
    return new Promise((resolve) => rl.question(query, resolve));
}

async function main() {
    console.log("🚀 Setting up project...");

    // 1. Prompt setting .env untuk backend
    const DB_HOST = await askQuestion("Masukkan DB_HOST: ");
    const DB_USER = await askQuestion("Masukkan DB_USER: ");
    const DB_PASS = await askQuestion("Masukkan DB_PASS: ");
    const LOCAL_IP = await askQuestion("Masukkan LOCAL_IP: ");
    const LOCAL_PORT = await askQuestion("Masukkan LOCAL_PORT: ");
    const osType = await askQuestion("Pilih sistem operasi (1: Windows, 2: Linux): ");
    const SQL_PATH = await askQuestion("Masukkan path SQL: ");

    let mysqlCommand = "";

    if (osType === "1") {
        mysqlCommand = "mysql.exe";
    } else {
        mysqlCommand = "mysql";
    }

    console.log(mysqlCommand)



    rl.close();

    // 2. Buat file .env di backend
    const backendEnvContent = `DB_HOST=${DB_HOST}
DB_USER=${DB_USER}
DB_PASS=${DB_PASS}
DB_NAME=mtcs_softpren
LOCAL_IP=${LOCAL_IP}
LOCAL_PORT=${LOCAL_PORT}
SQL_PATH=${SQL_PATH}
`;

    fs.writeFileSync(path.join(__dirname, ".env"), backendEnvContent);
    fs.writeFileSync(path.join(__dirname, "backend/.env"), backendEnvContent);
    console.log("✅ File .env untuk backend berhasil dibuat.");

    // 3. Buat file .env di frontend
    const frontendEnvContent = `VITE_API_SERVER=https://${LOCAL_IP}
VITE_API_PORT=${LOCAL_PORT}
`;

    fs.writeFileSync(path.join(__dirname, "frontend", ".env"), frontendEnvContent);
    console.log("✅ File .env untuk frontend berhasil dibuat.");

    // 4. Jalankan npm install di frontend
    console.log("📦 Menginstall dependencies di frontend...");
    execSync("npm install", { cwd: path.join(__dirname, "frontend"), stdio: "inherit" });

    // 5. Jalankan npm run build di frontend
    console.log("🔨 Membangun frontend...");
    execSync("npm run build", { cwd: path.join(__dirname, "frontend"), stdio: "inherit" });

    // 6. Mengosongkan folder dist di backend
    const backendDistPath = path.join(__dirname, "backend", "dist");

    if (fs.existsSync(backendDistPath)) {
        console.log("🧹 Menghapus isi folder dist di backend...");
        fs.rmSync(backendDistPath, { recursive: true, force: true });
    }

    // 7. Copy isi dist dari frontend ke backend
    const frontendDistPath = path.join(__dirname, "frontend", "dist");

    console.log("📂 Menyalin hasil build ke backend...");

    if (!fs.existsSync(backendDistPath)) {
        fs.mkdirSync(backendDistPath, { recursive: true });
    }

    if (os.platform() === "win32") {
        execSync(`xcopy /E /I /Y "${frontendDistPath}" "${backendDistPath}"`, { stdio: "inherit" });
    } else {
        execSync(`cp -r ${frontendDistPath}/* ${backendDistPath}/`, { stdio: "inherit" });
    }

    console.log("✅ Berhasil menyalin hasil build ke backend.");

    // 8. Jalankan npm install di backend
    console.log("📦 Menginstall dependencies di backend...");
    execSync("npm install", { cwd: path.join(__dirname, "backend"), stdio: "inherit" });

    // 12. Impor database MySQL dari file SQL
    const sqlFilePath = path.join(__dirname, "database.sql");

    console.log("📂 Menemukan file database.sql, mengimpor ke MySQL...");


    if (fs.existsSync(sqlFilePath)) {

        const databaseExists = checkDatabaseExists(DB_HOST, DB_USER, DB_PASS, SQL_PATH);

        if (databaseExists) {
            console.log("⚠️ Database 'mtcs-softpren' sudah ada. Menghapus database...");
            try {
                const mysqlPath = path.join(SQL_PATH, mysqlCommand);
                const dropCommand = `"${mysqlPath}" -h ${DB_HOST} -u ${DB_USER} ${DB_PASS ? `-p${DB_PASS}` : ""} -e "DROP DATABASE mtcs_softpren;"`;
                execSync(dropCommand, { stdio: "inherit", shell: true });

                console.log("✅ Database berhasil dihapus.");
            } catch (error) {
                console.error("⚠️ Gagal menghapus database.");
                console.log(error);
                return;
            }
        }

        try {
            const mysqlPath = path.join(SQL_PATH, mysqlCommand);
            const importCommand = `"${mysqlPath}" -h ${DB_HOST} -u ${DB_USER} ${DB_PASS ? `-p${DB_PASS}` : ""} < ${sqlFilePath}`;
            execSync(importCommand, { stdio: "inherit", shell: true });

            console.log("✅ Database berhasil diimpor ke MySQL.");
        } catch (error) {
            console.error("⚠️ Gagal mengimpor database SQL. Periksa kredensial dan server MySQL.");
            console.log(error)
        }
    } else {
        console.log("⚠️ Tidak ditemukan file database.sql, melewati proses impor database.");
    }

    console.log("🎉 Setup selesai! Backend siap dijalankan.");

    console.log("🚀 Mengecek instance PM2 yang berjalan...");

    try {
        // Coba hapus instance meskipun tidak muncul di list
        console.log("🛑 Memastikan instance yang lama dihentikan...");
        execSync("pm2 delete mtcs-softpren || true", { stdio: "inherit" });
    } catch (error) {
        console.error("⚠️ Tidak dapat menghapus instance sebelumnya (mungkin belum berjalan).");
    }

    // 9. Menjalankan backend menggunakan PM2
    console.log("🚀 Menjalankan backend dengan PM2...");
    try {
        execSync(`pm2 start ./backend/index.js --name mtcs-softpren`, { stdio: "inherit" });
    } catch (error) {
        console.error("⚠️ Gagal menjalankan backend dengan PM2.");
    }

    // 10. Mendaftarkan backend di PM2 agar berjalan otomatis setelah restart
    console.log("📌 Mendaftarkan backend ke PM2 agar otomatis berjalan setelah restart...");
    try {
        execSync("pm2 save", { stdio: "inherit" });
    } catch (error) {
        console.error("⚠️ Gagal menyimpan konfigurasi PM2.");
    }

    // 11. Jika OS adalah Windows, buat file batch untuk resurrect PM2 di startup folder
    if (os.platform() === "win32") {
        console.log("📝 Membuat file batch untuk resurrect PM2 di Windows startup...");

        const startupFolder = path.join(process.env.APPDATA, "Microsoft\\Windows\\Start Menu\\Programs\\Startup");
        const batchFilePath = path.join(startupFolder, "pm2_resurrect.bat");
        const batchContent = `@echo off
pm2 resurrect
`;

        fs.writeFileSync(batchFilePath, batchContent);
        console.log(`✅ File batch untuk resurrect PM2 telah disimpan di: ${batchFilePath}`);
    } else {

        execSync("pm2 startup", { stdio: "inherit" });
    }

    console.log("✅ Semua proses selesai!");
    console.log(`server berjalan di: http://${LOCAL_IP}:${LOCAL_PORT}`);

    function checkDatabaseExists(DB_HOST, DB_USER, DB_PASS, SQL_PATH) {
        try {
            const mysqlPath = path.join(SQL_PATH, mysqlCommand);
            const checkCommand = `"${mysqlPath}" -h ${DB_HOST} -u ${DB_USER} ${DB_PASS ? `-p${DB_PASS}` : ""} -e "USE mtcs_softpren;"`;
            execSync(checkCommand, { stdio: "inherit", shell: true });

            return true; // Jika berhasil "USE", berarti database ada
        } catch (error) {
            return false; // Jika error, berarti database belum ada
        }
    }
}

main();

