package com.example.SoundTix.service;

import com.example.SoundTix.dao.UserSearch;
import com.example.SoundTix.model.Booking;
import com.example.SoundTix.model.Feedback;
import com.example.SoundTix.model.User;
import com.example.SoundTix.repository.UserRepository;
import jakarta.persistence.criteria.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.util.ObjectUtils;

import java.util.*;

@Service
public class UserServiceImpl implements UserService{
    @Autowired
    private UserRepository userRepository;

    @Override
    public User addUser(User user) {
        return userRepository.save(user);
    }

    public long countAllUsers() { return userRepository.count(); }

    @Override
    public long countFilteredUsers(UserSearch userSearch) {
        return userRepository.count(new Specification<User>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(userSearch.getFullName())){
                    predicates.add(criteriaBuilder.like(root.get("fullName"), "%" + userSearch.getFullName() + "%"));
                }
                if(!ObjectUtils.isEmpty(userSearch.getEmail())){
                    predicates.add(criteriaBuilder.equal(root.get("email"), userSearch.getEmail()));
                }
                if(!ObjectUtils.isEmpty(userSearch.getRole())){
                    predicates.add(criteriaBuilder.equal(root.get("role"), userSearch.getRole()));
                }
                if(!ObjectUtils.isEmpty(userSearch.getStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("status"), userSearch.getStatus()));
                }
                if (!ObjectUtils.isEmpty(userSearch.getFeedbackId())) {
                    Join<User, Feedback> feedbackJoin = root.join("feedbacks");
                    predicates.add(criteriaBuilder.equal(feedbackJoin.get("feedbackId"), userSearch.getFeedbackId()));
                }
                if (!ObjectUtils.isEmpty(userSearch.getBookingId())) {
                    Join<User, Booking> bookingJoin = root.join("bookings");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), userSearch.getBookingId()));
                }
                if (userSearch.isFilterByCurrentMonth()) {
                    Date startOfCurrentMonth = getStartOfCurrentMonth();
                    Date endOfCurrentMonth = getEndOfCurrentMonth();
                    predicates.add(criteriaBuilder.between(root.get("dateAdded"), startOfCurrentMonth, endOfCurrentMonth));
                }
                if (userSearch.isFilterByPreviousMonth()) {
                    Date startOfPreviousMonth = getStartOfPreviousMonth();
                    Date endOfPreviousMonth = getEndOfPreviousMonth();
                    predicates.add(criteriaBuilder.between(root.get("dateAdded"), startOfPreviousMonth, endOfPreviousMonth));
                }
                if (userSearch.isSortByDateAddedAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("dateAdded")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("dateAdded")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        });
    }

    public long countByRole(String role) {
        return userRepository.countByRole(role);
    }

    public long countByStatus(String status) {
        return userRepository.countByStatus(status);
    }

    @Override
    public Optional<User> getUserById(Integer userId) {
        return userRepository.findById(userId);
    }

    @Override
    public User updateUser(Integer userId, User userDetails) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            User existingUser = user.get();

            if (userDetails.getUserName() != null) {
                existingUser.setUserName(userDetails.getUserName());
            }
            if (userDetails.getEmail() != null) {
                existingUser.setEmail(userDetails.getEmail());
            }
            if (userDetails.getPhoneNumber() != null) {
                existingUser.setPhoneNumber(userDetails.getPhoneNumber());
            }
            if (userDetails.getPassWord() != null) {
                existingUser.setPassWord(userDetails.getPassWord());
            }
            if (userDetails.getFullName() != null) {
                existingUser.setFullName(userDetails.getFullName());
            }
            if (userDetails.getRole() != null) {
                existingUser.setRole(userDetails.getRole());
            }
            if (userDetails.getBirthDay() != null) {
                existingUser.setBirthDay(userDetails.getBirthDay());
            }
            if (userDetails.getSex() != null) {
                existingUser.setSex(userDetails.getSex());
            }
            if (userDetails.getStatus() != null) {
                existingUser.setStatus(userDetails.getStatus());
            }
            if (userDetails.getAvatar() != null) {
                existingUser.setAvatar(userDetails.getAvatar());
            }
            if (userDetails.getQrCode() != null) {
                existingUser.setQrCode(userDetails.getQrCode());
            }
            return userRepository.save(existingUser);
        }
        return null;
    }

    @Override
    public void deleteAllUsers() {
        userRepository.deleteAll();
    }

    @Override
    public void deleteUser(Integer userId) {
        userRepository.deleteById(userId);
    }

    @Override
    public Page<User> findUser(UserSearch userSearch, Pageable pageable){
        return userRepository.findAll(new Specification<User>() {
            @Override
            public jakarta.persistence.criteria.Predicate toPredicate(Root<User> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
                List<jakarta.persistence.criteria.Predicate> predicates = new ArrayList<>();
                if(!ObjectUtils.isEmpty(userSearch.getFullName())){
                    predicates.add(criteriaBuilder.like(root.get("fullName"), "%" + userSearch.getFullName() + "%"));
                }
                if(!ObjectUtils.isEmpty(userSearch.getEmail())){
                    predicates.add(criteriaBuilder.equal(root.get("email"), userSearch.getEmail()));
                }
                if(!ObjectUtils.isEmpty(userSearch.getRole())){
                    predicates.add(criteriaBuilder.equal(root.get("role"), userSearch.getRole()));
                }
                if(!ObjectUtils.isEmpty(userSearch.getStatus())){
                    predicates.add(criteriaBuilder.equal(root.get("status"), userSearch.getStatus()));
                }
                if (!ObjectUtils.isEmpty(userSearch.getFeedbackId())) {
                    Join<User, Feedback> feedbackJoin = root.join("feedbacks");
                    predicates.add(criteriaBuilder.equal(feedbackJoin.get("feedbackId"), userSearch.getFeedbackId()));
                }
                if (!ObjectUtils.isEmpty(userSearch.getBookingId())) {
                    Join<User, Booking> bookingJoin = root.join("bookings");
                    predicates.add(criteriaBuilder.equal(bookingJoin.get("bookingId"), userSearch.getBookingId()));
                }
                if (userSearch.isFilterByCurrentMonth()) {
                    Date startOfCurrentMonth = getStartOfCurrentMonth();
                    Date endOfCurrentMonth = getEndOfCurrentMonth();
                    predicates.add(criteriaBuilder.between(root.get("dateAdded"), startOfCurrentMonth, endOfCurrentMonth));
                }
                if (userSearch.isFilterByPreviousMonth()) {
                    Date startOfPreviousMonth = getStartOfPreviousMonth();
                    Date endOfPreviousMonth = getEndOfPreviousMonth();
                    predicates.add(criteriaBuilder.between(root.get("dateAdded"), startOfPreviousMonth, endOfPreviousMonth));
                }
                if (userSearch.isSortByDateAddedAsc()) {
                    query.orderBy(criteriaBuilder.asc(root.get("dateAdded")));
                } else {
                    query.orderBy(criteriaBuilder.desc(root.get("dateAdded")));
                }
                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
            }
        }, pageable);
    }

    private Date getStartOfCurrentMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    private Date getEndOfCurrentMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        return calendar.getTime();
    }

    private Date getStartOfPreviousMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTime();
    }

    private Date getEndOfPreviousMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        return calendar.getTime();
    }
}

