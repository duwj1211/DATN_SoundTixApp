package com.example.SoundTix.controller;

import com.example.SoundTix.dao.EventTypeSearch;
import com.example.SoundTix.model.EventType;
import com.example.SoundTix.pojo.EventTypeResponse;
import com.example.SoundTix.service.EventTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/event-type")
public class EventTypeController {
    @Autowired
    private EventTypeService eventTypeService;

    @PostMapping("/add")
    public EventType addEventType(@RequestBody EventType eventType){
        return eventTypeService.addEventType(eventType);
    }

    @GetMapping("/{eventTypeId}")
    public Optional<EventType> getEventTypeById(@PathVariable Integer eventTypeId){
        return eventTypeService.getEventTypeById(eventTypeId);
    }

    @PatchMapping("update/{eventTypeId}")
    public EventType updateEventType(@PathVariable Integer eventTypeId, @RequestBody EventType eventTypeDetails){
        return eventTypeService.updateEventType(eventTypeId, eventTypeDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllEventTypes(){
        eventTypeService.deleteAllEventTypes();
        return "All eventTypes have been deleted successfully.";
    }

    @DeleteMapping("/delete/{eventTypeId}")
    public void deleteEventType(@PathVariable Integer eventTypeId){
        eventTypeService.deleteEventType(eventTypeId);
    }

    @PostMapping("/search")
    public ResponseEntity<EventTypeResponse> searchEventTypes(
            @RequestBody(required = false) EventTypeSearch eventTypeSearch,
            Pageable pageable) {

        if (eventTypeSearch == null) {
            eventTypeSearch = new EventTypeSearch();
        }

        Page<EventType> eventTypePage = eventTypeService.findEventType(eventTypeSearch, pageable);

        long totalEventTypes = eventTypeService.countFilteredEventTypes(eventTypeSearch);

        EventTypeResponse response = new EventTypeResponse(
                eventTypePage.getContent(),
                totalEventTypes
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

