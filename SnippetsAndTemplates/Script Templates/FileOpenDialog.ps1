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

Function mGetFileName($initialDirectory, $mFileType)
{
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
	$openFileDialog.title = "Select <file type> to open..."   
    $OpenFileDialog.filter = $mFileType
	$OpenFileDialog.
    $result = $OpenFileDialog.ShowDialog()
    if($result -eq "OK")
	{    
        Write-Host "Selected File to open:"  -ForegroundColor Green  
        $OpenFileDialog.filename   
        $OpenFileDialog.CheckFileExists  
        Write-Host "File to open exists!" -ForegroundColor Green 
    } 
    else 
	{ Write-Host "File Open Cancelled!" -ForegroundColor Red}
	$OpenFileDialog.Dispose()#dispose as you are done.
}

#call the function providing initial directory path and file type filter
$mWf = $vaultConnection.WorkingFoldersManager.GetWorkingFolder("$/")
$inputfile = mGetFileName $mWf "Inventor Project (*.ipj)|*.ipj|Excel CSV (*.csv)| *.csv"
Write-Host $outputfile


    

