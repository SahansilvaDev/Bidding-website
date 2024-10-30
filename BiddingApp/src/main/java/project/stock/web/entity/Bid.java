package project.stock.web.entity;

import java.util.Date;

public class Bid {

    private int id;
    private Date time;
    private int user_id;
    private String stock_code;
    private double bid_amount;

    public Bid(int id, Date time, int user_id,
               String stock_code, double bid_amount) {
        this.id = id;
        this.time = time;
        this.user_id = user_id;
        this.stock_code = stock_code;
        this.bid_amount = bid_amount;
    }

    public Bid(Date time, int user_id, String stock_code, double bid_amount) {
        this.time = time;
        this.user_id = user_id;
        this.stock_code = stock_code;
        this.bid_amount = bid_amount;
    }

    public int getId() {
        return id;
    }

    public Date getTime() {
        return time;
    }

    public int getUser_id() {
        return user_id;
    }

    public String getStock_code() {
        return stock_code;
    }

    public double getBid_amount() {
        return bid_amount;
    }

    public void setId(int id) {
        this.id = id;
    }
}
