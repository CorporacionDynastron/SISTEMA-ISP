package modelo;

public class Cliente {

    private int idCliente;

    private String codigoCliente;
    private String nombres;
    private String apellidos;
    private String dni;

    private String telefono;
    private String telefono2;

    private String direccion;
    private String referenciaDomicilio;
    private String observaciones;
    private String fotoPerfil;

    private int idPlan;

    private String nombrePlan;
    private String velocidad;
    private double precioPlan;

    private String fechaInstalacion;

    private int diaVencimiento;

    // NUEVO: tipo de emisión de la cuota
    // QUINCENAL = día 15 de cada mes
    // FIN_DE_MES = último día de cada mes
    private String tipoEmision;

    private String estado;


    // ==========================================
    // CONSTRUCTOR
    // ==========================================

    public Cliente() {
    }


    // ==========================================
    // ID CLIENTE
    // ==========================================

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }


    // ==========================================
    // CODIGO CLIENTE
    // ==========================================

    public String getCodigoCliente() {
        return codigoCliente;
    }

    public void setCodigoCliente(String codigoCliente) {
        this.codigoCliente = codigoCliente;
    }


    // ==========================================
    // NOMBRES
    // ==========================================

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }


    // ==========================================
    // APELLIDOS
    // ==========================================

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }


    // ==========================================
    // DNI
    // ==========================================

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }


    // ==========================================
    // TELEFONO
    // ==========================================

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }


    // ==========================================
    // TELEFONO 2
    // ==========================================

    public String getTelefono2() {
        return telefono2;
    }

    public void setTelefono2(String telefono2) {
        this.telefono2 = telefono2;
    }


    // ==========================================
    // DIRECCION
    // ==========================================

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }


    // ==========================================
    // REFERENCIA DOMICILIO
    // ==========================================

    public String getReferenciaDomicilio() {
        return referenciaDomicilio;
    }

    public void setReferenciaDomicilio(String referenciaDomicilio) {
        this.referenciaDomicilio = referenciaDomicilio;
    }


    // ==========================================
    // OBSERVACIONES
    // ==========================================

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }


    // ==========================================
    // FOTO DE PERFIL
    // ==========================================

    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }


    // ==========================================
    // ID PLAN
    // ==========================================

    public int getIdPlan() {
        return idPlan;
    }

    public void setIdPlan(int idPlan) {
        this.idPlan = idPlan;
    }


    // ==========================================
    // NOMBRE PLAN
    // ==========================================

    public String getNombrePlan() {
        return nombrePlan;
    }

    public void setNombrePlan(String nombrePlan) {
        this.nombrePlan = nombrePlan;
    }


    // ==========================================
    // VELOCIDAD
    // ==========================================

    public String getVelocidad() {
        return velocidad;
    }

    public void setVelocidad(String velocidad) {
        this.velocidad = velocidad;
    }


    // ==========================================
    // PRECIO PLAN
    // ==========================================

    public double getPrecioPlan() {
        return precioPlan;
    }

    public void setPrecioPlan(double precioPlan) {
        this.precioPlan = precioPlan;
    }


    // ==========================================
    // FECHA INSTALACION
    // ==========================================

    public String getFechaInstalacion() {
        return fechaInstalacion;
    }

    public void setFechaInstalacion(String fechaInstalacion) {
        this.fechaInstalacion = fechaInstalacion;
    }


    // ==========================================
    // DIA VENCIMIENTO
    // ==========================================

    public int getDiaVencimiento() {
        return diaVencimiento;
    }

    public void setDiaVencimiento(int diaVencimiento) {
        this.diaVencimiento = diaVencimiento;
    }


    // ==========================================
    // TIPO DE EMISION
    // ==========================================

    public String getTipoEmision() {
        return tipoEmision;
    }

    public void setTipoEmision(String tipoEmision) {
        this.tipoEmision = tipoEmision;
    }


    // ==========================================
    // ESTADO
    // ==========================================

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}