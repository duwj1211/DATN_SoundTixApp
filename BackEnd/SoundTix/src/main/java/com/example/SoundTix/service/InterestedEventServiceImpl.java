package com.example.SoundTix.service;

import com.example.SoundTix.dao.InterestedEventSearch;
import com.example.SoundTix.model.*;
import com.example.SoundTix.repository.InterestedEventRepository;
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
public class InterestedEventServiceImpl implements InterestedEventService {
    @Autowired
    InterestedEventRepository interestedEventRepository;

    @Override
    public InterestedEvent addInterestedEvent(InterestedEvent interestedEvent) {
        return interestedEventRepository.save(interestedEvent);
    }

    public long countAllInterestedEvents() { return interestedEventRepository.count(); }

    @Override
    public long countFilteredInterestedEvents(InterestedEventSearch interestedEventSearch) {
        return interestedEventRepository.count(new Specification<InterestedEvent>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<InterestedEvent> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(interestedEventSearch.getUserId())) {
                    Join<InterestedEvent, User> userJoin = root.join("user");
                    predicates.add(criteriaBuilder.equal(userJoin.get("userId"), interestedEventSearch.getUserId()));
                }
                if (!ObjectUtils.isEmpty(interestedEventSearch.getEventId())) {
                    Join<InterestedEvent, Event> eventJoin = root.join("events");
                    predicates.add(criteriaBuilder.equal(eventJoin.get("eventId"), interestedEventSearch.getEventId()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    @Override
    public Optional<InterestedEvent> getInterestedEventById(Integer interestedId) {
        return interestedEventRepository.findById(interestedId);
    }

    @Override
    public InterestedEvent updateInterestedEvent(Integer interestedId, InterestedEvent interestedEventDetails) {
        Optional<InterestedEvent> interestedEvent = interestedEventRepository.findById(interestedId);
        if (interestedEvent.isPresent()) {
            InterestedEvent existingInterestedEvent = interestedEvent.get();
            return interestedEventRepository.save(existingInterestedEvent);
        }
        return null;
    }

    @Override
    public void deleteAllInterestedEvents() {
        interestedEventRepository.deleteAll();
    }

    @Override
    public void deleteInterestedEvent(Integer interestedId) {
        interestedEventRepository.deleteById(interestedId);
    }

    @Override
    public Page<InterestedEvent> findInterestedEvent(InterestedEventSearch interestedEventSearch, Pageable pageable){
        return interestedEventRepository.findAll(new Specification<InterestedEvent>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<InterestedEvent> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(interestedEventSearch.getUserId())) {
                    Join<InterestedEvent, User> userJoin = root.join("user");
                    predicates.add(criteriaBuilder.equal(userJoin.get("userId"), interestedEventSearch.getUserId()));
                }
                if (!ObjectUtils.isEmpty(interestedEventSearch.getEventId())) {
                    Join<InterestedEvent, Event> eventJoin = root.join("events");
                    predicates.add(criteriaBuilder.equal(eventJoin.get("eventId"), interestedEventSearch.getEventId()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}
