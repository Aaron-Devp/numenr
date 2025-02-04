const express = require('express');
const router = express.Router();
const db = require('../db/db');

// Generar un código interno único
async function generarCodigoInterno(nombre, categoria, departamento) {
    const nombreCorto = nombre.substring(0, 3).toUpperCase();
    const categoriaCorta = categoria.substring(0, 2).toUpperCase();
    const departamentoCorto = departamento.substring(0, 2).toUpperCase();

    // Incrementar el contador global sin usar RETURNING
    const [updateResult] = await db.query(
        'UPDATE contador_global SET valor_actual = valor_actual + 1'
    );

    // Obtener el nuevo valor del contador
    const [[contador]] = await db.query('SELECT valor_actual FROM contador_global');

    return `${nombreCorto}-${categoriaCorta}-${departamentoCorto}-${contador.valor_actual}`;
}

router.get('/productos/search', async (req, res) => {
    const { query } = req.query; // Captura el texto de búsqueda.

    if (!query) {
        return res.status(400).json({ error: 'El parámetro de búsqueda es obligatorio' });
    }

    try {
        const [rows] = await db.query(
            `SELECT * FROM producto 
            WHERE nombre_producto LIKE ? 
                OR codigo_interno LIKE ? 
                OR cantidad LIKE ? 
                OR precio_costo LIKE ? 
                OR precio_venta LIKE ?`,
            Array(5).fill(`%${query}%`) // Aplica la búsqueda en todas las columnas relevantes.
        );
        res.json(rows);
    } catch (error) {
        console.error('Error en la búsqueda:', error.message);
        res.status(500).json({ error: error.message });
    }
});

// Obtener todos los productos
router.get('/productos', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT p.*, c.nombre AS categoria, d.nombre AS departamento, 
                m.nombre AS marca, col.nombre AS color, 
                CONCAT(t.tipo, ' ', t.valor) AS talla
            FROM producto p
            LEFT JOIN categorias c ON p.categoria_id = c.id
            LEFT JOIN departamentos d ON p.departamento_id = d.id
            LEFT JOIN marcas m ON p.marca_id = m.id
            LEFT JOIN colores col ON p.color_id = col.id
            LEFT JOIN tallas t ON p.talla_id = t.id;
        `);
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener productos:', error.message);
        res.status(500).json({ error: error.message });
    }
});

// Agregar un producto
router.post('/productos', async (req, res) => {
    const {
        codigo_defecto,
        nombre_producto,
        categoria_id,
        departamento_id,
        marca_id,
        color_id,
        talla_id,
        cantidad,
        precio_costo,
        precio_venta,
    } = req.body;

    try {
        const [[categoria]] = await db.query('SELECT nombre FROM categorias WHERE id = ?', [categoria_id]);
        const [[departamento]] = await db.query('SELECT nombre FROM departamentos WHERE id = ?', [departamento_id]);

        if (!categoria || !departamento) {
            return res.status(400).json({ error: 'Categoría o departamento inválidos' });
        }

        const codigo_interno = await generarCodigoInterno(nombre_producto, categoria.nombre, departamento.nombre);

        const [result] = await db.query(
            `INSERT INTO producto (codigo_defecto, codigo_interno, nombre_producto, 
            categoria_id, departamento_id, marca_id, color_id, talla_id, 
            cantidad, precio_costo, precio_venta, creado_en, actualizado_en) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())`,
            [
                codigo_defecto,
                codigo_interno,
                nombre_producto,
                categoria_id,
                departamento_id,
                marca_id,
                color_id,
                talla_id,
                cantidad,
                precio_costo,
                precio_venta,
            ]
        );

        res.status(201).json({ id: result.insertId, codigo_interno });
    } catch (error) {
        console.error('Error al agregar producto:', error.message);
        res.status(500).json({ error: error.message });
    }
});


// Eliminar un producto
router.delete('/productos/:id', async (req, res) => {
    const { id } = req.params;

    try {
        await db.query(`DELETE FROM producto WHERE id = ?`, [id]);
        res.status(200).json({ message: 'Producto eliminado correctamente' });
    } catch (error) {
        console.error('Error al eliminar producto:', error.message);
        res.status(500).json({ error: error.message });
    }
});

// Otros endpoints (categorías, departamentos, etc.)
router.get('/categorias', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, nombre FROM categorias');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.get('/departamentos', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, nombre FROM departamentos');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.get('/marcas', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, nombre FROM marcas');
        res.json(rows);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.get('/colores', async (req, res) => {
    try {
        const [rows] = await db.query('SELECT id, nombre FROM colores');
        if (rows.length === 0) {
            return res.status(404).json({ message: 'No se encontraron colores' });
        }
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener colores:', error.message);
        res.status(500).json({ error: error.message });
    }
});

router.get('/tallas', async (req, res) => {
    try {
        // `tallas` tiene las columnas `tipo` y `valor`
        const [rows] = await db.query('SELECT id, tipo, valor FROM tallas');
        if (rows.length === 0) {
            return res.status(404).json({ message: 'No se encontraron tallas' });
        }
        res.json(rows);
    } catch (error) {
        console.error('Error al obtener tallas:', error.message);
        res.status(500).json({ error: error.message });
    }
});


// Verificar si un código interno ya existe
router.get('/verificar-codigo/:codigoInterno', async (req, res) => {
    const { codigoInterno } = req.params;

    try {
        const [rows] = await db.query(
            'SELECT COUNT(*) AS count FROM producto WHERE codigo_interno = ?',
            [codigoInterno]
        );
        const existe = rows[0].count > 0;
        res.json({ existe });
    } catch (error) {
        console.error('Error al verificar el código interno:', error.message);
        res.status(500).json({ error: error.message });
    }
});



module.exports = router;
