<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User" %>
<%
    
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Inventory Baju Perempuan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        
        .header {
            background: linear-gradient(to right, #ff6b9d, #ff8fab);
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .welcome {
            font-size: 18px;
        }
        
        .logout-btn {
            background-color: white;
            color: #ff6b9d;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .logout-btn:hover {
            background-color: #fff5f7;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .card {
            background-color: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        
        .card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .card-desc {
            color: #666;
            font-size: 14px;
        }
        
        h1 {
            color: #333;
            text-align: center;
        }
        
        .info-box {
            background-color: #fff5f7;
            border-left: 4px solid #ff6b9d;
            padding: 15px;
            margin-bottom: 30px;
        }
        
        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            margin-left: 10px;
        }
        
        .role-admin {
            background-color: #ff6b9d;
            color: white;
        }
        
        .role-staff {
            background-color: #4a6fa5;
            color: white;
        }
        
        .role-viewer {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <div>
            <h1>Inventory Gudang Baju Perempuan</h1>
            <div class="welcome">
                Selamat datang, <%= user.getUsername() %>!
                <span class="role-badge role-<%= user.getRole() %>">
                    <%= 
                        "admin".equals(user.getRole()) ? "Administrator" :
                        "staff".equals(user.getRole()) ? "Staff" : "Viewer"
                    %>
                </span>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
    </div>
    
    <div class="container">
        <div class="info-box">
            <strong>Informasi Sistem:</strong> 
            Sistem ini digunakan untuk mengelola inventaris baju perempuan di gudang.
            Fitur: Login, CRUD Barang, Laporan PDF, Manajemen User.
            <br><br>
            <strong>Role Anda:</strong> 
            <%= 
                "admin".equals(user.getRole()) ? "Administrator - Akses penuh ke semua fitur" :
                "staff".equals(user.getRole()) ? "Staff - Dapat mengelola barang" :
                "Viewer - Hanya dapat melihat data"
            %>
        </div>
        
        <h2>Menu Utama</h2>
        
        <div class="card-container">
            <a href="${pageContext.request.contextPath}/barang?action=list" class="card">
                <div class="card-icon">👚</div>
                <div class="card-title">Kelola Barang</div>
                <div class="card-desc">Tambah, edit, hapus data baju</div>
            </a>
            
            <a href="${pageContext.request.contextPath}/views/laporan/cetak.jsp" class="card">
                <div class="card-icon">📊</div>
                <div class="card-title">Laporan</div>
                <div class="card-desc">Cetak laporan stok barang (PDF)</div>
            </a>
            
            <%-- Tampilkan User Management hanya untuk admin --%>
            <% if ("admin".equals(user.getRole())) { %>
                <a href="${pageContext.request.contextPath}/user?action=list" class="card">
                    <div class="card-icon">👥</div>
                    <div class="card-title">User Management</div>
                    <div class="card-desc">Kelola user system (Admin only)</div>
                </a>
            <% } %>
            
            <a href="#" class="card" onclick="alert('Fitur dalam pengembangan')">
                <div class="card-icon">⚙️</div>
                <div class="card-title">Pengaturan</div>
                <div class="card-desc">Konfigurasi sistem</div>
            </a>
        </div>
        
    </div>
    
    <script>
        // Alert jika baru login
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('newlogin')) {
            alert('Selamat datang di Sistem Inventory Baju Perempuan!');
        }
    </script>
</body>
</html>