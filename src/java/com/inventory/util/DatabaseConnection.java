package com.inventory.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // SESUAIKAN DENGAN SETUP DATABASE ANDA!
    private static final String URL = "jdbc:mysql://localhost:3306/inventory_baju";
    private static final String USER = "root";  // default XAMPP: "root"
    private static final String PASSWORD = "";  // default XAMPP: kosong
    
    // Jika pakai MySQL standalone dengan password
    // private static final String PASSWORD = "password123";
    
    public static Connection getConnection() throws SQLException {
        try {
            // Untuk MySQL 8.x
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Untuk MySQL 5.x
            // Class.forName("com.mysql.jdbc.Driver");
            
            System.out.println("Mencoba koneksi ke: " + URL);
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Koneksi berhasil!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL tidak ditemukan!");
            throw new SQLException("Database driver not found", e);
        }
    }
}