package com.example.SoundTix.repository;

import com.example.SoundTix.model.Feedback;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Integer>, JpaSpecificationExecutor<Feedback> {
    long count(Specification<Feedback> specification);
    long countByStarCount(Integer starCount);
}
