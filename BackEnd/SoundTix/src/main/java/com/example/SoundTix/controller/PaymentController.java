package com.example.SoundTix.controller;

import com.example.SoundTix.dao.PaymentSearch;
import com.example.SoundTix.model.Payment;
import com.example.SoundTix.pojo.PaymentResponse;
import com.example.SoundTix.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/payment")
public class PaymentController {
    @Autowired
    private PaymentService paymentService;

    @PostMapping("/add")
    public Payment addPayment(@RequestBody Payment payment){
        return paymentService.addPayment(payment);
    }

    @GetMapping("/{paymentId}")
    public Optional<Payment> getPaymentById(@PathVariable Integer paymentId){
        return paymentService.getPaymentById(paymentId);
    }

    @PatchMapping("update/{paymentId}")
    public Payment updatePayment(@PathVariable Integer paymentId, @RequestBody Payment paymentDetails){
        return paymentService.updatePayment(paymentId, paymentDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllPayments(){
        paymentService.deleteAllPayments();
        return "All payments have been deleted successfully.";
    }

    @DeleteMapping("/delete/{paymentId}")
    public void deletePayment(@PathVariable Integer paymentId){
        paymentService.deletePayment(paymentId);
    }

    @PostMapping("/search")
    public ResponseEntity<PaymentResponse> searchPayments(
            @RequestBody(required = false) PaymentSearch paymentSearch,
            Pageable pageable) {

        if (paymentSearch == null) {
            paymentSearch = new PaymentSearch();
        }

        Page<Payment> paymentPage = paymentService.findPayment(paymentSearch, pageable);

        long totalPayments = paymentService.countFilteredPayments(paymentSearch);
        long pendingCount = paymentService.countByPaymentStatus("Pending");
        long successCount = paymentService.countByPaymentStatus("Success");
        long canceledCount = paymentService.countByPaymentStatus("Canceled");
        long failedCount = paymentService.countByPaymentStatus("Failed");
        PaymentResponse response = new PaymentResponse(
                paymentPage.getContent(),
                totalPayments,
                pendingCount,
                successCount,
                canceledCount,
                failedCount
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

