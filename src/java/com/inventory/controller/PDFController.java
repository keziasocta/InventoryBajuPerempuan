package com.inventory.controller;

import com.inventory.model.Barang;
import com.inventory.model.BarangDAO;
import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/pdf/barang")
public class PDFController extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", 
            "inline; filename=\"laporan_barang.pdf\"");
        
        try {
            Document document = new Document();
            OutputStream out = response.getOutputStream();
            PdfWriter.getInstance(document, out);
            document.open();
            
            // Judul
            document.add(new Paragraph("LAPORAN STOK BARANG BAJU PEREMPUAN"));
            document.add(new Paragraph("Tanggal: " + 
                new SimpleDateFormat("dd-MM-yyyy HH:mm").format(new Date())));
            document.add(new Paragraph(" "));
            
            // Tabel
            BarangDAO dao = new BarangDAO();
            List<Barang> barangList = dao.getAllBarang();
            
            PdfPTable table = new PdfPTable(6);
            table.addCell("Nama");
            table.addCell("Kategori");
            table.addCell("Ukuran");
            table.addCell("Warna");
            table.addCell("Stok");
            table.addCell("Harga");
            
            for (Barang barang : barangList) {
                table.addCell(barang.getNama());
                table.addCell(barang.getKategori());
                table.addCell(barang.getUkuran());
                table.addCell(barang.getWarna());
                table.addCell(String.valueOf(barang.getStok()));
                table.addCell("Rp " + barang.getHarga());
            }
            
            document.add(table);
            document.close();
            
        } catch (Exception e) {
            response.sendError(500, "Error generating PDF: " + e.getMessage());
        }
    }
}