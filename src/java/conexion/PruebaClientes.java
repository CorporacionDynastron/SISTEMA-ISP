package conexion;

import dao.ClienteDAO;
import modelo.Cliente;

import java.util.List;

public class PruebaClientes {

    public static void main(String[] args) {

        ClienteDAO dao = new ClienteDAO();

        List<Cliente> clientes = dao.listar();

        System.out.println("================================");
        System.out.println("      LISTA DE CLIENTES");
        System.out.println("================================");

        for (Cliente cliente : clientes) {

            System.out.println(
                cliente.getCodigoCliente()
                + " - "
                + cliente.getNombres()
                + " "
                + cliente.getApellidos()
            );
        }

        System.out.println("================================");
        System.out.println("TOTAL CLIENTES: " + clientes.size());
        System.out.println("================================");
    }
}