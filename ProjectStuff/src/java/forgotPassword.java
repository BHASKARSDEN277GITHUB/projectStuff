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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 *
 * @author root
 */
public class forgotPassword extends HttpServlet {

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

            //reading parameters values ..
            String uid = (String) request.getParameter("uid");
            String email = (String) request.getParameter("email");
            String pass = (String) request.getParameter("pass");
            String confirmPass = (String) request.getParameter("confirmPass");
            String sq = (String) request.getParameter("sq");
            String sqa = (String) request.getParameter("sqa");

            //get connection to data source ..
            //Get connection to data source ..
            Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            Connection conn = ds.getConnection();

            //check if user name exists in database ..
            PreparedStatement s1 = conn.prepareStatement("select * from RUT where uid=?");
            s1.setString(1, uid);
            ResultSet rs1 = s1.executeQuery();

            if (rs1.next()) //userid is registered .. Status okay .. (Y) ..
            {
                //check if details : email , security question are valid ..

                String emailDB = rs1.getString("email");
                String sqDB = rs1.getString("sq");
                String sqaDB = rs1.getString("sqa");

                if (emailDB.equals(email) && sqDB.equals(sq) && sqaDB.equals(sqa)) {
                    //check if new password and confirm password are okay ..

                    if (pass.length() > 0 && pass.equals(confirmPass)) {

                        //reset password ..
                        //calculate hash of password ..
                        pass = ((new hashAlgo().execute(pass))).substring(0, 8);

                        //update in database ..
                        PreparedStatement s2 = conn.prepareStatement("update RUT set hPassword=? where uid=?");
                        s2.setString(1, pass);
                        s2.setString(2, uid);
                        int i = s2.executeUpdate();

                        if (i > 0) {

                            conn.close();
                            //send to login page with message . Password updated successfully ..
                            request.setAttribute("message", "Password Updated Successfully");
                            request.getRequestDispatcher("login.jsp").forward(request, response);

                        } else {
                            conn.close();
                            //send errorCode ..
                            String error = "2";
                            request.setAttribute("error", error);
                            request.getRequestDispatcher("forgotPass.jsp").forward(request, response);
                        }

                    } else {
                        conn.close();
                        //send errorCode ..
                        String error = "1";
                        request.setAttribute("error", error);
                        request.getRequestDispatcher("forgotPass.jsp").forward(request, response);

                    }

                } else {
                    conn.close();
                    //send errorCode ..
                    String error = "1";
                    request.setAttribute("error", error);
                    request.getRequestDispatcher("forgotPass.jsp").forward(request, response);

                }

            } else {
                //redirect with error message ..
                conn.close();
                //send errorCode to error page ..
                String error = "0";
                request.setAttribute("error", error);
                request.getRequestDispatcher("forgotPass.jsp").forward(request, response);

            }

        } catch (NamingException ex) {
            Logger.getLogger(forgotPassword.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(forgotPassword.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(forgotPassword.class.getName()).log(Level.SEVERE, null, ex);
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
