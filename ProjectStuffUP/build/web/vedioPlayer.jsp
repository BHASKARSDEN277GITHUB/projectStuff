<%-- 
    Document   : vedioPlayer
    Created on : 17 Nov, 2014, 9:38:32 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Vedio Player</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="css/Project.css">
    </head>
    <body>
        <%

            //get vedio name from request
            String vName = (String) request.getParameter("vName");
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
                Students Data Center / Vedio Player 
                <hr>

            </div>






            <center>
                 <video width="800" height="500" controls autoplay name="media">
                     <source src="<%=vName%>" type="video/mp4">
                 </video>
              <!--
                <embed src="<%=vName%>" type="application/x-mplayer2" 
                       pluginspage="http://www.microsoft.com/Windows/MediaPlayer/" 
                       name="mediaplayer1" 
                       ShowStatusBar="true" 
                       EnableContextMenu="false" 
                       width="700" height="500" 
                       autostart="false" loop="false" 
                       align="middle" volume="60" >
                </embed>
                

                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" 
                        codebase="http://download.macromedia.com/pub/shockwave/cabs
                        /flash/swflash.cab#version=6,0,29,0" 
                        width="225" height="113">
                    <param name="quality" value="high">
                    <embed src="<%=vName%>" quality="high" pluginspage=
                           "http://www.macromedia.com/go/getflashplayer" 
                           type="application/x-shockwave-flash" width="225" 
                           height="113">
                    </embed>
                </object>
                
                <iframe width="640" height="390" 
                        src="//www.youtube.com/embed/T96khoHU3Uc" 
                        frameborder="0" allowfullscreen>
                            
                </iframe>
                -->
            </center>








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