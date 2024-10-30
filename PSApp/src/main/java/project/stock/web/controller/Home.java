package project.stock.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.util.HtmlUtils;
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

    private final HttpServletRequest request;
    private final SimpMessageSendingOperations messagingTemplate;

    public Home(HttpServletRequest request, SimpMessageSendingOperations messagingTemplate) {
        this.request = request;
        this.messagingTemplate = messagingTemplate;
    }


    @RequestMapping(value = {"/", ""}, method = {RequestMethod.GET, RequestMethod.POST})
    public String getHome(Model model){

        Integer user = Database.getLogin(getSessionID());
        if (user == null) return "redirect:/login";

        List<Stock> stocks = Database.getStocks();

        model.addAttribute("stocks", stocks);
//        model.addAttribute("end", new SimpleDateFormat("MMM dd, yyyy HH:mm:ss").format(new Date(Database.getBidEnd())));
        model.addAttribute("user", user);

        return "homepage";
    }

    @RequestMapping(value = "/new")
    @ResponseBody
    public String newBid(){
        Database.onBidUpdate(messagingTemplate);
        return "0";
    }

    @RequestMapping(value = "/request", method = RequestMethod.GET)
    @ResponseBody
    public String request(
            @RequestParam(name = "request") String request,
            @RequestParam(name = "type") String type
            ){

        String[] a = request.split(" ");

        try {
            int user = Database.getLogin(getSessionID());

            if (type.equals("i")) {
//            Sub info
                StringBuilder r = new StringBuilder();
                for (int i = 1; i < a.length; i++) {
                    r.append(Database.subscribe(a[i], user, false));
                }
                return r.toString();

            }
            if (type.equals("b")) {
//            Sub bid
                StringBuilder r = new StringBuilder();
                for (int i = 1; i < a.length; i++) {
                    r.append(Database.subscribe(a[i], user, true));
                }
                return r.toString();


            }
            if (type.equals("p")) {
//            Pub info
                int security = Integer.parseInt(a[a.length - 1]);
                String code = a[1];
                StringBuilder info = new StringBuilder();
                for (int i = 2; i < a.length - 1; i++) {
                    info.append(a[i]).append(" ");
                }

                return Database.publish(code, user, info.toString(), security, messagingTemplate);

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "Unknown error occurred!";
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
