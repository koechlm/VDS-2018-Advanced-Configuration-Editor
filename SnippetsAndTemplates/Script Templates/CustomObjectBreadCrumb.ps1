#
#	Sample script using breadcrumb objects for any hierarchy selection
#
#	call function example:  
#		mAddCoCombo -_CoName "CustomObjectDefinitionName"
#--------------------------------------

function mAddCoCombo ([String] $_CoName) {
	$children = mgetCustomEntityList -_CoName $_CoName
	if($children -eq $null) { return }

	#toDo: replace by your XAML wrap panel name
	$breadCrumb = $dsWindow.FindName("wrpFilter")
	
	$cmb = New-Object System.Windows.Controls.ComboBox
	$cmb.Name = "cmbBreadCrumb_" + $breadCrumb.Children.Count.ToString();
	$cmb.DisplayMemberPath = "Name";
	$cmb.Tooltip = $UIString["ClassTerms_TT01"] #replace by your tooltip string
	$cmb.ItemsSource = @($children)
	# 	$cmb.SelectedIndex = 0
	# 	$cmb.IsDropDownOpen = $true
	$cmb.MinWidth = 140
	$cmb.HorizontalContentAlignment = "Center"
	$cmb.BorderThickness = "1,1,1,1"
	$cmb.add_SelectionChanged({
			param($sender,$e)
			$dsDiag.Trace("1. SelectionChanged, Sender = $sender, $e")
			mCoComboSelectionChanged -sender $sender
		});
	$breadCrumb.RegisterName($cmb.Name, $cmb) #register the name to activate later via indexed name
	$breadCrumb.Children.Add($cmb);

	#region EditMode CustomObjectTerm Window
	If ($dsWindow.Name-eq "CustomObjectTermWindow")
	{
		IF ($Prop["_EditMode"].Value -eq $true)
		{
			$_cmbNames = @()
			Foreach ($_cmbItem in $cmb.Items) 
			{
				$dsDiag.Trace("---$_cmbItem---")
				$_cmbNames += $_cmbItem.Name
			}
			$dsDiag.Trace("Combo $index Namelist = $_cmbNames")
			$_CurrentName = $_classes[0]
			$dsDiag.Trace("Current Name: $_CurrentName ")
			#get the index of name in array
			$i = 0
			Foreach ($_Name in $_cmbNames) 
			{
				$_1 = $_cmbNames.count
				$_2 = $_cmbNames[$i]
				$dsDiag.Trace(" Counter: $i von $_1 Value: $_2  and CurrentName: $_CurrentName ")
				If ($_cmbNames[$i] -eq $_CurrentName) 
				{
					$_IndexToActivate = $i
				}
				$i +=1
			}
			$dsDiag.Trace("Index of current name: $_IndexToActivate ")
			$cmb.SelectedIndex = $_IndexToActivate			
		}
	}
	#endregion
} # addCoCombo

