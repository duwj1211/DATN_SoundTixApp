package com.example.SoundTix.service;

import com.example.SoundTix.dao.InterestedEventSearch;
import com.example.SoundTix.dao.UserSearch;
import com.example.SoundTix.model.InterestedEvent;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface InterestedEventService {
    InterestedEvent addInterestedEvent(InterestedEvent interestedEvent);
    public long countAllInterestedEvents();
    public long countFilteredInterestedEvents(InterestedEventSearch interestedEventSearch);
    Optional<InterestedEvent> getInterestedEventById(Integer interestedId);
    InterestedEvent updateInterestedEvent(Integer interestedId, InterestedEvent interestedEventDetails);
    void deleteAllInterestedEvents();
    void deleteInterestedEvent(Integer interestedId);
    Page<InterestedEvent> findInterestedEvent(InterestedEventSearch interestedEventSearch, Pageable pageable);
}

