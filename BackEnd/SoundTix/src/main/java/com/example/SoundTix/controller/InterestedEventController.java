package com.example.SoundTix.controller;

import com.example.SoundTix.dao.InterestedEventSearch;
import com.example.SoundTix.model.InterestedEvent;
import com.example.SoundTix.pojo.InterestedEventResponse;
import com.example.SoundTix.service.InterestedEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

@RestController
@RequestMapping("/interested-event")
public class InterestedEventController {
    @Autowired
    private InterestedEventService interestedEventService;

    @PostMapping("/add")
    public InterestedEvent addInterestedEvent(@RequestBody InterestedEvent interestedEvent){
        return interestedEventService.addInterestedEvent(interestedEvent);
    }

    @GetMapping("/{interestedId}")
    public Optional<InterestedEvent> getInterestedEventById(@PathVariable Integer interestedId){
        return interestedEventService.getInterestedEventById(interestedId);
    }

    @PatchMapping("update/{interestedId}")
    public InterestedEvent updateInterestedEvent(@PathVariable Integer interestedId, @RequestBody InterestedEvent interestedEventDetails){
        return interestedEventService.updateInterestedEvent(interestedId, interestedEventDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllInterestedEvents(){
        interestedEventService.deleteAllInterestedEvents();
        return "All interestedEvents have been deleted successfully.";
    }

    @DeleteMapping("/delete/{interestedId}")
    public void deleteInterestedEvent(@PathVariable Integer interestedId){
        interestedEventService.deleteInterestedEvent(interestedId);
    }

    @PostMapping("/search")
    public ResponseEntity<InterestedEventResponse> searchInterestedEvents(
            @RequestBody(required = false) InterestedEventSearch interestedEventSearch,
            Pageable pageable) {

        if (interestedEventSearch == null) {
            interestedEventSearch = new InterestedEventSearch();
        }

        Page<InterestedEvent> interestedEventPage = interestedEventService.findInterestedEvent(interestedEventSearch, pageable);

        long totalInterestedEvents = interestedEventService.countFilteredInterestedEvents(interestedEventSearch);

        InterestedEventResponse response = new InterestedEventResponse(
                interestedEventPage.getContent(),
                totalInterestedEvents
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