function mAddCoComboChild ($data) {
	$children = mGetCustomEntityUsesList -sender $data
	$dsDiag.Trace("check data object: $children")
	if($children -eq $null) { return }

	#toDo: replace by your XAML wrap panel name
	$breadCrumb = $dsWindow.FindName("wrpFilter")
	
	$cmb = New-Object System.Windows.Controls.ComboBox
	$cmb.Name = "cmbBreadCrumb_" + $breadCrumb.Children.Count.ToString();
	$cmb.DisplayMemberPath = "Name";
	$cmb.ItemsSource = @($children)
	# 	$cmb.SelectedIndex = 0
	IF ($Prop["_CreateMode"].Value -eq $true) {$cmb.IsDropDownOpen = $true}
	# 	$cmb.width = 187
	$cmb.BorderThickness = "1,1,1,1"
	$cmb.HorizontalContentAlignment = "Center"
	$cmb.MinWidth = 140
	$cmb.add_SelectionChanged({
			param($sender,$e)
			$dsDiag.Trace("next. SelectionChanged, Sender = $sender")
			mCoComboSelectionChanged -sender $sender
		});
	$breadCrumb.RegisterName($cmb.Name, $cmb) #register the name to activate later via indexed name
	$breadCrumb.Children.Add($cmb)
	$_i = $breadCrumb.Children.Count
	$_Label = "lblGroup_" + $_i
	$dsDiag.Trace("Label to display: $_Label - but not longer used")
	# 	$dsWindow.FindName("$_Label").Visibility = "Visible"
	
	#region EditMode for CustomObjectTerm Window
	If ($dsWindow.Name-eq "CustomObjectTermWindow")
	{
		IF ($Prop["_EditMode"].Value -eq $true)
		{
			Try
			{
				$_cmbNames = @()
				Foreach ($_cmbItem in $cmb.Items) 
				{
					$dsDiag.Trace("---$_cmbItem---")
					$_cmbNames += $_cmbItem.Name
				}
				$dsDiag.Trace("Combo $index Namelist = $_cmbNames")
				#get the index of name in array
				$_CurrentName = $_classes[$_i-2] #remember the number of breadcrumb children is +2 (delete button, and the class start with index 0)
				$dsDiag.Trace("Current Name: $_CurrentName ")
				$i = 0
				Foreach ($_Name in $_cmbNames) 
				{
					$_1 = $_cmbNames.count
					$_2 = $_cmbNames[$i]
					$dsDiag.Trace(" Counter: $i von $_1 Value: $_2  and CurrentName: $_CurrentName ")
					If ($_cmbNames[$i] -eq $_CurrentName) 
					{
						$_IndexToActivate = $i
					}
					$i +=1
				}
				$dsDiag.Trace("Index of current name: $_IndexToActivate ")
				$cmb.SelectedIndex = $_IndexToActivate			
			} #end try
		catch 
		{
			$dsDiag.Trace("Error activating an existing index in edit mode.")
		}
	}
	}
	#endregion
} #addCoComboChild

function mgetCustomEntityList ([String] $_CoName) {
	try {
		$dsDiag.Trace(">> m_getCustomEntityList started")
		$srchConds = New-Object autodesk.Connectivity.WebServices.SrchCond[] 1
		$srchCond = New-Object autodesk.Connectivity.WebServices.SrchCond
		$propDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("CUSTENT")
		$propNames = @("CustomEntityName")
		$propDefIds = @{}
		foreach($name in $propNames) {
			$propDef = $propDefs | Where-Object { $_.SysName -eq $name }
			$propDefIds[$propDef.Id] = $propDef.DispName
		}
		$srchCond.PropDefId = $propDef.Id
		$srchCond.SrchOper = 3
		$srchCond.SrchTxt = $_CoName
		$srchCond.PropTyp = [Autodesk.Connectivity.WebServices.PropertySearchType]::SingleProperty
		$srchCond.SrchRule = [Autodesk.Connectivity.WebServices.SearchRuleType]::Must
		$srchConds[0] = $srchCond
		$srchSort = New-Object autodesk.Connectivity.WebServices.SrchSort
		$searchStatus = New-Object autodesk.Connectivity.WebServices.SrchStatus
		$bookmark = ""
		$global:_CustomEnts = $vault.CustomEntityService.FindCustomEntitiesBySearchConditions($srchConds,$null,[ref]$bookmark,[ref]$searchStatus)
		$dsDiag.Trace(".. m_getCustomEntityList finished - returns $_CustomEnts <<")
		return $_CustomEnts
	}
	catch { 
		$dsDiag.Trace("!! Error in m_getCustomEntityList")
	}
}

