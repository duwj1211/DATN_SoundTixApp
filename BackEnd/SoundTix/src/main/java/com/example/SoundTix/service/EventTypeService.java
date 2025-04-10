package com.example.SoundTix.service;

import com.example.SoundTix.dao.EventTypeSearch;
import com.example.SoundTix.model.EventType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface EventTypeService {
    EventType addEventType(EventType eventType);
    public long countAllEventTypes();
    public long countFilteredEventTypes(EventTypeSearch eventTypeSearch);
    Optional<EventType> getEventTypeById(Integer eventTypeId);
    EventType updateEventType(Integer eventTypeId, EventType eventTypeDetails);
    void deleteAllEventTypes();
    void deleteEventType(Integer eventTypeId);
    Page<EventType> findEventType(EventTypeSearch eventTypeSearch, Pageable pageable);
}

