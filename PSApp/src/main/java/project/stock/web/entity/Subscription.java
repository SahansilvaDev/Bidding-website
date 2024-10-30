package project.stock.web.entity;

public class Subscription {

    private int id;
    private int user_id;
    private String stock_code;
    private int type;

    public Subscription(int user_id, String stock_code, int type) {
        this.user_id = user_id;
        this.stock_code = stock_code;
        this.type = type;
    }

    public Subscription(int id, int user_id, String stock_code, int type) {
        this.id = id;
        this.user_id = user_id;
        this.stock_code = stock_code;
        this.type = type;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getStock_code() {
        return stock_code;
    }

    public void setStock_code(String stock_code) {
        this.stock_code = stock_code;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
}

