#Include Once "utilUDT.bas"
#Include Once "linklist.bas"

Type stackUDT extends utilUDT
	Private:
		As list_type list = 1
		As UInteger stackLimit
		As UByte modus = 1 ' 1=LastIn-FirstOut 2=FirstIn-FirstOut
		As Any Ptr mutex
	Public:
		Declare Constructor(stackLimit As UInteger=0)
		Declare Destructor
		
		Declare Function getStackLimit As Uinteger
		Declare Function getStackSize As Uinteger
		Declare Sub setLIFO
		Declare Sub setFIFO
		Declare Sub free
		Declare Sub push(item As utilUDT Ptr)
		Declare Function pop As utilUDT ptr
End Type

Constructor stackUDT(stackLimit As UInteger=0)
	mutex = MutexCreate
	this.stackLimit = stackLimit
End Constructor

Destructor stackUDT
	MutexLock mutex
	MutexUnLock mutex
	MutexDestroy mutex
End Destructor

Function stackUDT.getStackLimit As UInteger
	MutexLock mutex
	dim as UInteger tmp = stackLimit
	MutexUnLock mutex
	return tmp
End Function

Function stackUDT.getStackSize As UInteger
	MutexLock mutex
	Dim As UInteger tmp = list.itemCount
	MutexunLock mutex
	Return tmp
End Function

Sub stackUDT.setLIFO
	modus = 1
End Sub

Sub stackUDT.setFIFO
	modus = 2
End Sub

Sub stackUDT.free
	list.clear
End Sub

Sub stackUDT.push(item As utilUDT Ptr)
	If item = 0 Then Return
	MutexLock mutex
	If stackLimit=0 Or list.itemcount+1<stackLimit Then
		list.add(item,1)
	EndIf
	MutexUnLock mutex
End Sub

Function stackUDT.pop As utilUDT Ptr
	Dim As utilUDT Ptr tmp
	MutexLock mutex
	Select Case modus
		Case 1
			list.resetB(1)
			tmp = list.getItem(1)
			list.remove(tmp,1)
		Case 2
			list.reset(1)
			tmp = list.getItem()
			list.remove(tmp,1)
	End Select
	MutexUnLock mutex
	Return tmp
End Function

'Dim Shared As stackUDT tmp
'Dim Shared As UtilUDT Ptr tmpOut
'Dim Shared As UtilUDT Ptr tmpIn
'tmpIn = New utilUDT
'
'Sub push(x As Any Ptr)
'	For i As Integer = 1 To 1000000
'	tmp.push(tmpIn)
'	next
'End Sub
'
'Sub pop(x As Any Ptr)
'	For i As Integer = 1 To 1000000
'	tmpOut = tmp.pop
'	next
'End Sub
'
'
'
'Dim As Double zeit,diff,sum,comTime
'Dim As Integer count
'comTime = timer
'	zeit = Timer
'	Var t1 = ThreadCreate(@push)
'	Var t2 = ThreadCreate(@pop)
'	
'	ThreadWait t1
'	ThreadWait t2
'	diff = Timer - zeit
'
'Print diff
'
'Sleep
