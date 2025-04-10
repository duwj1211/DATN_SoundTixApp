package com.example.SoundTix.pojo;

import com.example.SoundTix.model.InterestedEvent;

import java.util.List;

public class InterestedEventResponse {
    private List<InterestedEvent> content;
    private long totalItems;

    public InterestedEventResponse(List<InterestedEvent> content, long totalItems) {
        this.content = content;
        this.totalItems = totalItems;
    }

    public List<InterestedEvent> getContent() {
        return content;
    }

    public void setContent(List<InterestedEvent> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
}

