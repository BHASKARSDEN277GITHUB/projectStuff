<%-- 
    Document   : register
    Created on : 25 Jul, 2014, 2:28:55 AM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Register Page</title>
    </head>
    <body>



        <%

            //handle error message if any ...
            String error = (String) request.getAttribute("error");
            if (error == null) {
                error = "";
            } else if (error.equals("0")) {
                error = "User Name Already Exists";
            } else if (error.equals("1")) {
                error = "Invalid Details";
            }


        %>
        <div id='outer'>
            <div id='header'>
                <div id='links'>

                    <a href="index.jsp"> Home </a>
                    <a href="contact.html"> Contact </a>



                </div>
                Enter Details to Register <hr>
               
            </div>

            


            <div id='subOuter'>
                 
                <center>
                    <font color="red" size="5px"><%=error%></font>
                    <div id="registration_form">

                        <form action="registerRequest" method="get" >
                            <table>
                                <tr>
                                    <td>First Name  : </td>
                                    <td>
                                        <input type="text" name="Fname" ><br>


                                    </td>
                                </tr>
                                <tr>
                                    <td>Last Name : </td>
                                    <td>
                                        <input type="text" name="Lname" ><br>


                                    </td>
                                </tr>
                                <tr>
                                    <td>User ID  : </td>
                                    <td>
                                        <input type="text" name="uid" ><br>


                                    </td>
                                </tr>
                                <tr>	
                                    <td>Email Id :</td>
                                    <td>
                                        <input type="text" name="email" > <font color="blue"> Please enter a valid Email Id</font><br>
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

                                    <td>Password :</td>
                                    <td>
                                        <input type="password" name="pass" ><br>
                                    </td>
                                </tr>
                                <tr>	
                                    <td>Confirm Password :</td>
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

            </div> <!-- subouter end -->

            <div id='footerIndexPage'>
                <small>
                    
                    <i>
                        Being Created By : Bhaskar Kalia  , CSE Final Year , NITH
                    </i>
                
                </small>
            </div>

        </div> <!-- outer end -->


    </body>
</html>
