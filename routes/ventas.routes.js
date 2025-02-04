const express = require('express');
const router = express.Router();
const db = require('../db/db');

// Registrar una nueva venta
router.post('/ventas', async (req, res) => {
    const { usuario_id, fecha, total, tipo_pago, descuento_total } = req.body;

    try {
        const [result] = await db.query(
            `INSERT INTO ventas (usuario_id, fecha, total, tipo_pago, descuento_total, creado_en) 
            VALUES (?, ?, ?, ?, ?, NOW())`,
            [usuario_id, fecha, total, tipo_pago, descuento_total]
        );

        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error('Error al registrar venta:', error.message);
        res.status(500).json({ error: 'Error al registrar venta.' });
    }
});

// Registrar detalles de una venta
router.post('/detalles-venta', async (req, res) => {
    const detalles = req.body;

    try {
        const queries = detalles.map((detalle) => {
            return db.query(
                `INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario, subtotal) 
                VALUES (?, ?, ?, ?, ?)`,
                [
                    detalle.venta_id,
                    detalle.producto_id,
                    detalle.cantidad,
                    detalle.precio_unitario,
                    detalle.subtotal,
                ]
            );
        });

        await Promise.all(queries);

        res.status(201).json({ message: 'Detalles de venta registrados correctamente.' });
    } catch (error) {
        console.error('Error al registrar detalles de venta:', error.message);
        res.status(500).json({ error: 'Error al registrar detalles de venta.' });
    }
});

// Actualizar stock de un producto
router.put('/productos/:id/stock', async (req, res) => {
    const { id } = req.params;
    const { cantidad } = req.body;

    try {
        await db.query(
            `UPDATE productos SET cantidad = ? WHERE id = ?`,
            [cantidad, id]
        );

        res.status(200).json({ message: 'Stock actualizado correctamente.' });
    } catch (error) {
        console.error('Error al actualizar stock:', error.message);
        res.status(500).json({ error: 'Error al actualizar stock.' });
    }
});

// Ruta para buscar productos
router.get('/productos/search', async (req, res) => {
    const { query } = req.query;
    try {
    const [rows] = await db.query(
    `SELECT id, nombre_producto AS name, precio_venta AS price, cantidad AS stock 
        FROM productos 
        WHERE nombre_producto LIKE ? OR codigo_interno LIKE ?`,
        [`%${query}%`, `%${query}%`]
    );
    res.status(200).json(rows);
    } catch (error) {
        console.error('Error al buscar productos:', error.message);
        res.status(500).json({ error: 'Error al buscar productos.' });
    }
});

module.exports = router;
