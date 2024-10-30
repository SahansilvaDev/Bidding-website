package project.stock.web.entity;

import java.util.Date;

public class User {

    private final int id;
    private final String password;
    private final Date registered;

    public User(int id, String password, Date registered) {
        this.id = id;
        this.password = password;
        this.registered = registered;
    }

    public User(int id, String password) {
        this.id = id;
        this.password = password;
        this.registered = new Date();
    }

    public int getId() {
        return id;
    }

    public String getPassword() {
        return password;
    }

    public Date getRegistered() {
        return registered;
    }
}
