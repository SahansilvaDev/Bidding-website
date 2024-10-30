package project.stock.web;

import project.stock.web.entity.Stock;
import project.stock.web.entity.User;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.sql.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

/*
* Read details from CSV
*
* */
public class Database {

    private static final String BD = "jdbc:mysql://localhost:3306/mini?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "1234";
    private static final String CSV_FILE = "P:\\Programming\\VPS\\.Mini\\CMP Mini project\\B\\BiddingApp\\src\\main\\resources\\static\\details.csv";
    private static SimpleDateFormat sdf;

    public static final int SUCCESSFULLY_BIDED = 1;
    public static final int INVALID_BID = 2;



    private static final HashMap<String, Integer> logins = new HashMap<>();

    private static Connection conn;

    private static long bidEnd = 0;

    public static void start(int end){
        load();
        bidEnd = new Date().getTime() + end * 1000L;
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }

    private static void load(){

        try {
            File file = new File(CSV_FILE);
            Scanner myReader = new Scanner(file);

            conn = DriverManager.getConnection(BD, DB_USER, DB_PASS);
            Statement statement = conn.createStatement();

            boolean first = true;
            while (myReader.hasNextLine()) {
                if (first) {
                    first = false;
                    myReader.nextLine();
                    continue;
                }

                String data = myReader.nextLine();
                String[] a = data.split(",");
                try{
                    String sql = "INSERT INTO stock (`code`, `name`, `price`, `security`, `profit`)\n" +
                            " VALUES (" +
                            "'"+a[0] +"'," +
                            "'"+a[1] +"'," +
                            a[2] +"," +
                            a[3] +"," +
                            a[4] +
                            ")";
                    statement.executeUpdate(sql);

                } catch (Exception ignored) {
                    ignored.printStackTrace();
                }

            }
            myReader.close();
        }
        catch (Exception ignored) {
        }
    }

//    Stock
    public static List<Stock> getStocks() {
        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select * from stock;");

            List<Stock> stocks = new ArrayList<>();
            while (results.next()) {
                String code = results.getString("code");
                String name = results.getString("name");
                double price = results.getDouble("price");
                int security = results.getInt("security");
                double profit = results.getInt("profit");

                Stock stock = new Stock(code, name, price, security, profit);
                stock.setLastBid(getHighestBid(stock));
                stocks.add(stock);
            }

            return stocks;
        } catch (SQLException throwables) {
            throwables.printStackTrace();
            return new ArrayList<>();
        }
    }
    public static Stock getStock(String code) {
        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select * from mini.stock WHERE stock.code='"+code+"';");

            if (results.next()) {
                String c = results.getString("code");
                String name = results.getString("name");
                double price = results.getDouble("price");
                int security = results.getInt("security");
                double profit = results.getInt("profit");

                return new Stock(c, name, price, security, profit);
            }

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return null;
    }
    public static double getHighestBid(Stock stock){
        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select MAX(`bid amount`) from bid WHERE `stock code`='"+stock.getCode()+"';");

            if (results.next()) {
                return results.getDouble(1);
            }

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        return 0.0;
    }
    public long getLastBidTime(Stock stock){
        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select MAX(`time`) from bid WHERE `stock code`='"+stock.getCode()+"';");

            if (results.next()) {

                String t = results.getString(1);
                return sdf.parse(t).getTime();
            }

        } catch (SQLException | ParseException throwables) {
            throwables.printStackTrace();
        }

        return 0;
    }

    public static String placeBid(Stock stock, double bid, Integer user){

        double current = getHighestBid(stock);

        if (current >= bid) return String.format("%s %s %.2f", "Invalid bid!", stock.getCode(), current);

        long now = new Date().getTime();
        if (bidEnd <= now){
            try{
                Statement statement = conn.createStatement();
                ResultSet results = statement.executeQuery("select MAX(`time`) " +
                        "from bid WHERE `stock code`='"+stock.getCode()+"';");

                if (results.next()) {
                    String a = results.getString(1);
                    System.out.println("Bid ends "+ a);

                    if (sdf.parse(a).getTime() + 60000L <= now){
                        return String.format("%s %s %.2f", "Invalid bid!", stock.getCode(), current);
                    }
                }

            } catch (SQLException | ParseException throwables) {
                throwables.printStackTrace();
                return String.format("%s %s %.2f", "Invalid bid!", stock.getCode(), current);
            }
        }

        try {

            PreparedStatement statement = conn.prepareStatement("insert into bid (`time`, `user id`, `stock code`, `bid amount`) values (?,?,?,?);");
            statement.setString(1, sdf.format(new Date()));
            statement.setInt(2, user);
            statement.setString(3, stock.getCode());
            statement.setDouble(4, bid);

            int r = statement.executeUpdate();
            if (r > 0) {
                notifyServer();
                return String.format("%s %s %.2f", "Successfully Bided!", stock.getCode(), bid);
            }

        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        return String.format("%s %s %.2f", "Invalid bid!", stock.getCode(), current);
    }

    private static void notifyServer(){
        try {
            URL url = new URL("http://localhost:2022/new");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            InputStream is = conn.getInputStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }



    public static boolean login(int user_id, String password, String session) {
        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select * from user WHERE id="+user_id+";");

            if (!results.next()) return false;
            String pw = results.getString("password");

            boolean success = pw.equals(password);

            if (success) logins.put(session, user_id);

            return success;
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        return false;
    }

    public static Integer getLogin(String session) {
        return logins.get(session);
    }

    public static boolean register(User user, String session) {

        try {
            Statement statement = conn.createStatement();
            ResultSet results = statement.executeQuery("select COUNT(*) from user WHERE id="+user.getId());

            if (results.next()){
                int count = results.getInt(1);
                System.out.println(count);
                if (count > 0) return false;
            }

            PreparedStatement stmt = conn.prepareStatement("insert into user (id, password, `time`)\n" +
                    "values (?,?,?);");
            stmt.setInt(1, user.getId());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, sdf.format(user.getRegistered()));
            int i = stmt.executeUpdate();

            if (i < 1){
                return false;
            }

            logins.put(session, user.getId());
            return true;

        }
        catch (SQLException throwables) {
            throwables.printStackTrace();
        }

        return false;

    }

    public static long getBidEnd() {
        return bidEnd;
    }

    public static void logout(String sessionID) {
        logins.remove(sessionID);
    }


}
