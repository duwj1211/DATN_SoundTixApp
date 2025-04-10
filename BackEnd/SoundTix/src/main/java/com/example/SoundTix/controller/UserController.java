package com.example.SoundTix.controller;

import com.example.SoundTix.dao.UserSearch;
import com.example.SoundTix.model.User;
import com.example.SoundTix.pojo.UserResponse;
import com.example.SoundTix.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping("/add")
    public User addUser(@RequestBody User user){
        return userService.addUser(user);
    }

    @GetMapping("/{userId}")
    public Optional<User> getUserById(@PathVariable Integer userId){
        return userService.getUserById(userId);
    }

    @PatchMapping("update/{userId}")
    public User updateUser(@PathVariable Integer userId, @RequestBody User userDetails){
        return userService.updateUser(userId, userDetails);
    }

    @DeleteMapping("/delete")
    public String deleteAllUsers(){
        userService.deleteAllUsers();
        return "All users have been deleted successfully.";
    }

    @DeleteMapping("/delete/{userId}")
    public void deleteUser(@PathVariable Integer userId){
        userService.deleteUser(userId);
    }

    @PostMapping("/search")
    public ResponseEntity<UserResponse> searchUsers(
            @RequestBody(required = false) UserSearch userSearch,
            Pageable pageable) {

        if (userSearch == null) {
            userSearch = new UserSearch();
        }

        Page<User> userPage = userService.findUser(userSearch, pageable);

        long totalUsers = userService.countFilteredUsers(userSearch);
        long adminCount = userService.countByRole("Administrator");
        long organizerCount = userService.countByRole("Organizer");
        long customerCount = userService.countByRole("Customer");
        long activeCount = userService.countByStatus("Active");
        long inactiveCount = userService.countByStatus("Inactive");

        UserResponse response = new UserResponse(
                userPage.getContent(),
                totalUsers,
                adminCount,
                organizerCount,
                customerCount,
                activeCount,
                inactiveCount
        );

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}

