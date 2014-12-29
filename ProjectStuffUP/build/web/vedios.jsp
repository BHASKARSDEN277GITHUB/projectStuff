<%-- 
    Document   : vedios
    Created on : 26 Jul, 2014, 1:04:35 PM
    Author     : root
--%>

<%@page import="java.io.File"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Videos</title>
    </head>
    <body>

        <%

            //get parameter type ...
            String type = (String) request.getParameter("type");
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
                Students Data Center / Videos / <%=type%>
                <hr>

            </div>




            <div id='subOuter'>

                <div id='contentDown'>
                    <center>

                        <h3>
                            Please check the List and click on the corresponding link to Download File 
                        </h3>


                       

                            <%

                                out.println("<br>");
                                out.println("<br>");
                                out.println("<br>");

                                //main code here ..
                                String Location = "";
                                if (type.equals("general")) {
                                    Location = "/media/New Volume/vedios/generalVedios"; //configure this directory path according to requirement ..
                             
                                } else if (type.equals("movies")) {
                                    Location = "/media/New Volume/movies"; //configure this directory path according to requirement ..
                                } else if (type.equals("snooker")) {
                                    Location = "/media/New Volume/vedios/snooker"; //configure this directory path according to requirement ..       
                                }

                                getFiles(Location, out);
                            %>
                            <%!
                                void getFiles(String location, JspWriter out) {

                                    try {
                                        File dir = new File(location); //this directory location needs to be modified whenever required ..
                                        File[] notes = dir.listFiles();
                                        int total = notes.length;
                                        for (int j = 0; j < total; j++) {
                                            if (notes[j].isFile()) {

                                                out.println(notes[j].getName() + "<br>");
                                                out.println("<a id='homeA'  href='download?loc=" + notes[j] + "&name=" + notes[j].getName() + "'> " + notes[j].getName() + " </a>" + "<br><br>");
                                                //out.println("Player Link : "+"<a id='vPlay' href='vedioPlayer.jsp?vName="+notes[j].getAbsolutePath()+"'>"+notes[j].getName()+"</a>"+"<br><br>");
                                            } else {
                                                getFiles(notes[j].getAbsolutePath(), out);
                                            }
                                        }
                                    } catch (Exception e) {
                                        // hahahahahahahahahahahahaha ....
                                    }
                                }
                            %>

                       
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
