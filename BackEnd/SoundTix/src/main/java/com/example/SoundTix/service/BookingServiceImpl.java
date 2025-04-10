package com.example.SoundTix.service;

import com.example.SoundTix.dao.BookingSearch;
import com.example.SoundTix.model.*;
import com.example.SoundTix.repository.BookingRepository;
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
public class BookingServiceImpl implements BookingService{
    @Autowired
    BookingRepository bookingRepository;
    @Autowired
    TicketRepository ticketRepository;

    @Override
    public Booking addBooking(Booking booking) {
        Set<Ticket> managedTickets = new HashSet<>();
        for (Ticket ticket : booking.getTickets()) {
            Ticket managedTicket = ticketRepository.findById(ticket.getTicketId())
                    .orElseThrow(() -> new RuntimeException("Ticket not found"));
            managedTicket.setBooking(booking);
            managedTickets.add(managedTicket);
        }
        booking.setTickets(managedTickets);
        return bookingRepository.save(booking);
    }

    public long countAllBookings() { return bookingRepository.count(); }

    @Override
    public long countFilteredBookings(BookingSearch bookingSearch) {
        return bookingRepository.count(new Specification<Booking>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Booking> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(bookingSearch.getUser())) {
                    Join<Booking, User> userJoin = root.join("user");
                    predicates.add(criteriaBuilder.like(userJoin.get("fullName"), "%" + bookingSearch.getUser()+ "%"));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getTicket())) {
                    Join<Booking, Ticket> ticketJoin = root.join("tickets");
                    predicates.add(criteriaBuilder.equal(ticketJoin.get("name"), bookingSearch.getTicket()));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getPaymentId())) {
                    Join<Booking, Payment> paymentJoin = root.join("payment");
                    predicates.add(criteriaBuilder.equal(paymentJoin.get("paymentId"), bookingSearch.getPaymentId()));
                }
                if (bookingSearch.getStartTotalPrice() != null && bookingSearch.getEndTotalPrice() != null) {
                    predicates.add(criteriaBuilder.between(root.get("totalPrice"), bookingSearch.getStartTotalPrice(), bookingSearch.getEndTotalPrice()));
                } else if (bookingSearch.getStartTotalPrice() != null) {
                    predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("totalPrice"), bookingSearch.getStartTotalPrice()));
                } else if (bookingSearch.getEndTotalPrice() != null) {
                    predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("totalPrice"), bookingSearch.getEndTotalPrice()));
                }
                if(!ObjectUtils.isEmpty(bookingSearch.getBookingStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("bookingStatus"), bookingSearch.getBookingStatus()));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getPaymentMethod())) {
                    Join<Booking, Payment> paymentJoin = root.join("payment");
                    predicates.add(criteriaBuilder.equal(paymentJoin.get("paymentMethod"), bookingSearch.getPaymentMethod()));
                }
                if (bookingSearch.isSortByCreateAtAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("createAt")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("createAt")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    public long countByBookingStatus(String bookingStatus) {
        return bookingRepository.countByBookingStatus(bookingStatus);
    }

    @Override
    public Optional<Booking> getBookingById(Integer bookingId) {
        return bookingRepository.findById(bookingId);
    }

    @Override
    public Booking updateBooking(Integer bookingId, Booking bookingDetails) {
        Optional<Booking> booking = bookingRepository.findById(bookingId);
        if (booking.isPresent()) {
            Booking existingBooking = booking.get();
            if (bookingDetails.getTotalPrice() != null) {
                existingBooking.setTotalPrice(bookingDetails.getTotalPrice());
            }
            if (bookingDetails.getBookingStatus() != null) {
                existingBooking.setBookingStatus(bookingDetails.getBookingStatus());
            }
            return bookingRepository.save(existingBooking);
        }
        return null;
    }

    @Override
    public void deleteAllBookings() {
        bookingRepository.deleteAll();
    }

    @Override
    public void deleteBooking(Integer bookingId) {
        bookingRepository.deleteById(bookingId);
    }

    @Override
    public Page<Booking> findBooking(BookingSearch bookingSearch, Pageable pageable){
        return bookingRepository.findAll(new Specification<Booking>() {
            @Override
            public Predicate toPredicate(Root<Booking> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(bookingSearch.getUser())) {
                    Join<Booking, User> userJoin = root.join("user");
                    predicates.add(criteriaBuilder.like(userJoin.get("fullName"), "%" + bookingSearch.getUser()+ "%"));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getTicket())) {
                    Join<Booking, Ticket> ticketJoin = root.join("tickets");
                    predicates.add(criteriaBuilder.equal(ticketJoin.get("name"), bookingSearch.getTicket()));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getPaymentId())) {
                    Join<Booking, Payment> paymentJoin = root.join("payment");
                    predicates.add(criteriaBuilder.equal(paymentJoin.get("paymentId"), bookingSearch.getPaymentId()));
                }
                if (bookingSearch.getStartTotalPrice() != null && bookingSearch.getEndTotalPrice() != null) {
                    predicates.add(criteriaBuilder.between(root.get("totalPrice"), bookingSearch.getStartTotalPrice(), bookingSearch.getEndTotalPrice()));
                } else if (bookingSearch.getStartTotalPrice() != null) {
                    predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("totalPrice"), bookingSearch.getStartTotalPrice()));
                } else if (bookingSearch.getEndTotalPrice() != null) {
                    predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("totalPrice"), bookingSearch.getEndTotalPrice()));
                }
                if(!ObjectUtils.isEmpty(bookingSearch.getBookingStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("bookingStatus"), bookingSearch.getBookingStatus()));
                }
                if (!ObjectUtils.isEmpty(bookingSearch.getPaymentMethod())) {
                    Join<Booking, Payment> paymentJoin = root.join("payment");
                    predicates.add(criteriaBuilder.equal(paymentJoin.get("paymentMethod"), bookingSearch.getPaymentMethod()));
                }
                if (bookingSearch.isSortByCreateAtAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("createAt")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("createAt")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

