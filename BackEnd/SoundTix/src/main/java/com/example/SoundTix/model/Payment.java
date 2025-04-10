package com.example.SoundTix.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "payment")
@JsonIgnoreProperties("booking")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer paymentId;
    private String paymentMethod;
    private String paymentStatus;
    @Temporal(TemporalType.TIMESTAMP)
    private Date paymentTime;
    @Temporal(TemporalType.TIMESTAMP)
    private Date updatedPaymentTime;
    @PrePersist
    protected void onCreate() {
        this.paymentTime = new Date();
        this.updatedPaymentTime = new Date();
    }
    @PreUpdate
    protected void onUpdate() {
        this.updatedPaymentTime = new Date();
    }

    @OneToOne
    @JoinColumn(name = "bookingId")
    private Booking booking;

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }

    public Date getUpdatedPaymentTime() {
        return updatedPaymentTime;
    }

    public void setUpdatedPaymentTime(Date updatedPaymentTime) {
        this.updatedPaymentTime = updatedPaymentTime;
    }

    public Booking getBooking() {
        return booking;
    }

    public void setBooking(Booking booking) {
        this.booking = booking;
    }
}

