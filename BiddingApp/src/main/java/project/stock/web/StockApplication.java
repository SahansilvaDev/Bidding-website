package project.stock.web;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class StockApplication {

    public static void main(String[] args) {
        //Starting server
        Database.start(Integer.parseInt(args[0]));
        SpringApplication.run(StockApplication.class, args);
    }

}
