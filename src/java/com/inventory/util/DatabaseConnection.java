package com.inventory.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    public static Connection getConnection() throws SQLException {
        // Ambil konfigurasi dari Environment Variable (Docker)
        // Jika tidak ada (null), pakai default (untuk test di laptop/XAMPP)
        
        String dbHost = System.getenv("DB_HOST");
        if (dbHost == null) dbHost = "localhost"; // Fallback ke localhost

        String dbPort = System.getenv("DB_PORT");
        if (dbPort == null) dbPort = "3306";

        String dbName = System.getenv("DB_NAME");
        if (dbName == null) dbName = "inventory_baju";

        String dbUser = System.getenv("DB_USER");
        if (dbUser == null) dbUser = "root";

        String dbPass = System.getenv("DB_PASSWORD");
        if (dbPass == null) dbPass = ""; 

        // Susun URL koneksi
        String url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            System.out.println("Mencoba koneksi ke: " + url);
            Connection conn = DriverManager.getConnection(url, dbUser, dbPass);
            System.out.println("Koneksi berhasil!");
            return conn;
            
        } catch (ClassNotFoundException e) {
            System.err.println("Driver MySQL tidak ditemukan!");
            throw new SQLException("Database driver not found", e);
        }
    }
}