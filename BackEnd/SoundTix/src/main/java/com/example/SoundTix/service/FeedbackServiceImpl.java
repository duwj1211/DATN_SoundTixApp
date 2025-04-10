package com.example.SoundTix.service;

import com.example.SoundTix.dao.FeedbackSearch;
import com.example.SoundTix.model.Feedback;
import com.example.SoundTix.repository.FeedbackRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class FeedbackServiceImpl implements FeedbackService{
    @Autowired
    private FeedbackRepository feedbackRepository;

    @Override
    public Feedback addFeedback(Feedback feedback) {
        return feedbackRepository.save(feedback);
    }

    public long countAllFeedbacks() { return feedbackRepository.count(); }

    @Override
    public long countFilteredFeedbacks(FeedbackSearch feedbackSearch) {
        return feedbackRepository.count(new Specification<Feedback>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<Feedback> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(feedbackSearch.getTitle())){
                    predicates.add(criteriaBuilder.like(root.get("title"), "%" + feedbackSearch.getTitle() + "%"));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getContent())){
                    predicates.add(criteriaBuilder.like(root.get("content"), "%" + feedbackSearch.getContent() + "%"));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getType())){
                    predicates.add(criteriaBuilder.equal(root.get("type"), feedbackSearch.getType()));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("status"), feedbackSearch.getStatus()));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getStarCount())){
                    predicates.add(criteriaBuilder.equal(root.get("starCount"), feedbackSearch.getStarCount()));
                }
                if (feedbackSearch.isFilterByTimeAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("feedbackTime")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("feedbackTime")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    public long countByStarCount(Integer starCount) {
        return feedbackRepository.countByStarCount(starCount);
    }

    @Override
    public Optional<Feedback> getFeedbackById(Integer feedbackId) {
        return feedbackRepository.findById(feedbackId);
    }

    @Override
    public Feedback updateFeedback(Integer feedbackId, Feedback feedbackDetails) {
        Optional<Feedback> feedback = feedbackRepository.findById(feedbackId);
        if (feedback.isPresent()) {
            Feedback existingFeedback = feedback.get();
            if (feedbackDetails.getTitle() != null) {
                existingFeedback.setTitle(feedbackDetails.getTitle());
            }
            if (feedbackDetails.getContent() != null) {
                existingFeedback.setContent(feedbackDetails.getContent());
            }
            if (feedbackDetails.getType() != null) {
                existingFeedback.setType(feedbackDetails.getType());
            }
            if (feedbackDetails.getStatus() != null) {
                existingFeedback.setStatus(feedbackDetails.getStatus());
            }
            if (feedbackDetails.getStarCount() != null) {
                existingFeedback.setStarCount(feedbackDetails.getStarCount());
            }
            if (feedbackDetails.getReply() != null) {
                existingFeedback.setReply(feedbackDetails.getReply());
            }
            if (feedbackDetails.getReaction() != null) {
                existingFeedback.setReaction(feedbackDetails.getReaction());
            }
            return feedbackRepository.save(existingFeedback);
        }
        return null;
    }

    @Override
    public void deleteAllFeedbacks() {
        feedbackRepository.deleteAll();
    }

    @Override
    public void deleteFeedback(Integer feedbackId) {
        feedbackRepository.deleteById(feedbackId);
    }

    @Override
    public Page<Feedback> findFeedback(FeedbackSearch feedbackSearch,Pageable pageable){
        return feedbackRepository.findAll(new Specification<Feedback>() {
            @Override
            public Predicate toPredicate(Root<Feedback> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(feedbackSearch.getTitle())){
                    predicates.add(criteriaBuilder.like(root.get("title"), "%" + feedbackSearch.getTitle() + "%"));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getContent())){
                    predicates.add(criteriaBuilder.like(root.get("content"), "%" + feedbackSearch.getContent() + "%"));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getType())){
                    predicates.add(criteriaBuilder.equal(root.get("type"), feedbackSearch.getType()));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("status"), feedbackSearch.getStatus()));
                }
                if(!ObjectUtils.isEmpty(feedbackSearch.getStarCount())){
                    predicates.add(criteriaBuilder.equal(root.get("starCount"), feedbackSearch.getStarCount()));
                }
                if (feedbackSearch.isFilterByTimeAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("feedbackTime")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("feedbackTime")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }
}

