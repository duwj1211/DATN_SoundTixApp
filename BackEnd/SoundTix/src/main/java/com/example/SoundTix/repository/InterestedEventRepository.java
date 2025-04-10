package com.example.SoundTix.repository;

import com.example.SoundTix.model.InterestedEvent;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface InterestedEventRepository extends JpaRepository<InterestedEvent, Integer>, JpaSpecificationExecutor<InterestedEvent> {
    long count(Specification<InterestedEvent> specification);
}
