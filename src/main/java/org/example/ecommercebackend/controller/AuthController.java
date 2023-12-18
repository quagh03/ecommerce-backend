package org.example.ecommercebackend.controller;

import org.example.ecommercebackend.dto.LoginRequest;
import org.example.ecommercebackend.dto.UserDto;
import org.example.ecommercebackend.entity.User;
import org.example.ecommercebackend.jsonapi.JsonApiResponse;
import org.example.ecommercebackend.jwt.JwtUtil;
import org.example.ecommercebackend.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.net.URI;
import java.util.UUID;

@RestController
public class AuthController {
    @Autowired
    private UserService userService;

    //REGISTER
    @PostMapping("/v1/auth/register")
    public ResponseEntity<JsonApiResponse<User>> createUser(@RequestBody UserDto userDto){
        User createdUser = userService.createUser(userDto);

        JsonApiResponse<User> response = new JsonApiResponse<>(createdUser);

        UUID createdUserId = createdUser.getId();
        URI location = URI.create("/api/v1/users/" + createdUserId);

        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(location);

        return new ResponseEntity<>(response, headers, HttpStatus.CREATED);
    }

    //LOGIN
    @PostMapping("/v1/auth/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest loginRequest){
        User user = userService.getUserByUsername(loginRequest.getUsername());
        if(!new BCryptPasswordEncoder().matches(loginRequest.getPassword(), user.getPasswordHash())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Mật khẩu không chính xác");
        }
        String token = JwtUtil.generateToken(user);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        return new ResponseEntity<>("Đăng nhập thành công", headers, HttpStatus.OK);
    }

}
