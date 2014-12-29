<%-- 
    Document   : index
    Created on : 25 Jul, 2014, 1:11:42 AM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
        <title>Student Data Center</title>
    </head>
    <body >


        <%
            //check if someone is logged in already ...

            
            //get cookies for this domain ..
            int exists = 0;
            String name = "";
            Cookie[] cookies = request.getCookies();
            Cookie cookie = null;
            int i; //iterator ..
            if (cookies != null) {
                for (i = 0; i < cookies.length; i++) {
                    cookie = cookies[i];
                    name = cookie.getName();
                     out.println(name+"   "+cookie.getValue());
                    if (name.equals("user")) {

                        exists = 1;
                        break;
                    }

                }
            }
            if (exists == 1) {
                response.sendRedirect("home.jsp");
            }
        %>
        <div id='outer'>  <!-- outer started -->


            <div id='header'> <!-- header started -->

                <div id='links'> <!-- links started -->

                    <a href="register.jsp"> Register </a>
                    <a href="contact.html"> Contact </a>
                </div> <!-- links closed -->

                <b>Students Data Center</b>
                <hr>
            </div> <!-- header started -->


            <div id='subOuter' > <!-- subouter started -->

                <div id='intro'> <!-- intro started -->

                    <h2><font color='green'><b>Welcome to Students Data Center</b><br></font></h2>
                    <p>
                    <h3>
                        This is the Final Year Project  BEING created for purpose of<br>
                        helping the students by providing them resources such as : <br> 
                        NOTES,SAMPLE QUESTION PAPERS,LATEST UPDATES,EBOOKS and <br>
                        other miscellaneous stuff .<br>
                        Users can DOWNLOAD and UPLOAD files/resources !<br><br>
                        The project also includes the development of a single sign on server <br>
                        to provide user authentication to other service providers<br><br>
                        Contact details can be found on click at Top Right Hand Corner "contact"<br>
                        Thank You !<br>
                        <br><br>


                    </h3>
                    </p>
                </div> <!-- intro closed -->



                <div id='login_form'> <!-- login form started -->


                    <b>Enter UID and Pass to Login</b><br>
                    <form action="login" method="post" >
                        <table>
                            <tr>
                                <td>User ID  : </td>
                                <td>
                                    <input type="text" name="uid" width="100"><br>


                                </td> 	
                            </tr>
                            <tr>	
                                <td>Password :</td>
                                <td>
                                    <input type="password" name="pass" width="100"><br>
                                </td>
                            </tr>
                            <tr>	
                                <td>
                                    <input type="submit" value="Submit">
                                </td>
                                <td>&#160;&#160;&#160;&#160;&#160;
                                    &#160;&#160;&#160;&#160;&#160;
                                    &#160;&#160;&#160;&#160;&#160;
                                    &#160;&#160;
                                    <a href="forgotPass.jsp">Forgot Password ?</a></td>
                            </tr>
                        </table>


                    </form>
                    <br>
                    If not registered <br>
                    Click on Register at Top Right Corner !
                </div> <!-- login form closed  -->
            </div>
            <div id='footerIndexPage'> 
                <small>
                    <i>
                        Under the Guidance of : Dr. Naveen Chauhan , CSED </br>
                        Being Created By : Bhaskar Kalia  , Premlata Negi , Sushant Thakur , Nisha Kumari , Anurag Singh , CSE Final Year , NITH 
                    </i>
                    </font>
                </small>
            </div> 
        </div>
    </body>

</html>
