#
# NumberschemePropInput_OnPostClose.ps1
#
function OnPostCloseDialog
{
	$mWindowName = $dsWindow.Name
	switch($mWindowName)
	{
		"InventorWindow"
		{
			if ($Prop["_CreateMode"])
			{
				#$dsDiag.ShowLog()
				#$dsDiag.Clear()
				$mySelectedNumschsFields = $dsWindow.DataContext.NumSchemeCtrlViewModel.NumSchmFields
				$_DataContext = $dsWindow.DataContext
				ForEach ($item in $mySelectedNumschsFields)
				{
					$_Type = $item.FieldTyp
					$_Name = $item.Name
					$dsDiag.Trace("Current Field $_Name is a $_Type ")
				}
				$_SelectedSchmName = $dsWindow.FindName("NumSchms").SelectedValue
				#todo: check that the number and position of arguments matches the numbering scheme's field types
				$numSchemes = $vault.DocumentService.GetNumberingSchemesByType([Autodesk.Connectivity.WebServices.NumSchmType]::Activated)
				$testNumScheme = $numSchemes | Where-Object { $_.Name.Equals($_SelectedSchmName) }
				$NumGenArgs = @()
				$NumGenArgs += $Prop["Title"].Value
				$genNum = $vault.DocumentService.GenerateFileNumber($testNumScheme.SchmID, $NumGenArgs)
				$Prop["DocNumber"].Value = $genNum
			} 
		
		}
		"AutoCADWindow"
		{
			#rules applying for AutoCAD
		}
		default
		{
			#rules applying commonly
		}
	}
	
}