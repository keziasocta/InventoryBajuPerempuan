package com.inventory.controller;

import com.inventory.model.Barang;
import com.inventory.model.BarangDAO;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.ByteArrayOutputStream;
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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LaporanController", urlPatterns = {"/laporan/*"})
public class LaporanController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cek session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("cetak".equals(action)) {
            cetakLaporanBarangPDF(request, response);
        } else {
            // Default: tampilkan halaman laporan
            request.getRequestDispatcher("/views/laporan/cetak.jsp").forward(request, response);
        }
    }
    
    private void cetakLaporanBarangPDF(HttpServletRequest request, HttpServletResponse response) {
        try {
            // Set response type untuk PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "inline; filename=\"laporan_barang_" + 
                new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".pdf\"");
            
            // Create PDF document
            Document document = new Document();
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, baos);
            document.open();
            
            // Fonts
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 10);
            Font smallFont = FontFactory.getFont(FontFactory.HELVETICA, 8);
            
            // Title
            Paragraph title = new Paragraph("LAPORAN STOK BARANG BAJU PEREMPUAN", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // Date
            Paragraph date = new Paragraph(
                "Tanggal cetak: " + new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(new Date()), 
                smallFont);
            date.setAlignment(Element.ALIGN_RIGHT);
            date.setSpacingAfter(20);
            document.add(date);
            
            // Get data from database
            BarangDAO barangDAO = new BarangDAO();
            List<Barang> barangList = barangDAO.getAllBarang();
            
            // Create table with 7 columns
            PdfPTable table = new PdfPTable(7);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10f);
            table.setSpacingAfter(10f);
            
            // Set column widths
            float[] columnWidths = {0.5f, 2f, 1f, 0.8f, 1f, 0.8f, 1.5f};
            table.setWidths(columnWidths);
            
            // Table headers
            addTableHeader(table, headerFont);
            
            // Table data
            addTableData(table, barangList, normalFont);
            
            // Add table to document
            document.add(table);
            
            // Summary
            if (!barangList.isEmpty()) {
                Paragraph summary = new Paragraph(
                    "Total barang: " + barangList.size() + " item", 
                    headerFont);
                summary.setSpacingBefore(20);
                document.add(summary);
                
                // Calculate total stock
                int totalStok = barangList.stream().mapToInt(Barang::getStok).sum();
                Paragraph totalStock = new Paragraph(
                    "Total stok: " + totalStok + " pcs", 
                    normalFont);
                document.add(totalStock);
            } else {
                Paragraph emptyMsg = new Paragraph("Tidak ada data barang", normalFont);
                emptyMsg.setAlignment(Element.ALIGN_CENTER);
                document.add(emptyMsg);
            }
            
            // Footer
            Paragraph footer = new Paragraph(
                "\n\n© " + new SimpleDateFormat("yyyy").format(new Date()) + 
                " - Sistem Inventory Gudang Baju Perempuan", 
                smallFont);
            footer.setAlignment(Element.ALIGN_CENTER);
            document.add(footer);
            
            document.close();
            
            // Write PDF to response
            response.setContentLength(baos.size());
            OutputStream os = response.getOutputStream();
            baos.writeTo(os);
            os.flush();
            os.close();
            
            System.out.println("PDF berhasil digenerate dengan iText");
            
        } catch (DocumentException e) {
            System.err.println("Error membuat PDF: " + e.getMessage());
            try {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal membuat PDF: " + e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private void addTableHeader(PdfPTable table, Font font) {
        String[] headers = {"ID", "NAMA BARANG", "KATEGORI", "UKURAN", "WARNA", "STOK", "HARGA (Rp)"};
        
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, font));
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            cell.setPadding(5);
            cell.setBackgroundColor(new com.itextpdf.text.BaseColor(255, 107, 157)); // Pink color
            table.addCell(cell);
        }
    }
    
    private void addTableData(PdfPTable table, List<Barang> barangList, Font font) {
        for (Barang barang : barangList) {
            // ID
            PdfPCell idCell = new PdfPCell(new Phrase(String.valueOf(barang.getId()), font));
            idCell.setPadding(5);
            table.addCell(idCell);
            
            // Nama
            PdfPCell namaCell = new PdfPCell(new Phrase(barang.getNama(), font));
            namaCell.setPadding(5);
            table.addCell(namaCell);
            
            // Kategori
            String kategori = barang.getKategori() != null ? barang.getKategori() : "-";
            PdfPCell kategoriCell = new PdfPCell(new Phrase(kategori, font));
            kategoriCell.setPadding(5);
            kategoriCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(kategoriCell);
            
            // Ukuran
            String ukuran = barang.getUkuran() != null ? barang.getUkuran() : "-";
            PdfPCell ukuranCell = new PdfPCell(new Phrase(ukuran, font));
            ukuranCell.setPadding(5);
            ukuranCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(ukuranCell);
            
            // Warna
            String warna = barang.getWarna() != null ? barang.getWarna() : "-";
            PdfPCell warnaCell = new PdfPCell(new Phrase(warna, font));
            warnaCell.setPadding(5);
            warnaCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(warnaCell);
            
            // Stok
            PdfPCell stokCell = new PdfPCell(new Phrase(String.valueOf(barang.getStok()), font));
            stokCell.setPadding(5);
            stokCell.setHorizontalAlignment(Element.ALIGN_CENTER);
            
            // Warna merah jika stok rendah
            if (barang.isStokRendah()) {
                stokCell.setBackgroundColor(new com.itextpdf.text.BaseColor(255, 200, 200));
            }
            table.addCell(stokCell);
            
            // Harga
            String hargaFormatted = String.format("Rp %,d", barang.getHarga().intValue());
            PdfPCell hargaCell = new PdfPCell(new Phrase(hargaFormatted, font));
            hargaCell.setPadding(5);
            hargaCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
            table.addCell(hargaCell);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Laporan Controller dengan iText PDF";
    }
}