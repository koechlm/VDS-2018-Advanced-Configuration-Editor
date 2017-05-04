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

#--------------------------------------------------------
# CreateFolder_Subfolders_Properties.ps1
# Note - Requires Default_Extensions_QS-VDS.ps1 available
#
#--------------------------------------------------------

#Replace / edit the default CreateFolder.ps1 file by this code:

$folderId = $vaultContext.CurrentSelectionSet[0].Id
$vaultContext.ForceRefresh = $true
$dialog = $dsCommands.GetCreateFolderDialog($folderId)
$xamlFile = New-Object CreateObject.WPF.XamlFile "testxaml", "%ProgramData%\Autodesk\Vault 2017\Extensions\DataStandard\Vault\Configuration\Folder.xaml"
$dialog.XamlFile = $xamlFile

$result = $dialog.Execute()
$dsDiag.Trace($result)

if($result)
{
	#new folder can be found in $dialog.CurrentFolder
	$folder = $vault.DocumentService.GetFolderById($folderId)
	#region create subfolders for particular categories only
	$NewFolder = $dialog.CurrentFolder
	$path = $folder.FullName+"/"+$dialog.CurrentFolder.Name
	If ($NewFolder.cat.CatName -eq "Project") {
		#get Ids of all entities and definitions
		$mCat = mGetCategoryDef "FLDR" "Folder" #change the name according category of 1st level's subfolders
		$mCat2 = mGetCategoryDef "FLDR" "Folder" #change the name according category of 2nd level's subfolders
		#region create folder level 1
			$_SubFolder = $vault.DocumentService.AddFolder("1000", $NewFolder.Id, $false)
			$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFolder.Id), @($mCat))
			$mFldPropUpdated = mUpdateFldrProperties $_SubFolder.Id "Title" "CAD Files"
			#region create folder level 2
				$_SubFldr2 = $vault.DocumentService.AddFolder("1010", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "3D Components"
			#endregion
			#region create folder level 2
				$_SubFldr2 = $vault.DocumentService.AddFolder("1020", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "2D Drawings"
			#endregion
			#region create folder level 2
				$_SubFldr2 = $vault.DocumentService.AddFolder("1030", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "Images"
			#endregion
		#endregion

		#region create folder level 1
			$_SubFolder =$vault.DocumentService.AddFolder("1100", $NewFolder.Id, $false)
			$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFolder.Id), @($mCat))
			$mFldPropUpdated = mUpdateFldrProperties $_SubFolder.Id "Title" "CAE Files"
		#endregion

		#region create folder level 1
			$_SubFolder =$vault.DocumentService.AddFolder("1200", $NewFolder.Id, $false)
			$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFolder.Id), @($mCat))
			$mFldPropUpdated = mUpdateFldrProperties $_SubFolder.Id "Title" "Office Files"
			#region create folder level 2
				$_SubFldr2 = $vault.DocumentService.AddFolder("1210", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "Customer Communication"

				$_SubFldr2 = $vault.DocumentService.AddFolder("1220", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "Internal Communication"

				$_SubFldr2 = $vault.DocumentService.AddFolder("1230", $_SubFolder.Id, $false)
				$vault.DocumentServiceExtensions.UpdateFolderCategories(@($_SubFldr2.Id), @($mCat2))
				$mFldPropUpdated = mUpdateFldrProperties $_SubFldr2.Id "Title" "Quality Management"
			#endregion
		#endregion
	}

	#endregion
	[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Autodesk\Vault Professional 2017\Explorer\Autodesk.Connectivity.Explorer.Extensibility.dll")
	$selectionId = [Autodesk.Connectivity.Explorer.Extensibility.SelectionTypeId]::Folder
	$location = New-Object Autodesk.Connectivity.Explorer.Extensibility.LocationContext $selectionId, $path
	$vaultContext.GoToLocation = $location
}