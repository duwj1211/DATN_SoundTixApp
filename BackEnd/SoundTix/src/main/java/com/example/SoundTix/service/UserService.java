package com.example.SoundTix.service;

import com.example.SoundTix.dao.UserSearch;
import com.example.SoundTix.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.Optional;

public interface UserService {
    User addUser(User user);
    public long countAllUsers();
    public long countFilteredUsers(UserSearch userSearch);
    public long countByRole(String role);
    public long countByStatus(String status);
    Optional<User> getUserById(Integer userId);
    User updateUser(Integer userId, User userDetails);
    void deleteAllUsers();
    void deleteUser(Integer userId);
    Page<User> findUser(UserSearch userSearch, Pageable pageable);
}
