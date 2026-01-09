package com.inventory.controller;

import com.inventory.model.Barang;
import com.inventory.model.BarangDAO;
import com.inventory.model.User;
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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        String action = request.getParameter("action");
        if (action == null) action = "list";

        // 🔐 BLOK VIEWER
        if (role.equals("viewer") &&
           (action.equals("new") || action.equals("edit") || action.equals("delete"))) {

            response.sendRedirect(request.getContextPath() + "/barang?action=list&error=akses");
            return;
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
            default:
                listBarang(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String role = user.getRole();

        String action = request.getParameter("action");

        // 🔐 BLOK VIEWER
        if (role.equals("viewer") &&
           ("insert".equals(action) || "update".equals(action))) {

            response.sendRedirect(request.getContextPath() + "/barang?action=list&error=akses");
            return;
        }

        if ("insert".equals(action)) {
            insertBarang(request, response);
        } else if ("update".equals(action)) {
            updateBarang(request, response);
        } else {
            listBarang(request, response);
        }
    }

    // ================= METHODS =================

    private void listBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("barangList", barangDAO.getAllBarang());
            request.getRequestDispatcher("/views/barang/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(500, e.getMessage());
        }
    }

    private void searchBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        try {
            request.setAttribute("barangList", barangDAO.searchBarang(keyword));
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/barang/list.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(500, e.getMessage());
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/barang/form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Barang barang = barangDAO.getBarangById(id);
        request.setAttribute("barang", barang);
        request.getRequestDispatcher("/views/barang/form.jsp").forward(request, response);
    }

    private void insertBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Barang barang = new Barang();
        barang.setNama(request.getParameter("nama"));
        barang.setKategori(request.getParameter("kategori"));
        barang.setUkuran(request.getParameter("ukuran"));
        barang.setWarna(request.getParameter("warna"));
        barang.setStok(Integer.parseInt(request.getParameter("stok")));
        barang.setHarga(new BigDecimal(request.getParameter("harga")));

        barangDAO.addBarang(barang);
        response.sendRedirect(request.getContextPath() + "/barang?action=list&success=add");
    }

    private void updateBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Barang barang = new Barang();
        barang.setId(Integer.parseInt(request.getParameter("id")));
        barang.setNama(request.getParameter("nama"));
        barang.setKategori(request.getParameter("kategori"));
        barang.setUkuran(request.getParameter("ukuran"));
        barang.setWarna(request.getParameter("warna"));
        barang.setStok(Integer.parseInt(request.getParameter("stok")));
        barang.setHarga(new BigDecimal(request.getParameter("harga")));

        barangDAO.updateBarang(barang);
        response.sendRedirect(request.getContextPath() + "/barang?action=list&success=update");
    }

    private void deleteBarang(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        barangDAO.deleteBarang(id);
        response.sendRedirect(request.getContextPath() + "/barang?action=list&success=delete");
    }
}
