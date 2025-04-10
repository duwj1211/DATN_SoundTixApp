package com.example.SoundTix.service;

import com.example.SoundTix.dao.EventTypeSearch;
import com.example.SoundTix.model.Event;
import com.example.SoundTix.model.EventType;
import com.example.SoundTix.repository.EventTypeRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class EventTypeServiceImpl implements EventTypeService{
    @Autowired
    EventTypeRepository eventTypeRepository;

    @Override
    public EventType addEventType(EventType eventType) {
        return eventTypeRepository.save(eventType);
    }

    public long countAllEventTypes() { return eventTypeRepository.count(); }

    @Override
    public long countFilteredEventTypes(EventTypeSearch eventTypeSearch) {
        return eventTypeRepository.count(new Specification<EventType>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<EventType> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(eventTypeSearch.getType())){
                    predicates.add(criteriaBuilder.equal(root.get("type"), eventTypeSearch.getType()));
                }
                if (!ObjectUtils.isEmpty(eventTypeSearch.getEventId())) {
                    Join<EventType, Event> eventJoin = root.join("events", JoinType.INNER);
                    predicates.add(criteriaBuilder.equal(eventJoin.get("eventId"), eventTypeSearch.getEventId()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    @Override
    public Optional<EventType> getEventTypeById(Integer eventTypeId) {
        return eventTypeRepository.findById(eventTypeId);
    }

    @Override
    public EventType updateEventType(Integer eventTypeId, EventType eventTypeDetails) {
        Optional<EventType> eventType = eventTypeRepository.findById(eventTypeId);
        if (eventType.isPresent()) {
            EventType existingEventType = eventType.get();
            if (eventTypeDetails.getType() != null) {
                existingEventType.setType(eventTypeDetails.getType());
            }
            return eventTypeRepository.save(existingEventType);
        }
        return null;
    }

    @Override
    public void deleteAllEventTypes() {
        eventTypeRepository.deleteAll();
    }

    @Override
    public void deleteEventType(Integer eventTypeId) {
        eventTypeRepository.deleteById(eventTypeId);
    }

    @Override
    public Page<EventType> findEventType(EventTypeSearch eventTypeSearch, Pageable pageable){
        return eventTypeRepository.findAll(new Specification<EventType>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<EventType> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(eventTypeSearch.getType())){
                    predicates.add(criteriaBuilder.equal(root.get("type"), eventTypeSearch.getType()));
                }
                if (!ObjectUtils.isEmpty(eventTypeSearch.getEventId())) {
                    Join<EventType, Event> eventJoin = root.join("events", JoinType.INNER);
                    predicates.add(criteriaBuilder.equal(eventJoin.get("eventId"), eventTypeSearch.getEventId()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

