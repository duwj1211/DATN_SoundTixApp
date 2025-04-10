package com.example.SoundTix.repository;

import com.example.SoundTix.model.EventType;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EventTypeRepository extends JpaRepository<EventType, Integer>, JpaSpecificationExecutor<EventType> {
    long count(Specification<EventType> specification);
}
