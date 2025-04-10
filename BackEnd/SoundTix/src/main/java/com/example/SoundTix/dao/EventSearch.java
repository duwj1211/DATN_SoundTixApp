package com.example.SoundTix.dao;

import java.util.Date;

public class EventSearch {
    private String name;
    private String location;
    private String description;
    private Date dateTime;
    private String eventType;
    private String artist;
    private String ticket;
    private Integer interestedId;
    private boolean sortByDateTimeAsc;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDateTime() {
        return dateTime;
    }

    public void setDateTime(Date dateTime) {
        this.dateTime = dateTime;
    }

    public String getEventType() {
        return eventType;
    }

    public void setEventType(String eventType) {
        this.eventType = eventType;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getTicket() {
        return ticket;
    }

    public void setTicket(String ticket) {
        this.ticket = ticket;
    }

    public Integer getInterestedId() {
        return interestedId;
    }

    public void setInterestedId(Integer interestedId) {
        this.interestedId = interestedId;
    }

    public boolean isSortByDateTimeAsc() {
        return sortByDateTimeAsc;
    }

    public void setSortByDateTimeAsc(boolean sortByDateTimeAsc) {
        this.sortByDateTimeAsc = sortByDateTimeAsc;
    }
}
