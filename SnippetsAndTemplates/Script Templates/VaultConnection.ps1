# Connect to Vault Webservices to use API
#
$mVltUtilsDll = [System.IO.File]::ReadAllBytes("C:\Users\Marku\OneDrive\VStudio Projects\VDSUtils2017\VDSUtils\obj\Debug\VDSUtils.dll")
[System.Reflection.Assembly]::Load($mVltUtilsDll)
[System.Reflection.Assembly]::LoadFrom("C:\Program Files\Autodesk\Vault Professional 2017\Explorer\Autodesk.Connectivity.WebServices.dll")
#[System.Reflection.Assembly]::LoadFrom("C:\Users\Marku\OneDrive\VStudio Projects\VDSUtils2017\VDSUtils\obj\Debug\VDSUtils.dll")

$server="192.168.85.128"
$vaultName="VLT-MKDE"
$username ="Administrator"
$passw = ""

$_VltHelpers = New-Object VDSUtils.VltHelpers
$credRW = $_VltHelpers.UserCredentials1($server, $vaultName, $username, $passw)
#$credRO = $_VltHelpers.UserCredentials2($server, $vaultName, $username, $passw) #returns readonly user

$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($credRW)
#$vaultRO = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($credRO)

$mUser = $credRW.UserName

$mFiles = $vault.DocumentService.GetFilesByMasterId(130826)
$mLatestFile = $vault.DocumentService.GetLatestFileByMasterId(130826)

$PropDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("FILE")

$propDefIds = @()
	$PropDefs | ForEach-Object {
		$propDefIds += $_.Id
	} 
	$mPropDef = $propDefs | Where-Object { $_.DispName -eq "Entstanden aus"}
	
	$mEntIDs = @()
	$mEntIDs += $mLatestFile.Id
	$mPropDefIDs = @()
	$mPropDefIDs += $mPropDef.Id
	$mProp = $vault.PropertyService.GetProperties("FILE",$mEntIDs, $mPropDefIDs)

	$mVal = $mProp[0].Val

	next
	