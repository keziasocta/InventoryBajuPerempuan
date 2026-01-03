package com.inventory.model;

import com.inventory.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BarangDAO {
    private static final Logger logger = Logger.getLogger(BarangDAO.class.getName());
    
    // CREATE
    public boolean addBarang(Barang barang) {
        String sql = "INSERT INTO barang (nama, kategori, ukuran, warna, stok, harga) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, barang.getNama());
            stmt.setString(2, barang.getKategori());
            stmt.setString(3, barang.getUkuran());
            stmt.setString(4, barang.getWarna());
            stmt.setInt(5, barang.getStok());
            stmt.setBigDecimal(6, barang.getHarga());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error adding barang", ex);
            return false;
        }
    }
    
    // READ ALL
    public List<Barang> getAllBarang() {
        List<Barang> barangList = new ArrayList<>();
        String sql = "SELECT * FROM barang ORDER BY nama";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Barang barang = new Barang();
                barang.setId(rs.getInt("id"));
                barang.setNama(rs.getString("nama"));
                barang.setKategori(rs.getString("kategori"));
                barang.setUkuran(rs.getString("ukuran"));
                barang.setWarna(rs.getString("warna"));
                barang.setStok(rs.getInt("stok"));
                barang.setHarga(rs.getBigDecimal("harga"));
                
                barangList.add(barang);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting barang", ex);
        }
        
        return barangList;
    }
    
    // READ SINGLE
    public Barang getBarangById(int id) {
        Barang barang = null;
        String sql = "SELECT * FROM barang WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                barang = new Barang();
                barang.setId(rs.getInt("id"));
                barang.setNama(rs.getString("nama"));
                barang.setKategori(rs.getString("kategori"));
                barang.setUkuran(rs.getString("ukuran"));
                barang.setWarna(rs.getString("warna"));
                barang.setStok(rs.getInt("stok"));
                barang.setHarga(rs.getBigDecimal("harga"));
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting barang by id", ex);
        }
        
        return barang;
    }
    
    // UPDATE
    public boolean updateBarang(Barang barang) {
        String sql = "UPDATE barang SET nama=?, kategori=?, ukuran=?, warna=?, stok=?, harga=? " +
                     "WHERE id=?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, barang.getNama());
            stmt.setString(2, barang.getKategori());
            stmt.setString(3, barang.getUkuran());
            stmt.setString(4, barang.getWarna());
            stmt.setInt(5, barang.getStok());
            stmt.setBigDecimal(6, barang.getHarga());
            stmt.setInt(7, barang.getId());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error updating barang", ex);
            return false;
        }
    }
    
    // DELETE
    public boolean deleteBarang(int id) {
        String sql = "DELETE FROM barang WHERE id=?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error deleting barang", ex);
            return false;
        }
    }
    
    // SEARCH
    public List<Barang> searchBarang(String keyword) {
        List<Barang> barangList = new ArrayList<>();
        String sql = "SELECT * FROM barang WHERE nama LIKE ? OR kategori LIKE ? OR warna LIKE ? ORDER BY nama";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String likeKeyword = "%" + keyword + "%";
            stmt.setString(1, likeKeyword);
            stmt.setString(2, likeKeyword);
            stmt.setString(3, likeKeyword);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Barang barang = new Barang();
                barang.setId(rs.getInt("id"));
                barang.setNama(rs.getString("nama"));
                barang.setKategori(rs.getString("kategori"));
                barang.setUkuran(rs.getString("ukuran"));
                barang.setWarna(rs.getString("warna"));
                barang.setStok(rs.getInt("stok"));
                barang.setHarga(rs.getBigDecimal("harga"));
                
                barangList.add(barang);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error searching barang", ex);
        }
        
        return barangList;
    }
}