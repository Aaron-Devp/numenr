-- MySQL dump 10.13  Distrib 8.0.38, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: numenr
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `permisos`
--

DROP TABLE IF EXISTS `permisos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permisos` (
  `id` bigint NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `permisos` json DEFAULT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permisos`
--

LOCK TABLES `permisos` WRITE;
/*!40000 ALTER TABLE `permisos` DISABLE KEYS */;
INSERT INTO `permisos` VALUES (1,'Permiso Alto','Permite acceso completo al sistema, incluyendo gestión de inventario, ventas, créditos, reportes y configuración del sistema.','{\"home\": true, \"venta\": true, \"pedidos\": true, \"clientes\": true, \"reportes\": true, \"inventario\": true, \"colaboradores\": true, \"configuraciones\": true, \"recibirProducto\": true}','2025-01-17 14:07:09','2025-01-17 14:07:09'),(2,'Permiso Avanzado','Permite gestionar inventarios, realizar y confirmar ventas, acceder a reportes, gráficos y administrar usuarios.','{\"home\": true, \"venta\": true, \"pedidos\": true, \"clientes\": true, \"reportes\": true, \"inventario\": true, \"colaboradores\": true, \"configuraciones\": true, \"recibirProducto\": true}','2025-01-17 14:07:09','2025-01-17 14:07:09'),(3,'Permiso Medio','Permite realizar ventas, gestionar inventarios y acceder a reportes básicos como ventas del día y créditos.','{\"home\": true, \"venta\": true, \"pedidos\": false, \"clientes\": true, \"reportes\": false, \"inventario\": true, \"colaboradores\": false, \"configuraciones\": false, \"recibirProducto\": true}','2025-01-17 14:07:09','2025-01-17 14:07:09'),(4,'Permiso Bajo','Permite realizar ventas, acceder al módulo de mis ventas y escanear productos.','{\"home\": true, \"venta\": false, \"pedidos\": false, \"clientes\": true, \"reportes\": false, \"inventario\": true, \"colaboradores\": false, \"configuraciones\": false, \"recibirProducto\": false}','2025-01-17 14:07:09','2025-01-17 14:07:09');
/*!40000 ALTER TABLE `permisos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-19 21:05:26
