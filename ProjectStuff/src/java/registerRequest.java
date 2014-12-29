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
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 *
 * @author root
 */
public class registerRequest extends HttpServlet {

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
            
            
            
            //check if some user is logged in ? if yes funckin log him out ...
            //get cookies for this domain ..
            int exists = 0;
            String name = "";
            Cookie[] cookies = request.getCookies();
            Cookie cookie = null;
            int i; //iterator ..
            for (i = 0; i < cookies.length; i++) {
                cookie = cookies[i];
                name = cookie.getName();
                if (name.equals("user")) {
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                    break;
                }

            }

            //read all the parameters ..
            String fName = (String) request.getParameter("Fname");
            String lName = (String) request.getParameter("Lname");
            String uid = (String) request.getParameter("uid");
            String email = (String) request.getParameter("email");
            String pass = (String) request.getParameter("pass");
            String confirmPass = (String) request.getParameter("confirmPass");
            String sq = (String) request.getParameter("sq");
            String sqa = (String) request.getParameter("sqa");
            /**
             * check for user id availability ..
             */
            //Get connection to data source ..
            Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            Connection conn = ds.getConnection();

            //check if uid already exists ..   
            PreparedStatement s1 = conn.prepareStatement("select * from RUT where uid=?");
            s1.setString(1, uid);
            ResultSet rs1 = s1.executeQuery();
            //conn.close();

            if (rs1.next()) {
                conn.close();
                //send errorCode to error page ..
                String error = "0";
                request.setAttribute("error", error);
                request.getRequestDispatcher("register.jsp").forward(request, response);

            } else {

                //check if other fields are valid ..
                out.println("I'll do registration now ");
                if (uid.length()>0 && pass.length()>0  &&fName.length()>0 &&lName.length()>0 &&sq.length()>0&&sqa.length()>0 &&email.length()>0) {
                    if (pass.equals(confirmPass)) {
                        out.println("I'll do registration now ");
                        //calculate the hash of password ..
                        // out.println("registered");
                        String hPass = new hashAlgo().execute(pass);
                        hPass = hPass.substring(0, 8); //get first 8 characters of hash digest ..

                        //register the user in the database ..
                        //Connection conn2 = ds.getConnection();
                        PreparedStatement s2 = conn.prepareStatement("insert into RUT values(?,?,?,?,?,?,?)");
                        s2.setString(1, fName);
                        s2.setString(2, lName);
                        s2.setString(3, uid);
                        s2.setString(4, email);
                        s2.setString(5, hPass);
                        s2.setString(6, sq);
                        s2.setString(7, sqa);
                        
                        int rs2 = s2.executeUpdate();
                        if (rs2 != 0) {
                           // out.println("I'll do registration now ");
                            //redirect to login page of user .
                             conn.close();
                            request.setAttribute("message", "Registration Successfull");
                            request.getRequestDispatcher("login.jsp").forward(request, response);
                        }
                        else
                        {   //out.println("I'll do registration now ");
                             conn.close();
                             out.println("Error in DataBase");
                        }
                       
                    } else {
                        conn.close();
                        String error = "1";
                         //out.println(uid.length()+"\n"+email+"\n"+pass+"\n"+confirmPass+"\n"+sq+"\n"+sqa+"\n"+lName+"\n"+fName+"\n"+"hello");
                        request.setAttribute("error", error);
                        request.getRequestDispatcher("register.jsp").forward(request, response);

                    }
                } else {
                    conn.close();
                    String error = "1";
                    //out.println(uid+"\n"+email+"\n"+pass+"\n"+sq+"\n"+sqa+"\n"+lName+"\n"+fName);
                    request.setAttribute("error", error);
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    
                }

            }

        } catch (NamingException ex) {
            Logger.getLogger(registerRequest.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(registerRequest.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(registerRequest.class.getName()).log(Level.SEVERE, null, ex);
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
