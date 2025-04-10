package com.example.SoundTix.pojo;

import com.example.SoundTix.model.EventType;

import java.util.List;

public class EventTypeResponse {
    private List<EventType> content;
    private long totalItems;

    public EventTypeResponse(List<EventType> content, long totalItems) {
        this.content = content;
        this.totalItems = totalItems;
    }

    public List<EventType> getContent() {
        return content;
    }

    public void setContent(List<EventType> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
}
