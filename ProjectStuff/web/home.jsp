<%-- 
    Document   : home
    Created on : 25 Jul, 2014, 9:07:20 PM
    Author     : root
--%>

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
        <title>Home</title>
    </head>
    <body>
        <%
                    //read uid from cookie ..

            //get cookies for this domain ..
            int exists = 0;
            String name = "";
            Cookie mycookie = null;
            Cookie[] cookies = request.getCookies();
            Cookie cookie = null;
            int i; //iterator ..
            if (cookies != null) {
                for (i = 0; i < cookies.length; i++) {
                    cookie = cookies[i];
                    name = cookie.getName();
                    if (name.equals("user")) {
                        mycookie = cookie;
                        exists = 1;
                        break;
                    }

                }
            }
            String uid = "";
            if (exists == 1) {
                uid = mycookie.getValue();
            } else {
                //redirect to login page . With message please login again ..

                request.setAttribute("message", "You have been Logged out , Please Login again .");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
            
            String redirectUrl="upload.jsp";

            //also read number of uploads of the current user from maxUploads table 
            //get database connection 
            //Get connection to data source ..
            /* Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            Connection conn = ds.getConnection();

            //write prepared statement to access database table data
            PreparedStatement s1 = conn.prepareStatement("select * from maxUploads where uid=?");
            s1.setString(1, uid);

            ResultSet rs = s1.executeQuery();
            int currentUploads = 0;
            if (rs.next()) {
                String str = rs.getString("currentUploads");
                currentUploads = Integer.parseInt(str);
            } else {
                //create a field with entry = 0
                PreparedStatement s2 = conn.prepareStatement("insert into maxUploads values(?,?)");
                s2.setString(1, uid);
                s2.setString(2, "0");
                int result = s2.executeUpdate();

                if (result != 0) {
                    //okay
                } else {
                    response.sendRedirect("errorPage.jsp");
                }

            }

            String redirectUrl = "";
            if (currentUploads < 100) {
                //its alright update the max uploads table value (It should actually be done after the upload but i am doing it here only right now for security reasons) and 
                //redirect him to uploads page 
                currentUploads++;
                String str = currentUploads + "";
                PreparedStatement s2 = conn.prepareStatement("update maxUploads set  currentUploads=? where uid=?");
                s2.setString(1, str);
                s2.setString(2, uid);
                int result = s2.executeUpdate();

                if (result != 0) {
                    //okay
                    redirectUrl = "upload.jsp";
                    conn.close();
                } else {
                    conn.close();
                    redirectUrl = "errorPage.jsp";
                }

            } else {
                conn.close();
                redirectUrl = "errorPage.jsp";
            }*/

        %>


        <div id='outer'>
            <div id='header'>
                <div id='links'>

                    <%=uid%>
                    <a href="home.jsp"> Home </a>
                    <a href="contact.html"> Contact </a>
                    <a href="logout"> Logout </a>



                </div>
                    <br>
                Project Stuff / Home 
                <hr>

            </div>




            <div id='subOuter'>
                <div style="position:absolute;right:10px;">
                    <b><a href=<%=redirectUrl%>>click here to upload files </a><br></b>
                </div>
                <br>
                <br>
                <br>
                <div id='subOuter1'>


                    <div id='list'>
                        <h3>
                            <font color='green'><b>STUDY MATERIAL</b><br><br></font>
                            <a id='homeA' href="notes.jsp">Notes</a><br>
                            <a id='homeA' href="ebooks.jsp">Ebooks</a><br>
                            <a id='homeA' href="papers.jsp">Sample Question Papers</a><br>
                        </h3>

                    </div>

                    <div id='list'>
                        <h3>
                            <font color='green'><b>LATEST  </b><br><br></font>
                        </h3>
                        <p>

                        <h2>Finally the network is all cool .<br> 
                            <a id='homeA' href="latest.jsp"> #CURRENT#</a>
                            </p>
                    </div>



                    <div id='list'>
                        <h3>
                            <font color="green">
                            <b>MISCELLANEOUS</b><br><br></font>
                            <a id='homeA' href="vediosHome.jsp">Videos</a><br>
                            <a id='homeA' href="comics.jsp">Comics</a><br>
                        </h3>
                    </div>


                </div>
            </div>

            <div id='footerIndexPage'>
                <small>

                    <i>
                        Being Created By : Bhaskar Kalia  , CSE Final Year , NITH
                    </i>

                </small>
            </div>

        </div>

    </body>
</html>
