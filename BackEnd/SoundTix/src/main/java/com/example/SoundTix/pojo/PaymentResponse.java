package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Payment;

import java.util.List;

public class PaymentResponse {
    private List<Payment> content;
    private long totalItems;
    private long pendingCount;
    private long successCount;
    private long canceledCount;
    private long failedCount;

    public PaymentResponse(List<Payment> content, long totalItems, long pendingCount, long successCount, long canceledCount, long failedCount) {
        this.content = content;
        this.totalItems = totalItems;
        this.pendingCount = pendingCount;
        this.successCount = successCount;
        this.canceledCount = canceledCount;
        this.failedCount = failedCount;
    }

    public List<Payment> getContent() {
        return content;
    }

    public void setContent(List<Payment> content) {
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

    public long getSuccessCount() {
        return successCount;
    }

    public void setSuccessCount(long successCount) {
        this.successCount = successCount;
    }

    public long getCanceledCount() {
        return canceledCount;
    }

    public void setCanceledCount(long canceledCount) {
        this.canceledCount = canceledCount;
    }

    public long getFailedCount() {
        return failedCount;
    }

    public void setFailedCount(long failedCount) {
        this.failedCount = failedCount;
    }
}

