package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Artist;

import java.util.List;

public class ArtistResponse {
    private List<Artist> content;
    private long totalItems;

    public ArtistResponse(List<Artist> content, long totalItems) {
        this.content = content;
        this.totalItems = totalItems;
    }

    public List<Artist> getContent() {
        return content;
    }

    public void setContent(List<Artist> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
}

