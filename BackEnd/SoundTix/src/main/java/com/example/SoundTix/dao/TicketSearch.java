package com.example.SoundTix.dao;

import com.example.SoundTix.model.Event;

public class TicketSearch {
    private String name;
    private Integer startPrice;
    private Integer endPrice;
    private Integer sold;
    private String detailInformation;
    private Event event;
    private Integer bookingId;
    private boolean sortByQuantityAvailableAsc;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getStartPrice() {
        return startPrice;
    }

    public void setStartPrice(Integer startPrice) {
        this.startPrice = startPrice;
    }

    public Integer getEndPrice() {
        return endPrice;
    }

    public void setEndPrice(Integer endPrice) {
        this.endPrice = endPrice;
    }

    public Integer getSold() {
        return sold;
    }
    public void setSold(Integer sold) {
        this.sold = sold;
    }
    public String getDetailInformation() {
        return detailInformation;
    }
    public void setDetailInformation(String detailInformation) {
        this.detailInformation = detailInformation;
    }

    public Event getEvent() {
        return event;
    }

    public void setEvent(Event event) {
        this.event = event;
    }

    public Integer getBookingId() {
        return bookingId;
    }

    public void setBookingId(Integer bookingId) {
        this.bookingId = bookingId;
    }

    public boolean isSortByQuantityAvailableAsc() {
        return sortByQuantityAvailableAsc;
    }

    public void setSortByQuantityAvailableAsc(boolean sortByQuantityAvailableAsc) {
        this.sortByQuantityAvailableAsc = sortByQuantityAvailableAsc;
    }
}

