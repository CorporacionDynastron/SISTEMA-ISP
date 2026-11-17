package modelo;

public class Usuario {

    private int idUsuario;
    private String usuario;
    private String password;
    private String nombres;
    private String rol;
    private String estado;

    public Usuario() {
    }

    public Usuario(
            int idUsuario,
            String usuario,
            String password,
            String nombres,
            String rol,
            String estado) {

        this.idUsuario = idUsuario;
        this.usuario = usuario;
        this.password = password;
        this.nombres = nombres;
        this.rol = rol;
        this.estado = estado;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }
}