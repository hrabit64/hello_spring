package com.example.demo.config.auth.dto;

import com.example.demo.domain.user.User;
import lombok.Getter;

@Getter
public class SessionUser {
    private String name;
    private String email;
    private String picture;

    public SessionUser(User user){
        this.email = user.getEmail();
        this.name = user.getName();
        this.picture = user.getPicture();
    }
}
