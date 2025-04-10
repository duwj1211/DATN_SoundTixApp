package com.example.SoundTix.service;

import com.example.SoundTix.dao.BookingSearch;
import com.example.SoundTix.model.Booking;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface BookingService {
    Booking addBooking(Booking booking);
    public long countAllBookings();
    public long countFilteredBookings(BookingSearch bookingSearch);
    public long countByBookingStatus(String bookingStatus);
    Optional<Booking> getBookingById(Integer bookingId);
    Booking updateBooking(Integer bookingId, Booking bookingDetails);
    void deleteAllBookings();
    void deleteBooking(Integer bookingId);
    Page<Booking> findBooking(BookingSearch bookingSearch, Pageable pageable);
}

