/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.output.*;

/**
 *
 * @author root
 */
public class upload extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {

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

            /**
             * reading and updating upload count value in the database .
             */
            //update database table value of maxUploads 
            //also read number of uploads of the current user from maxUploads table 
            //get database connection 
            //Get connection to data source ..
            Context initialContext = new InitialContext();
            Context environmentContext = (Context) initialContext.lookup("java:comp/env");

            // Look up our data source
            DataSource ds = (DataSource) environmentContext.lookup("jdbc/projectStuff");

            Connection conn = ds.getConnection();

            //write prepared statement to access database table data
            PreparedStatement s1 = conn.prepareStatement("select * from maxUploads where uid=?");
            s1.setString(1, uid);

            ResultSet rs = s1.executeQuery();
            int currentUploads = 0;
            if (rs.next()) {
                String str = rs.getString("currentUploads");
                currentUploads = Integer.parseInt(str);
            } else {
                //create a field with entry = 0
                PreparedStatement s2 = conn.prepareStatement("insert into maxUploads values(?,?)");
                s2.setString(1, uid);
                s2.setString(2, "0");
                int result = s2.executeUpdate();

                if (result != 0) {
                    //okay
                } else {
                    response.sendRedirect("errorPage.jsp");
                }

            }
            if (currentUploads < 100) {

                //done database check 
                /**
                 * uploading file
                 */
                //set max file size
                File file;
                int maxFileSize = 50000 * 1024;
                int maxMemSize = 50000 * 1024;

                String filePath = ""; ///home/bhaskar/Documents/";

                // Verify the content type
                String contentType = request.getContentType();
                if ((contentType.indexOf("multipart/form-data") >= 0)) {

                    DiskFileItemFactory factory = new DiskFileItemFactory();
                    // maximum size that will be stored in memory
                    factory.setSizeThreshold(maxMemSize);
                    // Location to save data that is larger than maxMemSize.
                    factory.setRepository(new File("/home/bhaskar/Documents/programming/jsp/repository/"));

                    // Create a new file upload handler
                    ServletFileUpload upload = new ServletFileUpload(factory);
                    // maximum file size to be uploaded.
                    upload.setSizeMax(maxFileSize);
                    try {
                        // Parse the request to get file items.
                        List fileItems = upload.parseRequest(request);

                        // Process the uploaded file items
                        Iterator iter = fileItems.iterator();

                        out.println("<html>");
                        out.println("<head>");
                        out.println("<title>JSP File upload</title>");
                        out.println("</head>");
                        out.println("<body>");
                        out.println("<center>");
                        out.println("uploading your file ..");
                        out.println("</center>");
                        String type = "";
                        while (iter.hasNext()) {
                            FileItem fi = (FileItem) iter.next();

                            if (fi.isFormField()) {
                                //type= (String)fi.getFieldName();
                                type = (String) fi.getString();
                                //out.println(type);

                            } else {
                                // Get the uploaded file parameters
                                String fieldName = fi.getFieldName();
                                String fileName = fi.getName();
                                boolean isInMemory = fi.isInMemory();
                                long sizeInBytes = fi.getSize();

                                /**
                                 * here check if type and file format are
                                 * correct else redirect to error page ..
                                 */
                                /**
                                 * ciggi pee k aate hain ;) crazy shit :)
                                 *
                                 */
                                String extension = fileName.substring(fileName.length() - 3, fileName.length());
                                // String fType ="";
                                out.println(extension + "   " + type);
                                //out.println(fieldName);

                                if ((extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {

                                    if (type.equals("notes") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {
                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/notes/";
                                    } else if (type.equals("ebooks") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {

                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/ebooks/";

                                    } else if (type.equals("comics") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {
                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/comics/";
                                    } else if (type.equals("papers") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {
                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/papers/";
                                    } else if (type.equals("ebooks-Upto First Periodical") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {
                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/ebooks/uptoPeriodicalOne/";
                                    } else if (type.equals("Notes-AI Assignments") && (extension.equals("pdf") || extension.equals("rar") || extension.equals("zip"))) {
                                        filePath = "/media/CC7E3BDB7E3BBD50/ebooks/notes/AI_Assignments/";
                                    } else {
                                        response.sendRedirect("errorPage.jsp");
                                    }

                                    // Write the file
                                    if (fileName.lastIndexOf("\\") >= 0) {
                                        file = new File(filePath
                                                + fileName.substring(fileName.lastIndexOf("\\")));
                                    } else {
                                        file = new File(filePath
                                                + fileName.substring(fileName.lastIndexOf("\\") + 1));
                                    }
                                    fi.write(file);
                                    out.println("<center>");
                                    out.println("Uploaded Filename: " + filePath
                                            + fileName + "<br>");
                                    out.println("</center>");

                                    /**
                                     * update maxCount value in upload count
                                     * table
                                     */
                                    //its alright update the max uploads table value (It should actually be done after the upload but i am doing it here only right now for security reasons) and 
                                    //redirect him to uploads page 
                                    currentUploads++;
                                    String str = currentUploads + "";
                                    PreparedStatement s2 = conn.prepareStatement("update maxUploads set  currentUploads=? where uid=?");
                                    s2.setString(1, str);
                                    s2.setString(2, uid);
                                    int result = s2.executeUpdate();

                                    if (result != 0) {
                                        //okay
                                        //continue
                                        /**
                                         * also update upload content table with
                                         * current file's entry
                                         */
                                        PreparedStatement s3 = conn.prepareStatement("insert into uploads values(?,?)");
                                        s3.setString(1, uid);
                                        s3.setString(2, filePath + fileName);
                                        result = s3.executeUpdate();

                                        conn.close();

                                    } else {
                                        conn.close();
                                        response.sendRedirect("errorPage.jsp");
                                    }

                                    response.sendRedirect("home.jsp");
                                } else {
                                    response.sendRedirect("errorPage.jsp");
                                }
                            }
                        }
                        out.println("</body>");
                        out.println("</html>");
                    } catch (Exception ex) {
                        //response.sendRedirect("errorPage.jsp");
                    }
                } else {
                    response.sendRedirect("errorPage.jsp");
                }

            } else {
                conn.close();
                response.sendRedirect("errorPage.jsp");
            }

        } catch (NamingException ex) {
            Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(upload.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
