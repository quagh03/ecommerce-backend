package org.example.ecommercebackend.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.ecommercebackend.exception.GlobalExceptionHandler;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class JwtAuthenticationFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String token = request.getHeader("Authorization");

        if (token != null && JwtUtil.isTokenValid(token)) {
            try {
                Jws<Claims> jws = JwtUtil.parseToken(token);

                String username = jws.getBody().getSubject();
                List<String> roles = (List<String>) jws.getBody().get("roles");

                if (username != null && roles != null) {
                    List<SimpleGrantedAuthority> authorities = roles.stream()
                            .map(role -> {
                                logger.info("Role: " + role);
                                return new SimpleGrantedAuthority(role);
                            })
                            .collect(Collectors.toList());

                    UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(username, null, authorities);

                    if (authentication.isAuthenticated()) {
                        SecurityContextHolder.getContext().setAuthentication(authentication);
                        logger.info("authentication" + SecurityContextHolder.getContext());
                        logger.info("authentication" + authentication);
                        logger.info("User authenticated with username: " + username);
                        logger.info("User authenticated with roles: " + roles);
                    }
                }
            } catch (ExpiredJwtException e) {
                logger.warn("Token hết hạn: " + e.getMessage());
                GlobalExceptionHandler.handleExpiredJwtException(e);
            } catch (JwtException e) {
                logger.error("Lỗi xác thực token: " + e.getMessage());
                GlobalExceptionHandler.handleJwtException(e);
            }
        }

        filterChain.doFilter(request, response);
    }
}
