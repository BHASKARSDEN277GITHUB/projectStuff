<%-- 
    Document   : vediosHome
    Created on : 26 Jul, 2014, 5:49:32 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Vedios Home</title>
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
                Students Data Center / Videos Home 
                <hr>

            </div>




            <div id='subOuter'>

                <div id='vedioHomeContent'>
                    <center>


                        <font color='green'>
                        <h2>
                            <b>Select List</b> <br>
                        </h2>

                        </font>
                        <h3>
                            <a id='homeA' href="vedios.jsp?type=general">General</a><br><br>
                            <a id='homeA' href="vedios.jsp?type=movies">Movies</a><br><br>
                            <a id='homeA' href="vedios.jsp?type=snooker">Snooker</a><br><br>

                        </h3>

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
    </body>
</html>
