package com.inventory.controller;

import com.inventory.model.Barang;
import com.inventory.model.BarangDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BarangController", urlPatterns = {"/barang"})
public class BarangController extends HttpServlet {

    private final BarangDAO barangDAO = new BarangDAO();
    
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
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBarang(request, response);
                break;
            case "search":
                searchBarang(request, response);
                break;
            default: // "list"
                listBarang(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Cek session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("insert".equals(action)) {
            insertBarang(request, response);
        } else if ("update".equals(action)) {
            updateBarang(request, response);
        } else {
            listBarang(request, response);
        }
    }
    
    // ========== METHOD HANDLERS ==========
    
    private void listBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            request.setAttribute("barangList", barangDAO.getAllBarang());
            request.getRequestDispatcher("/views/barang/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error retrieving barang list: " + e.getMessage());
        }
    }
    
    private void searchBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            listBarang(request, response);
            return;
        }
        
        try {
            request.setAttribute("barangList", barangDAO.searchBarang(keyword));
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/barang/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error searching barang: " + e.getMessage());
        }
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/barang/form.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Barang barang = barangDAO.getBarangById(id);
            
            if (barang == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Barang tidak ditemukan");
                return;
            }
            
            request.setAttribute("barang", barang);
            request.getRequestDispatcher("/views/barang/form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        }
    }
    
    private void insertBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Validasi input
        String nama = request.getParameter("nama");
        String kategori = request.getParameter("kategori");
        String ukuran = request.getParameter("ukuran");
        String warna = request.getParameter("warna");
        String stokStr = request.getParameter("stok");
        String hargaStr = request.getParameter("harga");
        
        // Validasi required fields
        if (nama == null || nama.trim().isEmpty() || 
            hargaStr == null || hargaStr.trim().isEmpty()) {
            
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Nama dan harga harus diisi");
            return;
        }
        
        try {
            Barang barang = new Barang();
            barang.setNama(nama.trim());
            barang.setKategori(kategori != null ? kategori.trim() : "");
            barang.setUkuran(ukuran != null ? ukuran.trim() : "");
            barang.setWarna(warna != null ? warna.trim() : "");
            
            // Parse stok dengan default 0 jika kosong
            if (stokStr != null && !stokStr.trim().isEmpty()) {
                barang.setStok(Integer.parseInt(stokStr.trim()));
            } else {
                barang.setStok(0);
            }
            
            // Parse harga
            barang.setHarga(new BigDecimal(hargaStr.trim()));
            
            // Save to database
            boolean success = barangDAO.addBarang(barang);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/barang?action=list&success=add");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal menambahkan barang");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Format angka tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    private void updateBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nama = request.getParameter("nama");
            String kategori = request.getParameter("kategori");
            String ukuran = request.getParameter("ukuran");
            String warna = request.getParameter("warna");
            String stokStr = request.getParameter("stok");
            String hargaStr = request.getParameter("harga");
            
            // Validasi
            if (nama == null || nama.trim().isEmpty() || 
                hargaStr == null || hargaStr.trim().isEmpty()) {
                
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                    "Nama dan harga harus diisi");
                return;
            }
            
            Barang barang = new Barang();
            barang.setId(id);
            barang.setNama(nama.trim());
            barang.setKategori(kategori != null ? kategori.trim() : "");
            barang.setUkuran(ukuran != null ? ukuran.trim() : "");
            barang.setWarna(warna != null ? warna.trim() : "");
            
            if (stokStr != null && !stokStr.trim().isEmpty()) {
                barang.setStok(Integer.parseInt(stokStr.trim()));
            } else {
                barang.setStok(0);
            }
            
            barang.setHarga(new BigDecimal(hargaStr.trim()));
            
            boolean success = barangDAO.updateBarang(barang);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/barang?action=list&success=update");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal mengupdate barang");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Format angka tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    private void deleteBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            boolean success = barangDAO.deleteBarang(id);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/barang?action=list&success=delete");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Gagal menghapus barang");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tidak valid");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error: " + e.getMessage());
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Barang Controller for CRUD operations";
    }
}