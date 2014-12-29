<%-- 
    Document   : login
    Created on : 25 Jul, 2014, 8:21:14 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Login Page</title>
    </head>
    <body>
        <%

            //read if any message is there ..
            String message = (String) request.getAttribute("message");
            if (message == null) {
                message = "";
            } else {
                //lol .. kuch to hoga bhai ..
            }
        %>

        <div id='outer'>
            <div id='header'>
                <div id='links'>

                    <a href="index.jsp"> Home </a>
                    <a href="register.jsp"> Register </a>
                    <a href="contact.html"> Contact </a>



                </div>
                <br>
                Enter UID and Password to Login
                <hr>

            </div>




            <div id='subOuter'>
                <div id="registration_form">
                    <center>
                        <h2><font color="red"><%=message%></font></h2>
                        <form action="login" method="post" >
                            <table>
                                <tr>
                                    <td>User ID  : </td>
                                    <td>
                                        <input type="text" name="uid" ><br>


                                    </td>
                                </tr>
                                <tr>	
                                    <td>Password :</td>
                                    <td>
                                        <input type="password" name="pass" ><br>
                                    </td>
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
