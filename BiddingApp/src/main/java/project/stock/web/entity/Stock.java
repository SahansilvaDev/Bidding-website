package project.stock.web.entity;

public class Stock {

    private final String code;
    private final String name;
    private double price;
    private final int security;
    private double profit;

    private double lastBid;


    public Stock(String code, String name,
                 double price, int security, double profit) {
        this.code = code;
        this.name = name;
        this.price = price;
        this.security = security;
        this.profit = profit;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    public int getSecurity() {
        return security;
    }

    public double getProfit() {
        return profit;
    }

    public double getLastBid() {
        return lastBid;
    }
    public String getLastBidTxt() {
        return String.format("%.2f", lastBid);
    }

    public void setLastBid(double lastBid) {
        this.lastBid = lastBid;
    }
}
