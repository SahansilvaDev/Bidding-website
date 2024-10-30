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

                    <div style="overflow-y: scroll; overflow-x: hidden; height: 70vh">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th scope="col">Stock code</th>
                                <th scope="col">Stock name</th>
                                <th scope="col">Last bid</th>
                            </tr>
                            </thead>
                            <tbody>

                            <c:forEach items="${stocks}" var="stock">
                                <tr>
                                    <td>${stock.code}</td>
                                    <td>${stock.name}</td>
                                    <td>Rs. ${stock.lastBidTxt}</td>
                                </tr>
                            </c:forEach>

                            </tbody>
                        </table>
                    </div>

                </div>
            </div>

            <div class="py-2"></div>
            <!--New bid-->
            <div class="row">
                <div class="col">
                    <form class="card p-3">
                        <div class="row">
                            <div class="col-sm-5">
                                <div class="form-group">
                                    <label for="stock-code">Stock code:</label>
                                    <input type="text" class="form-control" id="stock-code" placeholder="Stock code">
                                </div>
                            </div>
                            <div class="col-sm-5">
                                <div class="form-group">
                                    <label for="new-bid">Your bid: (Rs.)</label>
                                    <input type="number" min="0" class="form-control" id="new-bid" placeholder="Your bid">
                                </div>
                            </div>
                            <div class="col-sm-2 ">
                                <div class="py-2"></div>
                                <button type="button" onclick="place()" class="btn btn-primary float-end">Bid</button>
                            </div>

                    </div>
                    </form>
                </div>
            </div>

        </div>

        <!--Notifications-->
        <div class="col-sm-4">
            <div class="py-5"></div>
            <h3>Biding will end at</h3>
            <hr class="col-sm-11 text-center"/>
            <h1 id="countdown" style="color: #0d6efd" class="text-center">Loading...</h1>


            <div class="py-5"></div>
            <!--Go to pub sub-->
            <div class="row">
                <div class="col">
                    <form class="card p-3">
                        <a class="btn btn-success" href="http://localhost:2022" target="_blank">
                            <i class="fa fa-arrow-right"></i>
                            Visit publisher subscriber page
                        </a>
                    </form>
                </div>
            </div>

        </div>

    </div>


</div>

<script>
<%--    May 15, 2022 23:37:25--%>
    let countDownDate = new Date("${end}").getTime();

    // Update the count down every 1 second
    let x = setInterval(function() {

        // Get today's date and time
        let now = new Date().getTime();

        // Find the distance between now and the count down date
        let distance = countDownDate - now;

        // Time calculations for days, hours, minutes and seconds
        // let days = Math.floor(distance / (1000 * 60 * 60 * 24));
        let hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        let seconds = Math.floor((distance % (1000 * 60)) / 1000);

        // Display the result in the element with id="demo"
        document.getElementById("countdown").innerText = hours + "h " + minutes + "m " + seconds + "s ";

        // If the count down is finished, write some text
        if (distance < 0) {
            clearInterval(x);
            document.getElementById("countdown").innerText = "Bidding was ended!";
        }
    }, 1000);

    async function place() {
        let code = document.getElementById("stock-code").value;
        let bid = document.getElementById("new-bid").value;

        if (code.length < 1) {
            alert("Empty code!")
            return;
        }

        if (bid.length < 1) {
            alert("Empty bid!")
            return;
        }

        let request = code + " " + bid;

        let url = "/request?request=" + request;
        let response = await fetch(url);
        response.text().then(function (text) {
            alert(text);
            window.location.reload();

        });


    }


</script>

</body>
</html>