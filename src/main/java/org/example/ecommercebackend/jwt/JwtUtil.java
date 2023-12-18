package org.example.ecommercebackend.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.example.ecommercebackend.entity.User;

import java.security.Key;
import java.util.Date;
import java.util.Set;



public class JwtUtil {
    private static final Key SECRET_KEY = loadSecretKey();

    private static Key loadSecretKey() {
        return Keys.secretKeyFor(SignatureAlgorithm.HS256);
    }

    public static String generateToken(User user){
        Date now = new Date();

        Set<String> roles = user.getRoles() != null ? Set.of(user.getRoles().getRole().getRole().name()) : Set.of();

        String jws = Jwts.builder()
                .setHeaderParam("typ", "JWT")
                .setSubject(user.getUsername())
                .claim("roles", roles)
                .setIssuedAt(now)
                .setExpiration(new Date(now.getTime() + 3600000))
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact();
        return jws;
    }

    public static Jws<Claims> parseToken(String token) {
        try {
            token = token.replace("Bearer ", "");
            return Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token);
        } catch (ExpiredJwtException e) {
            throw new RuntimeException("JWT token is expired", e);
        } catch (UnsupportedJwtException e) {
            throw new RuntimeException("JWT token is unsupported", e);
        } catch (MalformedJwtException e) {
            throw new RuntimeException("JWT token is malformed", e);
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse JWT token", e);
        }
    }

    public static boolean isTokenValid(String token) {
        try {
            parseToken(token);
            return true;
        } catch (RuntimeException e) {
            return false;
        }
    }
}
