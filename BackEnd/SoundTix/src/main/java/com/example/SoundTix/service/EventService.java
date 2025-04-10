package com.example.SoundTix.service;

import com.example.SoundTix.dao.EventSearch;
import com.example.SoundTix.model.Event;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface EventService {
    Event addEvent(Event event);
    public long countAllEvents();
    public long countFilteredEvents(EventSearch eventSearch);
    Optional<Event> getEventById(Integer eventId);
    Event updateEvent(Integer eventId, Event eventDetails);
    void deleteAllEvents();
    void deleteEvent(Integer eventId);
    Page<Event> findEvent(EventSearch eventSearch, Pageable pageable);
}

