package org.example.ecommercebackend.jsonapi;

import java.util.List;

public class JsonApiResponse<T> {
    private T data;

    public JsonApiResponse(T data) {
        this.data = data;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}