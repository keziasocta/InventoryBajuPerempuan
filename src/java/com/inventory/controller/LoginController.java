package com.inventory.controller;

import com.inventory.model.User;
import com.inventory.model.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tampilkan halaman login
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        System.out.println("==================================");
        System.out.println("LOGIN ATTEMPT:");
        System.out.println("Username: " + username);
        System.out.println("==================================");
        
        // Validasi input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.out.println("Validation failed: empty fields");
            response.sendRedirect(request.getContextPath() + "/login?error=true");
            return;
        }
        
        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(username, password);
        
        System.out.println("User object from DAO: " + user);
        
        if (user != null) {
            System.out.println("Login SUCCESS for user: " + user.getUsername());
            System.out.println("User role: " + user.getRole());
            
            // Buat session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());
            
            // Set session timeout (30 menit)
            session.setMaxInactiveInterval(30 * 60);
            
            // Redirect ke dashboard
            response.sendRedirect(request.getContextPath() + "/views/dashboard.jsp");
        } else {
            System.out.println("Login FAILED");
            
            // Debug: coba langsung query
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                java.sql.Connection conn = java.sql.DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/inventory_baju", "root", "");
                
                java.sql.PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE username = ? AND is_active = 1");
                stmt.setString(1, username);
                java.sql.ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    System.out.println("User exists: " + (rs.getInt(1) > 0));
                }
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Redirect kembali ke login dengan error
            response.sendRedirect(request.getContextPath() + "/login?error=true");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Login Controller";
    }
}