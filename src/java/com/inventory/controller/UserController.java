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

@WebServlet(name = "UserController", urlPatterns = {"/user/*"})
public class UserController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cek session dan role (hanya admin yang bisa manage user)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, 
                "Hanya administrator yang dapat mengelola user");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "changepass":
                showChangePasswordForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "search":
                searchUsers(request, response);
                break;
            default: // "list"
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cek session dan role
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, 
                "Hanya administrator yang dapat mengelola user");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("insert".equals(action)) {
            insertUser(request, response);
        } else if ("update".equals(action)) {
            updateUser(request, response);
        } else if ("changepassword".equals(action)) {
            changePassword(request, response);
        } else {
            listUsers(request, response);
        }
    }
    
    // ========== METHOD HANDLERS ==========
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setAttribute("userList", userDAO.getAllUsers());
            request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error retrieving user list: " + e.getMessage());
        }
    }
    
    private void searchUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            listUsers(request, response);
            return;
        }
        
        try {
            request.setAttribute("userList", userDAO.searchUsers(keyword));
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/user/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error searching users: " + e.getMessage());
        }
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User tidak ditemukan");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/user/form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        }
    }
    
    private void showChangePasswordForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userDAO.getUserById(id);
            
            if (user == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User tidak ditemukan");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/user/changepassword.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        }
    }
    
    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Validasi input
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String namaLengkap = request.getParameter("nama_lengkap");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String isActive = request.getParameter("is_active");
        
        // Validasi required fields
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Username dan password harus diisi");
            return;
        }
        
        // Validasi password confirmation
        if (!password.equals(confirmPassword)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Password dan konfirmasi password tidak cocok");
            return;
        }
        
        // Validasi username uniqueness
        if (userDAO.isUsernameExists(username)) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Username sudah digunakan. Silakan pilih username lain.");
            return;
        }
        
        try {
            User user = new User();
            user.setUsername(username.trim());
            user.setPassword(password.trim());
            user.setNamaLengkap(namaLengkap != null ? namaLengkap.trim() : "");
            user.setEmail(email != null ? email.trim() : "");
            user.setRole(role != null ? role : "staff");
            user.setActive("1".equals(isActive));
            
            // Save to database
            boolean success = userDAO.addUser(user);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=add");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal menambahkan user");
            }
            
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String username = request.getParameter("username");
            String namaLengkap = request.getParameter("nama_lengkap");
            String email = request.getParameter("email");
            String role = request.getParameter("role");
            String isActive = request.getParameter("is_active");
            
            // Validasi
            if (username == null || username.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Username harus diisi");
                return;
            }
            
            // Get existing user to check username conflict (excluding current user)
            User existingUser = userDAO.getUserById(id);
            if (existingUser == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "User tidak ditemukan");
                return;
            }
            
            // Check if username is changed and already exists
            if (!existingUser.getUsername().equals(username.trim())) {
                if (userDAO.isUsernameExists(username.trim())) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                        "Username sudah digunakan");
                    return;
                }
            }
            
            User user = new User();
            user.setId(id);
            user.setUsername(username.trim());
            user.setNamaLengkap(namaLengkap != null ? namaLengkap.trim() : "");
            user.setEmail(email != null ? email.trim() : "");
            user.setRole(role != null ? role : "staff");
            user.setActive("1".equals(isActive));
            
            boolean success = userDAO.updateUser(user);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=update");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal mengupdate user");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String newPassword = request.getParameter("new_password");
            String confirmPassword = request.getParameter("confirm_password");
            
            // Validasi
            if (newPassword == null || newPassword.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Password baru harus diisi");
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Password baru dan konfirmasi tidak cocok");
                return;
            }
            
            if (newPassword.length() < 6) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Password minimal 6 karakter");
                return;
            }
            
            boolean success = userDAO.updatePassword(id, newPassword);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=changepass");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal mengubah password");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Cegah menghapus diri sendiri
            HttpSession session = request.getSession(false);
            if (session != null) {
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null && currentUser.getId() == id) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                        "Tidak dapat menghapus akun sendiri");
                    return;
                }
            }
            
            boolean success = userDAO.deleteUser(id);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=delete");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal menghapus user");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "User Management Controller";
    }
}