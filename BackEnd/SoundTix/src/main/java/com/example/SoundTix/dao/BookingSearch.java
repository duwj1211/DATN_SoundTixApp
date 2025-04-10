package com.example.SoundTix.dao;

public class BookingSearch {
    private String user;
    private String ticket;
    private Integer paymentId;
    private Integer startTotalPrice;
    private Integer endTotalPrice;
    private String bookingStatus;
    private String paymentMethod;
    private boolean sortByCreateAtAsc;

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getTicket() {
        return ticket;
    }

    public void setTicket(String ticket) {
        this.ticket = ticket;
    }

    public Integer getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Integer paymentId) {
        this.paymentId = paymentId;
    }

    public Integer getStartTotalPrice() {
        return startTotalPrice;
    }

    public void setStartTotalPrice(Integer startTotalPrice) {
        this.startTotalPrice = startTotalPrice;
    }

    public Integer getEndTotalPrice() {
        return endTotalPrice;
    }

    public void setEndTotalPrice(Integer endTotalPrice) {
        this.endTotalPrice = endTotalPrice;
    }

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public boolean isSortByCreateAtAsc() {
        return sortByCreateAtAsc;
    }

    public void setSortByCreateAtAsc(boolean sortByCreateAtAsc) {
        this.sortByCreateAtAsc = sortByCreateAtAsc;
    }
}

