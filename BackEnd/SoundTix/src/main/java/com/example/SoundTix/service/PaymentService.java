package com.example.SoundTix.service;

import com.example.SoundTix.dao.PaymentSearch;
import com.example.SoundTix.model.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface PaymentService {
    Payment addPayment(Payment payment);
    public long countAllPayments();
    public long countFilteredPayments(PaymentSearch paymentSearch);
    public long countByPaymentStatus(String paymentStatus);
    Optional<Payment> getPaymentById(Integer paymentId);
    Payment updatePayment(Integer paymentId, Payment paymentDetails);
    void deleteAllPayments();
    void deletePayment(Integer paymentId);
    Page<Payment> findPayment(PaymentSearch paymentSearch, Pageable pageable);
}

