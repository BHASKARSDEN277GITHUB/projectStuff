<%-- 
    Document   : interProcess
    Created on : 17 Dec, 2014, 2:03:37 PM
    Author     : root

    
--%>

<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            /**
             * check if user with this name is valid and already signed in if not
             * then ask for password
             */

            String uid = request.getParameter("uid");
            String from = request.getParameter("from");

            //check if validity of username in database and get email id
            String email = "";
            if (uid != "") {
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
                     //got the email 

                     //check cookies 
                    //check cookies now if the user is already authenticated ..
                    int exists = 0;
                    String name = "";
                    Cookie[] cookies = request.getCookies();
                    Cookie cookie = null;
                    int i; //iterator ..
                    for (i = 0; i < cookies.length; i++) {
                        cookie = cookies[i];
                        name = cookie.getName();
                        String value=cookie.getValue();
                        if (name.equals("user")&&value.equals(uid)) {
                            //create saml Response 
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
                            //this means already logged in . redirect him to service providers site with saml Response..
                            String url = from + "home.jsp" + "?SAMLResponse=" + SAMLResponse;
                            response.sendRedirect(url);
                        }

                    }
                }
            }
        %>

        <div id='outer'>
            <div id='header'>
                Welcome to Authentication Server 
                Request From : <%=from%>

                <hr>

            </div>




            <div id='subOuter'>
                <div id="registration_form">
                    <center>
                        Please Enter your Password , <%=uid%>


                        <form action="ssoLogin" method="post" >
                            <table>
                                <tr>
                                    <td>Password  : </td>
                                    <td>
                                        <input type="password" name="pass" ><br>


                                    </td>
                                </tr>

                                <tr>
                                <input  type="hidden" name='from' value='<%=from%>'/>
                                </tr>

                                <tr>
                                <input  type="hidden" name='uid' value='<%=uid%>'/>
                                </tr>
                                <tr>	
                                    <td>
                                        <input type="submit" value="Submit">
                                    </td>
                                </tr>
                            </table>


                        </form>

                    </center>
                </div>
            </div>




            <div id='footerIndexPage'>
                <small>

                    <i>
                        Under the Guidance of : Dr. Naveen Chauhan , CSED </br>
                        Being Created By : Bhaskar Kalia  , Premlata Negi , Sushant Thakur , Nisha Kumari , Anurag Singh , CSE Final Year , NITH 
                    </i>

                </small>
            </div>
        </div>
    </body>
</html>
