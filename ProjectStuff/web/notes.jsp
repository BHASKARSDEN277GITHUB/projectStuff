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
        <title>Notes</title>
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
                Project Stuff / Notes
                <hr>

            </div>




            <div id='subOuter'>




                <div id='contentDown'>
                    <h3>
                        Please check the List and click on the corresponding link to Download File 
                    </h3>
                    
                    <b><a id='homeA' href="aiAssingments.jsp"> AI Assignments</a></b>
                    
                    <%

                        out.println("<br>");
                        out.println("<br>");
                        out.println("<br>");
                      

                        //main code here ..
                        //this directory location needs to be modified whenever required ..
                        String Location = "/media/CC7E3BDB7E3BBD50/ebooks/notes";
                        getFiles(Location, out);
                    %>
                    
                    
                    <%!               void getFiles(String location, JspWriter out) {

                            try {
                                File dir = new File(location); //this directory location needs to be modified whenever required ..
                                File[] notes = dir.listFiles();
                                int total = notes.length;
                                for (int j = 0; j < total; j++) {
                                    if (notes[j].isFile() && (notes[j].getName().endsWith(".pdf") || notes[j].getName().endsWith(".rar") || notes[j].getName().endsWith(".zip"))) {

                                        out.println(notes[j].getName() + "<br>");
                                        out.println("<a id='homeA' href='download?loc=" + notes[j] + "&name=" + notes[j].getName() + "'> " + notes[j].getName() + " </a>" + "<br><br>");
                                    } else {
                                        getFiles(notes[j].getAbsolutePath(), out);
                                    }
                                }
                            } catch (Exception e) {
                                // hahahahahahahahahahahahaha ....
                            }
                        }
                    %>
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
