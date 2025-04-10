package com.example.SoundTix.pojo;

import com.example.SoundTix.model.Feedback;

import java.util.List;

public class FeedbackResponse {
    private List<Feedback> content;
    private long totalItems;
    private long oneStarCount;
    private long twoStarCount;
    private long threeStarCount;
    private long fourStarCount;
    private long fiveStarCount;

    public FeedbackResponse(List<Feedback> content, long totalItems, long oneStarCount, long twoStarCount, long threeStarCount, long fourStarCount, long fiveStarCount) {
        this.content = content;
        this.totalItems = totalItems;
        this.oneStarCount = oneStarCount;
        this.twoStarCount = twoStarCount;
        this.threeStarCount = threeStarCount;
        this.fourStarCount = fourStarCount;
        this.fiveStarCount = fiveStarCount;
    }

    public List<Feedback> getContent() {
        return content;
    }

    public void setContent(List<Feedback> content) {
        this.content = content;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }

    public long getOneStarCount() {
        return oneStarCount;
    }

    public void setOneStarCount(long oneStarCount) {
        this.oneStarCount = oneStarCount;
    }

    public long getTwoStarCount() {
        return twoStarCount;
    }

    public void setTwoStarCount(long twoStarCount) {
        this.twoStarCount = twoStarCount;
    }

    public long getThreeStarCount() {
        return threeStarCount;
    }

    public void setThreeStarCount(long threeStarCount) {
        this.threeStarCount = threeStarCount;
    }

    public long getFourStarCount() {
        return fourStarCount;
    }

    public void setFourStarCount(long fourStarCount) {
        this.fourStarCount = fourStarCount;
    }

    public long getFiveStarCount() {
        return fiveStarCount;
    }

    public void setFiveStarCount(long fiveStarCount) {
        this.fiveStarCount = fiveStarCount;
    }
}

