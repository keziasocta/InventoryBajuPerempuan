<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Inventory Baju Perempuan</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .login-container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 350px;
        }
        
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        
        .logo {
            display: block;
            margin: 0 auto 0px auto;
            width: 200px;
            height: auto;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
        }
        
        button {
            width: 100%;
            padding: 12px;
            background-color: #ff6b9d;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        
        button:hover {
            background-color: #ff4d8d;
        }
        
        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 15px;
        }
        
        .success-message {
            color: green;
            text-align: center;
            margin-bottom: 15px;
        }
        
        .copyright {
            text-align: center;
            margin-top: 25px;
            font-size: 12px;
            color: #888;
        }
        
        .copyright span {
            display: block;
        }

    </style>
</head>
<body>
    <div class="login-container">
        
        <img src="${pageContext.request.contextPath}/assets/images/logo1.png"
             alt="Logo Inventory"
             class="logo">

        <h2>Login</h2>
        
        <%-- Tampilkan pesan error --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                Username atau password salah!
            </div>
        <% } %>
        
        <%-- Tampilkan pesan logout --%>
        <% if (request.getParameter("logout") != null) { %>
            <div class="success-message">
                Anda telah logout
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/login" method="POST">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            
            <button type="submit">Login</button>
        </form>
            
            <div class="copyright">
                © 2026 Inventory Baju Perempuan. All Rights Reserved.<br>
                Kezia, Ris Naia, Saldy
            </div>
        
    </div>
</body>
</html>
