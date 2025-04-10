package com.example.SoundTix.controller;

import com.example.SoundTix.dao.EventSearch;
import com.example.SoundTix.model.Event;
import com.example.SoundTix.pojo.EventResponse;
import com.example.SoundTix.repository.EventRepository;
import com.example.SoundTix.service.EventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/event")
public class EventController {
    @Autowired
    private EventService eventService;

    @Autowired
    private EventRepository eventRepository;

    @PostMapping("/add")
    public Event addEvent(@RequestBody Event event){
        return eventService.addEvent(event);
    }

    @GetMapping("/{eventId}")
    public Optional<Event> getEventById(@PathVariable Integer eventId){
        return eventService.getEventById(eventId);
    }

    @PatchMapping("update/{eventId}")
    public Event updateEvent(@PathVariable Integer eventId, @RequestBody Event eventDetails){
        return eventService.updateEvent(eventId, eventDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllEvents(){
        eventService.deleteAllEvents();
        return "All events have been deleted successfully.";
    }

    @DeleteMapping("/delete/{eventId}")
    public void deleteEvent(@PathVariable Integer eventId){
        eventService.deleteEvent(eventId);
    }

    @PostMapping("/search")
    public ResponseEntity<EventResponse> searchEvents(
            @RequestBody(required = false) EventSearch eventSearch,
            Pageable pageable) {

        if (eventSearch == null) {
            eventSearch = new EventSearch();
        }

        Page<Event> eventPage = eventService.findEvent(eventSearch, pageable);

        long totalEvents = eventService.countFilteredEvents(eventSearch);

        EventResponse response = new EventResponse(
                eventPage.getContent(),
                totalEvents
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

