<?php
$con = mysql_connect("localhost","root","010305");
if (!$con)
  {
  die('Could not connect: ' . mysql_error());
  }


$db_selected = mysql_select_db("feedback", $con);

if (!$db_selected)
  {
  die ("Can\'t use test_db : " . mysql_error());
  }
      $ro='mobile-tone';
 

mysql_query("INSERT INTO test (sellername) VALUES ('$ro')");




mysql_close($con);

?>