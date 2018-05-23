<?php include 'database.php'; ?>
<!DOCTYPE html>
<html>

<head>
	<meta charset='UTF-8'>
	
	<title>Non-Responsive Table</title>
	
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">    
	<link rel="stylesheet" href="css/style2.css">
</head>
<?php
$query = "SELECT * FROM pembayaran where verified is NULL";
$result = $connect->query($query);
?>
<body>

	<div id="page-wrap">

    <h1>ADMIN</h1>
    <br>
	<table>
		<tr>
			<th>Username</th>
			<th>Email</th>
            <th>Image</th>
            <th>Action</th>
        </tr>
        <?php
		
            
            while($row = $result->fetch_array()){
                echo'<tr>';
                    echo '<td>'.$row['username'].'</td>';
                    echo '<td>'.$row['email'].'</td>';
                    echo '<td><img width="50" height="40" src="'.$row['file'].'"></td>';
                    echo '<td><a href="terima.php?username='.$row['username'].'"><button type="button" class="btn btn-primary">Terima</button></a>
                    <button type="button" class="btn btn-danger">Tolak</button>
                    </td>';
                echo'</tr>';
            }
            
            
        ?>
	</table>
	
	</div>
</body>

</html>
