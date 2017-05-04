function m_CaptureSelections
{#save combobox selections for restore after dialog refresh
	$global:_temp1 = $dsWindow.FindName("NumSchms").Text
}
function m_RestoreSelections
{ 
	#restore combobox selections that refresh itemssource 
	if ($global:_temp1) { $dsWindow.FindName("NumSchms").Text = $global:_temp1  }
}