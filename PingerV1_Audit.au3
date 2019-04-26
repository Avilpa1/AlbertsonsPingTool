#include <MsgBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <StringConstants.au3>
#include <FontConstants.au3>
#include <StaticConstants.au3>
#include <AutoItConstants.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <Inet.au3>
#include <WindowsConstants.au3>
#include <ListViewExport.au3>

Opt("TrayIconHide", 1)

Global $VLAN19, $VLAN95, $VLAN24, $VLAN16, $VLAN80, $VLAN85, $VLAN70, $VLAN14, $VLAN6, $VLAN4, $VLAN79, $store, $DOS, $Message, $idButton_Close
Global $IP, $device, $vlan, $status, $host, $output, $idListview, $SAGUI, $idButton_CSA=9999, $idButton_Export=9999, $hListview, $sPrintOut, $hCombo6=9999
$sFont = "Comic Sans Ms"

Call ("VLANCAL")

$hGUI = GUICreate("Pinger", 230, 450)

    ; Device Descriptions
     $idAboutLabe0 = GUICtrlCreateLabel("Server Room", 20, 70, 160, 20)
	 $idAboutLabe1 = GUICtrlCreateLabel("PC's", 20, 120, 160, 20)
     $idAboutLabe2 = GUICtrlCreateLabel("Printers", 20, 170, 160, 20)
     $idAboutLabe3 = GUICtrlCreateLabel("Lanes", 20, 220, 160, 20)
     $idAboutLabe4 = GUICtrlCreateLabel("Scales", 20, 270, 160, 20)
     $idAboutLabe5 = GUICtrlCreateLabel("Pharmacy", 20, 320, 160, 20)

    ; Create a combobox control.
     $hCombo0 = GUICtrlCreateCombo("", 20, 90, 185, 20)
	 $hCombo1 = GUICtrlCreateCombo("", 20, 140, 185, 20)
	 $hCombo2 = GUICtrlCreateCombo("", 20, 190, 185, 20)
	 $hCombo3 = GUICtrlCreateCombo("", 20, 240, 185, 20)
	 $hCombo4 = GUICtrlCreateCombo("", 20, 290, 185, 20)
	 $hCombo5 = GUICtrlCreateCombo("", 20, 340, 185, 20)

	 $idCheckbox = GUICtrlCreateCheckbox("Continuous Ping", 30, 365, 100, 17)
	 $idCheckbox1 = GUICtrlCreateCheckbox("CMD", 150, 365, 100, 17)

    ; Add additional items to the combobox.
    GUICtrlSetData($hCombo0, "MXA|WL1|WL2|WL3|WL4|C1|C2|C3|Storage Array|Cache Server|V1|V2|V3|CC|DD|Time Clock|DIGI|UPS 1|UPS 2|Catalina|Amino|IBN|Voice Gateway|Backup Paging", "Select A Device") ;Server Room
	GUICtrlSetData($hCombo1, "FMC|BDR|A1|A2|Floral|HR|T2|T3|V1|Veribalance|MoneyGram|Customer Service|Concierge|Bakery") ;Pc's
	GUICtrlSetData($hCombo2, "FMC|BDR|Manager|Cash Office|HR|FTD|Concierge") ;Printers
    GUICtrlSetData($hCombo3, "Lane 1|Lane 2|Lane 3|Lane 4|Lane 5|Lane 6|Lane 7|Lane 8|Lane 9|Lane 10|Lane 11|Lane 12|Lane 13|Lane 14|Lane 15|Lane 23|Lane 24|Lane 28|Lane 29|Lane 33|Lane 34|Lane 36|Lane 38|Lane 40|Lane 45|Lane 47|Lane 48|SCO 50|SCO 51|SCO 52|SCO 53|SCO 54", "Select A Device") ;Lanes
    GUICtrlSetData($hCombo4, "--Meat--|Scale 1|Scale 2|Scale 3|Scale 4|Scale 5|Scale 6|Scale 7|Scale 8|Scale 9|Auto Wapper||--Seafood--|Scale 10|Scale 11|Scale 12|Scale 13|Scale 14||--Bakery--|Scale 15|Scale 16|Scale 17|Scale 18|Scale 19||--Deli--|Scale 20|Scale 21|Scale 22|Scale 23|Scale 24|Scale 25||--Floral--|Scale 32|Scale 33||--Produce--|Scale 34") ;Scales
    GUICtrlSetData($hCombo5, "B1|B2|B3|B4|B5|B6|RX 1|RX 2|RX 3|RX 4|Pharmnet 8|Pharmnet 9|Pharmnet 10|Pharmnet 11") ;Pharmacy

   $idButton_VLANS = GUICtrlCreateButton("VLAN's", 20, 390, 60, 25)
   $idButton_Change = GUICtrlCreateButton("Store #", 85, 390, 60, 25)
   $idButton_Close = GUICtrlCreateButton("Close", 150, 390, 60, 25)
   $idButton_Audit = GUICtrlCreateButton("Store Network Audit", 55, 420, 120, 25)

   $CPRL = GUICtrlCreateLabel("Albertsons Pinger", 30, 10, 400, 50)
   GUICtrlSetFont($CPRL, 17, $FW_NORMAL, $sFont)
   GUICtrlCreateLabel("",10,40,210,2,$SS_SUNKEN)



   $SNAME = GUICtrlCreateLabel("Store #" & $Store, 70, 45, 400, 20)
   GUICtrlSetFont($SNAME, 13, $FW_NORMAL, $sFont)

