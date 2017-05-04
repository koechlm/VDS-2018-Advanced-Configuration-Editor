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

#
# CopyProjectFolderDescriptionToCADFile.ps1
# The script iterates the parent folders of a new file in Inventor or AutoCAD, until a project category parent folder is found; the title value copies to the new file.

# instructions: 
# 1) copy both functions to the end of .\CAD\addins\Default.ps1
# 2) call the function "mGetProjectTitleToCADFile" from OnDialogClose event function.


function mGetProjectFolderTitleToCADFile
{
		#get the Vault path of Inventors working folder
		$mWfVault = $Prop["_VaultVirtualPath"].Value + $Prop["_WorkspacePath"].Value
		
		#get local path of vault workspace path
		try {
			$mWFEnforced = $vault.DocumentService.GetEnforceWorkingFolder()
			if ($mWFEnforced -eq $true) {
				$m_IPJ = $vault.DocumentService.GetInventorProjectFileLocation()
				$m_IPJ = $m_IPJ.Split("/.")
				$mCAxRoot = $m_IPJ[1]
				$mWF = $vault.DocumentService.GetRequiredWorkingFolderLocation()
				$mWFCAD = $mWF + $mCAxRoot
				}
			}
		catch { [System.Windows.MessageBox]::Show("Check Vault CAD Working Folder Settings (Working Folder & IPJ Enforced?)" , "Inventor VDS Client")}			
		
		#merge the local path and relative target path of new file in vault
		$mPath = $Prop["_FilePath"].Value.Replace($mWFCAD, "")
		$mPath = $mWfVault + $mPath
		$mPath = $mPath -replace "\\", "/" -replace "//", "/"
		$mFld = $vault.DocumentService.GetFolderByPath($mPath)
		#the loop to get the next parent project category folder; skip if you don't look for projects
		Do {
				$mParID = $mFld.ParID
				$mFld = $vault.DocumentService.GetFolderByID($mParID)
				IF ($mFld.Cat.CatName -eq $UIString["CAT6"]) { $mProjectFound = $true}
			} 
		Until (($mFld.Cat.CatName -eq $UIString["CAT6"]) -or ($mFld.FullName -eq "$"))
	
		If ($mProjectFound -eq $true) 
		{
			$Prop["Description"].Value = mGetFolderPropValue $mFld.Id $UIString["LBL2"]
		}
}

#retrieve property value given by displayname from folder (ID)
function mGetFolderPropValue ([Int64] $mFldID, [STRING] $mDispName)
{
	$PropDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("FLDR")
	$propDefIds = @()
	$PropDefs | ForEach-Object {
		$propDefIds += $_.Id
	} 
	$mPropDef = $propDefs | Where-Object { $_.DispName -eq $mDispName}
	$mEntIDs = @()
	$mEntIDs += $mFldID
	$mPropDefIDs = @()
	$mPropDefIDs += $mPropDef.Id
	$mProp = $vault.PropertyService.GetProperties("FLDR",$mEntIDs, $mPropDefIDs)
	$mProp | Where-Object { $mPropVal = $_.Val }
	Return $mPropVal
}

