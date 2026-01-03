package com.inventory.model;

import java.io.Serializable;
import java.util.Date;

public class User implements Serializable {
    private int id;
    private String username;
    private String password;
    private String namaLengkap;
    private String email;
    private String role;
    private Date createdAt;
    private boolean isActive;
    
    // Constructor
    public User() {}
    
    public User(int id, String username, String password, String namaLengkap, 
                String email, String role, Date createdAt, boolean isActive) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.namaLengkap = namaLengkap;
        this.email = email;
        this.role = role;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getNamaLengkap() { return namaLengkap; }
    public void setNamaLengkap(String namaLengkap) { this.namaLengkap = namaLengkap; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    // Helper methods
    public String getRoleDisplay() {
        switch (role) {
            case "admin": return "Administrator";
            case "staff": return "Staff";
            case "viewer": return "Viewer";
            default: return role;
        }
    }
    
    public String getStatusDisplay() {
        return isActive ? "Aktif" : "Nonaktif";
    }
    
    public String getStatusColor() {
        return isActive ? "green" : "red";
    }
}