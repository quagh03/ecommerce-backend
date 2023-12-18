package org.example.ecommercebackend.service;

import org.example.ecommercebackend.dto.UserDto;
import org.example.ecommercebackend.entity.User;

import java.util.List;
import java.util.UUID;

public interface UserService {
    List<User> getUserList();

    User getUserById(UUID id);

    User createUser(UserDto userToAdd);

}
