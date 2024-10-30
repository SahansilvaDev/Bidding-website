<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.1/css/bootstrap.min.css" integrity="sha512-Ez0cGzNzHR1tYAv56860NLspgUGuQw16GiOOp/I2LuTmpSK9xDXlgJz3XN4cnpXWDmkNBKXR/VDMTCnAaEooxA=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.0.1/js/bootstrap.min.js" integrity="sha512-EKWWs1ZcA2ZY9lbLISPz8aGR2+L7JVYqBAYTq5AXgBkSjRSuQEGqWx8R1zAX16KdXPaCjOCaKE8MCpU0wcHlHA=="
          crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g=="
        crossorigin="anonymous" referrerpolicy="no-referrer" />
  <link rel="stylesheet" href="../../resources/login.css">

</head>
<body>

<div class="wrapper">
  <div class="logo">
    <img src="../../resources/img/logo.jpg" alt="logo">
  </div>
  <div class="text-center mt-4 name">
    Stock marketing app
  </div>
  <form id="login-form" class="p-3 mt-3" method="post" action="/login">
    <div class="form-field d-flex align-items-center">
      <span class="far fa-user"></span>
      <input type="number" min="1" name="id" id="userName" placeholder="User ID">

    </div>
    <div class="form-field d-flex align-items-center">
      <span class="fas fa-key"></span>
      <input type="password" name="password" id="pwd" placeholder="Password">
    </div>
    <button type="submit" id="login-txt" class="btn mt-3">Login</button>
    <div class="py-1"></div>
    <div class="form-check">
      <input id="cb" name="new user" onclick="new_user()" class="form-check-input" type="checkbox">
      <label class="form-check-label px-1" for="cb">I am a new user</label>
    </div>
  </form>
</div>

<script>
  let is_new = false;

  function new_user() {
    if (is_new){
      //Login

      document.getElementById("login-txt").innerText = "Login";
      document.title = "Login";
      document.getElementById("login-form").setAttribute("action", "/login");
    }else {
      document.getElementById("login-txt").innerText = "Register";
      document.title = "Register";
      document.getElementById("login-form").setAttribute("action", "/register");
    }

    is_new = !is_new;
  }

</script>

</body>
</html>