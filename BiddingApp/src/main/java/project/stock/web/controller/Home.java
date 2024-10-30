package project.stock.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import project.stock.web.Database;
import project.stock.web.entity.Stock;
import project.stock.web.entity.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
public class Home {

    @Autowired(required=true)
    private HttpServletRequest request;

    @RequestMapping(value = {"/", ""}, method = {RequestMethod.GET, RequestMethod.POST})
    public String getHome(Model model){

        Integer user = Database.getLogin(getSessionID());
        if (user == null) return "redirect:/login";

        List<Stock> stocks = Database.getStocks();

        model.addAttribute("stocks", stocks);
        model.addAttribute("end", new SimpleDateFormat("MMM dd, yyyy HH:mm:ss").format(new Date(Database.getBidEnd())));


        return "homepage";
    }

    @RequestMapping(value = "/request", method = RequestMethod.GET)
    @ResponseBody
    public String place(
            @RequestParam(name = "request") String request
            ){

        String[] a = request.split(" ");

        Integer login = Database.getLogin(getSessionID());

        Stock stock = Database.getStock(a[0]);
        if (stock == null){
            return String.format("%s %s", "Invalid Stock Code!", a[0]);
        }

        try{
            double bid = Double.parseDouble(a[1]);
            return Database.placeBid(stock, bid, login);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return String.format("%s %s %s", "Invalid Bid!", stock.getCode(), a[1]);
    }


    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logOut() {
        if (Database.getLogin(getSessionID()) != null) {
            Database.logout(getSessionID());
        }

        return "redirect:/";
    }

    private String getSessionID(){
        HttpSession session = request.getSession(true);
        return session.getId();
    }

}
