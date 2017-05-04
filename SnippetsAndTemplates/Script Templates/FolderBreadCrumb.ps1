#=============================================================================#
# PowerShell script sample for Vault Data Standard                            #
#			 Autodesk Vault - Quickstart 2017  								  #
# This sample is based on VDS 2017 RTM and adds functionality and rules       #
# All additions are marked with 'region Quickstart' - 'endregion'			  #
#                                                                             #
# Copyright (c) Autodesk - All rights reserved.                               #
#                                                                             #
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER   #
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.  #
#=============================================================================#

function GetChildFolders($folder)
{
	$ret = @()
	$folders = $vault.DocumentService.GetFoldersByParentId($folder.ID, $false)
	if($folders -ne $null){
		foreach ($item in $folders) {
			if (-Not $item.Cloaked)
			{
				$f = New-Object PSObject -Property @{ Name = $item.Name; ID=$item.Id }	
				$ret += $f
			}
		}
	}
	$ret += New-Object PSObject -Property @{ Name = "."; ID=-1 }
	return $ret
}

function GetFullPathFromBreadCrumb($breadCrumb)
{
	$path = ""
	foreach ($crumb in $breadCrumb.Children) {
		$path += $crumb.SelectedItem.Name+"\"
	}
	return $path
}

function OnSelectionChanged($sender)
{
	$breadCrumb = $dsWindow.FindName("BreadCrumb")
    $position = [int]::Parse($sender.Name.Split('_')[1]);
	$children = $breadCrumb.Children.Count - 1
    while($children -gt $position )
    {
		#region quickstart
			$cmb = $breadCrumb.Children[$children]
			$breadCrumb.UnregisterName($cmb.Name) #reset the registration to avoid multiple registrations
		#endregion
		$breadCrumb.Children.Remove($breadCrumb.Children[$children]);
		$children--;
    }
	$path = GetFullPathFromBreadCrumb -breadCrumb $breadCrumb
	$Prop["Folder"].Value = $path
    AddCombo -data $sender.SelectedItem
}


function AddCombo($data)
{
	if ($data.Name -eq '.' -or $data.Id -eq -1)
    {
        return
    }
	$children = GetChildFolders -folder $data
	if($children -eq $null) { return }
	$breadCrumb = $dsWindow.FindName("BreadCrumb")
	$cmb = New-Object System.Windows.Controls.ComboBox
	$cmb.Name = "cmbBreadCrumb_" + $breadCrumb.Children.Count.ToString();
	$cmb.DisplayMemberPath = "Name";
	$cmb.ItemsSource = @($children)
	
	$cmb.add_SelectionChanged({
		param($sender,$e)
		OnSelectionChanged -sender $sender
	});
	#region Quickstart
		#$breadCrumb.Children.Add($cmb);
		$breadCrumb.RegisterName($cmb.Name, $cmb) #register the name to activate later via indexed name
		If ($cmb.Items[0].Name -ne ".") { $cmb.IsDropDownOpen = $true} 
		$breadCrumb.Children.Add($cmb)
	#endregion
}
#
# Sample code to get Folder tree
#
#	call function example:  
#		$rootFolder = $vault.DocumentService.GetFolderByPath("$/Designs")
#   	$root = New-Object PSObject -Property @{ Name = $rootFolder.Name; ID=$rootFolder.Id }	
#   	AddCombo -data $root


function AddCombo($data)
{
	if ($data.Name -eq '.' -or $data.Id -eq -1)
	{
		return
	}
	$children = GetChildFolders -folder $data
	if($children -eq $null) { return }
	$breadCrumb = $dsWindow.FindName("BreadCrumb")
	$cmb = New-Object System.Windows.Controls.ComboBox
	$cmb.Name = "cmbBreadCrumb_" + $breadCrumb.Children.Count.ToString();
	$cmb.DisplayMemberPath = "Name";
	$cmb.ItemsSource = @($children)
	$cmb.IsDropDownOpen = $true
	$cmb.add_SelectionChanged({
			param($sender,$e)
			OnSelectionChanged -sender $sender
		});
	$breadCrumb.Children.Add($cmb);
}

function GetChildFolders($folder)
{
	$ret = @()
	$folders = $vault.DocumentService.GetFoldersByParentId($folder.ID, $false)
	if($folders -ne $null)
	{
		foreach ($item in $folders) 
		{
			$f = New-Object PSObject -Property @{ Name = $item.Name; ID=$item.Id } 
			If ($f.Name -ne 'Inaccessible')
			{
				$ret += $f
			}
		}
	}
	$ret += New-Object PSObject -Property @{ Name = "."; ID=-1 }
	return $ret
}

function GetFullPathFromBreadCrumb($breadCrumb)
{
	$path = ""
	foreach ($crumb in $breadCrumb.Children) 
	{
		$path += $crumb.SelectedItem.Name+"\"
	}
	return $path
}

function OnSelectionChanged($sender)
{
	$breadCrumb = $dsWindow.FindName("BreadCrumb")
	$position = [int]::Parse($sender.Name.Split('_')[1]);
	$children = $breadCrumb.Children.Count - 1
	while($children -gt $position )
	{
		$breadCrumb.Children.Remove($breadCrumb.Children[$children]);
		$children--;
	}
	$path = GetFullPathFromBreadCrumb -breadCrumb $breadCrumb
	$Prop["Folder"].Value = $path
	AddCombo -data $sender.SelectedItem
}





