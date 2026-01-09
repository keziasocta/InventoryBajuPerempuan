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
            background-color: #f9f9f9;
        }

        .header {
            background:
                linear-gradient(
                    rgba(255,107,157,0.75),
                    rgba(255,143,171,0.75)
                ),
            url("${pageContext.request.contextPath}/assets/images/cover-header1.jpg");
                
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;

            color: white;
            padding: 16px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 6px 20px rgba(0,0,0,0.2);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dashboard-logo {
            width: 250px;
            height: auto;
        }

        .header-left h1 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }

        .welcome {
            font-size: 14px;
            opacity: 0.95;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            margin-left: 6px;
            background: rgba(255,255,255,0.3);
        }

        /* ================= LOGOUT ================= */
        .logout-btn {
            background-color: white;
            color: #ff6b9d;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-weight: bold;
        }

        .logout-btn:hover {
            background-color: #ffe4ee;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .info-box {
            background-color: #fff5f7;
            border-left: 4px solid #ff6b9d;
            padding: 15px;
            margin-bottom: 30px;
            border-radius: 8px;
        }

        h2 {
            margin-bottom: 15px;
        }

        .card-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .card {
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
            text-align: center;
            text-decoration: none;
            color: #333;
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-6px);
            box-shadow: 0 14px 28px rgba(0,0,0,0.2);
        }

        .card-icon {
            font-size: 40px;
            margin-bottom: 12px;
        }

        .card-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 6px;
        }

        .card-desc {
            color: #666;
            font-size: 14px;
        }
    </style>
</head>

<body>

<!-- ================= HEADER ================= -->
<div class="header">

    <div class="header-left">
        <img src="${pageContext.request.contextPath}/assets/images/logo1-removebg.png"
             alt="Logo Inventory"
             class="dashboard-logo">

        <div>
            <h1>Inventory Gudang Baju Perempuan</h1>
            <div class="welcome">
                Kelola Stok Lebih Mudah, Cepat, dan Akurat<br>
                Selamat datang, <%= user.getUsername() %>!
                <span class="role-badge">
                    <%= 
                        "admin".equals(user.getRole()) ? "Administrator" :
                        "staff".equals(user.getRole()) ? "Staff" : "Viewer"
                    %>
                </span>
            </div>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/logout"
       class="logout-btn">Logout</a>

</div>

<!-- ================= CONTENT ================= -->
<div class="container">

    <div class="info-box">
        <strong>Informasi Sistem:</strong><br>
        Sistem ini digunakan untuk mengelola inventaris baju perempuan di gudang.
        Fitur utama meliputi Login, CRUD Barang, Laporan PDF, dan Manajemen User.
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

        <% if ("admin".equals(user.getRole())) { %>
        <a href="${pageContext.request.contextPath}/user?action=list" class="card">
            <div class="card-icon">👥</div>
            <div class="card-title">User Management</div>
            <div class="card-desc">Kelola user system</div>
        </a>
        <% } %>

        <a href="#" class="card" onclick="alert('Fitur dalam pengembangan')">
            <div class="card-icon">⚙️</div>
            <div class="card-title">Pengaturan</div>
            <div class="card-desc">Konfigurasi sistem</div>
        </a>

    </div>
</div>

</body>
</html>
