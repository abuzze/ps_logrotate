# logrotate.ps1
# version 1
# Christoph Miessler 2013
# License: Free 4 all

$now = get-date
$logfolder="" #Full Path to log Folder; no \ at the end
$logfolderbackup="" #Full Path to Backup log Folder; the script will create this folder for you
$oldestLog=(Get-Date).AddDays(-7) #Keep logs 1 week
$rotatelog=$logfolder+"\logrotate.log" #logfile for this script

#preflightchecks
$FolderExists = (Test-Path $logfolder)
if (!$FolderExists) {
	Write-Host "Could not find the logfolder $logfolder you specified. Pls check var: logfolder"
	exit 1
}
$FolderExists = (Test-Path $logfolderbackup)
if (!$FolderExists){
	New-Item -Path $logfolderbackup -ItemType directory
}
echo "On $now all logs older than $oldestLog where moved to $logfolderbackup." >> $rotatelog
Get-ChildItem $logfolder\*.log | Where-Object {$_.LastWriteTime -lt $oldestLog} >> $rotateLog #Appends a list of the files to be deleted/moved to the bottom of this scripts log file
#Get-ChildItem $logfolder\*.log | Where-Object {$_.LastWriteTime -lt $oldestLog} | Remove-Item  #Deletes files older then the specified amount of time
Get-ChildItem $logfolder\*.log | Where-Object {$_.LastWriteTime -lt $oldestLog} | Move-Item -Destination $logfolderbackup #moves all files older then the specified amount of time
echo "======================= Last Entry =======================" >> $rotatelog
exit 0
