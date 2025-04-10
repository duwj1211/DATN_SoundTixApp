package com.example.SoundTix.controller;

import com.example.SoundTix.dao.TicketSearch;
import com.example.SoundTix.model.Ticket;
import com.example.SoundTix.pojo.TicketResponse;
import com.example.SoundTix.service.TicketService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/ticket")
public class TicketController {
    @Autowired
    private TicketService ticketService;

    @PostMapping("/add")
    public Ticket addTicket(@RequestBody Ticket ticket){
        return ticketService.addTicket(ticket);
    }

    @GetMapping("/{ticketId}")
    public Optional<Ticket> getTicketById(@PathVariable Integer ticketId){
        return ticketService.getTicketById(ticketId);
    }

    @PatchMapping("update/{ticketId}")
    public Ticket updateTicket(@PathVariable Integer ticketId, @RequestBody Ticket userDetails){
        return ticketService.updateTicket(ticketId, userDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllTickets(){
        ticketService.deleteAllTickets();
        return "All tickets have been deleted successfully.";
    }

    @DeleteMapping("/delete/{ticketId}")
    public void deleteTicket(@PathVariable Integer ticketId){
        ticketService.deleteTicket(ticketId);
    }

    @PostMapping("/search")
    public ResponseEntity<TicketResponse> searchTickets(
            @RequestBody(required = false) TicketSearch ticketSearch,
            Pageable pageable) {

        if (ticketSearch == null) {
            ticketSearch = new TicketSearch();
        }

        Page<Ticket> ticketPage = ticketService.findTicket(ticketSearch, pageable);

        long totalTickets = ticketService.countFilteredTickets(ticketSearch);

        TicketResponse response = new TicketResponse(
                ticketPage.getContent(),
                totalTickets
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
