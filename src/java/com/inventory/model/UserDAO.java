package com.inventory.model;

import com.inventory.util.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserDAO {
    private static final Logger logger = Logger.getLogger(UserDAO.class.getName());
    
    // AUTHENTICATE USER
    public User authenticate(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = 1";
        
        System.out.println("AUTHENTICATE: " + username);
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setNamaLengkap(rs.getString("nama_lengkap"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setActive(rs.getBoolean("is_active"));
                
                System.out.println("User authenticated: " + user.getUsername() + " | Role: " + user.getRole());
            } else {
                System.out.println("Authentication failed for: " + username);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error during authentication", ex);
            System.err.println("SQL Error: " + ex.getMessage());
        }
        
        return user;
    }
    
    // CREATE
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, nama_lengkap, email, role, is_active) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getNamaLengkap());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isActive());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error adding user", ex);
            return false;
        }
    }
    
    // READ ALL
    public List<User> getAllUsers() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                userList.add(user);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting users", ex);
        }
        
        return userList;
    }
    
    // READ SINGLE
    public User getUserById(int id) {
        User user = null;
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting user by id", ex);
        }
        
        return user;
    }
    
    // READ SINGLE
    public User getUserByUsername(String username) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                user = extractUserFromResultSet(rs);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error getting user by username", ex);
        }
        
        return user;
    }
    
    // UPDATE
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username=?, nama_lengkap=?, email=?, role=?, is_active=? " +
                     "WHERE id=?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getNamaLengkap());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isActive());
            stmt.setInt(6, user.getId());
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error updating user", ex);
            return false;
        }
    }
    
    // UPDATE PASSWORD
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = MD5(?) WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPassword);
            stmt.setInt(2, userId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error updating password", ex);
            return false;
        }
    }
    
    // DELETE
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error deleting user", ex);
            return false;
        }
    }
    
    // CHECK USERNAME EXISTS
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error checking username", ex);
        }
        
        return false;
    }
    
    // SEARCH USERS
    public List<User> searchUsers(String keyword) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE username LIKE ? OR nama_lengkap LIKE ? OR email LIKE ? " +
                     "ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String likeKeyword = "%" + keyword + "%";
            stmt.setString(1, likeKeyword);
            stmt.setString(2, likeKeyword);
            stmt.setString(3, likeKeyword);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                userList.add(user);
            }
            
        } catch (SQLException ex) {
            logger.log(Level.SEVERE, "Error searching users", ex);
        }
        
        return userList;
    }
    
    // HELPER METHOD
    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setNamaLengkap(rs.getString("nama_lengkap"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setActive(rs.getBoolean("is_active"));
        return user;
    }
}