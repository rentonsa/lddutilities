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


    $select_sql = "select r.id, r.image_id, r.value_text, i.collection, r.game from orders.CROWD r, orders.COLLECTION c, orders.IMAGE i where r.image_id = i.image_id and i.collection = c.id and r.status in ('A', 'C') and r.game  in ('D', 'A', 'R') order by r.image_id;";
    $select_result = mysql_query($select_sql) or die( "A MySQL error has occurred.<br />Your Query: " . $select_sql . "<br /> Error: (" . mysql_errno() . ") " . mysql_error());
    $select_count = mysql_numrows($select_result);
    $outfile = "input/tagfile.txt";
    $file_handle_out = fopen($outfile, "w")or die("can't open outfile");
    //$researchfile = "output/sourcedResearch.csv";
    //$file_handle_res = fopen($researchfile, "w")or die("can't open resfile");
    //fwrite($file_handle_out,"workrecordid,field,value\n");
    //fwrite($file_handle_res,"workrecordid,field,value\n");
    $p = 0;
    $collarray =array();
    $prev_id = 0;

    while ($p < $select_count)
    {
        //$type = mysql_result($select_result, $p, 'type');
        $value_text = mysql_result($select_result, $p, 'value_text');
        $game = mysql_result($select_result, $p, 'game');
        $image_id = mysql_result($select_result, $p, 'image_id');
        $collection = mysql_result($select_result, $p, 'collection');
        $id = mysql_result($select_result, $p, 'id');
        /*
        switch ($type) {
            case 'subject_object':
                $subject_type = 'Subject Object';
                break;
            case 'subject_person':
                $subject_type = 'Subject Person';
                break;
            case 'subject_event':
                $subject_type = 'Subject Event';
                break;
            case 'subject_category':
                $subject_type = 'Subject Class';
                break;
            case 'subject_place':
                $subject_type = 'Subject Place';
                break;
            case 'subject_date':
                $subject_type = 'Subject Date';
                break;
            case 'creator':
                $subject_type = 'Creator';
                break;
            case 'transcription':
                $subject_type = 'Transcription';
                break;
            case 'translation':
                $subject_type = 'Translation';
                break;
            case 'date_research':
                $subject_type = 'Date';
                break;
            case 'production':
                $subject_type = 'Production';
                break;
        }
    */


        $image_id =(substr($image_id, 0,7));
        $value_text = (ucname($value_text));
        fwrite($file_handle_out, $image_id.';'.$value_text. ';'.$collection.";\n");


    /*
        $subjpos = strpos($subject_type, 'ubject');

        echo 'SUBJPOS'.$subjpos;
        if ($image_id != $prev_id and $keyword != '')
        {
            $keywordstring = $prev_id.','.'Keyword'.',"'.$keyword."\"\n";
            echo 'keybefore'.$keywordstring;
            $keywordstring = str_replace(', "' ,'"', $keywordstring);
            echo 'keyafter'.$keywordstring;
            fwrite($file_handle_out, $keywordstring);
            $keyword = '';
        }

        if ($subjpos !== false)
        {

            $keyword .= $value_text.', ';

        }
        else
        {
            fwrite($file_handle_res, $image_id.', '.$subject_type. ', "'.$value_text."\"\n");
        }
        echo 'IM'.$image_id.'PR'.$prev_id.'KY'.$keyword."\n";

*/

        $sql = "UPDATE orders.CROWD set status = 'L'  where id= '".$id."';";
        $result=mysql_query($sql) or die( "A MySQL error has occurred.<br />Your Query: " . $sql . "<br /> Error: (" . mysql_errno() . ") " . mysql_error());



      //  $prev_id = $image_id;
        $p++;

    }
/*
    if ($keyword != '')
    {
        $keywordstring = $prev_id.','.'Tag'.',"'.$keyword."\"\n";
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


    function ucname($string) {
        $string =ucwords(strtolower($string));

        foreach (array('-', '\'') as $delimiter) {
            if (strpos($string, $delimiter)!==false) {
                $string =implode($delimiter, array_map('ucfirst', explode($delimiter, $string)));
            }
        }
        return $string;
    }
    ?>


    <div class = "footer">
        <hr/>
        <p><a href="moderate.php">Back To Moderation Area</a></p>
        <p><a href="members.php">Back To Members' Area</a></p>
    </div>
</div>
</body>
</html>
