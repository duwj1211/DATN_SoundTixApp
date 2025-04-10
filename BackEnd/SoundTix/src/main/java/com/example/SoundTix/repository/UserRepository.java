package com.example.SoundTix.repository;

import com.example.SoundTix.model.User;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer>, JpaSpecificationExecutor<User> {
    long count(Specification<User> specification);
    Optional<User> findByUserName(String userName);
    long countByRole(String role);
    long countByStatus(String status);
}