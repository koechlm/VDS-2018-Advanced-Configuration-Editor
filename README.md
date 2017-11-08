This Visual Studio project is an updated version of the 2017 Advanced Editor, introduced to Autodesk EMEA reseller channel @OTX 2016, Berlin. Basically the project has all VDS 2018 configuration files linked from ProgramData's Extension folder. So each edit immediatly reflects in current running Vault or CAD sessions. The advanced configuration editor additionally shares all snippets and templates that might help to quickly reuse functions. Don't miss to add the snippets to your snippet manager configuration in VS.

This Editor is my active tool. Simply subscribe to stay up to date as I am adding all stuff, that I intend to reuse. 
The Master configuration, branch 2018.0 has linked all configuration files delivered by VDS 2018 RTM installation. 
Branch 2018.1 includes the additional configuration folders to split default and custom configuration files; this "smart configuration management" has been introduced with VDS 2018 update 1. Currently no files are linked to these folders. The intended use is to copy, e.g. the CAD\Default.ps1 to CAD.Custom\MyDefault.ps1 and to edit the new copy instead of changing the original file. VDS 2018.1 "smart configuration management" will recognize the functions within your copy as override to be preferred of the default ones.
Other branches listed are useful to switch configurations with additional configuration files, e.g. Quickstart configuration. But note - the physical files of other configurations are never included in these branches, but linked only. To get full configurations watch out my repository for VLT-MKDE (my demo environment, based on a specific Vault configuration) or the VDS Quickstart Configurations, that include the copied configuration files.

Markus