function mGetCustomEntityUsesList ($sender) {
	try {
		$dsDiag.Trace(">> mGetCustomEntityUsesList started")
		$breadCrumb = $dsWindow.FindName("wrpFilter")
		$_i = $breadCrumb.Children.Count -1
		$_CurrentCmbName = "cmbBreadCrumb_" + $breadCrumb.Children.Count.ToString()
		$_CurrentClass = $breadCrumb.Children[$_i].SelectedValue.Name
		$_customObjects = mgetCustomEntityList -_CoName "*"
		$_Parent = $_customObjects | Where-Object { $_.Name -eq $_CurrentClass }
		try {
			$links = $vault.DocumentService.GetLinksByParentIds(@($_Parent.Id),@("CUSTENT"))
			$linkIds = @()
			$links | ForEach-Object { $linkIds += $_.ToEntId }
			$mLinkedCustObjects = $vault.CustomEntityService.GetCustomEntitiesByIds($linkIds);
			#todo: check that we need to filter the list returned
			$dsDiag.Trace(".. m_getCustomEntityUsesList finished - returns $_CustomEnts <<")

			return $mLinkedCustObjects #$global:_Groups
		}
		catch {
			$dsDiag.Trace("!! Error getting links of Parent Co !!")
			return $null
		}
	}
	catch { $dsDiag.Trace("!! Error in mAddCoComboChild !!") }
}

function mCoComboSelectionChanged ($sender) {
	$breadCrumb = $dsWindow.FindName("wrpFilter")
	$position = [int]::Parse($sender.Name.Split('_')[1]);
	$children = $breadCrumb.Children.Count - 1
	while($children -gt $position )
	{
		$cmb = $breadCrumb.Children[$children]
		$breadCrumb.UnregisterName($cmb.Name) #unregister the name to correct for later addition/registration
		$breadCrumb.Children.Remove($breadCrumb.Children[$children]);
		$children--;
	}
	# toDo: save the selected values to properties; not sure that these exist; replace with yours
	Try
	{
		$Prop["_XLTN_SEGMENT"].Value = $breadCrumb.Children[1].SelectedItem.Name
		$Prop["_XLTN_MAINGROUP"].Value = $breadCrumb.Children[2].SelectedItem.Name
		$Prop["_XLTN_GROUP"].Value = $breadCrumb.Children[3].SelectedItem.Name
		$Prop["_XLTN_SUBGROUP"].Value = $breadCrumb.Children[4].SelectedItem.Name
	}
	catch{}
	#$dsDiag.Trace("---combo selection = $_selected, Position $position")
	mAddCoComboChild -sender $sender.SelectedItem
}

function mResetFilter
{
	$dsDiag.Trace(">> Reset Filter started...")
	IF ($Prop["_EditMode"].Value -eq $true)
	{
		try
		{
			IF ($dsWindow.Name -eq "CustomObjectTermWindow")
			{
				$_Return=[System.Windows.MessageBox]::Show("You are going to change the selected classification, are you sure?", "Autodesk Vault - Catalog", 4)
				If($_Return -eq "No") { return }
			}
		}
		catch
		{
			$dsDiag.Trace("Error - Reset Filter")
		}
	}
	IF (($Prop["_CreateMode"].Value -eq $true) -or ($_Return -eq "Yes"))
	{
		#$dsDiag.Inspect()
		#maintain selections as the reset will cause a dialog refresh
		$_temp30 = $dsWindow.FindName("Categories").SelectedIndex
		$_temp31 = $dsWindow.FindName("Categories").ItemsSource
		$_temp40 = $dsWindow.FindName("NumSchms").IsEnabled
		
		$breadCrumb = $dsWindow.FindName("wrpFilter")
		$breadCrumb.Children[1].SelectedIndex = -1
		#once the classification is reset the dialog should behave like create mode
		IF ($dsWindow.Name -eq "CustomObjectTermWindow")
		{
			$Prop["_CreateMode"].Value = $true
			$Prop["_EditMode"].Value = $false
		}

		#restore selections
		IF ($_temp31) { $dsWindow.FindName("Categories").ItemsSource = $_temp31}
		IF ($_temp30) { $dsWindow.FindName("Categories").SelectedIndex = $_temp30}
		IF ($_temp40) { $dsWindow.FindName("NumSchms").IsEnabled = $_temp40}
		$dsDiag.Trace("...Reset Filter finished <<")
	}
	
}