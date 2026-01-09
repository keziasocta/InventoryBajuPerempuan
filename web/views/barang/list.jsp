<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.Barang" %>
<%@ page import="com.inventory.model.User" %>
<%@ page import="java.util.List" %>
<%
    // Cek session
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    User user = (User) session.getAttribute("user");
    String role = user.getRole(); // admin / staff / viewer

    List<Barang> barangList = (List<Barang>) request.getAttribute("barangList");
    String keyword = (String) request.getAttribute("keyword");
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Daftar Barang - Inventory Baju Perempuan</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f9f9f9; }
        .container
        { 
            max-width: 1200px; 
            margin: 0 auto; 
            background-color: white; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 0 10px rgba(0,0,0,0.1); 
        }
        
        .header 
        { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
            padding-bottom: 20px; 
            border-bottom: 2px solid #ff6b9d; 
        }
        
        h1 
        { color: #333; margin: 0; }
        
        .btn 
        { padding: 10px 20px; 
          border: none; 
          border-radius: 5px; 
          cursor: pointer; 
          text-decoration: none; 
          display: inline-block; 
          font-size: 14px; 
        }
        
        .btn-primary 
        { background-color: #ff6b9d; 
          color: white; 
        }
        
        .btn-secondary 
        { background-color: #6c757d;
          color: white; 
        }
        
        .btn-warning 
        { background-color: #ffc107;
          color: black; 
        }
        
        .btn-danger 
        { 
            background-color: #dc3545; 
            color: white; 
        }
        
        .btn-sm 
        { 
            padding: 5px 10px; 
            font-size: 12px; 
        }
        .search-box { display: flex; gap: 10px; margin-bottom: 20px; }
        .search-input { flex-grow: 1; padding: 10px; border: 1px solid #ddd; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 15px; border-bottom: 1px solid #ddd; }
        th { background-color: #fff5f7; }
        .action-buttons { display: flex; gap: 5px; }
        .alert { padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .alert-success { background-color: #d4edda; }
        .alert-info { background-color: #d1ecf1; }
        .stok-rendah { background-color: #fff3cd !important; }
        .back-link { margin-bottom: 20px; display: inline-block; color: #ff6b9d; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">

    <a href="${pageContext.request.contextPath}/views/dashboard.jsp" class="back-link">
        ← Kembali ke Dashboard
    </a>

    <div class="header">
        <h1>👚 Daftar Barang Baju Perempuan</h1>

        <%-- Tambah Barang hanya untuk Admin & Staff --%>
        <% if (!role.equals("viewer")) { %>
            <a href="${pageContext.request.contextPath}/barang?action=new" class="btn btn-primary">
                ➕ Tambah Barang Baru
            </a>
        <% } %>
    </div>

    <% if ("add".equals(success)) { %>
        <div class="alert alert-success">✅ Barang berhasil ditambahkan!</div>
    <% } else if ("update".equals(success)) { %>
        <div class="alert alert-success">✅ Barang berhasil diperbarui!</div>
    <% } else if ("delete".equals(success)) { %>
        <div class="alert alert-success">✅ Barang berhasil dihapus!</div>
    <% } %>

    <form action="${pageContext.request.contextPath}/barang" method="GET" class="search-box">
        <input type="hidden" name="action" value="search">
        <input type="text" name="keyword" class="search-input"
               placeholder="Cari barang..."
               value="<%= keyword != null ? keyword : "" %>">
        <button type="submit" class="btn btn-secondary">🔍 Cari</button>
    </form>

    <% if (barangList != null && !barangList.isEmpty()) { %>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Nama</th>
                <th>Kategori</th>
                <th>Ukuran</th>
                <th>Warna</th>
                <th>Stok</th>
                <th>Harga</th>
                <th>Aksi</th>
            </tr>
            </thead>
            <tbody>
            <% for (Barang barang : barangList) { %>
                <tr class="<%= barang.isStokRendah() ? "stok-rendah" : "" %>">
                    <td><%= barang.getId() %></td>
                    <td><%= barang.getNama() %></td>
                    <td><%= barang.getKategori() %></td>
                    <td><%= barang.getUkuran() %></td>
                    <td><%= barang.getWarna() %></td>
                    <td><%= barang.getStok() %></td>
                    <td><%= barang.getHargaFormatted() %></td>
                    <td>
                        <div class="action-buttons">

                            <%-- Edit: Admin & Staff --%>
                            <% if (role.equals("admin") || role.equals("staff")) { %>
                                <a href="${pageContext.request.contextPath}/barang?action=edit&id=<%= barang.getId() %>"
                                   class="btn btn-warning btn-sm">✏️ Edit</a>
                            <% } %>

                            <%-- Hapus: Admin saja --%>
                            <% if (role.equals("admin")) { %>
                                <a href="${pageContext.request.contextPath}/barang?action=delete&id=<%= barang.getId() %>"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('Yakin ingin menghapus <%= barang.getNama() %>?')">🗑️ Hapus</a>
                            <% } %>

                        </div>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

        <p>Total: <strong><%= barangList.size() %></strong> barang</p>

    <% } else { %>
        <div class="alert alert-info">📭 Data barang belum tersedia</div>
    <% } %>

</div>
</body>
</html>
