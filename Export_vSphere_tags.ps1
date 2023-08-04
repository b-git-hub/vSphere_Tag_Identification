
$vcenter1 = "input_vcenter1"
$vcenter2 = "input_vcenter2"
$vccred = Get-Credential -Message "vCenter Credentials"


# Connect to the vCenter Server
Connect-VIServer -Server $vcenter1 -Credential $vccred

# List of VMs
$vmList = @(
    "VM1",
    "VM2",
    "VM3",
    "VM4",
    "VM5"
)

# Retrieve Application Category for each VM
foreach ($vmName in $vmList) {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if ($vm) {
        $tags = Get-TagAssignment -Entity $vm
        $AppTags = $tags | Where-Object { $_.Tag.Category.Name -eq "Application" } | Select-Object -ExpandProperty Tag
        $TierTag = $tags | Where-Object { $_.Tag.Category.Name -eq "Tier" } | Select-Object -ExpandProperty Tag
        $EnvironmentTag = $tags | Where-Object { $_.Tag.Category.Name -eq "Environment" } | Select-Object -ExpandProperty Tag
        $AppTagNames = $AppTags | ForEach-Object { $_.Name }
        $TierTagNames = $TierTag | ForEach-Object { $_.Name }
        $EnvironmentTagNames = $EnvironmentTag | ForEach-Object { $_.Name }
        Write-Output "VM: $($vm.Name) | Application Tags: $($AppTagNames -join ', ') | Tier Tags: $($TierTagNames -join ', ') | Environment Tags: $($EnvironmentTagNames -join ', ')"
    } else {
        Write-Output "VM: $vmName | Not found"
    }
}

# Disconnect from the vCenter Server
Disconnect-VIServer -Server $vcenter1  -Confirm:$false
Disconnect-VIServer -Server $vcenter2  -Confirm:$false