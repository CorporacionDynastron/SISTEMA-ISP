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
public class FiltroAutenticacion implements Filter {

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

        HttpServletResponse res =
                (HttpServletResponse) response;

        String ruta =
                req.getRequestURI();

        String contexto =
                req.getContextPath();

        String pagina =
                ruta.substring(contexto.length());

        HttpSession sesion =
                req.getSession(false);

        boolean logueado =
                sesion != null
                && sesion.getAttribute("usuario") != null;

        boolean recursoPublico =
                pagina.equals("/login.jsp")
                || pagina.equals("/LoginServlet")
                || pagina.startsWith("/css/")
                || pagina.startsWith("/img/")
                || pagina.startsWith("/js/")
                || pagina.startsWith("/fonts/");

        if (logueado || recursoPublico) {

            chain.doFilter(
                    request,
                    response
            );

        } else {

            res.sendRedirect(
                    contexto + "/login.jsp"
            );
        }
    }

    @Override
    public void destroy() {
    }
}