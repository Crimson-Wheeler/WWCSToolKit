#Gets the permissions of a directory, can recurse through all child directories and get their permissions too
function Get-DirectoryPermissions($directory, $exportLocation = "C:\Temp", [switch]$findDir, [switch]$Recurse) {
    $exportFile = "$exportLocation\folderPermissions.csv"

    #prompts the user to search for a directory
    if($findDir){$directory = Get-Directory}
    if(-not $directory){$directory = Get-Directory}

    
    #if recurce is on get list of all children in this directory and call this function recursively but without recurse on
    if($recurse)
    {

        $dirs = Get-ChildItem -Path $directory -Recurse -Directory | Select-Object -ExpandProperty FullName
        foreach ($dir in $dirs) {
            Get-DirectoryPermissions $dir $exportLocation 
        }
        return
    }

    #gets the permissions for the sigle provided directory
    $dir = Get-Item -Path $directory
    $permissionObjects = (Get-Acl -Path $dir).Access
    foreach ($obj in $permissionObjects) {
        if($obj.PropagationFlags -ne 'None'){continue}
        $folderInfo = [PSCustomObject]@{
            Directory = $dir
            Username = $obj.IdentityReference
            PermissionType = $obj.AccessControlType
            Permissions = $obj.FileSystemRights
            
        }
        Export-Csv -InputObject $folderInfo -Path $exportFile -Append
    }
}


function  Get-AllDrives()
{
    #writes an output for all the drives on the system
    return Get-PSDrive | Where-Object {$_.Name.Length -le 1}
}
