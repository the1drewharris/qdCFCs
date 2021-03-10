<?php

//replace this with your actual e-mail address
$email_to = "nobody@nobody.com";



if(!isset($_POST['Submit'])) {
    header('Location: index.php');
} else {
    //code to send the actual email
    $mail_subject = "New message from contact form:";
    $mail_body = "New message from: ".$_POST['firstname']." ".$_POST['lastname'] ;
    $mail_body.="\nE-mail address: ".$_POST['emailAddress'];
    $mail_body.="\nLives in ".$_POST['region'];
    $mail_body.="\nType of comment: ".$_POST['commentType'];
    $mail_body.="\nMessage: ".$_POST['comment'];
    
    mail($recipient,$mail_subject,$mail_body);
    echo "Thanks for contacting us!";
    echo "<p><a href='index.php'>Back to main page</a></p>";
}

?>
