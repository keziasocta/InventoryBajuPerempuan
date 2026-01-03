<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.inventory.model.Barang" %>
<%
    // Cek session
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Barang barang = (Barang) request.getAttribute("barang");
    boolean isEditMode = barang != null;
    String pageTitle = isEditMode ? "Edit Barang" : "Tambah Barang Baru";
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
            border-bottom: 2px solid #ff6b9d;
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
        input[type="number"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 14px;
        }
        
        input[type="text"]:focus,
        input[type="number"]:focus,
        select:focus {
            outline: none;
            border-color: #ff6b9d;
            box-shadow: 0 0 5px rgba(255, 107, 157, 0.3);
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
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
        
        .btn-secondary:hover {
            background-color: #5a6268;
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
        <a href="${pageContext.request.contextPath}/barang?action=list" class="back-link">← Kembali ke Daftar Barang</a>
        
        <h1><%= pageTitle %></h1>
        
        <form action="${pageContext.request.contextPath}/barang" method="POST">
            <input type="hidden" name="action" value="<%= action %>">
            <% if (isEditMode) { %>
                <input type="hidden" name="id" value="<%= barang.getId() %>">
            <% } %>
            
            <div class="form-group">
                <label for="nama" class="required">Nama Barang</label>
                <input type="text" id="nama" name="nama" 
                       value="<%= isEditMode ? barang.getNama() : "" %>" 
                       required placeholder="Contoh: Blouse Lace, Dress Floral...">
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="kategori">Kategori</label>
                    <select id="kategori" name="kategori">
                        <option value="">-- Pilih Kategori --</option>
                        <option value="Atasan" <%= isEditMode && "Atasan".equals(barang.getKategori()) ? "selected" : "" %>>Atasan</option>
                        <option value="Bawahan" <%= isEditMode && "Bawahan".equals(barang.getKategori()) ? "selected" : "" %>>Bawahan</option>
                        <option value="Dress" <%= isEditMode && "Dress".equals(barang.getKategori()) ? "selected" : "" %>>Dress</option>
                        <option value="Outer" <%= isEditMode && "Outer".equals(barang.getKategori()) ? "selected" : "" %>>Outer</option>
                        <option value="Aksesoris" <%= isEditMode && "Aksesoris".equals(barang.getKategori()) ? "selected" : "" %>>Aksesoris</option>
                        <option value="Dalam" <%= isEditMode && "Dalam".equals(barang.getKategori()) ? "selected" : "" %>>Pakaian Dalam</option>
                    </select>
                    <div class="form-hint">Baju atasan, bawahan, dress, dll</div>
                </div>
                
                <div class="form-group">
                    <label for="ukuran">Ukuran</label>
                    <select id="ukuran" name="ukuran">
                        <option value="">-- Pilih Ukuran --</option>
                        <option value="XS" <%= isEditMode && "XS".equals(barang.getUkuran()) ? "selected" : "" %>>XS (Extra Small)</option>
                        <option value="S" <%= isEditMode && "S".equals(barang.getUkuran()) ? "selected" : "" %>>S (Small)</option>
                        <option value="M" <%= isEditMode && "M".equals(barang.getUkuran()) ? "selected" : "" %>>M (Medium)</option>
                        <option value="L" <%= isEditMode && "L".equals(barang.getUkuran()) ? "selected" : "" %>>L (Large)</option>
                        <option value="XL" <%= isEditMode && "XL".equals(barang.getUkuran()) ? "selected" : "" %>>XL (Extra Large)</option>
                        <option value="XXL" <%= isEditMode && "XXL".equals(barang.getUkuran()) ? "selected" : "" %>>XXL (Double XL)</option>
                        <option value="All Size" <%= isEditMode && "All Size".equals(barang.getUkuran()) ? "selected" : "" %>>All Size</option>
                    </select>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="warna">Warna</label>
                    <input type="text" id="warna" name="warna" 
                           value="<%= isEditMode ? barang.getWarna() : "" %>" 
                           placeholder="Contoh: Putih, Hitam, Merah, Biru...">
                </div>
                
                <div class="form-group">
                    <label for="stok">Stok</label>
                    <input type="number" id="stok" name="stok" min="0" 
                           value="<%= isEditMode ? barang.getStok() : "0" %>">
                    <div class="form-hint">Jumlah barang di gudang</div>
                </div>
            </div>
            
            <div class="form-group">
                <label for="harga" class="required">Harga (Rp)</label>
                <input type="number" id="harga" name="harga" min="0" step="1000" 
                       value="<%= isEditMode ? barang.getHarga().intValue() : "" %>" 
                       required placeholder="Contoh: 120000">
                <div class="form-hint">Harga dalam Rupiah (tanpa titik atau koma)</div>
            </div>
            
            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    <%= isEditMode ? "💾 Update Barang" : "➕ Simpan Barang Baru" %>
                </button>
                <a href="${pageContext.request.contextPath}/barang?action=list" class="btn btn-secondary">
                    ❌ Batal
                </a>
            </div>
        </form>
    </div>
    
    <script>
        // Validasi form sederhana
        document.querySelector('form').addEventListener('submit', function(e) {
            const nama = document.getElementById('nama').value.trim();
            const harga = document.getElementById('harga').value.trim();
            
            if (!nama) {
                e.preventDefault();
                alert('Nama barang harus diisi!');
                return false;
            }
            
            if (!harga || isNaN(harga) || parseInt(harga) <= 0) {
                e.preventDefault();
                alert('Harga harus diisi dengan angka yang valid!');
                return false;
            }
        });
    </script>
</body>
</html>