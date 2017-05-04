#region disclaimer
#=============================================================================#
# PowerShell script sample for Vault Data Standard                            #
#                                                                             #
# Copyright (c) Autodesk - All rights reserved.                               #
#                                                                             #
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER   #
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.  #
#=============================================================================#
#endregion

function mSetFileName($initialDirectory, $mFileName, $mFileType)
{
	$SaveFileDialog = New-Object windows.forms.savefiledialog   
    $SaveFileDialog.initialDirectory = $initialDirectory
    $SaveFileDialog.title = "Save File to Disk"   
    $SaveFileDialog.filter = $mFileType
	$SaveFileDialog.FileName = $mFileName
	#$SaveFileDialog.ShowHelp = $True   
    #Write-Host "Where would you like to create log file?... (see File Save Dialog)" -ForegroundColor Green  
    $result = $SaveFileDialog.ShowDialog()    
	if($result -eq "OK")    
	{    
        Write-Host "Selected File and Location:"  -ForegroundColor Green  
        $SaveFileDialog.filename   
    } 
    else { Write-Host "File Save Dialog Cancelled!" -ForegroundColor Yellow}
	$SaveFileDialog.Dispose()#dispose as you are done.
}

#call the function providing initial directory path and file type filter
$mWf = $vaultConnection.WorkingFoldersManager.GetWorkingFolder("$/")
$outputfile = mSetFileName $mWf "MyProposedFileName" "Inventor Project (*.ipj)|*.ipj|Excel CSV (*.csv)| *.csv"
Write-Host $outputfile
