const crud = require('../helpers/crud')
const crypter = require('../helpers/crypter')

module.exports = {
    addType: async (req, res) => {
        try {
            const db = new crud
            const { typeName } = req.body
            const duplicate = await db.where('typeName', '=', typeName).get('t_tooltype')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Type Name",
                    text: "The given type name is already in use, please use another name!",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.insert('t_tooltype', { typeName })

            return res.status(200).json({ message: 'success' })
        } catch (error) {

            console.log(error)
            return res.status(404).json(error)
        }
    },
    getType: async (req, res) => {
        try {
            const db = new crud

            let types = await db.get('t_tooltype')
            let points = await db.get('t_pointcheck')
            db.join('left', 'resulttype', 'resulttype.typeId', 't_checkmethod.resultType')
            const checkMethods = await db.get('t_checkmethod')

            points = await Promise.all(points.map(point => {
                point.methodes = checkMethods.filter(method => method.pointCheckId === point.checkId)
                return point
            }))

            types = await Promise.all(types.map(type => {
                type.points = points.filter(point => point.typeId == type.typeId);
                return type
            }))

            return res.status(200).json(types)
        } catch (error) {

            console.log(error)
            return res.status(404).json(error)
        }
    },

    editType: async (req, res) => {
        try {
            const db = new crud
            const { typeName, typeId } = req.body
            const duplicate = await db.where('typeName', '=', typeName).where('typeId', '!=', typeId).get('t_tooltype')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Type Name",
                    text: "The given type name is already in use, please use another name!",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.where('typeId', '=', typeId).update('t_tooltype', { typeName })

            return res.status(200).json({ message: 'success' })
        } catch (error) {

            console.log(error)
            return res.status(404).json(error)
        }
    },

    deleteType: async (req, res) => {
        const db = new crud
        const { typeId } = req.body
        await db.where('typeId', '=', typeId).delete('t_tooltype')

        return res.status(200).json({ message: 'success' })
    },
    getResultType: async (req, res) => {
        try {
            const db = new crud

            const types = await db.get('resulttype')
            return res.status(200).json(types)
        } catch (error) {

            console.log(error)
            return res.status(404).json(error)
        }
    },
    getPoints: async (req, res) => {
        const db = new crud
        const { toolId } = req.body
        let points = await db.where('toolId', '=', toolId).get('t_pointcheck')
        const checkMethods = await db.get('t_checkmethod')

        points = await Promise.all(points.map(point => {
            point.methods = checkMethods.filter(method => method.pointCheckId == point.checkId)
            return point
        }))

        return res.status(200).json(points)
    }
}