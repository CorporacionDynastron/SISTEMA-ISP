-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-11-2026 a las 04:17:08
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sistema_isp`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `auditoria`
--

CREATE TABLE `auditoria` (
  `id_auditoria` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `modulo` varchar(50) NOT NULL,
  `accion` varchar(50) NOT NULL,
  `id_registro` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `auditoria`
--

INSERT INTO `auditoria` (`id_auditoria`, `id_usuario`, `modulo`, `accion`, `id_registro`, `descripcion`, `fecha_hora`) VALUES
(1, 1, 'PAGOS', 'REGISTRAR', 1, 'Pago registrado: PAG-20260915-0001', '2026-09-15 21:42:00'),
(2, 1, 'PAGOS', 'REGISTRAR', 8, 'Pago registrado: PAG-20260917-0001', '2026-09-17 18:24:19'),
(3, 1, 'PAGOS', 'REGISTRAR', 6, 'Pago registrado: PAG-20260917-0002', '2026-09-17 18:27:14'),
(4, 1, 'PAGOS', 'REGISTRAR', 5, 'Pago registrado: PAG-20260917-0003', '2026-09-17 18:27:56'),
(5, 1, 'PAGOS', 'REGISTRAR', 11, 'Pago registrado: PAG-20260917-0004', '2026-09-17 18:28:34'),
(6, 1, 'PAGOS', 'REGISTRAR', 9, 'Pago registrado: PAG-20260918-0001', '2026-09-18 10:53:33'),
(7, 1, 'PAGOS', 'REGISTRAR', 26, 'Pago registrado: PAG-20261007-0001', '2026-10-07 22:47:57'),
(8, 1, 'PAGOS', 'REGISTRAR', 3, 'Pago registrado: PAG-20261007-0002', '2026-10-07 22:49:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `codigo_cliente` varchar(20) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `telefono2` varchar(20) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `referencia_domicilio` varchar(255) DEFAULT NULL,
  `observaciones` text DEFAULT NULL,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `id_plan` int(11) NOT NULL,
  `fecha_instalacion` date DEFAULT NULL,
  `dia_vencimiento` int(11) NOT NULL,
  `tipo_emision` varchar(20) NOT NULL DEFAULT 'QUINCENAL',
  `estado` enum('ACTIVO','SUSPENDIDO','RETIRADO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `codigo_cliente`, `nombres`, `apellidos`, `dni`, `telefono`, `telefono2`, `direccion`, `referencia_domicilio`, `observaciones`, `foto_perfil`, `id_plan`, `fecha_instalacion`, `dia_vencimiento`, `tipo_emision`, `estado`) VALUES
(13, '1', 'Prueba 1', 'prueba 1', '12345698', '953021726', NULL, 'nada', NULL, NULL, NULL, 3, '2026-07-01', 5, 'QUINCENAL', 'ACTIVO'),
(44, '02', 'Cliente 2', 'Cliente 2', '12365986', '953021726', '', 'La Victoria', 'entrada la victoria', 'dedede', NULL, 3, '2026-09-08', 15, 'QUINCENAL', 'ACTIVO'),
(46, '10', 'emision', 'emision', '12365986', '953021726', '956905587', 'La Victoria', 'entrada la victoria', '', NULL, 1, '2026-10-09', 12, 'QUINCENAL', 'ACTIVO'),
(48, '11', 'recordatorio', 'recordatorio', '12365986', '953021726', '', 'La Victoria', 'entrada la victoria', '', NULL, 1, '2026-09-06', 9, 'QUINCENAL', 'ACTIVO'),
(49, '44', 'segundo aviso', 'segundo aviso', '12365986', '953021726', '', 'La Victoria', 'entrada la victoria', '', NULL, 1, '2026-09-07', 7, 'QUINCENAL', 'ACTIVO'),
(50, '47', 'suspension', 'suspension', '56986324', '978422655', '', 'nada', 'nada', '', NULL, 1, '2026-09-06', 6, 'QUINCENAL', 'ACTIVO'),
(51, '59', 'Evelin LIliana ', 'Martinez Guerra', '15698654', '314899478', '956905587', 'reamente las colinas A-14', 'Primera tranquera de colinas para arriba', 'Las Colinas', NULL, 1, '2026-09-25', 25, 'QUINCENAL', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracion`
--

