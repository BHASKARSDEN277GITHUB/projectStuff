<%-- 
    Document   : forgotPass
    Created on : 26 Jul, 2014, 6:22:01 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
         <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Reset Password</title>
    </head>
    <body>


        <%

            //handle error message if any ...
            String errorC = (String) request.getAttribute("error");
            if (errorC == null) {
                errorC = "";
            } else if (errorC.equals("0")) {
                errorC = "User Name is Invalid Try Again !";
            } else if (errorC.equals("1")) {
                errorC = "Invalid Details Try Again !";
            } else if (errorC.equals("2")) {
                errorC = "Error Server . Please Try Again Later . <br> Sorry for Inconvinience";
            }


        %>


        <div id='outer'>
            <div id='header'>
                <div id='links'>

                    <a href="index.jsp"> Home </a>
                    <a href="contact.html"> Contact </a>



                </div>
                Enter Details to Reset Password <hr>

            </div>




            <div id='subOuter'>




                <center>
                    <h3><font color="red"><%=errorC%></font></h3>
                    <div id='registration_form'>

                        <form action="forgotPassword" method="get" >
                            <table>

                                <tr>
                                    <td>User ID  : </td>
                                    <td>
                                        <input type="text" name="uid" ><br>


                                    </td>
                                </tr>
                                <tr>	
                                    <td>Email Id :</td>
                                    <td>
                                        <input type="text" name="email" ><br>
                                    </td>
                                </tr>
                                <tr>	
                                    <td>Security Question :</td>
                                    <td>
                                        <select name="sq">
                                            <option value="mName">What is your Mother Maiden's Name ?
                                            <option value="sName">What was your First School ?
                                            <option value="pName">What is your Pet's name ?
                                            <option value="vName">What is you vehicle number ?
                                        </select>
                                    </td>
                                </tr>
                                <tr>	
                                    <td>Security Question's Answer:</td>
                                    <td>
                                        <input type="text" name="sqa" ><br>
                                    </td>
                                </tr>
                                <tr>

                                    <td>New Password :</td>
                                    <td>
                                        <input type="password" name="pass" ><br>
                                    </td>
                                </tr>
                                <tr>	
                                    <td>Confirm New Password :</td>
                                    <td>
                                        <input type="password" name="confirmPass" ><br>
                                    </td>
                                </tr><br><br>
                                <tr>
                                    <td>
                                        <input type="submit" value="Submit">
                                    </td>
                                </tr>
                            </table>


                        </form>

                    </div>
                </center>

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
