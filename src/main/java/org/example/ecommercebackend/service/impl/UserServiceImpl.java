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
import java.time.Instant;
import java.util.*;
import java.util.function.Predicate;

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

        // Check if mobile or email or already exists
        boolean emailExists = userRepository.existsByEmail(userToAdd.getEmail());
        boolean usernameExists = userRepository.existsByUsername(userToAdd.getUsername());
        boolean mobileExists = userRepository.existsByMobile(userToAdd.getMobile());

        List<String> duplicateFields = new ArrayList<>();

        if (emailExists) duplicateFields.add("Email");
        if (usernameExists) duplicateFields.add("Username");
        if (mobileExists) duplicateFields.add("Mobile");

        if (!duplicateFields.isEmpty()) {
            throw new EntityExistsException(String.join(" and ", duplicateFields) + " already exist");
        }

        //Create user
        User newUser = new User();
        BeanUtils.copyProperties(userToAdd, newUser, "password");
        newUser.setPasswordHash(passwordEncoder.encode(userToAdd.getPassword()));
        newUser.setRegisteredAt(Timestamp.from(Instant.now()));

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

        List<ValidationCondition> validationConditions = Arrays.asList(
                new ValidationCondition(StringUtils::isEmpty, userDto.getFirstName(), "First name must not be null or empty"),
                new ValidationCondition(StringUtils::isEmpty, userDto.getLastName(), "Last name must not be null or empty"),
                new ValidationCondition(StringUtils::isEmpty, userDto.getUsername(), "Username must not be null or empty"),
                new ValidationCondition(StringUtils::isEmpty, userDto.getMobile(), "Mobile must not be null or empty"),
                new ValidationCondition(StringUtils::isEmpty, userDto.getEmail(), "Email must not be null or empty"),
                new ValidationCondition(StringUtils::isEmpty, userDto.getPassword(), "Password must not be null or empty")
        );

        for (ValidationCondition condition : validationConditions) {
            if (condition.isInvalid()) {
                throw new IllegalArgumentException(condition.errorMessage());
            }
        }
    }

    private record ValidationCondition(Predicate<String> validation, String value, String errorMessage) {

        public boolean isInvalid() {
                return validation.test(value);
            }
        }

}
