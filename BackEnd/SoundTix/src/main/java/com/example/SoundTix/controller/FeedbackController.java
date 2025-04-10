package com.example.SoundTix.controller;

import com.example.SoundTix.dao.FeedbackSearch;
import com.example.SoundTix.model.Feedback;
import com.example.SoundTix.pojo.FeedbackResponse;
import com.example.SoundTix.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/feedback")
public class FeedbackController {
    @Autowired
    private FeedbackService feedbackService;

    @PostMapping("/add")
    public Feedback addFeedback(@RequestBody Feedback feedback){
        return feedbackService.addFeedback(feedback);
    }

    @GetMapping("/{feedbackId}")
    public Optional<Feedback> getFeedbackById(@PathVariable Integer feedbackId){
        return feedbackService.getFeedbackById(feedbackId);
    }

    @PatchMapping("update/{feedbackId}")
    public Feedback updateFeedback(@PathVariable Integer feedbackId, @RequestBody Feedback feedbackDetails){
        return feedbackService.updateFeedback(feedbackId, feedbackDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllFeedbacks(){
        feedbackService.deleteAllFeedbacks();
        return "All feedbacks have been deleted successfully.";
    }

    @DeleteMapping("/delete/{feedbackId}")
    public void deleteFeedback(@PathVariable Integer feedbackId){
        feedbackService.deleteFeedback(feedbackId);
    }

    @PostMapping("/search")
    public ResponseEntity<FeedbackResponse> searchFeedbacks(
            @RequestBody(required = false) FeedbackSearch feedbackSearch,
            Pageable pageable) {

        if (feedbackSearch == null) {
            feedbackSearch = new FeedbackSearch();
        }

        Page<Feedback> feedbackPage = feedbackService.findFeedback(feedbackSearch, pageable);

        long totalFeedbacks = feedbackService.countFilteredFeedbacks(feedbackSearch);
        long oneStarCount = feedbackService.countByStarCount(1);
        long twoStarCount = feedbackService.countByStarCount(2);
        long threeStarCount = feedbackService.countByStarCount(3);
        long fourStarCount = feedbackService.countByStarCount(4);
        long fiveStarCount = feedbackService.countByStarCount(5);

        FeedbackResponse response = new FeedbackResponse(
                feedbackPage.getContent(),
                totalFeedbacks,
                oneStarCount,
                twoStarCount,
                threeStarCount,
                fourStarCount,
                fiveStarCount
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

