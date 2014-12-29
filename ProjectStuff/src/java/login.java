/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 *
 * @author root
 */
public class login extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

            
            //get the parameters check if details are valid .. else redirect to login page  ..
            String uid = (String) request.getParameter("uid");
            String pass = (String) request.getParameter("pass");

            if (uid != "" && pass != "") {
                //Get connection to data source ..
                Context initialContext = new InitialContext();
                Context environmentContext = (Context) initialContext.lookup("java:comp/env");

                // Look up our data source
                DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

                Connection conn = ds.getConnection();

                PreparedStatement s1 = conn.prepareStatement("select * from RUT where uid=?");
                s1.setString(1, uid);
                ResultSet rs1 = s1.executeQuery();
                if (rs1.next()) {
                    String passDB = rs1.getString("hPass"); //hPassword  changed to hPass upon database recreation . check here .
                    //get hash of current password ..
                    pass = (new hashAlgo().execute(pass)).substring(0, 8);
                    if (pass.equals(passDB)) {

                        //create cookie in the browser ..persistene cookie ..
                        Cookie setcookie = new Cookie("user", uid);
                        setcookie.setMaxAge(60 * 60);
                        response.addCookie(setcookie);

                         
                       
                        
                        
                        //redirect to homepage of the user ..
                        //request.setAttribute("uid", uid);
                        response.sendRedirect("home.jsp");
                    } else {
                        request.setAttribute("message", "Invalid UserName and Password Combination");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                    }

                } else {
                    request.setAttribute("message", "Invalid UserName and Password Combination");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            } else {
                request.setAttribute("message", "Invalid UserName and Password Combination");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (NamingException ex) {
            Logger.getLogger(login.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(login.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(login.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
