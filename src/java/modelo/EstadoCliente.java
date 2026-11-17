package modelo;

public class EstadoCliente {

    private int idCliente;
    private String codigoCliente;
    private String cliente;
    private String dni;
    private String telefono;
    private String estadoServicio;

    private int cuotasPendientes;
    private double deudaTotal;
    private int diasAtraso;

    private String proximoVencimiento;
    private String estadoPago;

    public EstadoCliente() {
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getCodigoCliente() {
        return codigoCliente;
    }

    public void setCodigoCliente(String codigoCliente) {
        this.codigoCliente = codigoCliente;
    }

    public String getCliente() {
        return cliente;
    }

    public void setCliente(String cliente) {
        this.cliente = cliente;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEstadoServicio() {
        return estadoServicio;
    }

    public void setEstadoServicio(String estadoServicio) {
        this.estadoServicio = estadoServicio;
    }

    public int getCuotasPendientes() {
        return cuotasPendientes;
    }

    public void setCuotasPendientes(int cuotasPendientes) {
        this.cuotasPendientes = cuotasPendientes;
    }

    public double getDeudaTotal() {
        return deudaTotal;
    }

    public void setDeudaTotal(double deudaTotal) {
        this.deudaTotal = deudaTotal;
    }

    public int getDiasAtraso() {
        return diasAtraso;
    }

    public void setDiasAtraso(int diasAtraso) {
        this.diasAtraso = diasAtraso;
    }

    public String getProximoVencimiento() {
        return proximoVencimiento;
    }

    public void setProximoVencimiento(String proximoVencimiento) {
        this.proximoVencimiento = proximoVencimiento;
    }

    public String getEstadoPago() {
        return estadoPago;
    }

    public void setEstadoPago(String estadoPago) {
        this.estadoPago = estadoPago;
    }
}