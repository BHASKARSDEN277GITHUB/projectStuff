<%-- 
    Document   : errorPage
    Created on : 25 Jul, 2014, 6:52:37 PM
    Author     : root
--%>

<%-- 
    Document   : notes
    Created on : 26 Jul, 2014, 1:03:54 PM
    Author     : root
--%>

<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Error Page</title>
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
                Project Stuff / Home 
                <hr>

            </div>




            <div id='subOuter'>


                <div id='contentDown'>
                    <center>
                        


                        <h2>Unable to Process Your Request right now . <br>
                            Please try again Later and please check the file Size . <br> 
                            You can upload a maximum upto 500 MB's of data and please check file formats !<br><br>

                            You may also have exceeded the maximum files Upload limit . 
                        </h2>


                    </center>
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

