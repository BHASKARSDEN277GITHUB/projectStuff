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
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 *
 * @author root
 */
public class auth extends HttpServlet {

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
            throws ServletException, IOException, SQLException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
             //Get connection to data source ..

            Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            /**
             * Get parameters from request (uid,hPass) ...
             */
            String uid = request.getParameter("uid");
            String hPass = request.getParameter("hPass");

            /**
             * check in LRT if user user has already authenticated ..
             */
            int status = 0;
            int exist = 0;
            Connection c1 = ds.getConnection();
            PreparedStatement s1 = c1.prepareStatement("Select status from LRT where uid=?");
            s1.setString(1, uid);
            ResultSet rs1 = s1.executeQuery();
            if (rs1.next()) {
                status = rs1.getInt("status");
                exist = 1;
            }

            /**
             * if not , then check if request exists at his uid in LRT ...
             */
            if (exist == 0) {
                out.println("No Login Request From Your User Id !"+uid);
            } else {
                if (status == 1) {
                    out.println("You are already authenticated !");
                } else {

                    //out.println("under processing");
                    /**
                     * read uid and hPass from the database
                     */
                    String hPassD = "";
                    String uidD = "";

                    PreparedStatement s2 = c1.prepareStatement("select * from RUT where uid=?");
                    s2.setString(1, uid);
                    ResultSet rs2 = s2.executeQuery();
                    
                    if (rs2.next()) {
                        hPassD = rs2.getString("hPass"); //hPassword  changed to hPass upon database recreation . check here .
                        
                        /**
                         * write status back to LRT .
                         */
                        if (hPass.equals(hPassD)) {
                            PreparedStatement s3= c1.prepareStatement("update  LRT set status=1 where uid=?");
                            s3.setString(1, uid);
                            s3.executeUpdate();
                            c1.close();
                            out.println("You Have Been Authenticated Successfully");
                        } else {
                            PreparedStatement s3 = c1.prepareStatement("update  LRT set status=-1 where uid=?");
                            s3.setString(1, uid);
                            s3.executeUpdate();
                            c1.close();
                            out.println("You Have not  Been Authenticated Successfully");
                        }
                    }
                }
            }
        }

            catch (Exception ex) {
            Logger.getLogger(processAuthentication.class.getName()).log(Level.SEVERE, null, ex);
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
        protected void doGet
        (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(auth.class.getName()).log(Level.SEVERE, null, ex);
        }
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
        protected void doPost
        (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(auth.class.getName()).log(Level.SEVERE, null, ex);
        }
        }

        /**
         * Returns a short description of the servlet.
         *
         * @return a String containing servlet description
         */
        @Override
        public String getServletInfo
        
            () {
        return "Short description";
        }// </editor-fold>

    }
