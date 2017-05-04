#
#	Sample code for Vault Item search
#	expects a XAML datagrid control with name "ItemsFound"	- the table of results
#	expects a XAML textbox control with name "SearchText"	- the input field for search text
#
#	a command to select a row of the table is included		- implement the command as context command of "ItemsFound"

Add-Type @"
public class itemData
{
	public string Item {get;set;}
	public string Revision {get;set;}
	public string Title {get;set;}
}
"@

function mSearchItem()
{
	$mSearchText = $dsWindow.FindName("SearchText").text
	$dsDiag.Trace(">> Item search started... SearchText = $mSearchText")

	if($mSearchText -eq "") #no searchparameters
	{
		$dsWindow.FindName("ItemsFound").ItemsSource = $null
		return 
	} 
	try
	{
		$dsDiag.Trace(" -- Item search executes...")
		$srchconds = New-Object autodesk.Connectivity.WebServices.SrchCond[] 1
		$srchconds[0] = New-Object autodesk.Connectivity.WebServices.SrchCond
		$srchconds[0].PropDefId = 0
		$srchconds[0].SrchOper = 1
		$srchconds[0].SrchTxt = $mSearchText
		$srchconds[0].PropTyp = "AllProperties"
		$srchconds[0].SrchRule = "Must"
		$bookmark = ""
		$status = New-Object autodesk.Connectivity.WebServices.SrchStatus
		$items = $vault.ItemService.FindItemRevisionsBySearchConditions($srchconds, $null, $true, [ref]$bookmark, [ref]$status)
		$results = @()
		foreach($item in $items)
		{
			$row = New-Object itemData
			$row.Item = $item.ItemNum
			$row.Revision = $item.RevNum
			$row.Title = $item.Title
			$results += $row 
		}
		$dsWindow.FindName("ItemsFound").ItemsSource = $results
		$dsDiag.Trace(" -- Item search returned")
	}
	catch
	{
		$dsDiag.Trace("Item search failed")
	}
}


function mSelectItem
{
	$dsDiag.Trace("Item selected to write it's number to the file part number field")
	try 
	{
		$mSelectedItem = $dsWindow.FindName("ItemsFound").SelectedItem
		#fill properties with objects itemData.Properties
		$Prop["Part Number"].Value = $mSelectedItem.Item
	}
	Catch 
	{
		$dsDiag.Trace("cannot write item number to property field")
	}
}

