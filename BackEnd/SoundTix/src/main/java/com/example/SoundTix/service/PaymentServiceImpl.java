package com.example.SoundTix.service;

import com.example.SoundTix.dao.PaymentSearch;
import com.example.SoundTix.model.Booking;
import com.example.SoundTix.model.Payment;
import com.example.SoundTix.repository.PaymentRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.*;

@Service
public class PaymentServiceImpl implements PaymentService {
    @Autowired
    PaymentRepository paymentRepository;

    @Override
    public Payment addPayment(Payment payment) {
        return paymentRepository.save(payment);
    }

    public long countAllPayments() { return paymentRepository.count(); }

    @Override
    public long countFilteredPayments(PaymentSearch paymentSearch) {
        return paymentRepository.count(new Specification<Payment>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Payment> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(paymentSearch.getBookingId())) {
                    Join<Payment, Booking> bookingJoin = root.join("booking");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), paymentSearch.getBookingId()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentMethod())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentMethod"), paymentSearch.getPaymentMethod()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentStatus"), paymentSearch.getPaymentStatus()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentTime())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentTime"), paymentSearch.getPaymentTime()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    public long countByPaymentStatus(String paymentStatus) {
        return paymentRepository.countByPaymentStatus(paymentStatus);
    }

    @Override
    public Optional<Payment> getPaymentById(Integer paymentId) {
        return paymentRepository.findById(paymentId);
    }

    @Override
    public Payment updatePayment(Integer paymentId, Payment paymentDetails) {
        Optional<Payment> payment = paymentRepository.findById(paymentId);
        if (payment.isPresent()) {
            Payment existingPayment = payment.get();
            if (paymentDetails.getPaymentMethod() != null) {
                existingPayment.setPaymentMethod(paymentDetails.getPaymentMethod());
            }
            if (paymentDetails.getPaymentStatus() != null) {
                existingPayment.setPaymentStatus(paymentDetails.getPaymentStatus());
            }
            return paymentRepository.save(existingPayment);
        }
        return null;
    }

    @Override
    public void deleteAllPayments() {
        paymentRepository.deleteAll();
    }

    @Override
    public void deletePayment(Integer paymentId) {
        paymentRepository.deleteById(paymentId);
    }

    @Override
    public Page<Payment> findPayment(PaymentSearch paymentSearch, Pageable pageable){
        return paymentRepository.findAll(new Specification<Payment>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Payment> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if (!ObjectUtils.isEmpty(paymentSearch.getBookingId())) {
                    Join<Payment, Booking> bookingJoin = root.join("booking");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), paymentSearch.getBookingId()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentMethod())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentMethod"), paymentSearch.getPaymentMethod()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentStatus"), paymentSearch.getPaymentStatus()));
                }
                if(!ObjectUtils.isEmpty(paymentSearch.getPaymentTime())){
                    predicates.add(criteriaBuilder.equal(root.get("paymentTime"), paymentSearch.getPaymentTime()));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

