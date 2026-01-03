<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.User" %>
<%@ page import="java.util.List" %>
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
    
    List<User> userList = (List<User>) request.getAttribute("userList");
    String keyword = (String) request.getAttribute("keyword");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manajemen User - Inventory Baju Perempuan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f9f9f9;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #4a6fa5;
        }
        
        h1 {
            color: #333;
            margin: 0;
        }
        
        .btn {
            padding: 10px 20px;
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
        
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        
        .btn-warning {
            background-color: #ffc107;
            color: black;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-info {
            background-color: #17a2b8;
            color: white;
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .search-input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .search-btn {
            background-color: #17a2b8;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background-color: #f0f5ff;
            color: #333;
            font-weight: bold;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
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
        
        .status-active {
            color: green;
            font-weight: bold;
        }
        
        .status-inactive {
            color: red;
            font-weight: bold;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #4a6fa5;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/views/dashboard.jsp" class="back-link">← Kembali ke Dashboard</a>
        
        <div class="header">
            <h1>👥 Manajemen Pengguna</h1>
            <a href="${pageContext.request.contextPath}/user?action=new" class="btn btn-primary">
                👤 Tambah User Baru
            </a>
        </div>
        
        <%-- Success Message --%>
        <% if ("add".equals(success)) { %>
            <div class="alert alert-success">
                ✅ User berhasil ditambahkan!
            </div>
        <% } else if ("update".equals(success)) { %>
            <div class="alert alert-success">
                ✅ User berhasil diperbarui!
            </div>
        <% } else if ("delete".equals(success)) { %>
            <div class="alert alert-success">
                ✅ User berhasil dihapus!
            </div>
        <% } else if ("changepass".equals(success)) { %>
            <div class="alert alert-success">
                ✅ Password berhasil diubah!
            </div>
        <% } %>
        
        <%-- Search Box --%>
        <form action="${pageContext.request.contextPath}/user" method="GET" class="search-box">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" 
                   placeholder="Cari user (username, nama, email)..." 
                   value="<%= keyword != null ? keyword : "" %>">
            <button type="submit" class="search-btn">🔍 Cari</button>
            <% if (keyword != null) { %>
                <a href="${pageContext.request.contextPath}/user" class="btn btn-secondary">Tampilkan Semua</a>
            <% } %>
        </form>
        
        <% if (userList != null && !userList.isEmpty()) { %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Avatar</th>
                            <th>Username</th>
                            <th>Nama Lengkap</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Tanggal Daftar</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (User user : userList) { 
                            String initials = user.getUsername().substring(0, 1).toUpperCase();
                        %>
                            <tr>
                                <td>
                                    <div class="user-avatar">
                                        <%= initials %>
                                    </div>
                                </td>
                                <td><strong><%= user.getUsername() %></strong></td>
                                <td><%= user.getNamaLengkap() != null ? user.getNamaLengkap() : "-" %></td>
                                <td><%= user.getEmail() != null ? user.getEmail() : "-" %></td>
                                <td>
                                    <span class="role-badge role-<%= user.getRole() %>">
                                        <%= user.getRoleDisplay() %>
                                    </span>
                                </td>
                                <td>
                                    <% if (user.isActive()) { %>
                                        <span class="status-active">✓ Aktif</span>
                                    <% } else { %>
                                        <span class="status-inactive">✗ Nonaktif</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (user.getCreatedAt() != null) { %>
                                        <%= new java.text.SimpleDateFormat("dd-MM-yyyy").format(user.getCreatedAt()) %>
                                    <% } else { %>
                                        -
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/user?action=edit&id=<%= user.getId() %>" 
                                           class="btn btn-warning btn-sm">✏️ Edit</a>
                                        <a href="${pageContext.request.contextPath}/user?action=changepass&id=<%= user.getId() %>" 
                                           class="btn btn-info btn-sm">🔐 Ganti Pass</a>
                                        <% if (currentUser.getId() != user.getId()) { %>
                                            <a href="${pageContext.request.contextPath}/user?action=delete&id=<%= user.getId() %>" 
                                               class="btn btn-danger btn-sm"
                                               onclick="return confirm('Yakin ingin menghapus user <%= user.getUsername() %>?')">🗑️ Hapus</a>
                                        <% } else { %>
                                            <button class="btn btn-secondary btn-sm" disabled>Diri Sendiri</button>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div style="margin-top: 20px; color: #666; font-size: 14px;">
                Total: <strong><%= userList.size() %></strong> user ditemukan
                <% if (keyword != null) { %>
                    untuk pencarian "<%= keyword %>"
                <% } %>
            </div>
            
        <% } else { %>
            <div class="alert alert-info">
                <% if (keyword != null) { %>
                    🔍 Tidak ada user yang ditemukan untuk pencarian "<%= keyword %>"
                <% } else { %>
                    📭 Belum ada data user. <a href="${pageContext.request.contextPath}/user?action=new">Tambahkan user pertama</a>
                <% } %>
            </div>
        <% } %>
        
        <div style="margin-top: 40px; padding: 20px; background-color: #f8f9fa; border-radius: 5px;">
            <h3>📋 Informasi Role:</h3>
            <ul>
                <li><strong>Administrator</strong> - Akses penuh: kelola barang, user, laporan</li>
                <li><strong>Staff</strong> - Akses terbatas: hanya kelola barang (CRUD)</li>
                <li><strong>Viewer</strong> - Akses baca saja: hanya lihat data, tidak bisa edit/hapus</li>
            </ul>
        </div>
    </div>
</body>
</html>