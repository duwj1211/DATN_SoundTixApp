package com.example.SoundTix.dao;

public class UserSearch {
    private String fullName;
    private String email;
    private String role;
    private String status;
    private Integer feedbackId;
    private Integer bookingId;
    private boolean sortByDateAddedAsc;
    private boolean filterByCurrentMonth;
    private boolean filterByPreviousMonth;

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(Integer feedbackId) {
        this.feedbackId = feedbackId;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public boolean isSortByDateAddedAsc() {
        return sortByDateAddedAsc;
    }

    public void setSortByDateAddedAsc(boolean sortByDateAddedAsc) {
        this.sortByDateAddedAsc = sortByDateAddedAsc;
    }

    public boolean isFilterByCurrentMonth() {
        return filterByCurrentMonth;
    }

    public void setFilterByCurrentMonth(boolean filterByCurrentMonth) {
        this.filterByCurrentMonth = filterByCurrentMonth;
    }

    public boolean isFilterByPreviousMonth() {
        return filterByPreviousMonth;
    }

    public void setFilterByPreviousMonth(boolean filterByPreviousMonth) {
        this.filterByPreviousMonth = filterByPreviousMonth;
    }
}

