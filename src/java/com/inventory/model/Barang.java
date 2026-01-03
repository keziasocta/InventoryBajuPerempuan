package com.inventory.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Barang implements Serializable {
    private int id;
    private String nama;
    private String kategori;
    private String ukuran;
    private String warna;
    private int stok;
    private BigDecimal harga;
    
    // Constructor
    public Barang() {}
    
    public Barang(int id, String nama, String kategori, String ukuran, 
                  String warna, int stok, BigDecimal harga) {
        this.id = id;
        this.nama = nama;
        this.kategori = kategori;
        this.ukuran = ukuran;
        this.warna = warna;
        this.stok = stok;
        this.harga = harga;
    }
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }
    
    public String getKategori() { return kategori; }
    public void setKategori(String kategori) { this.kategori = kategori; }
    
    public String getUkuran() { return ukuran; }
    public void setUkuran(String ukuran) { this.ukuran = ukuran; }
    
    public String getWarna() { return warna; }
    public void setWarna(String warna) { this.warna = warna; }
    
    public int getStok() { return stok; }
    public void setStok(int stok) { this.stok = stok; }
    
    public BigDecimal getHarga() { return harga; }
    public void setHarga(BigDecimal harga) { this.harga = harga; }
    
    // Format harga untuk display
    public String getHargaFormatted() {
        return String.format("Rp %,d", harga.intValue());
    }
    
    // Cek stok rendah
    public boolean isStokRendah() {
        return stok < 10;
    }
}