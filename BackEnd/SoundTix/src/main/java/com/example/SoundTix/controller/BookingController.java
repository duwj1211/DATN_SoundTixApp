package com.example.SoundTix.controller;

import com.example.SoundTix.dao.BookingSearch;
import com.example.SoundTix.model.Booking;
import com.example.SoundTix.pojo.BookingResponse;
import com.example.SoundTix.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/booking")
public class BookingController {
    @Autowired
    private BookingService bookingService;

    @PostMapping("/add")
    public Booking addBooking(@RequestBody Booking booking){
        return bookingService.addBooking(booking);
    }

    @GetMapping("/{bookingId}")
    public Optional<Booking> getBookingById(@PathVariable Integer bookingId){
        return bookingService.getBookingById(bookingId);
    }

    @PatchMapping("update/{bookingId}")
    public Booking updateBooking(@PathVariable Integer bookingId, @RequestBody Booking bookingDetails){
        return bookingService.updateBooking(bookingId, bookingDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllBookings(){
        bookingService.deleteAllBookings();
        return "All bookings have been deleted successfully.";
    }

    @DeleteMapping("/delete/{bookingId}")
    public void deleteBooking(@PathVariable Integer bookingId){
        bookingService.deleteBooking(bookingId);
    }

    @PostMapping("/search")
    public ResponseEntity<BookingResponse> searchBookings(
            @RequestBody(required = false) BookingSearch bookingSearch,
            Pageable pageable) {

        if (bookingSearch == null) {
            bookingSearch = new BookingSearch();
        }

        Page<Booking> bookingPage = bookingService.findBooking(bookingSearch, pageable);

        long totalBookings = bookingService.countFilteredBookings(bookingSearch);
        long pendingCount = bookingService.countByBookingStatus("Pending");
        long paidCount = bookingService.countByBookingStatus("Paid");
        long canceledCount = bookingService.countByBookingStatus("Canceled");
        long refundedCount = bookingService.countByBookingStatus("Refunded");

        BookingResponse response = new BookingResponse(
                bookingPage.getContent(),
                totalBookings,
                pendingCount,
                paidCount,
                canceledCount,
                refundedCount
        );

        return new ResponseEntity<>(response, HttpStatus.OK);

    }
}

