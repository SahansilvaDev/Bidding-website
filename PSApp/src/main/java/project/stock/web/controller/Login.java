package project.stock.web.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import project.stock.web.Database;
import project.stock.web.entity.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
public class Login {

    @Autowired(required=true)
    private HttpServletRequest request;

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String getLogin(){
        if (Database.getLogin(getSessionID()) != null){
            return "redirect:/";
        }

        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(
            @RequestParam(name = "id", defaultValue = "0") int id,
            @RequestParam(name = "password") String password,
            Model model){
        if (id == 0 || password == null){
            return "login";
        }

        boolean success = Database.login(id, password, getSessionID());

        if (success) return "redirect:/";

        return "login";

    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String register(

            @RequestParam(name = "password") String password,
            @RequestParam(name = "id" ) int id,
            Model model){

        try{
            User user = new User(id, password);
            boolean register = Database.register(user, getSessionID());
            if (register) return "redirect:/";

        } catch (Exception e) {
            e.printStackTrace();
        }


        model.addAttribute("username", id);
        model.addAttribute("password", password);

        return "login";
    }


    private String getSessionID(){
        HttpSession session = request.getSession(true);
        return session.getId();
    }


}
