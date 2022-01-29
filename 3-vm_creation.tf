resource "azurerm_windows_virtual_machine" "VM" {
  for_each = var.vm_name
  name = "${each.key}"
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  network_interface_ids = [azurerm_network_interface.NIC[each.key].id]
  size = "Standard_F2"
  admin_username = "Benjamin"
  admin_password = "W3lc0me@1234567"
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-Datacenter"
    version = "latest"
  }
}
/*
Run this command manually inside VM

"$LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object    System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)"
resource "azurerm_virtual_machine_extension" "vm_extension" {
  for_each = var.vm_name
  name                 = "ext-${each.key}"
  virtual_machine_id = "${azurerm_windows_virtual_machine.VM[each.key].id}"
  #location             = "${azurerm_resource_group.RG.location}"
  #resource_group_name  = "${azurerm_resource_group.RG.name}"
  #virtual_machine_name = "${each.key}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.8"

   settings = <<SETTINGS
    {
        "fileUris": ["https://raw.githubusercontent.com/kallalmajumder/scripts/4c7bbc2efa7072d47f16b31b59ea254e3dd0dfea/install_chrome.ps1"],
        "commandToExecute": "powershell.exe -ExecutionPolicy unrestricted -NoProfile -NonInteractive -File install_chrome.ps1"
    }
SETTINGS

}*/