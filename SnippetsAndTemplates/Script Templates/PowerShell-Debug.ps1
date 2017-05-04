# 1)Copy&Paste to console and run
    Enter-PsHostProcess -Name Connectivity.VaultPro # or / Inventor.exe / Acad.exe
#

# Copy&Paste code of function below to your script at the location you intend to start step by step debugging
function ShowRunspaceID
{
            $id = [runspace]::DefaultRunspace.Id
            $app = [System.Diagnostics.Process]::GetCurrentProcess()
            [System.Windows.Forms.MessageBox]::Show("application: $($app.name)"+[Environment]::NewLine+"runspace ID: $id")
}

# Start a vault VDS command that will hit your "breakpoint" (the location mentioned above)

# Copy&Paste to console, replace the <the ID ...> by the ID displayed in the dialog
    Debug-Runspace -id <the ID returned before>

#close the dialog in Vault / CAD session.