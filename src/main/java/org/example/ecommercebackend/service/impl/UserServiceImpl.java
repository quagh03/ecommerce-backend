package org.example.ecommercebackend.service.impl;

import jakarta.persistence.EntityExistsException;
import jakarta.persistence.EntityNotFoundException;
import org.example.ecommercebackend.dto.UserDto;
import org.example.ecommercebackend.entity.User;
import org.example.ecommercebackend.repository.UserRepository;
import org.example.ecommercebackend.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;


    //GET USER LIST
    @Override
    public List<User> getUserList(){
        return Optional.of(userRepository.findAll())
                .filter(list -> !list.isEmpty())
                .orElseThrow(() -> new EntityNotFoundException("User list is empty"));
    }

    //GET USER BY ID
    @Override
    public User getUserById(UUID id){
        return userRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User with id: " + id + " NOT FOUND"));
    }


    @Override
    public User createUser(UserDto userToAdd){
        // Validate and process userDto
        validateUserDto(userToAdd);

        // Check if mobile or email already exists
        if (userRepository.existsByMobileOrEmailOrUsername(userToAdd.getMobile(), userToAdd.getEmail(), userToAdd.getUsername())) {
            throw new EntityExistsException("Mobile or email or username already exists");
        }

        User newUser = new User();
        BeanUtils.copyProperties(userToAdd, newUser, "password");
        newUser.setPasswordHash(passwordEncoder.encode(userToAdd.getPassword()));
        newUser.setRegisteredAt(new Timestamp(System.currentTimeMillis()));

        return userRepository.save(newUser);
    }

    @Override
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() ->  new EntityNotFoundException("User with username: " + username + " NOT FOUND"));
    }

    public void validateUserDto(UserDto userDto) {
        if (userDto == null) {
            throw new IllegalArgumentException("UserDto must not be null");
        }

        if (StringUtils.isEmpty(userDto.getFirstName())) {
            throw new IllegalArgumentException("First name must not be null or empty");
        }

        if (StringUtils.isEmpty(userDto.getLastName())) {
            throw new IllegalArgumentException("Last name must not be null or empty");
        }

        if (StringUtils.isEmpty(userDto.getUsername())) {
            throw new IllegalArgumentException("Username must not be null or empty");
        }

        if (StringUtils.isEmpty(userDto.getMobile())) {
            throw new IllegalArgumentException("Mobile must not be null or empty");
        }

        if (StringUtils.isEmpty(userDto.getEmail())) {
            throw new IllegalArgumentException("Email must not be null or empty");
        }

        if (StringUtils.isEmpty(userDto.getPassword())) {
            throw new IllegalArgumentException("Password must not be null or empty");
        }
    }
}