CREATE TABLE `configuracion` (
  `id_configuracion` int(11) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `valor` text DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `fecha_actualizacion` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `configuracion`
--

INSERT INTO `configuracion` (`id_configuracion`, `clave`, `valor`, `descripcion`, `fecha_actualizacion`) VALUES
(1, 'nombre_empresa', 'Grupo Stellar', 'Nombre de la empresa', '2026-09-14 10:53:27'),
(2, 'moneda', 'PEN', 'Moneda utilizada por el sistema', '2026-09-14 10:53:27'),
(3, 'dias_alerta_vencimiento', '3', 'Días antes del vencimiento para mostrar alerta', '2026-09-14 10:53:27'),
(4, 'generar_cuotas_automaticamente', 'SI', 'Activar generación automática de cuotas', '2026-09-14 10:53:27'),
(5, 'mostrar_clientes_morosos_dashboard', 'SI', 'Mostrar morosos en el dashboard', '2026-09-14 10:53:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cuotas`
--

CREATE TABLE `cuotas` (
  `id_cuota` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `periodo` varchar(7) NOT NULL,
  `fecha_generacion` date NOT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date NOT NULL,
  `fecha_pago` date DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `estado` enum('PENDIENTE','PAGADA','VENCIDA','ANULADA') NOT NULL DEFAULT 'PENDIENTE',
  `observacion` varchar(255) DEFAULT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cuotas`
--

INSERT INTO `cuotas` (`id_cuota`, `id_cliente`, `periodo`, `fecha_generacion`, `fecha_emision`, `fecha_vencimiento`, `fecha_pago`, `monto`, `estado`, `observacion`, `fecha_registro`) VALUES
(5, 13, '2026-08', '2026-07-01', NULL, '2026-08-01', '2026-09-17', 100.00, 'PAGADA', 'Primera cuota generada automáticamente', '2026-09-16 21:56:03'),
(11, 13, '2026-09', '2026-09-17', NULL, '2026-09-05', '2026-09-17', 100.00, 'PAGADA', NULL, '2026-09-17 18:27:56'),
(12, 13, '2026-10', '2026-09-17', '2026-10-02', '2026-10-05', NULL, 100.00, 'VENCIDA', NULL, '2026-09-17 18:28:34'),
(35, 44, '2026-10', '2026-09-08', '2026-10-12', '2026-10-15', NULL, 100.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 15', '2026-10-08 20:49:06'),
(37, 46, '2026-11', '2026-10-09', '2026-10-09', '2026-10-12', NULL, 50.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 12', '2026-10-09 21:18:29'),
(38, 48, '2026-10', '2026-09-06', '2026-10-06', '2026-10-09', NULL, 50.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 9', '2026-10-09 21:19:21'),
(39, 49, '2026-10', '2026-09-07', '2026-10-04', '2026-10-07', NULL, 50.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 7', '2026-10-09 21:21:04'),
(40, 50, '2026-10', '2026-09-06', '2026-10-03', '2026-10-06', NULL, 50.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 6', '2026-10-09 21:21:55'),
(41, 51, '2026-10', '2026-09-25', '2026-10-22', '2026-10-25', NULL, 50.00, 'VENCIDA', 'Primera cuota generada automáticamente. Día elegido: 25', '2026-10-19 11:59:29');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodos_pago`
--

CREATE TABLE `metodos_pago` (
  `id_metodo_pago` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_registro` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `metodos_pago`
--

INSERT INTO `metodos_pago` (`id_metodo_pago`, `nombre`, `descripcion`, `estado`, `fecha_registro`) VALUES
(1, 'Yape', 'Pago realizado mediante Yape', 'ACTIVO', '2026-09-14 10:51:56'),
(2, 'Plin', 'Pago realizado mediante Plin', 'ACTIVO', '2026-09-14 10:51:56'),
(3, 'Transferencia', 'Transferencia bancaria', 'ACTIVO', '2026-09-14 10:51:56'),
(4, 'Efectivo', 'Pago en efectivo', 'ACTIVO', '2026-09-14 10:51:56'),
(5, 'Depósito', 'Depósito bancario', 'ACTIVO', '2026-09-14 10:51:56');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id_pago` int(11) NOT NULL,
  `codigo_pago` varchar(30) DEFAULT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_cuota` int(11) DEFAULT NULL,
  `fecha_pago` date NOT NULL,
  `periodo` varchar(20) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) DEFAULT NULL,
  `numero_operacion` varchar(100) DEFAULT NULL,
  `comprobante` varchar(255) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `observacion` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id_pago`, `codigo_pago`, `id_cliente`, `id_cuota`, `fecha_pago`, `periodo`, `monto`, `metodo_pago`, `numero_operacion`, `comprobante`, `id_usuario`, `observacion`) VALUES
(14, 'PAG-20260917-0003', 13, 5, '2026-09-17', '2026-08', 100.00, 'Yape', '01', 'pago_3578d126-d2ad-4fea-881f-adf0afa15b39.jpg', 1, 'pago realizado'),
(15, 'PAG-20260917-0004', 13, 11, '2026-09-17', '2026-09', 100.00, 'Efectivo', '02', 'pago_2673c450-f689-4cd1-b387-badc6bcdef25.jpg', 1, 'pago realizado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id_plan` int(11) NOT NULL,
  `nombre_plan` varchar(100) NOT NULL,
  `velocidad` varchar(50) NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id_plan`, `nombre_plan`, `velocidad`, `precio`, `descripcion`, `estado`) VALUES
(1, 'Plan Básico', '100 Mbps', 50.00, 'Internet residencial', 'ACTIVO'),
(2, 'Plan Estándar', '200 Mbps', 70.00, 'Internet residencial', 'ACTIVO'),
(3, 'Plan Premium', '400 Mbps', 100.00, 'Internet residencial', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `rol` enum('ADMIN','COBRANZAS','TECNICO') DEFAULT 'COBRANZAS',
  `estado` enum('ACTIVO','INACTIVO') DEFAULT 'ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `usuario`, `password`, `nombres`, `rol`, `estado`) VALUES
(1, 'admin', 'Paraque963@', 'Administrador', 'ADMIN', 'ACTIVO');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_deudas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_deudas` (
`id_cliente` int(11)
,`codigo_cliente` varchar(20)
,`cliente` varchar(201)
,`dni` varchar(20)
,`telefono` varchar(20)
,`direccion` varchar(255)
,`id_cuota` int(11)
,`periodo` varchar(7)
,`fecha_generacion` date
,`fecha_vencimiento` date
,`monto` decimal(10,2)
,`estado` enum('PENDIENTE','PAGADA','VENCIDA','ANULADA')
,`dias_atraso` int(7)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_estado_clientes`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_estado_clientes` (
`id_cliente` int(11)
,`codigo_cliente` varchar(20)
,`cliente` varchar(201)
,`dni` varchar(20)
,`telefono` varchar(20)
,`estado_servicio` enum('ACTIVO','SUSPENDIDO','RETIRADO')
,`cuotas_pendientes` bigint(21)
,`deuda_total` decimal(32,2)
,`dias_atraso` bigint(7)
,`proximo_vencimiento` date
,`estado_pago` varchar(16)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_deudas`
--
DROP TABLE IF EXISTS `vw_deudas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_deudas`  AS SELECT `c`.`id_cliente` AS `id_cliente`, `c`.`codigo_cliente` AS `codigo_cliente`, concat(`c`.`nombres`,' ',`c`.`apellidos`) AS `cliente`, `c`.`dni` AS `dni`, `c`.`telefono` AS `telefono`, `c`.`direccion` AS `direccion`, `q`.`id_cuota` AS `id_cuota`, `q`.`periodo` AS `periodo`, `q`.`fecha_generacion` AS `fecha_generacion`, `q`.`fecha_vencimiento` AS `fecha_vencimiento`, `q`.`monto` AS `monto`, `q`.`estado` AS `estado`, CASE WHEN `q`.`estado` in ('PENDIENTE','VENCIDA') AND curdate() > `q`.`fecha_vencimiento` THEN to_days(curdate()) - to_days(`q`.`fecha_vencimiento`) ELSE 0 END AS `dias_atraso` FROM (`clientes` `c` join `cuotas` `q` on(`c`.`id_cliente` = `q`.`id_cliente`)) WHERE `q`.`estado` in ('PENDIENTE','VENCIDA') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_estado_clientes`
--
DROP TABLE IF EXISTS `vw_estado_clientes`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_estado_clientes`  AS SELECT `c`.`id_cliente` AS `id_cliente`, `c`.`codigo_cliente` AS `codigo_cliente`, concat(`c`.`nombres`,' ',`c`.`apellidos`) AS `cliente`, `c`.`dni` AS `dni`, `c`.`telefono` AS `telefono`, `c`.`estado` AS `estado_servicio`, count(case when `q`.`estado` in ('PENDIENTE','VENCIDA') then 1 end) AS `cuotas_pendientes`, coalesce(sum(case when `q`.`estado` in ('PENDIENTE','VENCIDA') then `q`.`monto` else 0 end),0) AS `deuda_total`, max(case when `q`.`estado` in ('PENDIENTE','VENCIDA') and curdate() > `q`.`fecha_vencimiento` then to_days(curdate()) - to_days(`q`.`fecha_vencimiento`) else 0 end) AS `dias_atraso`, min(case when `q`.`estado` = 'PENDIENTE' and `q`.`fecha_vencimiento` >= curdate() then `q`.`fecha_vencimiento` else NULL end) AS `proximo_vencimiento`, CASE WHEN max(case when `q`.`estado` in ('PENDIENTE','VENCIDA') AND curdate() > `q`.`fecha_vencimiento` then to_days(curdate()) - to_days(`q`.`fecha_vencimiento`) else 0 end) >= 30 THEN 'MOROSO' WHEN max(case when `q`.`estado` in ('PENDIENTE','VENCIDA') AND curdate() > `q`.`fecha_vencimiento` then to_days(curdate()) - to_days(`q`.`fecha_vencimiento`) else 0 end) > 0 THEN 'VENCIDO' WHEN min(case when `q`.`estado` = 'PENDIENTE' AND `q`.`fecha_vencimiento` >= curdate() then to_days(`q`.`fecha_vencimiento`) - to_days(curdate()) else NULL end) <= 3 THEN 'PROXIMO A VENCER' ELSE 'AL DIA' END AS `estado_pago` FROM (`clientes` `c` left join `cuotas` `q` on(`c`.`id_cliente` = `q`.`id_cliente`)) GROUP BY `c`.`id_cliente`, `c`.`codigo_cliente`, `c`.`nombres`, `c`.`apellidos`, `c`.`dni`, `c`.`telefono`, `c`.`estado` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD PRIMARY KEY (`id_auditoria`),
  ADD KEY `idx_auditoria_usuario` (`id_usuario`),
  ADD KEY `idx_auditoria_modulo` (`modulo`),
  ADD KEY `idx_auditoria_accion` (`accion`),
  ADD KEY `idx_auditoria_fecha` (`fecha_hora`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `codigo_cliente` (`codigo_cliente`),
  ADD KEY `id_plan` (`id_plan`);

--
-- Indices de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  ADD PRIMARY KEY (`id_configuracion`),
  ADD UNIQUE KEY `uk_configuracion_clave` (`clave`);

--
-- Indices de la tabla `cuotas`
--
ALTER TABLE `cuotas`
  ADD PRIMARY KEY (`id_cuota`),
  ADD UNIQUE KEY `uk_cuota_cliente_periodo` (`id_cliente`,`periodo`),
  ADD KEY `idx_cuota_cliente` (`id_cliente`),
  ADD KEY `idx_cuota_vencimiento` (`fecha_vencimiento`),
  ADD KEY `idx_cuota_estado` (`estado`);

--
-- Indices de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  ADD PRIMARY KEY (`id_metodo_pago`),
  ADD UNIQUE KEY `uk_metodo_pago_nombre` (`nombre`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id_pago`),
  ADD UNIQUE KEY `uk_pago_codigo` (`codigo_pago`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `idx_pago_cuota` (`id_cuota`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`id_plan`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `auditoria`
--
ALTER TABLE `auditoria`
  MODIFY `id_auditoria` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT de la tabla `configuracion`
--
ALTER TABLE `configuracion`
  MODIFY `id_configuracion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cuotas`
--
ALTER TABLE `cuotas`
  MODIFY `id_cuota` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `metodos_pago`
--
ALTER TABLE `metodos_pago`
  MODIFY `id_metodo_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `pagos`
--
ALTER TABLE `pagos`
  MODIFY `id_pago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id_plan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `auditoria`
--
ALTER TABLE `auditoria`
  ADD CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_plan`) REFERENCES `planes` (`id_plan`);

--
-- Filtros para la tabla `cuotas`
--
ALTER TABLE `cuotas`
  ADD CONSTRAINT `fk_cuota_cliente` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD CONSTRAINT `fk_pago_cuota` FOREIGN KEY (`id_cuota`) REFERENCES `cuotas` (`id_cuota`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `pagos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  ADD CONSTRAINT `pagos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
