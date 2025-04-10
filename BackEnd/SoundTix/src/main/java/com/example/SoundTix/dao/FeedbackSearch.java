package com.example.SoundTix.dao;

import java.util.Date;

public class FeedbackSearch {
    private String title;
    private String content;
    private String type;
    private Date feedbackTime;
    private String status;
    private Integer starCount;
    private boolean filterByTimeAsc;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getFeedbackTime() {
        return feedbackTime;
    }

    public void setFeedbackTime(Date feedbackTime) {
        this.feedbackTime = feedbackTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getStarCount() {
        return starCount;
    }

    public void setStarCount(Integer starCount) {
        this.starCount = starCount;
    }

    public boolean isFilterByTimeAsc() {
        return filterByTimeAsc;
    }

    public void setFilterByTimeAsc(boolean filterByTimeAsc) {
        this.filterByTimeAsc = filterByTimeAsc;
    }
}

