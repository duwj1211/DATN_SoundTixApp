package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Ticket;

import java.util.List;

public class TicketResponse {
    private List<Ticket> content;
    private long totalItems;

    public TicketResponse(List<Ticket> content, long totalItems) {
        this.content = content;
        this.totalItems = totalItems;
    }

    public List<Ticket> getContent() {
        return content;
    }

    public void setContent(List<Ticket> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
}

