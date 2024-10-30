<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bid</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.1/css/bootstrap.min.css" integrity="sha512-Ez0cGzNzHR1tYAv56860NLspgUGuQw16GiOOp/I2LuTmpSK9xDXlgJz3XN4cnpXWDmkNBKXR/VDMTCnAaEooxA=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.1/js/bootstrap.min.js" integrity="sha512-EKWWs1ZcA2ZY9lbLISPz8aGR2+L7JVYqBAYTq5AXgBkSjRSuQEGqWx8R1zAX16KdXPaCjOCaKE8MCpU0wcHlHA=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"
            integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.2/sockjs.min.js" integrity="sha512-2hPuJOZB0q6Eu4RlRRL2/8/MZ+IoSSxgDUu+eIUNzHOoHLUwf2xvrMFN4se9mu0qCgxIjHum6jdGk/uMiQoMpQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script>
        let stompClient = null;


        function connect() {
            let socket = new SockJS('/notification');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/notifications/${user}', function (greeting) {
                    alert(greeting.body);

                    let b = greeting.body.split(" ");
                    let a = document.getElementById("not-body-temp");
                    let m = "";

                    for (let i = 1; i < b.length; i++) {
                        m += " "+ b[i];
                    }
                    m.replaceAll('"', "");

                    a.innerHTML = "Stock: " + b[0] + " (" +new Date().toLocaleString() + ")<br/>" +
                        m;

                    let c = document.getElementById("not-temp").cloneNode(true);
                    c.style.display = "block";
                    document.getElementById("notifications")
                        .appendChild(c);

                });
            });
        }

        connect();
    </script>
</head>
<body>

