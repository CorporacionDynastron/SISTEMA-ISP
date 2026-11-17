package controlador;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class FiltroSesion implements Filter {

    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
    }

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req =
                (HttpServletRequest) request;

        HttpServletResponse resp =
                (HttpServletResponse) response;

        String uri = req.getRequestURI();

        HttpSession sesion =
                req.getSession(false);

        boolean usuarioLogueado =
                sesion != null
                && sesion.getAttribute("usuario") != null;

        boolean paginaLogin =
                uri.endsWith("login.jsp")
                || uri.endsWith("LoginServlet");

        boolean recursoPublico =
                uri.contains("/css/")
                || uri.contains("/js/")
                || uri.contains("/img/");

        if (usuarioLogueado
                || paginaLogin
                || recursoPublico) {

            chain.doFilter(request, response);

        } else {

            resp.sendRedirect(
                    req.getContextPath()
                    + "/login.jsp"
            );
        }
    }

    @Override
    public void destroy() {
    }
}