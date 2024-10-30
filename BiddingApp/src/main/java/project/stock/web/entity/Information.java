package project.stock.web.entity;

public class Information {

    private int id;
    private int user;
    private String code;
    private String info;

    public Information(int id, int user, String code, String info) {
        this.id = id;
        this.user = user;
        this.code = code;
        this.info = info;
    }

    public Information(int user, String code, String info) {
        this.user = user;
        this.code = code;
        this.info = info;
    }

    public int getId() {
        return id;
    }

    public int getUser() {
        return user;
    }

    public String getCode() {
        return code;
    }

    public String getInfo() {
        return info;
    }
}

