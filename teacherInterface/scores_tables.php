<html><style>.borders tr td {
   border: solid black 1px;
   padding-left: 5px;
   padding-right: 5px;
   text-align: right;
}
.borders tr:first-child, .borders tr td:first-child {
   font-weight: bold
}
.orange td {
   background-color: orange;
}
.yellow td {
   background-color: yellow;
}
.green td {
   background-color: lightgreen;
}
</style><body>

<?php

require_once("../shared/common.php");
require_once("commonAdmin.php");

function displayScores($contestIDs, $minForOrange, $minForGreen) {
   global $db;

   $query = "SELECT team.score, count(*) as nb, contestant.grade FROM contestant JOIN team ON team.ID = contestant.teamID JOIN `group` ON team.groupID = `group`.ID WHERE team.participationType = 'Official' AND contestID IN (".implode($contestIDs, ',').") AND contestant.grade > 0 GROUP BY contestant.grade, team.score";

   $stmt = $db->prepare($query);
   $stmt->execute();

   $grades = array(4 => "CM1", 5 => "CM2", 6 => "6ème", 7 => "5ème", 8 => "4ème", 9 => "3ème", 10 => "2nde", 11 => "1ère", 12 => "Terminale", 13 => "2nde<br/>pro", 14 => "1ère<br/>pro", 15 => "Terminale<br/>pro");
   $scores = array();

   $results = array();

   foreach($grades as $grade => $gradeName) {
      $results[$grade] = array();
   }

   $count = 0;
   $maxScore = 0;
   while ($row = $stmt->fetchObject()) {
      $scores[$row->score] = true;
      if ($row->score > $maxScore) {
         $maxScore = $row->score;
      }
      $results[$row->grade][$row->score] = $row->nb;
      $count++;
   }

   echo "<table class='borders' cellspacing=0>\n<tr><td>Score</td>";

   $gradeTotal = array();
   foreach ($grades as $grade => $gradeName) {
      echo "<td>".$gradeName."</td>";
      $gradeTotal[$grade] = 0;
   }
   echo "<td>Classement<br/>général</td></tr>\n";

   $rows = "";
   $allTotal = 0;
   for ($score = $maxScore; $score > 0; $score--) {
      $allTotalBefore = $allTotal;
      if (!isset($scores[$score])) {
         continue;
      }
      $class = "yellow";
      if ($score >= $minForOrange) {
         $class = "orange";
      }
      if ($score >= $minForGreen) {
         $class = "green";
      }
      $row = "<tr class='".$class."'><td>".$score."</td>";
      foreach ($grades as $grade => $gradeName) {
         $row .= "<td>";
         if (isset($results[$grade][$score])) {
            $row .= $gradeTotal[$grade] + 1;
            $gradeTotal[$grade] += $results[$grade][$score];
            $allTotal += $results[$grade][$score];
         } else {
            $row .= "&nbsp;";
         }
         $row .= "</td>";
      }
      $row .= "<td>".($allTotalBefore + 1)."</td>";
      $row .= "</tr>\n";
      $rows .= $row;
   }
   echo $rows;

   echo "<tr><td>Total</td>";
   foreach ($grades as $grade => $gradeName) {
      echo "<td>".$gradeTotal[$grade]."</td>";
   }
   echo "<td>".$allTotal."</tr>\n";


   echo "</table>\n";
}


/*
if (!isset($_SESSION["userID"])) {
   echo "Votre session a expiré, veuillez vous reconnecter.";
   exit;
}
*/


displayScores(array("283704875576424463", "423169985941254889", "989302451917244420"), 100, 200);

echo "<p>Catégorie orange :</p>";
displayScores(array("54582481688917144", "519967720615750538", "807333481808931576"), 0, 100);


?>
</body>
</html>