GUISetState(@SW_SHOW, $hGUI)


Func _IsChecked($idControlID)
    Return BitAND(GUICtrlRead($idControlID), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>_IsChecked

Func VLANCAL()
TCPStartup ()
$Store = Inputbox("Store Number", "Enter Store Number: ", "", " M4", 100, 130, Default, Default, "")

If $Store = 0 Then
   Exit
   EndIf

SplashTextOn("", "Please Wait...", 250, 65, -1, -1, $DLG_NOTITLE, "", 24)
$IP = "I" & $store
$output = TCPNameToIP ( $IP )
SplashOff()

If $output = 0 Then
   MsgBox($MB_SYSTEMMODAL, "", $store & " is an invalid store number or you are not on the Albertsons network.")
   Call("VLANCAL")
   EndIf

$Oct = StringSplit($output, ".")
For $i = 1 to $Oct[0]
$Oct[$i] = $Oct[$i]
Next

$n6 = ($Oct[2] - 64)
$n1 = ($Oct[3] - 1)
$n2 = ($Oct[3] - 2)
$n3 = ($Oct[3] - 3)
$VLAN24 = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "."
$VLAN16 = $Oct[1] & "." & $Oct[2] & "." & $n2 & "."
$VLAN19 = $Oct[1] & "." & $Oct[2] & "." & $n1 & "."
$VLAN70 = $Oct[1] & "." & $n6 & "." & $n3 & "."
$VLAN80 = $Oct[1] & "." & $n6 & "." & $n2 & "."
$VLAN85 = $Oct[1] & "." & $n6 & "." & $Oct[3] & "."
$VLAN95 = $Oct[1] & "." & $n6 & "." & $n1 & "."
$VLAN14 = $Oct[1] & "." & $Oct[2] & "." & $n3 & "."
$VLAN4 = $Oct[1] & "." & $Oct[2] & "." & $n3 & "."
$VLAN6 = $Oct[1] & "." & $Oct[2] & "." & $n3 & "."
$VLAN79 = $Oct[1] & "." & $n6 & "." & $n1 & "."
TCPShutdown()
EndFunc

Func PINGD()
   If _IsChecked($idCheckbox) Then
	  Run(@ComSpec & " /k" & "ping.exe " & $IP & " -t")
   ElseIf _IsChecked($idCheckbox1) Then
	  Run(@ComSpec & " /c" & "ping.exe " & $IP)
   Else
	  SplashTextOn("", "Please Wait...", 250, 65, -1, -1, $DLG_NOTITLE, "", 24)
	  $iPID = Run(@ComSpec & " /c" & "ping.exe -n 4 " & $IP, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	  ProcessWaitClose($iPID)
	  SplashOff()
	  Local $sOutput = StdoutRead($iPID)
	  MsgBox($MB_SYSTEMMODAL, "Ping Result", $sOutput)
   EndIf
EndFunc

Func Audit()
$SAGUI = GUICreate("Store " & $store & " Device Audit", 705, 665)
$idListview = GUICtrlCreateListView("Device|Host Name|IP Address|VLAN	|Status", 10, 10, 680, 620)
$hListView = GUICtrlGetHandle($idListView)
_GUICtrlListView_SetColumnWidth($idListview, 0, 170)
_GUICtrlListView_SetColumnWidth($idListview, 1, 265)
_GUICtrlListView_SetColumnWidth($idListview, 2, 100)
$idButton_CSA = GUICtrlCreateButton("Close", 630, 635, 60, 25)
$idButton_Export = GUICtrlCreateButton("Export To HTML", 530, 635, 100, 25)
$hCombo6 = GUICtrlCreateCombo("", 10, 635, 185, 20)
GUICtrlSetData($hCombo6, "--Select to Audit--|All Devices|Server Room|PCs|Printers|Lanes|Scales|Pharmacy", "--Select to Audit--")
GUISetState(@SW_SHOW, $SAGUI)
EndFunc

Func SERVER_AUDIT()
	$device = "MXA"
	 $IP = ("MX" & $store & "A")
	 Call("Audit_PING")

	$device = "WL1"
	 $IP = ($VLAN4 & "34")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "WL2"
	 $IP = ($VLAN4 & "35")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "WL3"
	 $IP = ($VLAN4 & "36")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "WL4"
	 $IP = ($VLAN4 & "43")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "C1"
	 $IP = ($VLAN4 & "37")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "C2"
	 $IP = ($VLAN4 & "44")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "C3"
	 $IP = ($VLAN4 & "45")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "Storage Array"
	 $IP = ($VLAN85 & "15")
    $vlan = ("VLAN4")
	 Call("Audit_PING")

	$device = "Cache Server"
	 $IP = ($VLAN14 & "249")
	 $vlan = ("VLAN14")
	 Call("Audit_PING")

	$device = "V1"
	 $IP = ($VLAN85 & "21")
	  $vlan = ("VLAN85")
	 Call("Audit_PING")

	$device = "V2"
	 $IP = ($VLAN85 & "22")
     $vlan = ("VLAN85")
	 Call("Audit_PING")

	$device = "V3"
	 $IP = ($VLAN85 & "23")
     $vlan = ("VLAN85")
	 Call("Audit_PING")

	$device = "CC"
	 $IP = ($VLAN24 & "5")
     $vlan = ("VLAN24")
	 Call("Audit_PING")

	$device = "DD"
	 $IP = ($VLAN24 & "6")
     $vlan = ("VLAN24")
	 Call("Audit_PING")

	$device = "Time Clock"
	$IP = ($VLAN24 & "24")
    $vlan = ("VLAN24")
	Call("Audit_PING")

	$device = "DIGI"
	$IP = ($VLAN24 & "12")
    $vlan = ("VLAN24")
	Call("Audit_PING")

	$device = "UPS 1"
	$IP = ($VLAN24 & "87")
    $vlan = ("VLAN24")
	Call("Audit_PING")

	$device = "UPS 2"
	$IP = ($VLAN24 & "88")
    $vlan = ("VLAN24")
	Call("Audit_PING")

	$device = "Catalina"
	$IP = ($VLAN19 & "241")
    $vlan = ("VLAN19")
	Call("Audit_PING")

	$device = "Amino"
	$IP = ($VLAN19 & "99")
    $vlan = ("VLAN19")
	Call("Audit_PING")

	$device = "IBN"
	$IP = ($VLAN6 & "78")
    $vlan = ("VLAN6")
	Call("Audit_PING")

	$device = "Voice Gateway"
	$IP = ($VLAN79 & "196")
    $vlan = ("VLAN79")
	Call("Audit_PING")

    $device = "Backup Paging"
	$IP = ($VLAN79 & "217")
    $vlan = ("VLAN79")
	Call("Audit_PING")
EndFunc

Func PC_AUDIT()
	  $device = "A1"
	  $IP = ($VLAN19 & "8")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "A2"
	  $IP = ($VLAN19 & "27")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "BDR"
	  $IP = ($VLAN19 & "30")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "FMC"
	  $IP = ($VLAN19 & "33")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "Veribalance"
	  $IP = ($VLAN19 & "194")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "T2"
	  $IP = ($VLAN19 & "21")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "T3"
	  $IP = ($VLAN19 & "95")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "V1"
	  $IP = ($VLAN19 & "185")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "HR"
	  $IP = ($VLAN19 & "195")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "Q1"
	  $IP = ($VLAN19 & "51")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "Floral"
	  $IP = ($VLAN19 & "20")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")

	  $device = "MoneyGram"
	  $IP = ($VLAN6 & "73")
	  $vlan = ("VLAN6")
	  Call("Audit_PING")

	  $device = "Customer Service"
	  $IP = ($VLAN24 & "31")
	  $vlan = ("VLAN24")
	  Call("Audit_PING")

	  $device = "Concierge"
	  $IP = ($VLAN24 & "30")
	  $vlan = ("VLAN24")
	  Call("Audit_PING")

	  $device = "Bakery"
	  $IP = ($VLAN19 & "35")
	  $vlan = ("VLAN19")
	  Call("Audit_PING")
 EndFunc

Func PRINTER_AUDIT()
		$device = "FMC Printer"
		$IP = ($VLAN95 & "135")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "BDR Printer"
		$IP = ($VLAN95 & "143")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Manager Printer"
		$IP = ($VLAN95 & "133")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Cash Office Printer"
		$IP = ($VLAN95 & "145")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "HR Printer"
		$IP = ($VLAN95 & "156")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Concierge Printer"
		$IP = ($VLAN95 & "149")
		$vlan = ("VLAN95")
		Call("Audit_PING")
EndFunc

Func LANE_AUDIT()
		$device = "Lane 1"
		$IP = ($VLAN24 & "101")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 2"
		$IP = ($VLAN24 & "102")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 3"
		$IP = ($VLAN24 & "103")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 4"
		$IP = ($VLAN24 & "104")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 5"
		$IP = ($VLAN24 & "105")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 6"
		$IP = ($VLAN24 & "106")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 7"
		$IP = ($VLAN24 & "107")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 8"
		$IP = ($VLAN24 & "108")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 9"
		$IP = ($VLAN24 & "109")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 10"
		$IP = ($VLAN24 & "110")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 11"
		$IP = ($VLAN24 & "111")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 12"
		$IP = ($VLAN24 & "112")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 13"
		$IP = ($VLAN24 & "113")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 14"
		$IP = ($VLAN24 & "114")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 15"
		$IP = ($VLAN24 & "115")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 23"
		$IP = ($VLAN24 & "123")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 24"
		$IP = ($VLAN24 & "124")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 28"
		$IP = ($VLAN24 & "128")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 29"
		$IP = ($VLAN24 & "129")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 33"
		$IP = ($VLAN24 & "133")
		$vlan = ("VLAN24")
		Call("Audit_PING")

	    $device = "Lane 34"
		$IP = ($VLAN24 & "134")
		$vlan = ("VLAN24")
		Call("Audit_PING")

	    $device = "Lane 36"
		$IP = ($VLAN24 & "136")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 38"
		$IP = ($VLAN24 & "138")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 40"
		$IP = ($VLAN24 & "140")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 45"
		$IP = ($VLAN24 & "145")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 47"
		$IP = ($VLAN24 & "147")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "Lane 48"
		$IP = ($VLAN24 & "148")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 50"
		$IP = ($VLAN24 & "150")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 51"
		$IP = ($VLAN24 & "151")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 52"
		$IP = ($VLAN24 & "152")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 53"
		$IP = ($VLAN24 & "153")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 54"
		$IP = ($VLAN24 & "154")
		$vlan = ("VLAN24")
		Call("Audit_PING")

		$device = "SCO 55"
		$IP = ($VLAN24 & "155")
		$vlan = ("VLAN24")
		Call("Audit_PING")
EndFunc

Func SCALE_AUDIT()
		$device = "Scale 1"
		$IP = ($VLAN80 & "200")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 2"
		$IP = ($VLAN80 & "201")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 3"
		$IP = ($VLAN80 & "202")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 4"
		$IP = ($VLAN80 & "203")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 5"
		$IP = ($VLAN80 & "204")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 6"
		$IP = ($VLAN80 & "205")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 7"
		$IP = ($VLAN80 & "206")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 8"
		$IP = ($VLAN80 & "207")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 9"
		$IP = ($VLAN80 & "208")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 10"
		$IP = ($VLAN80 & "209")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 11"
		$IP = ($VLAN80 & "210")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 12"
		$IP = ($VLAN80 & "211")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 13"
		$IP = ($VLAN80 & "212")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 14"
		$IP = ($VLAN80 & "213")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 15"
		$IP = ($VLAN80 & "214")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 16"
		$IP = ($VLAN80 & "215")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 17"
		$IP = ($VLAN80 & "216")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 18"
		$IP = ($VLAN80 & "217")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 19"
		$IP = ($VLAN80 & "218")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 20"
		$IP = ($VLAN80 & "219")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 21"
		$IP = ($VLAN80 & "220")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 22"
		$IP = ($VLAN80 & "221")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 23"
		$IP = ($VLAN80 & "222")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 24"
		$IP = ($VLAN80 & "223")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 25"
		$IP = ($VLAN80 & "224")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 32"
		$IP = ($VLAN80 & "231")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 33"
		$IP = ($VLAN80 & "232")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Scale 34"
		$IP = ($VLAN80 & "233")
		$vlan = ("VLAN80")
		Call("Audit_PING")

		$device = "Auto Wapper"
		$IP = ($VLAN19 & "200")
		$vlan = ("VLAN19")
		Call("Audit_PING")
EndFunc

Func RX_AUDIT()
		$device = "B1"
		$IP = ($VLAN70 & "98")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B2"
		$IP = ($VLAN70 & "99")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B3"
		$IP = ($VLAN70 & "100")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B4"
		$IP = ($VLAN70 & "101")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B5"
		$IP = ($VLAN70 & "102")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B6"
		$IP = ($VLAN70 & "103")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "B7"
		$IP = ($VLAN70 & "104")
		$vlan = ("VLAN70")
		Call("Audit_PING")

		$device = "RX 1"
		$IP = ($VLAN95 & "134")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "RX 2"
		$IP = ($VLAN95 & "136")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "RX 3"
		$IP = ($VLAN95 & "137")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Pharmnet 8"
		$IP = ($VLAN95 & "147")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Pharmnet 9"
		$IP = ($VLAN95 & "148")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Pharmnet 10"
		$IP = ($VLAN95 & "150")
		$vlan = ("VLAN95")
		Call("Audit_PING")

		$device = "Pharmnet 11"
		$IP = ($VLAN95 & "151")
		$vlan = ("VLAN95")
		Call("Audit_PING")
EndFunc

Func Audit_PING()
   TCPStartup()
   Local $statC = 0
   SplashTextOn("", $device, 300, 65, -1, -1, $DLG_NOTONTOP, "", 24)
   $iPID = Run(@ComSpec & " /k" & "ping.exe -n 1 " & $IP, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
   $host = _TCPIpToName($IP)
   ProcessWaitClose($iPID)
   SplashOff()
   Local $sOutput = StdoutRead($iPID)
   Local $ms = StringInStr($sOutput, "ms")

   If $ms = 0 Then
	  $status = ("Offline")
	  GUICtrlSetDefBkColor(0xFF0000)
   Else
	  $status = ("Online")
	  GUICtrlSetDefBkColor(0x00FF00)
   EndIf

   Local $idItem1 = GUICtrlCreateListViewItem($device & "|" & $host & "|" & $IP & "|" & $VLAN & "|" & $status , $idListview)
   _GUICtrlListView_Scroll($idListview, 0, 500)
EndFunc

Func VLAN_DISPLAY()
MsgBox($MB_SYSTEMMODAL, "Store " & $store & " Vlan's", @CRLF _
	  & "VLAN  4: " & $VLAN4   & "X" & @CRLF _
									& @CRLF _
	  & "VLAN  6: " & $VLAN6   & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 14: " & $VLAN14 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 16: " & $VLAN16 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 19: " & $VLAN19 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 24: " & $VLAN24 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 70: " & $VLAN70 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 79: " & $VLAN79 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 80: " & $VLAN80 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 85: " & $VLAN85 & "X" & @CRLF _
									& @CRLF _
	  & "VLAN 95: " & $VLAN95 & "X" & @CRLF _
)
EndFunc

While 1

    Switch GUIGetMsg()
	  Case $GUI_EVENT_CLOSE, $idButton_Close
            Exit

	  Case $idButton_VLANS
			   Call("VLAN_DISPLAY")

	  Case $idButton_Change
			   Call("VLANCAL")
			   GUICtrlSetData($SNAME, "Store #" & $Store)

	  Case $idButton_Audit
			   Call("Audit")

	  Case $idButton_CSA
			   GUIDelete($SAGUI)

	  Case $idButton_Export
			   $sPrintOut = _GUICtrlListView_SaveHTML($hListview, @ScriptDir & "\Export.html", "http://www.autoitscript.com/forum")
			   ShellExecute($sPrintOut)

	  Case $hCombo0
            Switch GUICtrlRead($hCombo0)
                Case "MXA"
					 $IP = ("MX" & $store & "A")
					 Call("PINGD")
                Case "WL1"
					 $IP = ("S" & $store & "WL1")
					 Call("PINGD")
                Case "WL2"
					 $IP = ("S" & $store & "WL2")
					 Call("PINGD")
			    Case "WL3"
					 $IP = ("S" & $store & "WL3")
					 Call("PINGD")
			    Case "WL4"
					 $IP = ("S" & $store & "WL4")
					 Call("PINGD")
			    Case "C1"
					 $IP = ("S" & $store & "C1")
					 Call("PINGD")
			    Case "C2"
					 $IP = ("S" & $store & "C2")
					 Call("PINGD")
			    Case "C3"
					 $IP = ("S" & $store & "C3")
					 Call("PINGD")
			    Case "Storage Array"
					 $IP = ("B" & $store & "A")
					 Call("PINGD")
			    Case "Cache Server"
					 $IP = ($VLAN14 & "249")
					 Call("PINGD")
			    Case "V1"
					 $IP = ("B" & $store & "V1")
					 Call("PINGD")
			    Case "V2"
					 $IP = ("B" & $store & "V2")
					 Call("PINGD")
			    Case "V3"
					 $IP = ("B" & $store & "V3")
					 Call("PINGD")
			    Case "CC"
					 $IP = ("CC" & $store)
					 Call("PINGD")
			    Case "DD"
					 $IP = ("DD" & $store)
					 Call("PINGD")
                Case "Time Clock"
					$IP = ($VLAN24 & "24")
					Call("PINGD")
			    Case "DIGI"
					$IP = ($VLAN24 & "12")
					Call("PINGD")
			    Case "UPS 1"
					$IP = ($VLAN24 & "87")
					Call("PINGD")
			    Case "UPS 2"
					$IP = ($VLAN24 & "88")
					Call("PINGD")
			    Case "Catalina"
					$IP = ($VLAN19 & "241")
					Call("PINGD")
			    Case "Amino"
					$IP = ($VLAN19 & "99")
					Call("PINGD")
			    Case "IBN"
					$IP = ($VLAN6 & "78")
					Call("PINGD")
			    Case "Voice Gateway"
					$IP = ($VLAN79& "196")
					Call("PINGD")
			    Case "Backup Paging"
					$IP = ($VLAN79 & "217")
					Call("PINGD")
				 EndSwitch

	  Case $hCombo1
            Switch GUICtrlRead($hCombo1)
			    Case "A1"
					$IP = ($VLAN19 & "8")
					Call("PINGD")
			    Case "A2"
					$IP = ($VLAN19 & "27")
					Call("PINGD")
			    Case "BDR"
					$IP = ($VLAN19 & "30")
					Call("PINGD")
			    Case "FMC"
					$IP = ($VLAN19 & "33")
					Call("PINGD")
			    Case "Veribalance"
					$IP = ($VLAN19 & "194")
					Call("PINGD")
			    Case "T2"
					$IP = ($VLAN19 & "21")
					Call("PINGD")
			    Case "T3"
					$IP = ($VLAN19 & "95")
					Call("PINGD")
			    Case "V1"
					$IP = ($VLAN19 & "185")
					Call("PINGD")
			    Case "Q1"
					$IP = ($VLAN19 & "51")
					Call("PINGD")
			    Case "HR"
					$IP = ($VLAN19 & "195")
					Call("PINGD")
			    Case "Floral"
					$IP = ($VLAN19 & "20")
					Call("PINGD")
			    Case "MoneyGram"
					$IP = ($VLAN6 & "73")
					Call("PINGD")
			    Case "Customer Service"
					$IP = ($VLAN24 & "31")
					Call("PINGD")
			    Case "Concierge"
					$IP = ($VLAN24 & "30")
					Call("PINGD")
			    Case "Bakery"
					$IP = ($VLAN19 & "35")
					Call("PINGD")
			   EndSwitch

	  Case $hCombo2
            Switch GUICtrlRead($hCombo2)
			    Case "FMC"
					$IP = ($VLAN95 & "135")
					Call("PINGD")
			    Case "BDR"
					$IP = ($VLAN95 & "143")
					Call("PINGD")
			    Case "Manager"
					$IP = ($VLAN95 & "133")
					Call("PINGD")
			    Case "Cash Office"
					$IP = ($VLAN95 & "145")
					Call("PINGD")
			    Case "HR"
					$IP = ($VLAN95 & "156")
					Call("PINGD")
			    Case "Concierge"
					$IP = ($VLAN95 & "149")
					Call("PINGD")
				 EndSwitch

	  Case $hCombo3
            Switch GUICtrlRead($hCombo3)
			    Case "Lane 1"
					$IP = ($VLAN24 & "101")
					Call("PINGD")
			    Case "Lane 2"
					$IP = ($VLAN24 & "102")
					Call("PINGD")
			    Case "Lane 3"
					$IP = ($VLAN24 & "103")
					Call("PINGD")
			    Case "Lane 4"
					$IP = ($VLAN24 & "104")
					Call("PINGD")
			    Case "Lane 5"
					$IP = ($VLAN24 & "105")
					Call("PINGD")
			    Case "Lane 6"
					$IP = ($VLAN24 & "106")
					Call("PINGD")
			    Case "Lane 7"
					$IP = ($VLAN24 & "107")
					Call("PINGD")
			    Case "Lane 8"
					$IP = ($VLAN24 & "108")
					Call("PINGD")
			    Case "Lane 9"
					$IP = ($VLAN24 & "109")
					Call("PINGD")
			    Case "Lane 10"
					$IP = ($VLAN24 & "110")
					Call("PINGD")
			    Case "Lane 11"
					$IP = ($VLAN24 & "111")
					Call("PINGD")
			    Case "Lane 12"
					$IP = ($VLAN24 & "112")
					Call("PINGD")
			    Case "Lane 13"
					$IP = ($VLAN24 & "113")
					Call("PINGD")
			    Case "Lane 14"
					$IP = ($VLAN24 & "114")
					Call("PINGD")
			    Case "Lane 15"
					$IP = ($VLAN24 & "115")
					Call("PINGD")
			    Case "Lane 23"
					$IP = ($VLAN24 & "123")
					Call("PINGD")
			    Case "Lane 24"
					$IP = ($VLAN24 & "124")
					Call("PINGD")
			    Case "Lane 28"
					$IP = ($VLAN24 & "128")
					Call("PINGD")
			    Case "Lane 29"
					$IP = ($VLAN24 & "129")
					Call("PINGD")
			    Case "Lane 33"
					$IP = ($VLAN24 & "133")
					Call("PINGD")
			    Case "Lane 34"
					$IP = ($VLAN24 & "134")
					Call("PINGD")
			    Case "Lane 36"
					$IP = ($VLAN24 & "136")
					Call("PINGD")
			    Case "Lane 38"
					$IP = ($VLAN24 & "138")
					Call("PINGD")
			    Case "Lane 40"
					$IP = ($VLAN24 & "140")
					Call("PINGD")
			    Case "Lane 45"
					$IP = ($VLAN24 & "145")
					Call("PINGD")
			    Case "Lane 47"
					$IP = ($VLAN24 & "147")
					Call("PINGD")
			    Case "Lane 48"
					$IP = ($VLAN24 & "148")
					Call("PINGD")
			    Case "SCO 50"
					$IP = ($VLAN24 & "150")
					Call("PINGD")
			    Case "SCO 51"
					$IP = ($VLAN24 & "151")
					Call("PINGD")
			    Case "SCO 52"
					$IP = ($VLAN24 & "152")
					Call("PINGD")
			    Case "SCO 53"
					$IP = ($VLAN24 & "153")
					Call("PINGD")
			    Case "SCO 54"
					$IP = ($VLAN24 & "154")
					Call("PINGD")
			    Case "SCO 55"
					$IP = ($VLAN24 & "155")
					Call("PINGD")
				 EndSwitch

	  Case $hCombo4
            Switch GUICtrlRead($hCombo4)
			    Case "Scale 1"
					$IP = ($VLAN80 & "200")
					Call("PINGD")
			    Case "Scale 2"
					$IP = ($VLAN80 & "201")
					Call("PINGD")
			    Case "Scale 3"
					$IP = ($VLAN80 & "202")
					Call("PINGD")
			    Case "Scale 4"
					$IP = ($VLAN80 & "203")
					Call("PINGD")
			    Case "Scale 5"
					$IP = ($VLAN80 & "204")
					Call("PINGD")
			    Case "Scale 6"
					$IP = ($VLAN80 & "205")
					Call("PINGD")
			    Case "Scale 7"
					$IP = ($VLAN80 & "206")
					Call("PINGD")
			    Case "Scale 8"
					$IP = ($VLAN80 & "207")
					Call("PINGD")
			    Case "Scale 9"
					$IP = ($VLAN80 & "208")
					Call("PINGD")
			    Case "Scale 10"
					$IP = ($VLAN80 & "209")
					Call("PINGD")
			    Case "Scale 11"
					$IP = ($VLAN80 & "210")
					Call("PINGD")
			    Case "Scale 12"
					$IP = ($VLAN80 & "211")
					Call("PINGD")
			    Case "Scale 13"
					$IP = ($VLAN80 & "212")
					Call("PINGD")
			    Case "Scale 14"
					$IP = ($VLAN80 & "213")
					Call("PINGD")
			    Case "Scale 15"
					$IP = ($VLAN80 & "214")
					Call("PINGD")
			    Case "Scale 16"
					$IP = ($VLAN80 & "215")
					Call("PINGD")
			    Case "Scale 17"
					$IP = ($VLAN80 & "216")
					Call("PINGD")
			    Case "Scale 18"
					$IP = ($VLAN80 & "217")
					Call("PINGD")
			    Case "Scale 19"
					$IP = ($VLAN80 & "218")
					Call("PINGD")
			    Case "Scale 20"
					$IP = ($VLAN80 & "219")
					Call("PINGD")
			    Case "Scale 21"
					$IP = ($VLAN80 & "220")
					Call("PINGD")
			    Case "Scale 22"
					$IP = ($VLAN80 & "221")
					Call("PINGD")
			    Case "Scale 23"
					$IP = ($VLAN80 & "222")
					Call("PINGD")
			    Case "Scale 24"
					$IP = ($VLAN80 & "223")
					Call("PINGD")
			    Case "Scale 25"
					$IP = ($VLAN80 & "224")
					Call("PINGD")
			    Case "Scale 32"
					$IP = ($VLAN80 & "231")
					Call("PINGD")
			    Case "Scale 33"
					$IP = ($VLAN80 & "232")
					Call("PINGD")
			    Case "Scale 34"
					$IP = ($VLAN80 & "233")
					Call("PINGD")
			    Case "Auto Wapper"
					$IP = ($VLAN19 & "200")
					Call("PINGD")
				 EndSwitch

	  Case $hCombo5
            Switch GUICtrlRead($hCombo5)
			    Case "B1"
					$IP = ($VLAN70 & "98")
					Call("PINGD")
			    Case "B2"
					$IP = ($VLAN70 & "99")
					Call("PINGD")
			    Case "B3"
					$IP = ($VLAN70 & "100")
					Call("PINGD")
			    Case "B4"
					$IP = ($VLAN70 & "101")
					Call("PINGD")
			    Case "B5"
					$IP = ($VLAN70 & "102")
					Call("PINGD")
			    Case "B6"
					$IP = ($VLAN70 & "103")
					Call("PINGD")
			    Case "B7"
					$IP = ($VLAN70 & "104")
					Call("PINGD")
			    Case "RX 1"
					$IP = ($VLAN95 & "134")
					Call("PINGD")
			    Case "RX 2"
					$IP = ($VLAN95 & "136")
					Call("PINGD")
			    Case "RX 3"
					$IP = ($VLAN95 & "137")
					Call("PINGD")
			    Case "Pharmnet 8"
					$IP = ($VLAN95 & "147")
					Call("PINGD")
			    Case "Pharmnet 9"
					$IP = ($VLAN95 & "148")
					Call("PINGD")
			    Case "Pharmnet 10"
					$IP = ($VLAN95 & "150")
					Call("PINGD")
			    Case "Pharmnet 11"
					$IP = ($VLAN95 & "151")
					Call("PINGD")
				 EndSwitch

	  Case $hCombo6
            Switch GUICtrlRead($hCombo6)
			Case "All Devices"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   SERVER_AUDIT()
			   PC_AUDIT()
			   PRINTER_AUDIT()
			   LANE_AUDIT()
			   SCALE_AUDIT()
			   RX_AUDIT()

			Case "Server Room"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   SERVER_AUDIT()

			Case "PCs"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   PC_AUDIT()

			Case "Printers"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   PRINTER_AUDIT()

			Case "Lanes"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   LANE_AUDIT()

			Case "Scales"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   SCALE_AUDIT()

			Case "Pharmacy"
			   _GUICtrlListView_DeleteAllItems($idListview)
			   RX_AUDIT()
			   EndSwitch

    EndSwitch

WEnd




