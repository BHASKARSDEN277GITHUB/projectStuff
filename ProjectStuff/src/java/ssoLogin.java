/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.

    NOT IN USE IN THIS PROJECT . (AUTHENTICATION VIA USERNAME AND PASSWORD IS USED IN THIS PROJECT)
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
public class ssoLogin extends HttpServlet {

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
            throws ServletException, IOException, NamingException, SQLException, Exception {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            
            
            
            String from = (String) request.getParameter("from");
            String uid = (String) request.getParameter("uid");
            String pass = (String) request.getParameter("pass");

            /**
             * check if user details are correct If yes , get his email id ,
             * check cookies id user already is logged in , redirect or log him
             * in and redirect if NO : give him warning message saying that
             * login not possible .
             */
            String email = "";
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
                    email = rs1.getString("email");
                    //create samlResponse here 
                    /**
                     * create a saml response here ..
                     */
                    String idpUrl = request.getRequestURL().toString();
                    Date dateN = new Date();
                    long dayN = dateN.getDate();
                    long hourN = dateN.getHours();
                    long minN = dateN.getMinutes();
                    long secN = dateN.getSeconds();

                    long nn = minN + 10;
                    String DATE = dayN + ":" + hourN + ":" + minN + ":" + secN;
                    String notAfter = dayN + ":" + hourN + ":" + nn + ":" + secN;

                    String SAMLResponse = "<samlp:Response\n"
                            + "xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"\n"
                            + "xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\"\n"
                            + "ID=\"identifier_2\"\n"
                            + "InResponseTo=\"identifier_1\"\n"
                            + "Version=\"2.0\"\n"
                            + "IssueInstant=" + DATE + "\n"
                            + "Destination=" + from + ">\n"
                            + "<saml:Issuer>" + idpUrl + "</saml:Issuer>\n"
                            + "<samlp:Status>\n"
                            + "<samlp:StatusCode Value=\"urn:oasis:names:tc:SAML:2.0:status:Success\"/>\n"
                            + "</samlp:Status>\n"
                            + "<saml:Assertion\n"
                            + "xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\"\n"
                            + "ID=" + email + "\n"
                            + "Version=\"2.0\"\n"
                            + "IssueInstant=" + DATE + ">\n"
                            + "<saml:Issuer>" + idpUrl + "</saml:Issuer>\n"
                            + "<!-- a POSTed assertion MUST be signed -->\n"
                            + "<ds:Signature\n"
                            + "xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\">...</ds:Signature>\n"
                            + "<saml:Subject>\n"
                            + "<saml:NameID\n"
                            + "Format=\"urn:oasis:names:tc:SAML:2.0:nameid-format:transient\">\n"
                            + "3f7b3dcf-1674-4ecd-92c8-1544f346baf8\n"
                            + "</saml:NameID>\n"
                            + "<saml:SubjectConfirmation\n"
                            + "Method=\"urn:oasis:names:tc:SAML:2.0:cm:bearer\">\n"
                            + "<saml:SubjectConfirmationData\n"
                            + "InResponseTo=\"identifier_1\"\n"
                            + "Recipient=" + from + "\n"
                            + "NotOnOrAfter=" + notAfter + "/>\n"
                            + "</saml:SubjectConfirmation>\n"
                            + "</saml:Subject>\n"
                            + "<saml:Conditions\n"
                            + "NotBefore=" + DATE + "\n"
                            + "NotOnOrAfter=" + notAfter + ">\n"
                            + "<saml:AudienceRestriction>\n"
                            + "<saml:Audience>" + from + "</saml:Audience>\n"
                            + "</saml:AudienceRestriction>\n"
                            + "</saml:Conditions>\n"
                            + "<saml:AuthnStatement\n"
                            + "AuthnInstant=" + DATE + "\n"
                            + "SessionIndex=\"identifier_3\">\n"
                            + "<saml:AuthnContext>\n"
                            + "<saml:AuthnContextClassRef>\n"
                            + "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport\n"
                            + "</saml:AuthnContextClassRef>\n"
                            + "</saml:AuthnContext>\n"
                            + "</saml:AuthnStatement>\n"
                            + "</saml:Assertion>\n"
                            + "</samlp:Response>\n";

                    //done ..
                   
                    //  do log him in right now by checking c red entials ..
                    //get hash of current password ..
                    pass = (new hashAlgo().execute(pass)).substring(0, 8);
                    if (pass.equals(passDB)) {

                        //create cookie in the browser ..persistene cookie ..
                        Cookie setcookie = new Cookie("user", uid);
                        setcookie.setMaxAge(60 * 60);
                        response.addCookie(setcookie);

                        //redirect to homepage of the user ..
                        //request.setAttribute("uid", uid);d
                        String url = from + "home.jsp" + "?SAMLResponse=" + SAMLResponse;
                        response.sendRedirect(url);
                        
                        
                    } else {
                        //redirect him to sp Index page saying that request to authenticate not possible
                        String  url=from+"error.jsp";
                        response.sendRedirect(url);
                    }

                } else {
                    //redirect him to sp Index page saying that request to authenticate not possible
                        String  url=from+"error.jsp";
                        response.sendRedirect(url);
                }

            } else {
                //redirect him to sp Index page saying that request to authenticate not possible
                        String  url=from+"error.jsp";
                        response.sendRedirect(url);
            }
            
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
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ssoLogin.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ssoLogin.class.getName()).log(Level.SEVERE, null, ex);
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(ssoLogin.class.getName()).log(Level.SEVERE, null, ex);
        } catch (Exception ex) {
            Logger.getLogger(ssoLogin.class.getName()).log(Level.SEVERE, null, ex);
        }
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
