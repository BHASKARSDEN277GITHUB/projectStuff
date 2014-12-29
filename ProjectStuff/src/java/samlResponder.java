/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author root
 */
public class samlResponder extends HttpServlet {

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
              //recieve parameter as samlResolve ...
            
            String samlResolve = request.getParameter("SAMLResolve");
            //parse this samlResove to get the address of sender ..
            String url ="";
            String[] saml = samlResolve.split("\n");
            int i =0 ;
        
            for(i=0;i<saml.length;i++)
            {
            if(saml[i].startsWith("<saml:Issuer>"))
            {
                String[] lines = saml[i].split(">");
                String reqLine=lines[1];
                String[] lines1 = lines[1].split("<");
                url=lines1[0];
            }
            }
            out.println("SAMLResolve From : "+url);
            
            
            //creating the saml artifact response ..
            
            String samlAResponse="<samlp:ArtifactResponse\n" +
                                    "xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"\n" +
                                    "ID=\"identifier_2\"\n" +
                                    "InResponseTo=\"identifier_1\"\n" +
                                    "Version=\"2.0\"\n" +
                                    "IssueInstant=\"2004-12-05T09:21:59\">\n" +
                                    "<!-- an ArtifactResponse message SHOULD be signed -->\n" +
                                    "<ds:Signature\n" +
                                    "xmlns:ds=\"http://www.w3.org/2000/09/xmldsig#\">...</ds:Signature>\n" +
                                    "<samlp:Status>\n" +
                                    "<samlp:StatusCode\n" +
                                    "Value=\"urn:oasis:names:tc:SAML:2.0:status:Success\"/>\n" +
                                    "</samlp:Status>\n" +
                                    "<samlp:AuthnRequest\n" +
                                    "xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"\n" +
                                    "xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\"\n" +
                                    "ID=\"identifier_3\"\n" +
                                    "Version=\"2.0\"\n" +
                                    "IssueInstant=\"2004-12-05T09:21:59\"\n" +
                                    "Destination=\""+url+"\"\n" +
                                    "ProtocolBinding=\"urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact\"\n" +
                                    "AssertionConsumerServiceURL=\"https://sp.example.com/SAML2/SSO/Artifact\">\n" +
                                    "<saml:Issuer>https://localhost:8443/ProjectStuffUP/samlResponder</saml:Issuer>\n" +
                                    "<samlp:NameIDPolicy\n" +
                                    "AllowCreate=\"false\"\n" +
                                    "Format=\"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress\"/>\n" +
                                    "</samlp:AuthnRequest>\n" +
                                    "</samlp:ArtifactResponse>";
       
            
             out.println("url"+url);
            url=url+"responderSaml"+"?samAResponse="+samlAResponse;
           
            response.sendRedirect(url);
            
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
