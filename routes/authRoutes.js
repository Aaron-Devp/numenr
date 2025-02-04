const express = require('express');
const router = express.Router();
const db = require('../db/db');

// Ruta para iniciar sesión
router.post('/login', async (req, res) => {
    console.log('Datos recibidos:', req.body); // Registra los datos entrantes
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).send({ message: 'Usuario y contraseña son requeridos' });
    }

    try {
        const query = `
        SELECT usuarios.id, usuarios.nombre_usuario, usuarios.profile_picture, permisos.permisos
        FROM usuarios
        INNER JOIN permisos ON usuarios.permiso_id = permisos.id
        WHERE nombre_usuario = ? AND contrasena = ?
        `;

        const [rows] = await db.query(query, [username, password]);

        if (rows.length > 0) {
            const user = rows[0];

            // Validar y procesar permisos
            let permisos;
            try {
                if (typeof user.permisos === 'string') {
                    permisos = JSON.parse(user.permisos); // Parsear si es una cadena JSON
                } else if (typeof user.permisos === 'object') {
                    permisos = user.permisos; // Si ya es un objeto, úsalo directamente
                } else {
                    throw new Error('Formato de permisos no reconocido');
                }
            } catch (err) {
                console.error('Error al procesar permisos:', err.message);
                return res.status(500).send({ message: 'Error interno al procesar permisos' });
            }

            res.status(200).send({
                message: 'Inicio de sesión exitoso',
                user: {
                    id: user.id,
                    nombre_usuario: user.nombre_usuario,
                    profile_picture: user.profile_picture || 'uploads/profile_pictures/default_profile.png', // Imagen por defecto si no hay
                    permisos: permisos, // Permisos como objeto JSON
                },
            });
        } else {
            res.status(401).send({ message: 'Credenciales inválidas' });
        }
    } catch (err) {
        console.error('Error en la consulta:', err.message);
        res.status(500).send({ message: 'Error interno del servidor' });
    }
});

module.exports = router;
