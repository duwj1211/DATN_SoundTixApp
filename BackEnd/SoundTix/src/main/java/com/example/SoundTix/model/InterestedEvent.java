package com.example.SoundTix.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.Date;
import java.util.List;

@Entity
@Table(name = "interested_event")
public class InterestedEvent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer interestedId;
    @Temporal(TemporalType.TIMESTAMP)
    private Date addedTime;
    @PrePersist
    protected void onCreate() {
        this.addedTime = new Date();
    }

    @ManyToOne
    @JoinColumn(name = "userId")
    @JsonIgnoreProperties("interestedEvents")
    private User user;

    @JsonIgnoreProperties("interestedEvents")
    @ManyToMany
    @JoinTable(
            name = "interestedEvent_event",
            joinColumns = @JoinColumn(name = "interestedId"),
            inverseJoinColumns = @JoinColumn(name = "eventId")
    )
    private List<Event> events;

    public Integer getInterestedId() {
        return interestedId;
    }

    public void setInterestedId(Integer interestedId) {
        this.interestedId = interestedId;
    }

    public Date getAddedTime() {
        return addedTime;
    }

    public void setAddedTime(Date addedTime) {
        this.addedTime = addedTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Event> getEvents() {
        return events;
    }

    public void setEvents(List<Event> events) {
        this.events = events;
    }
}
