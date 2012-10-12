<?php

$sourceDir = "/Users/ligro/Projects/trunk/inc";
$grepDir = "/Users/ligro/Projects/trunk";
$sFileFunction = "/Users/ligro/function";
$sFileNotUsed = "/Users/ligro/function-not-used-trunk";
/*
 * first store all functions
 *
 * list dir foreach file grep function (.*)()
 *
 * stock it in file
 *
 * 2 grep -r all file to check if function is used.
 *
 */


function listDir($sDir, $rOutput)
{
echo "\nlist directory: ".$sDir."\n";
	$rDir = opendir($sDir);

	while ($sFile = readdir($rDir))
	{
		if ($sFile[0] != '.')
		{
            $sFile = $sDir."/".$sFile;
			if (is_file($sFile))
			{
                $ext = substr($sFile, strrpos($sFile, '.') - strlen($sFile));
                if (in_array($ext, array('.php', '.phtml'))) {
                    parseFile($sFile, $rOutput);
                }
			}
			else if (is_dir($sFile))
			{
				listDir($sFile, $rOutput);
			}
			else
			{
				echo "ERROR on file ".$sFile."\n";
			}
		}
	}
}

function parseFile($sFile, $rOutput)
{
	echo "parse the file: ".$sFile."\n";
	$rFile = fopen($sFile, "r");
	while ($sLine = fgets($rFile))
	{
		if (preg_match_all("/function +([a-zA-Z0-9_-]*)\(/", $sLine, $aMatches))
		{
			echo "find function: ".$aMatches[1][0]."\n";
			fputs($rOutput, $sFile.":".$aMatches[1][0]."\n");
		}
	}
}

$rOutput = fopen($sFileFunction, "w");
listDir($sourceDir, $rOutput);
fclose($rOutput);

/*
 * foreach fonction make a grep
 *
 */

$rFunctions = fopen($sFileFunction, "r");
$rOutput = fopen($sFileNotUsed, "w");

fputs($rOutput, "Function never used :\n\n");

while ($sFunction = fgets($rFunctions))
{
	$aFunction = explode(":", $sFunction);
	$sFunction = substr($aFunction[1], 0, strlen($aFunction[1]) - 1);
	$sCmd = "project-grep.sh \"".$sFunction."(\" ".$grepDir." | grep -v function | wc -l";
	echo $sCmd."\n";
	if (exec($sCmd) == 0)
	{
		fputs($rOutput, $aFunction[0].":".$sFunction."\n");
	}
}

fclose($rFunctions);
//unlink($sFileFunction);

?>
