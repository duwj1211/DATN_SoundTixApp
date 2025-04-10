package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Booking;

import java.util.List;

public class BookingResponse {
    private List<Booking> content;
    private long totalItems;
    private long pendingCount;
    private long paidCount;
    private long canceledCount;
    private long refundedCount;

    public BookingResponse(List<Booking> content, long totalItems, long pendingCount, long paidCount, long canceledCount, long refundedCount) {
        this.content = content;
        this.totalItems = totalItems;
        this.pendingCount = pendingCount;
        this.paidCount = paidCount;
        this.canceledCount = canceledCount;
        this.refundedCount = refundedCount;
    }

    public List<Booking> getContent() {
        return content;
    }

    public void setContent(List<Booking> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }

    public long getPendingCount() {
        return pendingCount;
    }

    public void setPendingCount(long pendingCount) {
        this.pendingCount = pendingCount;
    }

    public long getPaidCount() {
        return paidCount;
    }

    public void setPaidCount(long paidCount) {
        this.paidCount = paidCount;
    }

    public long getCanceledCount() {
        return canceledCount;
    }

    public void setCanceledCount(long canceledCount) {
        this.canceledCount = canceledCount;
    }

    public long getRefundedCount() {
        return refundedCount;
    }

    public void setRefundedCount(long refundedCount) {
        this.refundedCount = refundedCount;
    }
}

