package controlador;

import dao.UsuarioDAO;
import modelo.Usuario;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(
    name = "LoginServlet",
    urlPatterns = {"/LoginServlet"}
)
public class LoginServlet extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String usuario =
                request.getParameter("usuario");

        String password =
                request.getParameter("password");

        Usuario usuarioEncontrado =
                dao.validarUsuario(
                        usuario,
                        password
                );

        if (usuarioEncontrado != null) {

            HttpSession sesion =
                    request.getSession();

            sesion.setAttribute(
                    "usuario",
                    usuarioEncontrado
            );

            response.sendRedirect(
                    "DashboardServlet"
            );

        } else {

            request.setAttribute(
                    "error",
                    "Usuario o contraseña incorrectos"
            );

            request.getRequestDispatcher(
                    "login.jsp"
            ).forward(
                    request,
                    response
            );
        }
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("login.jsp");
    }
}