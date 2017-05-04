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

#region check GroupMembership of current user
#	Strategy: 
#		1) create subfolder within .\Templates\Vault\DepartmentCheck\ with empty text files named according each group name.
#		2) set ACL on each file to represent group access
#		The function iterates the files and returns array of group names the current user belongs to

function mGetGroupMemberShip()
{
	Try
	{
		$_DepFolder = $vault.DocumentService.GetFolderByPath("$/Templates/Vault/DepartmentCheck")
		$_DepFolderFiles = $Vault.DocumentService.GetLatestFilesByFolderId($_DepFolder.ID, $false)
		$_UserMemOf = @()
		foreach ($file in $_DepFolderFiles)
		{
			if ($file.Cloaked -eq $false) {	$_UserMemOf += $file.Name.Replace(".txt", "")}
		}
		return $_UserMemOf
		}
	Catch 
	{
		[System.Windows.MessageBox]::Show("Could not evaluate user group membership", "Vault VDS Rules")
	}
}
#endregion