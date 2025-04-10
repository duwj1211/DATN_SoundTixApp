package com.example.SoundTix.repository;

import com.example.SoundTix.model.Payment;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Integer>, JpaSpecificationExecutor<Payment> {
    long count(Specification<Payment> specification);
    long countByPaymentStatus(String paymentStatus);
}
