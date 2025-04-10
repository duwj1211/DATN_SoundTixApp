package com.example.SoundTix.repository;

import com.example.SoundTix.model.Booking;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer>, JpaSpecificationExecutor<Booking> {
    long count(Specification<Booking> specification);
    long countByBookingStatus(String bookingStatus);
}
