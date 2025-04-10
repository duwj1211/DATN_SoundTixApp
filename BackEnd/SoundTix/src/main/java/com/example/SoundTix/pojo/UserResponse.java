package com.example.SoundTix.pojo;

import com.example.SoundTix.model.User;

import java.util.List;

public class UserResponse {
    private List<User> content;
    private long totalItems;
    private long administratorCount;
    private long organizerCount;
    private long customerCount;
    private long activeCount;
    private long inactiveCount;

    public UserResponse(List<User> content, long totalItems, long administratorCount,
                        long organizerCount, long customerCount, long activeCount, long inactiveCount) {
        this.content = content;
        this.totalItems = totalItems;
        this.administratorCount = administratorCount;
        this.organizerCount = organizerCount;
        this.customerCount = customerCount;
        this.activeCount = activeCount;
        this.inactiveCount = inactiveCount;
    }

    public List<User> getContent() {
        return content;
    }

    public void setContent(List<User> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }

    public long getAdministratorCount() {
        return administratorCount;
    }

    public void setAdministratorCount(long administratorCount) {
        this.administratorCount = administratorCount;
    }

    public long getOrganizerCount() {
        return organizerCount;
    }

    public void setOrganizerCount(long organizerCount) {
        this.organizerCount = organizerCount;
    }

    public long getCustomerCount() {
        return customerCount;
    }

    public void setCustomerCount(long customerCount) {
        this.customerCount = customerCount;
    }

    public long getActiveCount() {
        return activeCount;
    }

    public void setActiveCount(long activeCount) {
        this.activeCount = activeCount;
    }

    public long getInactiveCount() {
        return inactiveCount;
    }

    public void setInactiveCount(long inactiveCount) {
        this.inactiveCount = inactiveCount;
    }
}
