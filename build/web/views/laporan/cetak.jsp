<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Cek session
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cetak Laporan - Inventory Baju Perempuan</title>
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
            text-align: center;
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
        
        .report-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .report-card {
            background-color: #fff5f7;
            padding: 25px;
            border-radius: 10px;
            border: 1px solid #ffd1dc;
            text-align: center;
            transition: transform 0.3s;
        }
        
        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(255, 107, 157, 0.2);
        }
        
        .report-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        
        .report-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
            color: #333;
        }
        
        .report-desc {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .btn-print {
            background-color: #ff6b9d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-print:hover {
            background-color: #ff4d8d;
        }
        
        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            margin-bottom: 30px;
            border-radius: 5px;
        }
        
        .info-box h3 {
            margin-top: 0;
            color: #0c5460;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="${pageContext.request.contextPath}/views/dashboard.jsp" class="back-link">← Kembali ke Dashboard</a>
        
        <h1>📊 Cetak Laporan</h1>
        
        <div class="info-box">

<div class="alert alert-info">
    <p>Silahkan pilih menu mana yang akan anda cetak</p> 
    PDF akan terbuka di tab baru browser Anda.
</div>
        
        <div class="report-options">
            <!-- Laporan Stok Barang -->
            <div class="report-card">
                <div class="report-icon">👚</div>
                <div class="report-title">Laporan Stok Barang</div>
                <div class="report-desc">
                    Daftar semua barang dengan detail: nama, kategori, ukuran, warna, stok, dan harga.
                </div>
                <form action="${pageContext.request.contextPath}/laporan" method="GET" target="_blank">
                    <input type="hidden" name="action" value="cetak">
                    <button type="submit" class="btn-print">📄 Cetak PDF</button>
                </form>
            </div>
            
            <!-- Laporan Stok Rendah -->
            <div class="report-card">
                <div class="report-icon">⚠️</div>
                <div class="report-title">Laporan Stok Rendah</div>
                <div class="report-desc">
                    Barang dengan stok di bawah 10 pcs. Untuk monitoring restock.
                </div>
                <button class="btn-print" onclick="alert('Fitur dalam pengembangan')">
                    🔧 Coming Soon
                </button>
            </div>
        
        <div style="margin-top: 40px; padding: 20px; background-color: #f8f9fa; border-radius: 5px;">
            <h3>🖨️ Cara Mencetak:</h3>
            <ol>
                <li>Klik tombol <strong>"Cetak PDF"</strong> pada laporan yang diinginkan</li>
                <li>Tunggu proses generate laporan (beberapa detik)</li>
                <li>PDF akan terbuka di tab baru browser</li>
                <li>Gunakan fitur print browser untuk mencetak fisik</li>
                <li>Atau simpan file PDF dengan klik tombol save di viewer PDF</li>
            </ol>
        </div>
    </div>
    
    <script>
        // Notifikasi jika ada error
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('error')) {
            alert('Terjadi error saat generate laporan. Pastikan JasperReports terinstall dengan benar.');
        }
    </script>
</body>
</html>