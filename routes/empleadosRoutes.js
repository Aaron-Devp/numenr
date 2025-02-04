const express = require('express');
const router = express.Router();
const db = require('../db/db');

// Obtener todos los empleados
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT id, nombre, apellido, email, telefono, creado_en, actualizado_en
            FROM empleados
        `);
        res.status(200).json(rows);
    } catch (error) {
        console.error('Error al obtener empleados:', error.message);
        res.status(500).json({
            error: 'Error al obtener empleados',
            details: error.message,
        });
    }
});

// Agregar nuevo empleado
router.post('/', async (req, res) => {
    const { nombre, apellido, email, telefono } = req.body;

    if (!nombre || !apellido || !email || !telefono) {
        return res.status(400).json({ error: 'Faltan datos requeridos' });
    }

    try {
        const [result] = await db.query(
            'INSERT INTO empleados (nombre, apellido, email, telefono, creado_en, actualizado_en) VALUES (?, ?, ?, ?, NOW(), NOW())',
            [nombre, apellido, email, telefono]
        );
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error('Error al agregar empleado:', error.message);
        res.status(500).json({
            error: 'Error al agregar empleado',
            details: error.message,
        });
    }
});

// Editar empleado
router.put('/:id', async (req, res) => {
    const { id } = req.params;
    const { nombre, apellido, email, telefono } = req.body;

    if (!nombre || !apellido || !email || !telefono) {
        return res.status(400).json({ error: 'Faltan datos requeridos' });
    }

    try {
        const [result] = await db.query(
            'UPDATE empleados SET nombre = ?, apellido = ?, email = ?, telefono = ?, actualizado_en = NOW() WHERE id = ?',
            [nombre, apellido, email, telefono, id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Empleado no encontrado' });
        }
        res.json({ message: 'Empleado actualizado correctamente' });
    } catch (error) {
        console.error('Error al actualizar empleado:', error.message);
        res.status(500).json({
            error: 'Error al actualizar empleado',
            details: error.message,
        });
    }
});

// Eliminar empleado
router.delete('/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const [result] = await db.query('DELETE FROM empleados WHERE id = ?', [id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Empleado no encontrado' });
        }
        res.json({ message: 'Empleado eliminado correctamente' });
    } catch (error) {
        console.error('Error al eliminar empleado:', error.message);
        res.status(500).json({
            error: 'Error al eliminar empleado',
            details: error.message,
        });
    }
});

module.exports = router;
