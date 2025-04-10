package com.example.SoundTix.service;

import com.example.SoundTix.dao.TicketSearch;
import com.example.SoundTix.model.Ticket;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface TicketService {
    Ticket addTicket(Ticket ticket);
    public long countAllTickets();
    public long countFilteredTickets(TicketSearch ticketSearch);
    Optional<Ticket> getTicketById(Integer ticketId);
    Ticket updateTicket(Integer ticketId, Ticket ticketDetails);
    void deleteAllTickets();
    void deleteTicket(Integer ticketId);
    Page<Ticket> findTicket(TicketSearch ticketSearch, Pageable pageable);
}

