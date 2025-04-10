package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Event;

import java.util.List;

public class EventResponse {
    private List<Event> content;
    private long totalItems;

    public EventResponse(List<Event> content, long totalItems) {
        this.content = content;
        this.totalItems = totalItems;
    }

    public List<Event> getContent() {
        return content;
    }

    public void setContent(List<Event> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
}
