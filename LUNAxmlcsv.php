<?php
/**
 * Created by PhpStorm.
 * User: srenton1
 * Date: 17/08/15
 * Time: 16:14
 */

$infile = 'input/Insight.xml';
$outfile = 'input/newXml.xml';

$myinfile = fopen($infile, "r") or die("Unable to open file!");
$myoutfile = fopen($outfile, "w") or die("Unable to open file!");
/*
while(!feof($myinfile)) {
 $line = fgets($myoutfile);
 if ((strpos($line, '?xml')> 0) or (strpos($line, 'record')> 0) or (strpos($line, 'field type')> 0))
 {
     if (strpos($line, 'field type')> 0)
     {
         $label = substr()
     }
 }
}
*/


$file = 'output/lunaUpload.csv';
include 'config/vars.php';
$link = mysql_connect($dbserver, $username, $password);
$xml_file = 'input/Insight.xml';
$xml = simplexml_load_file($xml_file);


foreach($xml->children() as $child)
{
    $j = 0;
    $k = 0;
    foreach($child->children() as $fieldGroup) {


        foreach($fieldGroup->children() as $node)
        {

                    $newdata = (string)$node[0];
                    $attr = $node->attributes();
                    $type = (string)$attr["type"];




                    $newarray[$j][0] = $type;
                    $newarray[$j][1] = $newdata;
                    $j++;

        }

    }
    print_r($newarray);
}



?>
