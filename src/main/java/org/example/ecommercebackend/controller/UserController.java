package org.example.ecommercebackend.controller;

import org.example.ecommercebackend.dto.UserDto;
import org.example.ecommercebackend.entity.User;
import org.example.ecommercebackend.jsonapi.JsonApiResponse;
import org.example.ecommercebackend.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;
import java.net.URI;


@RestController
@RequestMapping("/api")
public class UserController {
    @Autowired
    private UserService userService;

    //GET USER LIST
    @GetMapping("/v1/users")
    public ResponseEntity<?> getUserList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int limit
    ){
        List<User> userList = userService.getUserList();

        // Apply pagination
        int totalItems = userList.size();
        int totalPages = (int) Math.ceil((double) totalItems / limit);

        // Calculate start and end indexes based on page and limit
        int startIndex = (page - 1) * limit;
        int endIndex = Math.min(startIndex + limit, totalItems);
        List<User> paginatedList = userList.subList(startIndex, endIndex);

        // Create pagination headers
        HttpHeaders headers = new HttpHeaders();
        headers.add("Pagination-Total-Items", String.valueOf(totalItems));
        headers.add("Pagination-Total-Pages", String.valueOf(totalPages));
        headers.add("Pagination-Page", String.valueOf(page));
        headers.add("Pagination-Limit", String.valueOf(limit));

        // Create JSON:API response
        JsonApiResponse<List<User>> jsonResponse = new JsonApiResponse<>(paginatedList);

        // Add links for next and previous pages
        if (page < totalPages) {
            String nextPageUrl = "/users?page=" + (page + 1) + "&limit=" + limit;
            headers.add("Pagination-Next-Page", nextPageUrl);
        }
        if (page > 1) {
            String prevPageUrl = "/users?page=" + (page - 1) + "&limit=" + limit;
            headers.add("Pagination-Prev-Page", prevPageUrl);
        }

        return new ResponseEntity<>(jsonResponse, headers, HttpStatus.OK);
    }

    //GET USER BY ID
    @GetMapping("/v1/users/{id}")
    public ResponseEntity<JsonApiResponse<User>> getUserById(@PathVariable UUID id) {
        JsonApiResponse<User> response = new JsonApiResponse<>(userService.getUserById(id));
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    //ADD USER
    @PostMapping("/v1/users")
    public ResponseEntity<JsonApiResponse<User>> createUser(@RequestBody UserDto userDto){
        JsonApiResponse<User> response = new JsonApiResponse<>(userService.createUser(userDto));

        UUID createdUserId = response.getData().getId();
        URI location = URI.create("/api/v1/users/" + createdUserId);

        HttpHeaders headers = new HttpHeaders();
        headers.setLocation(location);

        return new ResponseEntity<>(response, headers, HttpStatus.CREATED);
    }

}
