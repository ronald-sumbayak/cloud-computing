<!DOCTYPE html>
<html lang="en" >

<head>
  <meta charset="UTF-8">
  <title>Form 1</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/5.0.0/normalize.min.css">

  <link rel='stylesheet prefetch' href='https://codepen.io/mariacheline/pen/zzbEXv?editors=0100'>

      <link rel="stylesheet" href="css/style.css">

  
</head>

<body>

  <div class="pagewrap">
  <form class="form" id="form" method="post" action="submit_form.php" enctype="multipart/form-data">
    <h3 class="form__title">Form Pendaftaran tekankata.com</h3>
    <div class="container">
      <input class="container__input" type="text" id="username" name="username" value="" required>
      <label id="userLabel" for="username" class="container__label">Username</label>
    </div>
    <div class="container">
      <input class="container__input" type="email" id="pass" name="email" value="" required>
      <label id="passLabel" for="pass" class="container__label">Email</label>
    </div>
    <div class="container">
      <input class="container__input" type="file" id="pass" name="file" value="" required>
      <label id="passLabel" for="pass" class="container__label">Bukti Pembayaran</label>
    </div>
    <button class="form__submit" id="submit" type="submit" value="submit">Submit</button>
  </form>
</div>
  <script src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
<script src='https://codepen.io/mariacheline/pen/zzbEXv?editors=0100'></script>

  

    <script  src="js/index.js"></script>




</body>

</html>