<div class="container-fluid">

    <div class="row " style="background-color: black">
        <div class="col">
            <a class="btn float-end" href="/logout">
                <i class="fa fa-sign-out" style="color: white"></i>
            </a>
        </div>
    </div>

    <div class="row">

        <!--Stocks | New bid-->
        <div class="col-sm-8">
            <!--Stocks-->
            <div class="row">
                <div class="col">

                    <h3 class="text-center">Available stocks</h3>

                    <div class="px-2" style="overflow-y: scroll; overflow-x: hidden; height: 35vh">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th scope="col">Stock code</th>
                                <th scope="col">Stock name</th>
                                <th scope="col">Last bid</th>
                                <th scope="col">Profit</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${stocks}" var="stock">
                                <tr>
                                    <td>${stock.code}</td>
                                    <td>${stock.name}</td>
                                    <td>Rs. ${stock.lastBidTxt}</td>
                                    <td>Rs. ${stock.profit}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </div>
            </div>

            <div class="py-3"></div>

            <div class="nav nav-tabs">
                <div class="nav-item">
                    <button id="bsb" onclick="toggle('sb')" class="nav-link active" >Subscribe bids</button>
                </div>
                <div class="nav-item">
                    <button id="bsi" onclick="toggle('si')" class="nav-link">Subscribe information</button>
                </div>
                <div class="nav-item">
                    <button id="bpi" onclick="toggle('pi')" class="nav-link">Publish information</button>
                </div>
            </div>

            <div class="p-1"></div>
            <!--Subscribe bid-->
            <div id="sb" class="row">
                <div class="col">
                    <form class="card p-3">
                        <div class="card-header">
                            Subscribe for bids
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-sm-8">
                                    <div class="form-group">
                                        <label for="stock-code">Stock code:</label>
                                        <input type="text" class="form-control" id="stock-code" placeholder="Stock code">
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="py-2"></div>
                                    <button type="button" onclick="sub_for_bid()" class="btn btn-primary float-end">Subscribe</button>
                                </div>

                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!--Subscribe info-->
            <div id="si" class="row collapse">
                <div class="col">
                    <form class="card p-3">
                        <div class="card-header">
                            Subscribe for information
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-sm-8">
                                    <div class="form-group">
                                        <label for="stock-code">Stock code:</label>
                                        <input type="text" class="form-control" id="stock-code-info" placeholder="Stock code">
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="py-2"></div>
                                    <button type="button" onclick="sub_for_info()" class="btn btn-primary float-end">Subscribe</button>
                                </div>

                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!--Publish info-->
            <div id="pi" class="row collapse">
                <div class="col">
                    <form class="card p-3">
                        <div class="card-header">
                            Publish information
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="stock-code-publish">Stock code:</label>
                                        <input type="text" class="form-control" id="stock-code-publish" placeholder="Stock code">
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="security-code">Security code:</label>
                                        <input type="text" class="form-control" id="security-code" placeholder="Security code">
                                    </div>
                                </div>

                            </div>
                            <div class="row">
                                <div class="col-sm-10">
                                    <div class="form-group">
                                        <label for="info">Information:</label>
                                        <textarea class="form-control" id="info" placeholder="Information"></textarea>
                                    </div>
                                </div>
                                <div class="col-sm-2">
                                    <div class="py-3"></div>
                                    <button type="button" onclick="pub_info()" class="btn btn-primary float-end">Publish</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>



        </div>

        <!--Notifications-->
        <div class="col-sm-4">
            <h3>Notifications</h3>
            <hr class="col-sm-11 text-center"/>

            <div class="px-2" id="notifications" style="height: 70vh; overflow-x: hidden; overflow-y: scroll">
                <div id="not-temp" class="card" style="display: none">
                    <div id="not-body-temp" class="card-body ">
                        Stock: AAL
                        Bid was changed to 123
                    </div>
                </div>
            </div>

            <div class="py-1"></div>
            <!--Go to pub sub-->
            <div class="row">
                <div class="col">
                    <form class="card p-3">
                        <a class="btn btn-success" target="_blank" href="http://localhost:2021">
                            <i class="fa fa-arrow-right"></i>
                            Visit bidding page
                        </a>
                    </form>
                </div>
            </div>

        </div>

    </div>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"
        integrity="sha512-iKDtgDyTHjAitUDdLljGhenhPwrbBfqTKWO1mkhSFH3A7blITC9MhYon6SjnMhp4o0rADGw9yAC6EW4t5a4K3g=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.2/sockjs.min.js" integrity="sha512-2hPuJOZB0q6Eu4RlRRL2/8/MZ+IoSSxgDUu+eIUNzHOoHLUwf2xvrMFN4se9mu0qCgxIjHum6jdGk/uMiQoMpQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script type="text/javascript">
    var stompClient = null;

    function connect() {
        var socket = new SockJS('/hello');
        stompClient = Stomp.over(socket);
        stompClient.connect({}, function(frame) {
            console.log('Connected: ' + frame);

            stompClient.subscribe('/topic/notification/', function(messageOutput) {
                alert(messageOutput.body);
                showMessageOutput((messageOutput.body));
            });
            sendMsg("HHHHHH");
        });

    }
    function disconnect() {
        if(stompClient != null) {
            stompClient.disconnect();
        }
        console.log("Disconnected");
    }
    function sendMsg(text) {
        stompClient.send("/app/hello", {},
            text);
    }

    function showMessageOutput(messageOutput) {
        receive(messageOutput);
        // alert(messageOutput);
    }

    connect();
</script>

<script>
    let ids = ["sb", "si", "pi"];

    function toggle(id) {

        for (let i = 0; i < 3; i++) {
            let a = ids[i];
            document.getElementById(a).classList.remove("collapse");
            document.getElementById(a).classList.add("collapse");

            document.getElementById("b"+a).classList.remove("active");

        }

        document.getElementById(id).classList.remove("collapse");
        document.getElementById("b"+id).classList.add("active");


    }

    async function sub_for_bid() {
        // PUB AAL “Open Day on 3.4.2022” 74904

        let inp = document.getElementById("stock-code").value;

        let request = "SUB " +inp;
        let url = "/request?type=b&request=" + request;
        let response = await fetch(url);
        response.text().then(function (text) {
            alert(text);
        });


    }
    async function sub_for_info() {
        // PUB AAL “Open Day on 3.4.2022” 74904

        let inp = document.getElementById("stock-code-info").value;

        let request = "SUB " +inp;
        let url = "/request?type=i&request=" + encodeURIComponent(request);
        let response = await fetch(url);
        response.text().then(function (text) {
            alert(text);
        });


    }
    async function pub_info() {
        // PUB AAL “Open Day on 3.4.2022” 74904

        let code = document.getElementById("stock-code-publish").value;
        let security = document.getElementById("security-code").value;
        let info = document.getElementById("info").value;

        let request = "PUB " +code+ " \"" + info + "\" " + security;
        let url = "/request?type=p&request=" + encodeURIComponent(request);
        let response = await fetch(url);
        response.text().then(function (text) {
            alert(text);
        });


    }

</script>

</body>
</html>