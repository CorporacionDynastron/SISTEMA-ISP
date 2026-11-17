# SISTEMA ISP - GESTIÓN Y COBRANZAS

Sistema web empresarial diseñado para la administración integral de clientes, cuotas, recaudación y control de morosidad para proveedores de servicios de internet (WISP / ISP) y empresas de telecomunicaciones.

Desarrollado y mantenido por **Corporación Dynastron**.

---

## 🚀 Características Principales

* **Gestión de Clientes (Abonados):** Padrón centralizado con datos de contacto, dirección, IP asignada, plan contratado y estados de servicio (`ACTIVO`, `SUSPENDIDO`, `EN CORTE`, `RETIRADO`).
* **Catálogo de Planes:** Configuración flexible de planes de internet por velocidad (Mbps) y precio mensual.
* **Control de Cuotas y Facturación:** Emisión de cuotas mensuales automáticas con control de fechas de vencimiento y estados (`PENDIENTE`, `PAGADO`, `VENCIDO`).
* **Módulo de Cobranzas y Pagos:** Registro de pagos con código único de recibo, soporte para múltiples medios de pago (Efectivo, Yape, Plin, Transferencia) y registro de comprobantes.
* **Semáforo de Morosidad:** Detección de clientes con cuotas vencidas y alertas de corte de servicio.
* **Notificaciones por WhatsApp:** Generación de avisos de cobranza personalizados (recordatorio preventivo, vencimiento y aviso de suspensión) con apertura directa en WhatsApp Web / Móvil.
* **Reportes Contables en Excel:** Exportación nativa de estados de cuenta y reportes financieros en formato `.xlsx` utilizando Apache POI.
* **Auditoría del Sistema:** Trazabilidad completa de operaciones y modificaciones por usuario y fecha.

---

## 🛠️ Stack Tecnológico

* **Lenguaje:** Java (JDK 17 / 21)
* **Arquitectura:** Modelo-Vista-Controlador (MVC) con patrón Data Access Object (DAO)
* **Controladores:** Servlets (`javax.servlet`)
* **Vistas:** JavaServer Pages (JSP) + HTML5 + CSS3 + JavaScript
* **Base de Datos:** MySQL / MariaDB (UTF-8 `utf8mb4`)
* **Reportes:** Apache POI 5.2.3 (`poi`, `poi-ooxml`)
* **Servidor de Aplicaciones:** Apache Tomcat 9.0+
* **Proxy Web & SSL:** Nginx + Let's Encrypt (HTTPS / TLS 1.3)

---

## 📂 Estructura del Proyecto

```text
├── lib/                     # Librerías y dependencias JAR (Apache POI, MySQL Driver, etc.)
├── src/
│   └── java/
│       ├── conexion/        # Conexión JDBC a base de datos
│       ├── controlador/     # Servlets y Filtros de autenticación
│       ├── dao/             # Acceso a datos (Consultas SQL)
│       └── modelo/          # Clases de dominio y entidades
├── web/                     # Páginas JSP, CSS, imágenes y recursos estáticos
├── build.xml                # Script de compilación Apache Ant
├── sistema_isp (5).sql      # Script de base de datos (esquema y datos iniciales)
└── README.md                # Documentación del proyecto
```

---

## ⚙️ Instalación y Configuración Local

### 1. Requisitos Previos
* Java Development Kit (JDK 17 o superior)
* Apache Tomcat 9.0.x
* MySQL Server o MariaDB (10.4+)
* IDE recomendado: IntelliJ IDEA o NetBeans

### 2. Base de Datos
1. Crear la base de datos en MySQL/MariaDB:
   ```sql
   CREATE DATABASE sistema_isp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
2. Importar el archivo `sistema_isp (5).sql`:
   ```bash
   mysql -u root -p sistema_isp < "sistema_isp (5).sql"
   ```

### 3. Configuración de Conexión
Verificar los parámetros de conexión en `src/java/conexion/Conexion.java`:
* Host: `localhost:3306`
* Base de datos: `sistema_isp`
* Usuario: `root` (desarrollo) o `isp_admin` (producción)

### 4. Compilación y Ejecución
* Abrir el proyecto en **IntelliJ IDEA** o **NetBeans** y compilar mediante Ant o las herramientas del IDE.
* Desplegar el artefacto `.war` resultante en el contenedor Tomcat (`webapps/`).

---

## 🏢 Licencia y Créditos

Desarrollado para **Grupo Stellar**.  
Propiedad de **Corporación Dynastron**. Todos los derechos reservados.
