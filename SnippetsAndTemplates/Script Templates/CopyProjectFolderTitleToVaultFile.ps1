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
# CopyProjectFolderDescriptionToVaultFile.ps1
# The script iterates the parent folders of a new file, until a project category parent folder is found; the title value copies to the new file.

# instructions: 
# 1) copy both functions to the end of .\Vault\addinVault\Default.ps1
# 2) call the function "mGetProjectTitleToVaultFile" from InitializeWindow FileWindow Switch.


function mGetProjectFolderTitleToVaultFile
{
	#region copy parent folder property value to this dialog / file
				$mPath = $Prop["_FilePath"].Value
				$mFld = $vault.DocumentService.GetFolderByPath($mPath)
	
				IF ($mFld.Cat.CatName -eq $UIString["CAT6"]) { $Global:mProjectFound = $true}
				Else {
					Do {
						$mParID = $mFld.ParID
						$mFld = $vault.DocumentService.GetFolderByID($mParID)
						IF ($mFld.Cat.CatName -eq $UIString["CAT6"]) { $Global:mProjectFound = $true}
					} Until (($mFld.Cat.CatName -eq $UIString["CAT6"]) -or ($mFld.FullName -eq "$"))

				}

				If ($mProjectFound -eq $true) 
				{
					$Prop["_XLTN_DESCRIPTION"].Value = mGetFolderPropValue $mFld.Id $UIString["LBL2"] #multilanguage string for Title
				}
				#endregion
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

