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
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/user?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Ganti Password - Inventory Baju Perempuan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        
        .container {
            max-width: 600px;
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
            text-align: center;
        }
        
        .user-info {
            background-color: #f0f5ff;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .user-info h3 {
            margin-top: 0;
            color: #4a6fa5;
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
        
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        input:focus {
            outline: none;
            border-color: #4a6fa5;
            box-shadow: 0 0 5px rgba(74, 111, 165, 0.3);
        }
        
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }
        
        .strength-weak { color: red; }
        .strength-medium { color: orange; }
        .strength-strong { color: green; }
        
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
            flex: 1;
            text-align: center;
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
        
        .password-requirements {
            background-color: #fff3cd;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .password-requirements ul {
            margin: 10px 0;
            padding-left: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/user?action=list" class="back-link">← Kembali ke Daftar User</a>
        
        <h1>🔐 Ganti Password</h1>
        
        <div class="user-info">
            <h3>User: <%= user.getUsername() %></h3>
            <p><%= user.getNamaLengkap() != null ? user.getNamaLengkap() : "" %></p>
            <p>Role: <%= user.getRoleDisplay() %></p>
        </div>
        
        <div class="password-requirements">
            <h4>📋 Persyaratan Password:</h4>
            <ul>
                <li>Minimal 6 karakter</li>
                <li>Disarankan kombinasi huruf dan angka</li>
                <li>Jangan gunakan password yang mudah ditebak</li>
            </ul>
        </div>
        
        <form action="${pageContext.request.contextPath}/user" method="POST">
            <input type="hidden" name="action" value="changepassword">
            <input type="hidden" name="id" value="<%= user.getId() %>">
            
            <div class="form-group">
                <label for="new_password" class="required">Password Baru</label>
                <input type="password" id="new_password" name="new_password" required 
                       placeholder="Masukkan password baru" autofocus>
                <div class="password-strength" id="password-strength">
                    Kekuatan password: -
                </div>
            </div>
            
            <div class="form-group">
                <label for="confirm_password" class="required">Konfirmasi Password Baru</label>
                <input type="password" id="confirm_password" name="confirm_password" required 
                       placeholder="Ulangi password baru">
                <div class="form-hint">Pastikan password sama dengan di atas</div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    🔐 Ganti Password
                </button>
                <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-secondary">
                    ❌ Batal
                </a>
            </div>
        </form>
    </div>
    
    <script>
        // Password strength checker
        const passwordInput = document.getElementById('new_password');
        const strengthDisplay = document.getElementById('password-strength');
        
        passwordInput.addEventListener('input', function() {
            const password = passwordInput.value;
            let strength = 0;
            
            // Length check
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            
            // Character variety checks
            if (/[a-z]/.test(password)) strength++; // lowercase
            if (/[A-Z]/.test(password)) strength++; // uppercase
            if (/[0-9]/.test(password)) strength++; // numbers
            if (/[^a-zA-Z0-9]/.test(password)) strength++; // special chars
            
            // Update display
            let strengthText = 'Kekuatan password: ';
            let strengthClass = '';
            
            if (strength <= 2) {
                strengthText += 'Lemah';
                strengthClass = 'strength-weak';
            } else if (strength <= 4) {
                strengthText += 'Sedang';
                strengthClass = 'strength-medium';
            } else {
                strengthText += 'Kuat';
                strengthClass = 'strength-strong';
            }
            
            strengthDisplay.textContent = strengthText;
            strengthDisplay.className = 'password-strength ' + strengthClass;
        });
        
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Password minimal 6 karakter!');
                return false;
            }
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Password baru dan konfirmasi tidak cocok!');
                return false;
            }
            
            return confirm('Yakin ingin mengganti password untuk user <%= user.getUsername() %>?');
        });
    </script>
</body>
</html>