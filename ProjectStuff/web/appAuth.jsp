<%-- 
    Document   : appAuth
    Created on : 18 Dec, 2014, 12:12:32 AM
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
        <title>SmartApp Authentication</title>
    </head>
    <body>
        <%

            /**
             * ***************************Rewritten*************************************
             */
            //check if user is registered or not
            //checks if there is anuy login request from this uid
            response.setIntHeader("refresh", 5);    // setting response header refresh after every 5 seconds ..

            /**
             * get attributes from (request forwarded by interProcess servlet)
             * ..
             */
            String uid = (String) request.getParameter("uid");
            String from = (String) request.getParameter("from");

            //Get connection to data source ..
            Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            Connection conn = ds.getConnection();

            /**
             * read email id from the database table RUT ..
             *
             */
            PreparedStatement stat = conn.prepareStatement("select * from RUT where uid=?");
            stat.setString(1, uid);

            ResultSet res = stat.executeQuery();
            String email = "";
            if (res.next()) {
                //means user entry exists in the RUT
                email = res.getString("email");

                //create saml response
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
                /**
                 * check if user id exists in LRT ..
                 */
                PreparedStatement s1 = conn.prepareStatement("select status from LRT where uid=?");
                s1.setString(1, uid);

                ResultSet rs = s1.executeQuery();

                if (rs.next()) //means entry is there ..
                {
                    int status = 0;
                    PreparedStatement s4 = conn.prepareStatement("Select * from LRT where uid=?");
                    s4.setString(1, uid);
                    ResultSet rs4 = s4.executeQuery();
                    if (rs4.next()) {
                        status = rs4.getInt("status");

                    }

                    if (status == 1) {

                        //create cookie here
                        //create cookie in the browser ..persistene cookie ..
                        Cookie setcookie = new Cookie("user", uid);
                        setcookie.setMaxAge(60 * 60);
                        response.addCookie(setcookie);

                        /**
                         * read spAddress value LRT ..
                         */
                        String url = from + "home.jsp" + "?SAMLResponse=" + SAMLResponse;

                        /**
                         * delete entry in the table
                         */
                        PreparedStatement s5 = conn.prepareStatement("delete from LRT where uid=?");
                        s5.setString(1, uid);
                        s5.executeUpdate();
                        conn.close();

                        /**
                         * redirect to server ..
                         */
                        response.sendRedirect(url);

                    } else {

                        out.println("Please start SmartIdApp on Your SmartPhone and tap to Authenticate . <br>After Authentication is successfull , you'll be automatically redirected to Service Provider's site");

                    }

                } else {

                    out.println("Please start SmartIdApp on Your SmartPhone and tap to Authenticate . <br>After Authentication is successfull , you'll be automatically redirected to Service Provider's site");

                    /**
                     * add entry to LRT with status == 0 .. and from and uid ..
                     */
                    if (uid != null && from != null) //before refresh ..
                    {

                        /**
                         * add data and time also in format :
                         * date+hour+min+second ..
                         */
                        Date date = new Date();
                        long day = date.getDate();
                        long hour = date.getHours();
                        long min = date.getMinutes();
                        long sec = date.getSeconds();

                        String dateTime = day + ":" + hour + ":" + min + ":" + sec;

                        PreparedStatement s3 = conn.prepareStatement("insert into LRT values(?,0,?,?)");
                        s3.setString(1, uid);
                        s3.setString(2, from);
                        s3.setString(3, dateTime);

                        s3.executeUpdate();
                    }

                    // response.setStatus(response.SC_MOVED_TEMPORARILY);
                    //response.setHeader("Location", from);
                }

            } else {
                //print message please register YourSelf First
                out.println("<center>Please register yourself first . You are not a Registered user</center>\n\n");
                out.println(" <center><a href=\"register.jsp\">click Here to Register</a></center>");
            }

        %>


    </body>
</html>
