function Get-DirectoryPermissions($directory, $exportLocation = "C:\Temp", [switch]$findDir, [switch]$Recurse) {
    $exportFile = "$exportLocation\folderPermissions.csv"
    if($findDir){$directory = Get-Directory}
    if(-not $directory){$directory = Get-Directory}

    if($recurse)
    {
        
        $dirs = Get-ChildItem -Path $directory -Recurse -Directory
        foreach ($dir in $dirs) {
            Write-Host "$dir"
            #Get-DirectoryPermissions $dir 
        }
        return
    }

    $dir = Get-Item -Path $directory
    $permissionObjects = (Get-Acl -Path $dir).AccessS
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


