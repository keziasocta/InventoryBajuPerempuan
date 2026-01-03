<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User" %>
<%
    // Cek session dan role
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    User currentUser = (User) session.getAttribute("user");
    if (!"admin".equals(currentUser.getRole())) {
        response.sendError(403, "Akses ditolak. Hanya administrator.");
        return;
    }
    
    User user = (User) request.getAttribute("user");
    boolean isEditMode = user != null;
    String pageTitle = isEditMode ? "Edit User" : "Tambah User Baru";
    String action = isEditMode ? "update" : "insert";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= pageTitle %> - Inventory Baju Perempuan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #4a6fa5;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        
        .required::after {
            content: " *";
            color: red;
        }
        
        input[type="text"],
        input[type="password"],
        input[type="email"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        input:focus,
        select:focus {
            outline: none;
            border-color: #4a6fa5;
            box-shadow: 0 0 5px rgba(74, 111, 165, 0.3);
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: auto;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
        }
        
        .btn-primary {
            background-color: #4a6fa5;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #3a5a8c;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #5a6268;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #4a6fa5;
            text-decoration: none;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .error-message {
            color: red;
            font-size: 14px;
            margin-top: 5px;
        }
        
        .form-hint {
            color: #666;
            font-size: 12px;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/user?action=list" class="back-link">← Kembali ke Daftar User</a>
        
        <h1><%= pageTitle %></h1>
        
        <form action="${pageContext.request.contextPath}/user" method="POST">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (isEditMode) { %>
                <input type="hidden" name="id" value="<%= user.getId() %>">
            <% } %>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="username" class="required">Username</label>
                    <input type="text" id="username" name="username" 
                           value="<%= isEditMode ? user.getUsername() : "" %>" 
                           required placeholder="contoh: johndoe" 
                           <%= isEditMode ? "" : "autofocus" %>>
                    <div class="form-hint">Username untuk login (unik, tidak bisa diubah)</div>
                </div>
                
                <% if (!isEditMode) { %>
                    <div class="form-group">
                        <label for="password" class="required">Password</label>
                        <input type="password" id="password" name="password" required>
                        <div class="form-hint">Minimal 6 karakter</div>
                    </div>
                <% } %>
            </div>
            
            <% if (!isEditMode) { %>
                <div class="form-group">
                    <label for="confirm_password" class="required">Konfirmasi Password</label>
                    <input type="password" id="confirm_password" name="confirm_password" required>
                </div>
            <% } %>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="nama_lengkap">Nama Lengkap</label>
                    <input type="text" id="nama_lengkap" name="nama_lengkap" 
                           value="<%= isEditMode && user.getNamaLengkap() != null ? user.getNamaLengkap() : "" %>" 
                           placeholder="Nama lengkap pengguna">
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" 
                           value="<%= isEditMode && user.getEmail() != null ? user.getEmail() : "" %>" 
                           placeholder="email@contoh.com">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="role" class="required">Role</label>
                    <select id="role" name="role" required>
                        <option value="staff" <%= isEditMode && "staff".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                        <option value="admin" <%= isEditMode && "admin".equals(user.getRole()) ? "selected" : "" %>>Administrator</option>
                        <option value="viewer" <%= isEditMode && "viewer".equals(user.getRole()) ? "selected" : "" %>>Viewer</option>
                    </select>
                    <div class="form-hint">
                        Admin: akses penuh, Staff: kelola barang, Viewer: lihat saja
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Status Akun</label>
                    <div class="checkbox-group">
                        <input type="checkbox" id="is_active" name="is_active" value="1" 
                               <%= isEditMode && user.isActive() ? "checked" : "checked" %>>
                        <label for="is_active" style="font-weight: normal;">Aktif</label>
                    </div>
                    <div class="form-hint">Nonaktifkan untuk menonaktifkan akun</div>
                </div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEditMode ? "💾 Update User" : "👤 Simpan User Baru" %>
                </button>
                <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-secondary">
                    ❌ Batal
                </a>
            </div>
        </form>
        
        <% if (isEditMode) { %>
            <div style="margin-top: 40px; padding: 20px; background-color: #f0f8ff; border-radius: 5px;">
                <h3>🔐 Ganti Password</h3>
                <p>Untuk mengganti password user ini, gunakan menu khusus ganti password.</p>
                <a href="${pageContext.request.contextPath}/user?action=changepass&id=<%= user.getId() %>" 
                   class="btn btn-primary">Ganti Password</a>
            </div>
        <% } %>
    </div>
    
    <script>
        // Validasi form
        document.querySelector('form').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm_password');
            
            if (!username) {
                e.preventDefault();
                alert('Username harus diisi!');
                return false;
            }
            
            // Validasi password hanya untuk form tambah baru
            if (password && password.value) {
                if (password.value.length < 6) {
                    e.preventDefault();
                    alert('Password minimal 6 karakter!');
                    return false;
                }
                
                if (confirmPassword && password.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('Password dan konfirmasi password tidak cocok!');
                    return false;
                }
            }
        });
    </script>
</body>
</html>