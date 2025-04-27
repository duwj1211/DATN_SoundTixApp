package com.example.SoundTix.service;

import com.example.SoundTix.dao.TicketSearch;
import com.example.SoundTix.model.Booking;
import com.example.SoundTix.model.Ticket;
import com.example.SoundTix.repository.TicketRepository;
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
public class TicketServiceImpl implements TicketService{

    @Autowired
    private TicketRepository ticketRepository;

    @Override
    public Ticket addTicket(Ticket ticket) {
        return ticketRepository.save(ticket);
    }

    public long countAllTickets() { return ticketRepository.count(); }

    @Override
    public long countFilteredTickets(TicketSearch ticketSearch) {
        return ticketRepository.count(new Specification<Ticket>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Ticket> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(ticketSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + ticketSearch.getName() + "%"));
                }
                if (ticketSearch.getStartPrice() != null && ticketSearch.getEndPrice() != null) {
                    predicates.add(criteriaBuilder.between(root.get("price"), ticketSearch.getStartPrice(), ticketSearch.getEndPrice()));
                } else if (ticketSearch.getStartPrice() != null) {
                    predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("price"), ticketSearch.getStartPrice()));
                } else if (ticketSearch.getEndPrice() != null) {
                    predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("price"), ticketSearch.getEndPrice()));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getSold())){
                    predicates.add(criteriaBuilder.equal(root.get("sold"), ticketSearch.getSold()));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getDetailInformation())){
                    predicates.add(criteriaBuilder.like(root.get("detailInformation"), "%" + ticketSearch.getDetailInformation() + "%"));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getEvent())){
                    predicates.add(criteriaBuilder.equal(root.get("event"), ticketSearch.getEvent()));
                }
                if (!ObjectUtils.isEmpty(ticketSearch.getBookingId())) {
                    Join<Ticket, Booking> bookingJoin = root.join("booking");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), ticketSearch.getBookingId()));
                }
                if (ticketSearch.isSortByQuantityAvailableAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("quantityAvailable")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("quantityAvailable")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    @Override
    public Optional<Ticket> getTicketById(Integer ticketId) {
        return ticketRepository.findById(ticketId);
    }

    @Override
    public Ticket updateTicket(Integer ticketId, Ticket ticketDetails) {
        Optional<Ticket> ticket = ticketRepository.findById(ticketId);
        if (ticket.isPresent()) {
            Ticket existingTicket = ticket.get();
            if (ticketDetails.getName() != null) {
                existingTicket.setName(ticketDetails.getName());
            }
            if (ticketDetails.getPrice() != null) {
                existingTicket.setPrice(ticketDetails.getPrice());
            }
            if (ticketDetails.getQuantityAvailable() != null) {
                existingTicket.setQuantityAvailable(ticketDetails.getQuantityAvailable());
            }
            if (ticketDetails.getSold() != null) {
                existingTicket.setSold(ticketDetails.getSold());
            }
            if (ticketDetails.getDetailInformation() != null) {
                existingTicket.setDetailInformation(ticketDetails.getDetailInformation());
            }
            if (ticketDetails.getQrCode() != null) {
                existingTicket.setQrCode(ticketDetails.getQrCode());
            }

            return ticketRepository.save(existingTicket);
        }
        return null;
    }

    @Override
    public void deleteAllTickets() {
        ticketRepository.deleteAll();
    }

    @Override
    public void deleteTicket(Integer ticketId) {
        ticketRepository.deleteById(ticketId);
    }

    @Override
    public Page<Ticket> findTicket(TicketSearch ticketSearch, Pageable pageable){
        return ticketRepository.findAll(new Specification<Ticket>() {
            @Override
            public Predicate toPredicate(Root<Ticket> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(ticketSearch.getName())){
                    predicates.add(criteriaBuilder.like(root.get("name"), "%" + ticketSearch.getName() + "%"));
                }
                if (ticketSearch.getStartPrice() != null && ticketSearch.getEndPrice() != null) {
                    predicates.add(criteriaBuilder.between(root.get("price"), ticketSearch.getStartPrice(), ticketSearch.getEndPrice()));
                } else if (ticketSearch.getStartPrice() != null) {
                    predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("price"), ticketSearch.getStartPrice()));
                } else if (ticketSearch.getEndPrice() != null) {
                    predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("price"), ticketSearch.getEndPrice()));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getSold())){
                    predicates.add(criteriaBuilder.equal(root.get("sold"), ticketSearch.getSold()));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getDetailInformation())){
                    predicates.add(criteriaBuilder.like(root.get("detailInformation"), "%" + ticketSearch.getDetailInformation() + "%"));
                }
                if(!ObjectUtils.isEmpty(ticketSearch.getEvent())){
                    predicates.add(criteriaBuilder.equal(root.get("event"), ticketSearch.getEvent()));
                }
                if (!ObjectUtils.isEmpty(ticketSearch.getBookingId())) {
                    Join<Ticket, Booking> bookingJoin = root.join("booking");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), ticketSearch.getBookingId()));
                }
                if (ticketSearch.isSortByQuantityAvailableAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("quantityAvailable")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("quantityAvailable")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

