const crud = require("../helpers/crud");
const crypter = require("../helpers/crypter");
const path = require("path"); // Untuk membangun path file secara aman
const fs = require("fs");
const Crud = require("../helpers/crud");
module.exports = {
  login: async (req, res) => {
    try {
      const { userId, userPassword } = req.body;
      const hashed1 = crypter.encryptText(userPassword);
      console.log(hashed1);
      const db = new crud();
      db.where("userId", "=", userId);
      const user = await db.get("t_user");
      if (user.length < 1) {
        throw {
          title: "Unknown NIK",
          text: "Please check your NIK and try again!",
          icon: "error",
          timer: 3000,
        };
      }

      const hashed = user[0].userPassword;
      const dehashed = crypter.decryptText(hashed);
      if (userPassword != dehashed) {
        throw {
          title: "Invalid Password",
          text: "Please check your password and try again!",
          icon: "error",
          timer: 3000,
        };
      }

      const lastLogin = req["_startTime"];
      const lastIP = req["_remoteAddress"];

      await db
        .where("userId", "=", userId)
        .update("t_user", { lastLogin, lastIP });
      const newUser = await db.where("userId", "=", userId).get("t_user");
      const response = crypter.encryptObject(newUser[0]);
      return res.status(200).json(response);
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  addRole: async (req, res) => {
    try {
      const { roleName, dashboardPage } = req.body;
      const db = new crud();
      const duplicate = await db
        .where("roleName", "=", roleName)
        .get("t_roles");
      if (duplicate.length > 0) {
        throw {
          title: "Duplicate Role Name",
          text: "The given role name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      await db.insert("t_roles", { roleName, dashboardPage });
      return res.status(200).json({ message: "success" });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  getRoles: async (req, res) => {
    const db = new crud();
    const response = await db.get("t_roles");
    return res.status(200).json(response);
  },
  editRole: async (req, res) => {
    try {
      const db = new crud();
      const { roleId, roleName, dashboardPage } = req.body;
      const duplicate = await db
        .where("roleName", "=", roleName)
        .where("roleId", "!=", roleId)
        .get("t_roles");
      if (duplicate.length > 0) {
        throw {
          title: "Duplicate Role Name",
          text: "The given role name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      await db
        .where("roleId", "=", roleId)
        .update("t_roles", { roleName, dashboardPage });
      return res.status(200).json({
        message: "Success",
      });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  deleteRole: async (req, res) => {
    const roleId = req.body.roleId;
    const db = new crud();
    await db.where("roleId", "=", roleId).delete("t_roles");
    return res.status(200).json({
      message: "Success",
    });
  },
  addUser: async (req, res) => {
    try {
      const db = new crud();
      let { userName, userId, userPassword, roleId, divId } = req.body;

      const user = await db.where("userId", "=", userId).get("t_user");
      if (user.length > 0) {
        throw {
          title: "DUPLICATE NIK",
          text: "The given NIK is already used by another user, please try again with a different NIK",
          icon: "error",
          timer: 5000,
        };
      }

      userPassword = crypter.encryptText(userPassword);
      const insert = await db.insert("t_user", {
        userName,
        userId,
        userPassword,
        roleId,
        divId,
      });
      console.log(insert);

      if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send("No files were uploaded.");
      }

      const uploadedFile = req.files.signFile;
      const filePath = path.join(
        __dirname,
        "../uploads/signs/",
        `${userId}_signature.png`
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
  getUser: async (req, res) => {
    const db = new crud();
    db.join("left", "t_roles", "t_roles.roleId", "t_user.roleId");
    db.join("left", "division", "division.divId", "t_user.divId");

    let response = await db.get("t_user");

    response = await Promise.all(
      response.map((e) => {
        const filePath = path.join(
          __dirname,
          "../uploads/signs/",
          `${e.userId}_signature.png`
        );

        let fileBase64 = "";
        if (fs.existsSync(filePath)) {
          const fileBuffer = fs.readFileSync(filePath);
          fileBase64 = `data:image/png;base64,${fileBuffer.toString("base64")}`;
        }
        e.signFile = fileBase64;
        return e;
      })
    );
    return res.status(200).json(response);
  },
  editUser: async (req, res) => {
    try {
      const db = new crud();
      let { userName, userId, roleId, oldId, divId } = req.body;

      console.log(req.body);
      if (oldId !== userId) {
        const user = await db.where("userId", "=", userId).get("t_user");
        if (user.length > 0) {
          throw {
            title: "DUPLICATE NIK",
            text: "The given NIK is already used by another user, please try again with a different NIK",
            icon: "error",
            timer: 5000,
          };
        }
      }

      await db
        .where("userId", "=", oldId)
        .update("t_user", { userName, userId, roleId, divId });

      if (!req.files || Object.keys(req.files).length === 0) {
        return res.status(400).send("No files were uploaded.");
      }

      const uploadedFile = req.files.signFile;
      const filePath = path.join(
        __dirname,
        "../uploads/signs/",
        `${userId}_signature.png`
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

  deleteUser: async (req, res) => {
    const userId = req.body.userId;
    const db = new crud();
    await db.where("userId", "=", userId).delete("t_user");
    return res.status(200).json({
      message: "Success",
    });
  },
  changePass: async (req, res) => {
    let { userId, userPassword } = req.body;
    const db = new crud();
    userPassword = crypter.encryptText(userPassword);

    await db.where("userId", "=", userId).update("t_user", { userPassword });

    return res.status(200).json({
      message: "Success",
    });
  },
  getHome: async (req, res) => {
    const db = new crud();
    const { sessionId } = req.body;
    const decrypted = crypter.decryptObject(sessionId);
    const roles = await db
      .where("roleId", "=", decrypted.roleId)
      .get("t_roles");
    const home = roles[0].dashboardPage;
    return res.status(200).json(home);
  },
  getMydata: async (req, res) => {
    const { sessionId } = req.body;
    const decrypted = crypter.decryptObject(sessionId);
    const { userName, userId } = decrypted;

    const db = new crud();
    const response = await db
      .where("userId", "=", userId)
      .join("left", "division", "division.divId", "t_user.divId")
      .get("t_user");

    return res.status(200).json(response[0]);
  },
  getDiv: async (req, res) => {
    const db = new crud();
    const divisions = await db.get("division");
    return res.status(200).json(divisions);
  },
  addDiv: async (req, res) => {
    try {
      const { divName } = req.body;
      const db = new crud();
      const dupe = await db.where("divName", "=", divName).get("division");
      if (dupe.length > 0) {
        throw {
          title: "Duplicate Division Name",
          text: "The given division name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      await db.insert("division", { divName });

      return res.status(200).json({ message: "success" });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  getaccess: async (req, res) => {
    try {
      const code = req.body.code;
      const db = new Crud();

      const existed = await db.where("code", "=", code).get("access");

      let dataresponse = {
        access: [],
        configs: [],
        setups: [],
      };

      if (existed.length < 1) {
        return res.status(200).json(dataresponse);
      } else {
        const result = JSON.parse(existed[0].rights);

        dataresponse.access = result;
        dataresponse.configs = JSON.parse(existed[0].configs);
        dataresponse.setups = JSON.parse(existed[0].setups);
        return res.status(200).json(dataresponse);
      }
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },

  setaccess: async (req, res) => {
    try {
      const db = new Crud();
      const data = req.body;
      const { rights, code, configs, setups } = data;

      const existed = await db.where("code", "=", code).get("access");
      if (existed.length < 1) {
        await db.insert("access", {
          rights: JSON.stringify(rights),
          code,
          configs: JSON.stringify(configs),
          setups: JSON.stringify(setups),
        });
        return res.status(200).json({ success: "success" });
      } else {
        await db.where("code", "=", code).update("access", {
          rights: JSON.stringify(rights),
          configs: JSON.stringify(configs),
          setups: JSON.stringify(setups),
        });
        return res.status(200).json({ success: "success" });
      }
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },

  editDiv: async (req, res) => {
    try {
      const db = new crud();
      const { divId, divName } = req.body;
      const duplicate = await db
        .where("divName", "=", divName)
        .where("divId", "!=", divId)
        .get("division");
      if (duplicate.length > 0) {
        throw {
          title: "Duplicate Division Name",
          text: "The given division name is already in use, please use another name!",
          icon: "error",
          timer: 3000,
        };
      }

      await db.where("divId", "=", divId).update("division", { divName });
      return res.status(200).json({
        message: "Success",
      });
    } catch (error) {
      console.log(error);
      return res.status(404).json(error);
    }
  },
  deleteDiv: async (req, res) => {
    const db = new crud();
    const divId = req.body.divId;

    await db.where("divId", "=", divId).delete("division");
    return res.status(200).json({
      message: "Success",
    });
  },
  getConfigs: async (req, res) => {
    const configKey = req.body.configKey;
    const db = new crud();
    const configs = await db.where("configKey", "=", configKey).get("config");
    const value = configs[0].configValue;
    return res.status(200).json(value);
  },
  setconfig: async (req, res) => {
    const { configKey, configValue } = req.body;
    const db = new crud();
    await db
      .where("configKey", "=", configKey)
      .update("config", { configValue });
    return res.status(200).json({ message: "success" });
  },
};
