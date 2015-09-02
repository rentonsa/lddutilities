<!DOCTYPE html>
<html lang="en">
<head>
    <TITLE>DIU Photography Ordering System</TITLE>
    <link rel="stylesheet" type ="text/css" href="diustyles.css">
    <meta name="author" content="Library Online Editor">
    <meta name="description" content="Edinburgh University Library Online: Book purchase request forms for staff: Medicine and Veterinary">
    <meta name="distribution" content="global">
    <meta name="resource-type" content="document">
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</HEAD>
<BODY>
<div class = "central">
    <div class = "heading">
        <a href="index.html" title="Link to The DIU Web Area">
            <img src="images/header4.jpg" alt="The University of Edinburgh Image Collections" width="754" height="65" border="0" />
        </a>
        <h2>METADATA UPDATED</h2>
        <hr/>
    </div>
    <?php

    //STEP 1 Connect To Database
    include 'config/vars.php';
    $error = '';
    $link = mysql_connect($dbserver, $username, $password);
    @mysql_select_db($database) or die( "Unable to select database");



    $select_sql = "select r.id, r.image_id, r.type, r.value_text, c.name as collection from orders.CROWD r, orders.COLLECTION c, orders.IMAGE i where r.image_id = i.image_id and i.collection = c.id and r.status = 'A'  and r.game = 'A' order by r.image_id;";
    $select_result = mysql_query($select_sql) or die( "A MySQL error has occurred.<br />Your Query: " . $select_sql . "<br /> Error: (" . mysql_errno() . ") " . mysql_error());
    $select_count = mysql_numrows($select_result);

    echo $select_sql;
    $outfile = "output/art_tags.xml";
    $file_handle_out = fopen($outfile, "w")or die("can't open infile");

    fwrite($file_handle_out,"<recordset>\n");

    $p = 0;
    $collarray =array();
    $prev_id = 0;

    while ($p < $select_count)
    {
        fwrite($file_handle_out,"<record>\n");

       // $type = mysql_result($select_result, $p, 'type');
        $value_text = mysql_result($select_result, $p, 'value_text');
        $image_id = ltrim(mysql_result($select_result, $p, 'image_id'),0);
        $image_id = substr($image_id,0,5);
        $id = mysql_result($select_result, $p, 'id');

        $vernon_sys_sql = "select system_id from orders.ART_VERNON where image_id =".$image_id.";";
        $vernon_sys_result = mysql_query($vernon_sys_sql) or die( "A MySQL error has occurred.<br />Your Query: " . $vernon_sys_sql . "<br /> Error: (" . mysql_errno() . ") " . mysql_error());
        $vernon_sys_count = mysql_numrows($vernon_sys_result);
        $v = 0;
        while ($v < $vernon_sys_count)
        {
            $vernon_sys_id = mysql_result($vernon_sys_result, $v, 'system_id');
            $v++;
        }

        fwrite($file_handle_out, '<id>'.$vernon_sys_id."</id>\n");
        fwrite($file_handle_out, '<tag>'.$value_text."</tag>\n");


        $sql = "UPDATE orders.CROWD set status = 'C'  where id= '".$id."';";
        $result=mysql_query($sql) or die( "A MySQL error has occurred.<br />Your Query: " . $sql . "<br /> Error: (" . mysql_errno() . ") " . mysql_error());

       /* $value = $collection;

        if (!in_array($value, $collarray))
        {
            $collarray[] = $value;
        }
       */


        $prev_id = $image_id;
        $p++;
        fwrite($file_handle_out,"</record>\n");

    }
/*
    if ($keyword != '')
    {
        $keywordstring = $prev_id.','.'Keyword'.',"'.$keyword."\"\n";
        $keywordstring = str_replace(', "' ,'"', $keywordstring);
        fwrite($file_handle_out, $keywordstring);
        $keyword = '';
    }

    echo '<div class = "die"><p>METADATA IN FILE</p></div>';
    //construct and send e-mail to let the user know they're approved

    foreach ($collarray as $item )
    {
        $concatenated_message .= $item."\n";
    }


    $whoto = "scott.renton@ed.ac.uk";
    $email = "scott.renton@ed.ac.uk";
    $subject = "You have new metadata for these collections";

    mail( $email, $subject,$concatenated_message, "From: $whoto" );

*/

    fwrite($file_handle_out,"</recordset>\n");
    ?>


    <div class = "footer">
        <hr/>
        <p><a href="moderate.php">Back To Moderation Area</a></p>
        <p><a href="members.php">Back To Members' Area</a></p>
    </div>
</div>
</body>
</html>
