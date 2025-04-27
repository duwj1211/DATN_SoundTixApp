package com.example.SoundTix.service;

import com.example.SoundTix.dao.EventSearch;
import com.example.SoundTix.model.*;
import com.example.SoundTix.repository.ArtistRepository;
import com.example.SoundTix.repository.EventRepository;
import com.example.SoundTix.repository.TicketRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.*;

@Service
public class EventServiceImpl implements EventService{
    @Autowired
    EventRepository eventRepository;

    @Autowired
    ArtistRepository artistRepository;

    @Autowired
    TicketRepository ticketRepository;

    @Override
    public Event addEvent(Event event) {
        return eventRepository.save(event);
    }

    public long countAllEvents() { return eventRepository.count(); }

    @Override
    public long countFilteredEvents(EventSearch eventSearch) {
        return eventRepository.count(new Specification<Event>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Event> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(eventSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + eventSearch.getName() + "%"));
                }
                if ("Others".equals(eventSearch.getLocation())) {
                    predicates.add(criteriaBuilder.notEqual(root.get("location"), "Hà Nội"));
                    predicates.add(criteriaBuilder.notEqual(root.get("location"), "Hồ Chí Minh"));
                    predicates.add(criteriaBuilder.notEqual(root.get("location"), "Đà Nẵng"));
                } else {
                    predicates.add(criteriaBuilder.equal(root.get("location"), eventSearch.getLocation()));
                }
                if(!ObjectUtils.isEmpty(eventSearch.getDescription())){
                    predicates.add(criteriaBuilder.like(root.get("description"), "%" + eventSearch.getDescription() + "%"));
                }
                if(!ObjectUtils.isEmpty(eventSearch.getDateTime())){
                    predicates.add(criteriaBuilder.equal(root.get("dateTime"), eventSearch.getDateTime()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getEventType())) {
                    predicates.add(criteriaBuilder.equal(root.get("eventType").get("type"), eventSearch.getEventType()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getArtist())) {
                    Join<Event, Artist> artistJoin = root.join("artists");
                    predicates.add(criteriaBuilder.equal(artistJoin.get("name"), eventSearch.getArtist()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getTicket())) {
                    Join<Event, Ticket> ticketJoin = root.join("tickets");
                    predicates.add(criteriaBuilder.equal(ticketJoin.get("name"), eventSearch.getTicket()));
                }
                if(!ObjectUtils.isEmpty(eventSearch.getOrganizer())){
                    predicates.add(criteriaBuilder.equal(root.get("organizer"),  eventSearch.getOrganizer()));
                }
                if (eventSearch.isSortByDateTimeAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("dateTime")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("dateTime")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }
    @Override
    public Optional<Event> getEventById(Integer eventId) {
        return eventRepository.findById(eventId);
    }

    @Override
    public Event updateEvent(Integer eventId, Event eventDetails) {
        Optional<Event> event = eventRepository.findById(eventId);
        if (event.isPresent()) {
            Event existingEvent = event.get();
            if (eventDetails.getName() != null) {
                existingEvent.setName(eventDetails.getName());
            }
            if (eventDetails.getDateTime() != null) {
                existingEvent.setDateTime(eventDetails.getDateTime());
            }
            if (eventDetails.getLocation() != null) {
                existingEvent.setLocation(eventDetails.getLocation());
            }
            if (eventDetails.getDescription() != null) {
                existingEvent.setDescription(eventDetails.getDescription());
            }
            if (eventDetails.getPath() != null) {
                existingEvent.setPath(eventDetails.getPath());
            }
            if (eventDetails.getOrganizer() != null) {
                existingEvent.setOrganizer(eventDetails.getOrganizer());
            }
            if (eventDetails.getOrganizerDescription() != null) {
                existingEvent.setOrganizerDescription(eventDetails.getOrganizerDescription());
            }
            if (eventDetails.getOrganizerAvatar() != null) {
                existingEvent.setOrganizerAvatar(eventDetails.getOrganizerAvatar());
            }
            if (eventDetails.getArtists() != null) {
                List<Artist> updatedArtists = new ArrayList<>();
                for (Artist artistDetail : eventDetails.getArtists()) {
                    Optional<Artist> artist = artistRepository.findById(artistDetail.getArtistId());
                    artist.ifPresent(updatedArtists::add);
                }
                existingEvent.setArtists(updatedArtists);
            }
            if (eventDetails.getTickets() != null) {
                Set<Ticket> updatedTickets = new HashSet<>();
                for (Ticket ticketDetail : eventDetails.getTickets()) {
                    Optional<Ticket> ticket = ticketRepository.findById(ticketDetail.getTicketId());
                    ticket.ifPresent(updatedTickets::add);
                }
                existingEvent.setTickets(updatedTickets);
            }
            if (eventDetails.getEventType() != null) {
                existingEvent.setEventType(eventDetails.getEventType());
            }

            return eventRepository.save(existingEvent);
        }
        return null;
    }

    @Override
    public void deleteAllEvents() {
        eventRepository.deleteAll();
    }

    @Override
    public void deleteEvent(Integer eventId) {
        eventRepository.deleteById(eventId);
    }

    @Override
    public Page<Event> findEvent(EventSearch eventSearch, Pageable pageable){
        return eventRepository.findAll(new Specification<Event>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Event> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(eventSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + eventSearch.getName() + "%"));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getLocation())) {
                    if ("Others".equals(eventSearch.getLocation())) {
                        predicates.add(criteriaBuilder.notEqual(root.get("location"), "Hà Nội"));
                        predicates.add(criteriaBuilder.notEqual(root.get("location"), "Đà Nẵng"));
                        predicates.add(criteriaBuilder.notEqual(root.get("location"), "Đà Lạt"));
                        predicates.add(criteriaBuilder.notEqual(root.get("location"), "Hồ Chí Minh"));
                    } else {
                        predicates.add(criteriaBuilder.equal(root.get("location"), eventSearch.getLocation()));
                    }
                }
                if(!ObjectUtils.isEmpty(eventSearch.getDescription())){
                    predicates.add(criteriaBuilder.like(root.get("description"), "%" + eventSearch.getDescription() + "%"));
                }
                if(!ObjectUtils.isEmpty(eventSearch.getDateTime())){
                    predicates.add(criteriaBuilder.equal(root.get("dateTime"), eventSearch.getDateTime()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getEventType())) {
                    predicates.add(criteriaBuilder.equal(root.get("eventType").get("type"), eventSearch.getEventType()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getArtist())) {
                    Join<Event, Artist> artistJoin = root.join("artists");
                    predicates.add(criteriaBuilder.equal(artistJoin.get("name"), eventSearch.getArtist()));
                }
                if (!ObjectUtils.isEmpty(eventSearch.getTicket())) {
                    Join<Event, Ticket> ticketJoin = root.join("tickets");
                    predicates.add(criteriaBuilder.equal(ticketJoin.get("name"), eventSearch.getTicket()));
                }
                if(!ObjectUtils.isEmpty(eventSearch.getOrganizer())){
                    predicates.add(criteriaBuilder.equal(root.get("organizer"),  eventSearch.getOrganizer()));
                }
                if (eventSearch.isSortByDateTimeAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("dateTime")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("dateTime")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

