#region disclaimer
#=============================================================================#
# PowerShell script sample for Vault Data Standard Quickstart Configuration   #
#                                                                             #
# Copyright (c) Autodesk - All rights reserved.                               #
#                                                                             #
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER   #
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.  #
#=============================================================================#
#endregion

# Version Info - VDS Quickstart 2017 Update 1.

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

#retrieve the definition ID for given property by displayname
function mGetFolderPropertyDefId ([STRING] $mDispName) {
	$PropDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("FLDR")
	$propDefIds = @()
	$PropDefs | ForEach-Object {
		$propDefIds += $_.Id
	} 
	$mPropDef = $propDefs | Where-Object { $_.DispName -eq $mDispName}
	Return $mPropDef.Id
}

#retrieve Category definition ID by display name
function mGetCategoryDef ([String] $mEntType, [String] $mDispName)
{
	$mEntityCategories = $vault.CategoryService.GetCategoriesByEntityClassId($mEntTyp, $true)
	$mEntCatId = ($mEntityCategories | Where-Object {$_.Name -eq $mDispName }).ID
	return $mEntCatId
}

#update single property. Parameters: Folder ID, UDP display name and UDP value
function mUpdateFldrProperties([Long] $FldId, [String] $mDispName, [Object] $mVal)
{
	$ent_idsArray = @()
	$ent_idsArray += $FldId
	$propInstParam = New-Object Autodesk.Connectivity.WebServices.PropInstParam
	$propInstParamArray = New-Object Autodesk.Connectivity.WebServices.PropInstParamArray
	#first time only - get the definition ID for Title; later just reuse the def.ID
	$mTitlePropDefId = mGetFolderPropertyDefId $mDispName
 	$propInstParam.PropDefId = $mTitlePropDefId
	$propInstParam.Val = $mVal
	$propInstParamArray.Items += $propInstParam
	$propInstParamArrayArray += $propInstParamArray
	$propInstParam = New-Object Autodesk.Connectivity.WebServices.PropInstParam
	$_fldPropUpdate = $vault.DocumentServiceExtensions.UpdateFolderProperties($ent_idsArray, $propInstParamArrayArray)
	return $_fldPropUpdate
}

#create folder structure based on seqential file numbering; 
# parameters: Filenumber (has to be number in string format) and number of files per folder as digit, e.g. 3 for max. 999 files.
function mGetFolderNumber($_FileNumber, $_nChar)
{
	#$_FileNumber = "1000000"
	$_l = $_FileNumber.Length
	#$_nChar = 3 # number of files per folder
	$_nO = [math]::Ceiling( $_FileNumber.Length/$_nChar)
	$_NumberArray = @()
	$_d = 0
	$_n = 0

	do{
	if ($_l-$_nChar -ge 0) { 
			$_NumberArray += $_FileNumber.Substring($_l-$_nChar,$_nChar)
		}
		else {
			if ($_d -gt 0) {
				$_NumberArray += $_FileNumber.Substring(0, $_d)
			}
		}
		$_l -= $_nChar
		$_d = $_FileNumber.Length-(($_n+1)*$_nChar)
		$_n +=1
	}
	while ($_n -le $_nO+1) 

	$_Folders = @()
	for ($_i = 1; $_i -lt $_NumberArray.Count; $_i++)
	{
		if ($_NumberArray[$_i] -eq "000") { $_Folder = 0 }
		else { [int16]$_Folder = $_NumberArray[$_i] }
		$_Folders += $_Folder
	}

	$_ItemFilePath = "$/Item-Files/"
	for ($_i = 0; $_i -lt $_Folders.Count; $_i++) {
		$_ItemFilePath = $_ItemFilePath + $_Folders[$_i] + "/"
	}
	return $_ItemFilePath

} #end function mGetFolderNumber