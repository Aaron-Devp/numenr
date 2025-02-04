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
-- Table structure for table `inventario`
--

DROP TABLE IF EXISTS `inventario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventario` (
  `id` bigint NOT NULL,
  `codigo_defecto` varchar(255) DEFAULT NULL,
  `codigo_interno` varchar(255) DEFAULT NULL,
  `nombre_producto` varchar(255) NOT NULL,
  `categoria_id` bigint NOT NULL,
  `departamento_id` bigint NOT NULL,
  `marca_id` bigint NOT NULL,
  `color_id` bigint DEFAULT NULL,
  `talla_id` bigint DEFAULT NULL,
  `cantidad` int DEFAULT '0',
  `precio_costo` decimal(10,2) NOT NULL,
  `precio_venta` decimal(10,2) NOT NULL,
  `creado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `actualizado_en` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `inventario_categoria_id_fkey` (`categoria_id`),
  KEY `inventario_color_id_fkey` (`color_id`),
  KEY `inventario_departamento_id_fkey` (`departamento_id`),
  KEY `inventario_marca_id_fkey` (`marca_id`),
  KEY `inventario_talla_id_fkey` (`talla_id`),
  CONSTRAINT `inventario_categoria_id_fkey` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`),
  CONSTRAINT `inventario_color_id_fkey` FOREIGN KEY (`color_id`) REFERENCES `colores` (`id`),
  CONSTRAINT `inventario_departamento_id_fkey` FOREIGN KEY (`departamento_id`) REFERENCES `departamentos` (`id`),
  CONSTRAINT `inventario_marca_id_fkey` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`),
  CONSTRAINT `inventario_talla_id_fkey` FOREIGN KEY (`talla_id`) REFERENCES `tallas` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventario`
--

LOCK TABLES `inventario` WRITE;
/*!40000 ALTER TABLE `inventario` DISABLE KEYS */;
INSERT INTO `inventario` VALUES (1,NULL,'001','Televisor 55 pulgadas',1,1,2,NULL,NULL,10,500.00,800.00,'2025-01-17 01:47:45','2025-01-17 01:47:45'),(2,NULL,'002','Refrigerador',2,1,1,NULL,NULL,5,300.00,500.00,'2025-01-17 01:47:45','2025-01-17 01:47:45'),(3,NULL,'003','Camiseta',3,1,3,NULL,NULL,20,10.00,20.00,'2025-01-17 01:47:45','2025-01-17 01:47:45');
/*!40000 ALTER TABLE `inventario` ENABLE KEYS */;
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
