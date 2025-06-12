const crud = require('../helpers/crud')

module.exports = {
    addPoint: async (req, res) => {
        try {
            const db = new crud
            const { toolId, pointString, pointNumber } = req.body
            const duplicate = await db.where('pointString', '=', pointString).where('toolId', '=', toolId).get('t_pointcheck')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Item",
                    text: "The Point is already in the database",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.insert('t_pointcheck', { toolId, pointString, pointNumber })

            return res.status(200).json({ message: 'success' });

        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    getPoint: async (req, res) => {
        const db = new crud
        let points = await db.join('left', 't_rank', 't_rank.rankId', 't_pointcheck.rankId').get('t_pointcheck')

        const methodes = await db
            .join('left', 'resulttype', 'resulttype.typeId', 't_checkmethod.resultType')
            .get('t_checkmethod');

        await Promise.all(points.map(async (element, index) => {
            points[index].methodes = methodes.filter(method => method.pointCheckId === element.checkId)
        }));

        return res.status(200).json(points)
    },
    getMethods: async (req, res) => {
        const db = new crud
        const pointCheckId = req.body.pointCheckId
        const methods = await db.where('pointCheckId', '=', pointCheckId).join('left', 'resulttype', 'resulttype.typeId', 't_checkmethod.resultType').get('t_checkmethod')
        return res.status(200).json(methods)
    },
    editPoint: async (req, res) => {
        try {
            const db = new crud

            const { toolId, pointString, pointNumber, checkId } = req.body
            const duplicate = await db.where('pointString', '=', pointString).where('toolId', '=', toolId).where('checkId', '!=', checkId).get('t_pointcheck')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Item",
                    text: "The Point is already in the database",
                    icon: "error",
                    timer: 3000,
                }
            }

            db.where('checkId', '=', checkId)
            await db.update('t_pointcheck', { pointString, pointNumber })

            return res.status(200).json({ message: 'success' })

        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    deletePoint: async (req, res) => {
        const db = new crud
        const checkId = req.body.checkId
        await db.where('checkId', '=', checkId).delete('t_pointcheck')
        return res.status(200).json({ message: 'success' })
    },
    addMethod: async (req, res) => {
        try {
            const db = new crud
            const { pointCheckId, methodString, resultType, standard } = req.body
            const duplicate = await db.where('pointCheckId', '=', pointCheckId).where('methodString', '=', methodString).get('t_checkmethod')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Item",
                    text: "The methode is already in the database",
                    icon: "error",
                    timer: 3000,
                }
            }

            const added = await db.insert('t_checkmethod', { pointCheckId, methodString, resultType, standard: JSON.stringify(standard) })

            return res.status(200).json(added);

        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    editMethod: async (req, res) => {
        try {
            const {
                standard,
                methodString,
                resultType,
                typeLabel,
                methodId,
                pointCheckId,
            } = req.body

            const db = new crud
            const duplicate = await db.where('methodId', '!=', methodId)
                .where('methodString', '=', methodString)
                .where('resultType', '=', resultType)
                .where('pointCheckId', '=', pointCheckId)
                .get('t_checkmethod')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Item",
                    text: "The methode is already in the database",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.where('methodId', '=', methodId)
                .update('t_checkmethod', {
                    methodString,
                    resultType,
                    standard: JSON.stringify(standard),
                })

            return res.status(200).json({ response: 'success' })
        } catch (error) {

            console.log(error)
            return res.status(404).json(error)
        }
    },

    deleteMethod: async (req, res) => {
        const db = new crud
        const methodId = req.body.methodId
        await db.where('methodId', '=', methodId).delete('t_checkmethod')
        return res.status(200).json({ message: 'success' })
    },
}