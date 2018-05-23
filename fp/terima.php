<?php include 'database.php'; ?>
<?php 
    $username = $_GET['username'];
	//print_r('1');
    // sql to delete a record
    $sql = "UPDATE pembayaran SET verified=1 WHERE username='$username'";
    if (mysqli_query($connect, $sql)) {
	//print_r('2');
	//$sel="SELECT * FROM pembayaran where username='$username'";
	//$user=mysqli_fetch_assoc(mysqli_query($connect,$sel));
	mysqli_close($connect);
        header('Location: admin.php');
        exit;
    } else {
        echo "Error deleting record";
    }
?>
