const crud = require('../helpers/crud')
const crypter = require('../helpers/crypter')

module.exports = {
    getRanks: async (req, res) => {
        const db = new crud
        const ranks = await db.get('t_rank')
        return res.status(200).json(ranks)
    },
    addRank: async (req, res) => {
        try {
            const db = new crud
            const { rankName, description, collumns, rankNameJp } = req.body
            const duplicate = await db.where('rankName', '=', rankName).get('t_rank')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Rank Name",
                    text: "The given rank name is already in use, please use another name!",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.insert('t_rank', { rankName, description, collumns: JSON.stringify(collumns), rankNameJp })

            return res.status(200).json({ message: 'success' })

        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    deleteRank: async (req, res) => {
        const db = new crud
        const rankId = req.body.rankId
        await db.where('rankId', '=', rankId).delete('t_rank')
        return res.status(200).json({ message: 'success' })
    },
    editRank: async (req, res) => {
        try {
            const db = new crud
            const { rankName, description, rankId, collumns, rankNameJp } = req.body
            const duplicate = await db.where('rankName', '=', rankName).where('rankId', '!=', rankId).get('t_rank')

            if (duplicate.length > 0) {
                throw {
                    title: "Duplicate Rank Name",
                    text: "The given rank name is already in use, please use another name!",
                    icon: "error",
                    timer: 3000,
                }
            }

            await db.where('rankId', '=', rankId).update('t_rank', { rankName, description, collumns: JSON.stringify(collumns), rankNameJp })

            return res.status(200).json({ message: 'success' })
        } catch (error) {
            console.log(error)
            return res.status(404).json(error)
        }
    },
    getCollumn: async (req, res) => {
        const db = new crud
        const columns = await db.get('t_collumns')
        return res.status(200).json(columns)
    }
}