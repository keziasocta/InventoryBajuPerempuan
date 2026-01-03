<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.Barang" %>
<%@ page import="java.util.List" %>
<%
    // Cek session
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    List<Barang> barangList = (List<Barang>) request.getAttribute("barangList");
    String keyword = (String) request.getAttribute("keyword");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar Barang - Inventory Baju Perempuan</title>
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
            border-bottom: 2px solid #ff6b9d;
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
            background-color: #ff6b9d;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff4d8d;
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
            background-color: #fff5f7;
            color: #333;
            font-weight: bold;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .stok-rendah {
            background-color: #fff3cd !important;
            color: #856404;
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
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff6b9d;
            text-decoration: none;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/views/dashboard.jsp" class="back-link">← Kembali ke Dashboard</a>
        
        <div class="header">
            <h1>👚 Daftar Barang Baju Perempuan</h1>
            <a href="${pageContext.request.contextPath}/barang?action=new" class="btn btn-primary">
                ➕ Tambah Barang Baru
            </a>
        </div>
        
        <%-- Success Message --%>
        <% if ("add".equals(success)) { %>
            <div class="alert alert-success">
                ✅ Barang berhasil ditambahkan!
            </div>
        <% } else if ("update".equals(success)) { %>
            <div class="alert alert-success">
                ✅ Barang berhasil diperbarui!
            </div>
        <% } else if ("delete".equals(success)) { %>
            <div class="alert alert-success">
                ✅ Barang berhasil dihapus!
            </div>
        <% } %>
        
        <%-- Search Box --%>
        <form action="${pageContext.request.contextPath}/barang" method="GET" class="search-box">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" class="search-input" 
                   placeholder="Cari barang (nama, kategori, warna)..." 
                   value="<%= keyword != null ? keyword : "" %>">
            <button type="submit" class="search-btn">🔍 Cari</button>
            <% if (keyword != null) { %>
                <a href="${pageContext.request.contextPath}/barang" class="btn btn-secondary">Tampilkan Semua</a>
            <% } %>
        </form>
        
        <% if (barangList != null && !barangList.isEmpty()) { %>
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nama Barang</th>
                            <th>Kategori</th>
                            <th>Ukuran</th>
                            <th>Warna</th>
                            <th>Stok</th>
                            <th>Harga</th>
                            <th>Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Barang barang : barangList) { 
                            String rowClass = barang.isStokRendah() ? "stok-rendah" : "";
                        %>
                            <tr class="<%= rowClass %>">
                                <td><%= barang.getId() %></td>
                                <td><strong><%= barang.getNama() %></strong></td>
                                <td><%= barang.getKategori() %></td>
                                <td><%= barang.getUkuran() %></td>
                                <td>
                                    <span style="display: inline-block; width: 15px; height: 15px; 
                                          background-color: <%= getColorCode(barang.getWarna()) %>; 
                                          border-radius: 50%; margin-right: 5px;"></span>
                                    <%= barang.getWarna() %>
                                </td>
                                <td>
                                    <strong><%= barang.getStok() %></strong>
                                    <% if (barang.isStokRendah()) { %>
                                        <span style="color: red; font-size: 12px;"> (Rendah)</span>
                                    <% } %>
                                </td>
                                <td><strong><%= barang.getHargaFormatted() %></strong></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${pageContext.request.contextPath}/barang?action=edit&id=<%= barang.getId() %>" 
                                           class="btn btn-warning btn-sm">✏️ Edit</a>
                                        <a href="${pageContext.request.contextPath}/barang?action=delete&id=<%= barang.getId() %>" 
                                           class="btn btn-danger btn-sm"
                                           onclick="return confirm('Yakin ingin menghapus <%= barang.getNama() %>?')">🗑️ Hapus</a>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div style="margin-top: 20px; color: #666; font-size: 14px;">
                Total: <strong><%= barangList.size() %></strong> barang ditemukan
                <% if (keyword != null) { %>
                    untuk pencarian "<%= keyword %>"
                <% } %>
            </div>
            
        <% } else { %>
            <div class="alert alert-info">
                <% if (keyword != null) { %>
                    🔍 Tidak ada barang yang ditemukan untuk pencarian "<%= keyword %>"
                <% } else { %>
                    📭 Belum ada data barang. <a href="${pageContext.request.contextPath}/barang?action=new">Tambahkan barang pertama</a>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>

<%!
    // Helper method untuk color code
    private String getColorCode(String warna) {
        if (warna == null) return "#cccccc";
        
        switch (warna.toLowerCase()) {
            case "putih": return "#ffffff";
            case "hitam": return "#000000";
            case "merah": return "#ff0000";
            case "biru": return "#0000ff";
            case "hijau": return "#00ff00";
            case "kuning": return "#ffff00";
            case "pink": return "#ffc0cb";
            case "ungu": return "#800080";
            case "abu-abu": return "#808080";
            case "coklat": return "#a52a2a";
            default: return "#" + Math.abs(warna.hashCode() % 0xFFFFFF);
        }
    }
%>