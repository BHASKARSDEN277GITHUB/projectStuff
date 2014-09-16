<%-- 
    Document   : upload
    Created on : 5 Aug, 2014, 4:40:14 PM
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
        <title>Upload File</title>
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
                Project Stuff / Upload Stuff
                <hr>

            </div>




            <div id='subOuter'>




                <div id='contentUpload'>
                    <center>

                        <h3>
                            <font color='green'>
                            File Formats should be : <br>
                            </font>

                            Notes :  pdf file / zip file / rar file <br>
                            Question Papers :  pdf file / zip file / rar file <br>
                            comics :  pdf file / zip file / rar file <br>
                            ebooks : pdf file / zip file / rar file <br>

                        </h3>
                        <br>
                        <br>
                        <div id='contentUploadForm'>
                            <div id='registration_form'>



                                <h2>Select a Category : </h2><br>
                                <form action="upload" method="post" enctype="multipart/form-data">
                                    <table>
                                        <tr>	
                                            <td>Type :</td>
                                            <td>
                                                <select name="type">
                                                    <option value="notes">Notes
                                                         <option value="Notes-AI Assignments">Notes-AI Assignments
                                                    <option value="ebooks">Ebooks
                                                    <option value="ebooks-Upto First Periodical">Ebooks-Upto First Periodical
                                                    <option value="comics">comics
                                                    <option value="papers">Question Papers
                                                   
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>	
                                            <td>Select File to Upload :</td>
                                            <td>
                                                <input type="file" name="file"  />
                                            </td>
                                            <td>
                                                <input type="submit" value="Upload File" />
                                            </td>
                                        </tr>


                                    </table>
                                </form>



                            </div>
                        </div>
                    </center>
                </div>

            </div>



            <div id="footerIndexPage">
                <small>

                    <i>
                        Being Created By : Bhaskar Kalia  , CSE Final Year , NITH
                    </i>

                </small>
            </div>


        </div>

    </body>
</html>

