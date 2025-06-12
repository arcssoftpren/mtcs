// index.js

// Import modul yang diperlukan
const express = require("express");
const http = require("http");
const path = require("path");
const morgan = require("morgan");
const cors = require("cors");
const bodyParser = require("body-parser");
const fileUpload = require("express-fileupload");

require('dotenv').config();

// Konfigurasi aplikasi
const app = express();
const PORT = process.env.LOCAL_PORT;
const LOCAL_IP = process.env.LOCAL_IP

// Middleware
app.use(cors({ origin: "*", methods: ["POST", "GET"] }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(morgan("dev"));
app.use(
    fileUpload({
        createParentPath: true,
    })
);

// Endpoint API
const authRoutes = require('./routes/authRoutes')
const rankRoutes = require('./routes/rankRoutes')
const typeRoutes = require('./routes/typeRoutes')
const pointRoutes = require('./routes/pointRoutes')
const toolRoutes = require('./routes/toolRoutes')
app.use('/auth', authRoutes)
    .use('/ranks', rankRoutes)
    .use('/type', typeRoutes)
    .use('/point', pointRoutes)
    .use('/tool', toolRoutes)

app.post('/auth/login', (req, res) => {
    console.log('request')
})

// Sajikan file statis dari folder 'dist' untuk frontend
app.use(express.static(path.join(__dirname, "dist")));

// Tangani semua rute dengan mengembalikan file index.html
app.get("*", (req, res) => {
    res.sendFile(path.join(__dirname, "dist", "index.html"));
});

// Membuat HTTP server
const server = http.createServer(app);


// Jalankan server
server.listen(PORT, LOCAL_IP, () => {
    console.log(`Server berjalan di http://${LOCAL_IP}:${PORT}`);
});
