function Get-DirectoryPermissions($directory, $exportLocation = "C:\Temp", [switch]$findDir, [switch]$Recurse) {
    $exportFile = "$exportLocation\folderPermissions.csv"

    if($findDir){$directory = Get-Directory}
    if(-not $directory){$directory = Get-Directory}

    if($recurse)
    {
        
        $dirs = Get-ChildItem -Path $directory -Recurse -Directory
        foreach ($dir in $dirs) {
            Get-DirectoryPermissions $dir 
        }
        return
    }

    $dir = Get-Item -Path $directory
    
    #look at the permissions
    #foreach user who has permissions, dir, username, permission type
    #WRITE CUSTOM OBJECT WITH PERMISSION INFO


    $permissionObjects = (Get-Acl -Path $dir).Access
    foreach ($obj in $permissionObjects) {
        if($obj.PropagationFlags -ne 'None'){continue}
        $folderInfo = [PSCustomObject]@{
            Directory = $dir
            Username = $obj.IdentityReference
            PermissionType = $obj.AccessControlType
            Permissions = $obj.FileSystemRights
            
        }
        Write-Host $folderInfo
        Export-Csv -InputObject $folderInfo -Path $exportFile -Append
    }
}


