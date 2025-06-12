const database = require("../config/database");

class Crud {
    constructor() {
        this.clear();
    }

    clear() {
        this.selectArr = [];
        this.whereArr = [];
        this.joinArr = [];
        this.groupBy = "";
        this.query = "";
        this.order = {
            field: "",
            order: "ASC",
        };
    }

    whereBetween(key, start, end) {
        this.whereArr.push({ key, operator: "BETWEEN", value: [start, end] });
        return this; // Agar bisa di-chain
    }

    viewLastQuery() {
        return this.lastQuery;
    }

    select(str) {
        this.selectArr.push(str);
        return this; // Agar bisa di-chain
    }

    where(key, operator = "=", value) {
        this.whereArr.push({ key, operator, value });
        return this; // Agar bisa di-chain
    }

    join(type, table, a, b) {
        this.joinArr.push({ table, type, a, b });
        return this; // Agar bisa di-chain
    }

    orderBy(field, order = "ASC") {
        this.order.field = field;
        this.order.order = order;
        return this; // Agar bisa di-chain
    }

    async get(table) {
        if (this.selectArr.length === 0) {
            this.selectArr.push('*');
        }

        this.query = `SELECT ${this.selectArr.join(", ")} FROM ${table}`;
        let whereQuery = "";
        let joinQuery = "";

        if (this.joinArr.length > 0) {
            this.joinArr.forEach(element => {
                joinQuery += ` ${element.type.toUpperCase()} JOIN ${element.table} ON ${element.a} = ${element.b}`;
            });
        }
        this.query += joinQuery;

        if (this.whereArr.length > 0) {
            whereQuery = " WHERE " + this.whereArr.map(w => {
                if (w.operator === "BETWEEN") {
                    return `${w.key} BETWEEN ? AND ?`;
                }
                return `${w.key} ${w.operator} ?`;
            }).join(" AND ");
        }
        this.query += whereQuery;


        if (this.order.field) {
            this.query += ` ORDER BY ${this.order.field} ${this.order.order}`;
        }

        const values = [];
        this.whereArr.forEach(w => {
            if (w.operator === "BETWEEN") {
                values.push(w.value[0], w.value[1]); // Pastikan dua nilai masuk
            } else {
                values.push(w.value);
            }
        });

        this.lastQuery = this.query

        try {
            const [rows] = await database.promise().query(this.query, values);
            this.clear(); // Reset state setelah operasi selesai
            return rows;
        } catch (err) {
            this.clear(); // Reset state jika terjadi error
            throw err;
        }
    }

    async insert(table, data) {
        try {
            const [result] = await database.promise().query("INSERT INTO ?? SET ?", [table, data]);
            this.clear();
            return result;
        } catch (err) {
            this.clear();
            throw err;
        }
    }

    async update(table, data) {
        const fields = Object.keys(data).map(key => `${key} = ?`).join(", ");
        const values = Object.values(data);

        this.query = `UPDATE ${table} SET ${fields}`;
        let whereQuery = "";

        if (this.whereArr.length > 0) {
            whereQuery = " WHERE " + this.whereArr.map(w => `${w.key} ${w.operator} ?`).join(" AND ");
            values.push(...this.whereArr.map(w => w.value));
        }
        this.query += whereQuery;

        try {
            const [result] = await database.promise().query(this.query, values);
            this.clear();
            return result;
        } catch (err) {
            this.clear();
            throw err;
        }
    }


    async delete(table) {
        if (this.whereArr.length === 0) {
            throw new Error("Delete operation requires at least one WHERE condition.");
        }

        // Tentukan primary key secara dinamis dari whereArr (default: "id")
        let primaryKey = "id";
        const eqCondition = this.whereArr.find(w => w.operator === "=");
        if (eqCondition) {
            primaryKey = eqCondition.key;
        }

        this.query = `DELETE FROM ${table} WHERE ` + this.whereArr.map(w => `${w.key} ${w.operator} ?`).join(" AND ");

        try {
            // 1️⃣ Hapus data berdasarkan kondisi
            const [result] = await database.promise().query(this.query, this.whereArr.map(w => w.value));

            // 2️⃣ Ambil MAX(id) dari tabel setelah penghapusan
            const [[{ maxId }]] = await database.promise().query(`SELECT MAX(${primaryKey}) AS maxId FROM ${table}`);

            if (typeof maxId == Number) {
                // 3️⃣ Jika maxId valid (bukan null), atur ulang AUTO_INCREMENT
                if (maxId !== null) {
                    await database.promise().query(`ALTER TABLE ${table} AUTO_INCREMENT = ?`, [maxId + 1]);
                } else {
                    // Jika tabel kosong, reset AUTO_INCREMENT ke 1
                    await database.promise().query(`ALTER TABLE ${table} AUTO_INCREMENT = 1`);
                }
            }

            this.clear();
            return result;
        } catch (err) {
            this.clear();
            throw err;
        }
    }



    async alter(table) {
        try {
            const [result] = await database.promise().query(`ALTER TABLE ${table} AUTO_INCREMENT=1`);
            this.clear();
            return result;
        } catch (err) {
            this.clear();
            throw err;
        }
    }

    viewQuery() {
        return this.query;
    }
    whereNotIn(key, values) {
        if (values.length > 0) {
            const placeholders = values.map(() => "?").join(", ");
            this.whereArr.push({ key, operator: `NOT IN (${placeholders})`, value: values });
        }
        return this; // Agar bisa di-chain
    }

}

module.exports = Crud;
