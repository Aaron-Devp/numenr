const express = require('express');
const multer = require('multer');
const path = require('path');
const db = require('../db/db');

const router = express.Router();

// Configuración de multer
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, '../uploads/profile_pictures/')); // Ruta absoluta
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}_${file.originalname}`);
    },
});

const upload = multer({ storage });

// Ruta para subir la imagen de perfil
router.post('/uploadProfilePicture', upload.single('profile_picture'), async (req, res) => {
    const { userId } = req.body;

    // Verificar si el archivo fue subido
    if (!req.file) {
        return res.status(400).send({ message: 'No se subió ninguna imagen' });
    }

    const profilePicturePath = `/uploads/profile_pictures/${req.file.filename}`;

    try {
        // Actualizar la base de datos con la nueva ruta
        const [result] = await db.query('UPDATE usuarios SET profile_picture = ? WHERE id = ?', [profilePicturePath, userId]);

        if (result.affectedRows === 0) {
            return res.status(404).send({ message: 'Usuario no encontrado' });
        }

        res.status(200).send({
            message: 'Imagen de perfil actualizada correctamente',
            profilePictureUrl: `http://192.168.1.68:3000${profilePicturePath}`,
        });
    } catch (error) {
        console.error('Error al subir la imagen:', error);
        res.status(500).send({ message: 'Error al subir la imagen' });
    }
});

// Ruta para obtener datos del usuario
router.get('/:userId', async (req, res) => {
    const { userId } = req.params;

    try {
        const [rows] = await db.query('SELECT * FROM usuarios WHERE id = ?', [userId]);

        if (rows.length > 0) {
            const user = rows[0];
            // Si no tiene foto de perfil, asignar la imagen predeterminada
            user.profile_picture = user.profile_picture || '/uploads/profile_pictures/default_profile.png';

            res.status(200).send(user);
        } else {
            res.status(404).send({ message: 'Usuario no encontrado' });
        }
    } catch (error) {
        console.error('Error al obtener datos del usuario:', error);
        res.status(500).send({ message: 'Error interno del servidor' });
    }
});

module.exports = router;
