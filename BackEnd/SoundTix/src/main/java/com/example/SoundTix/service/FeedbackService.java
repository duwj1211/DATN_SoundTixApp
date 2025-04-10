package com.example.SoundTix.service;

import com.example.SoundTix.dao.FeedbackSearch;
import com.example.SoundTix.model.Feedback;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface FeedbackService {
    Feedback addFeedback(Feedback feedback);
    public long countAllFeedbacks();
    public long countFilteredFeedbacks(FeedbackSearch feedbackSearch);
    public long countByStarCount(Integer starCount);
    Optional<Feedback> getFeedbackById(Integer feedbackId);
    Feedback updateFeedback(Integer feedbackId, Feedback feedbackDetails);
    void deleteAllFeedbacks();
    void deleteFeedback(Integer feedbackId);
    Page<Feedback> findFeedback(FeedbackSearch feedbackSearch, Pageable pageable);
}

