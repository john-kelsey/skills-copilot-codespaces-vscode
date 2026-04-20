# Azani ISP – Form VBA Code Reference
### KCSE 2026 – Computer Studies Paper 3

This file contains ready-to-paste VBA **event procedures** for each
Microsoft Access form you create in the Azani ISP database.

---

## How to add VBA to a form
1. Open the form in **Design View**.
2. Select the control (button, text box, etc.).
3. Open its **Property Sheet** → **Event** tab.
4. Click `[…]` next to the event you want → choose **Code Builder**.
5. Paste the procedure body between the `Private Sub … End Sub` lines
   that Access generates for you.

---

## Form 1 – frmRegisterInstitution
Allows staff to register a new institution and record the registration fee.

```vba
' ── On Open: pre-fill defaults ──────────────────────────────────────
Private Sub Form_Open(Cancel As Integer)
    Me.RegistrationFee.Value   = REGISTRATION_FEE    ' 8500
    Me.RegistrationDate.Value  = Date
    Me.ServiceStatus.Value     = "Registered"
    Me.IsReadyForInstall.Value = False
End Sub

' ── IsReadyForInstall checkbox: show/hide InstallationDate ──────────
Private Sub IsReadyForInstall_AfterUpdate()
    If Me.IsReadyForInstall Then
        Me.InstallationDate.Enabled = True
        Me.InstallationFee.Value    = INSTALLATION_FEE   ' 10000
    Else
        Me.InstallationDate.Enabled = False
        Me.InstallationDate.Value   = Null
        Me.InstallationFee.Value    = 0
    End If
End Sub

' ── Save button ──────────────────────────────────────────────────────
Private Sub cmdSave_Click()
    ' Validate required fields
    If IsNull(Me.InstitutionName) Or Me.InstitutionName = "" Then
        MsgBox "Institution Name is required.", vbExclamation
        Me.InstitutionName.SetFocus
        Exit Sub
    End If
    If IsNull(Me.Category) Or Me.Category = "" Then
        MsgBox "Category is required.", vbExclamation
        Me.Category.SetFocus
        Exit Sub
    End If
    If IsNull(Me.ContactPersonName) Or Me.ContactPersonName = "" Then
        MsgBox "Contact Person Name is required.", vbExclamation
        Me.ContactPersonName.SetFocus
        Exit Sub
    End If

    ' Save the record
    DoCmd.RunCommand acCmdSaveRecord

    ' Record registration payment automatically
    Dim newID As Long
    newID = Me.InstitutionID        ' AutoNumber just assigned
    Call RecordPayment(newID, Null, "Registration", REGISTRATION_FEE, _
                       "Cash", "REG-" & newID, "Clerk", "")

    MsgBox "Institution registered. Registration fee of " & _
           FormatKSh(REGISTRATION_FEE) & " recorded.", _
           vbInformation, "Registration Complete"
End Sub

' ── Cancel button ────────────────────────────────────────────────────
Private Sub cmdCancel_Click()
    DoCmd.RunCommand acCmdUndo
    DoCmd.Close
End Sub
```

---

## Form 2 – frmInfrastructure
Records PCs and LAN nodes purchased by an institution.

```vba
' ── After entering the number of PCs: auto-calculate PC cost ────────
Private Sub NumPCsPurchased_AfterUpdate()
    Me.PCUnitCost.Value   = PC_UNIT_COST
    Me.TotalPCCost.Value  = CalcTotalPCCost(Nz(Me.NumPCsPurchased, 0))
    Call UpdateInfraTotals
End Sub

' ── After entering LAN nodes: look up tier and calculate cost ────────
Private Sub LANNodesBought_AfterUpdate()
    Dim nodes As Integer
    nodes = Nz(Me.LANNodesBought, 0)

    If nodes > 0 Then
        Me.LANTierID.Value       = GetLANTierID(nodes)
        Me.LANNodeUnitCost.Value = GetLANNodeUnitCost(nodes)
        Me.TotalLANCost.Value    = CalcTotalLANCost(nodes)
    Else
        Me.LANTierID.Value       = Null
        Me.LANNodeUnitCost.Value = 0
        Me.TotalLANCost.Value    = 0
    End If
    Call UpdateInfraTotals
End Sub

' ── Helper: refresh TotalInfraCost ───────────────────────────────────
Private Sub UpdateInfraTotals()
    Me.TotalInfraCost.Value = CalcTotalInfraCost( _
        Nz(Me.NumPCsPurchased, 0), _
        Nz(Me.LANNodesBought, 0))
End Sub

' ── Save and record infrastructure payment ───────────────────────────
Private Sub cmdSave_Click()
    If IsNull(Me.InstitutionID) Then
        MsgBox "Please select an institution.", vbExclamation
        Exit Sub
    End If

    DoCmd.RunCommand acCmdSaveRecord

    Dim total As Currency
    total = Nz(Me.TotalInfraCost, 0)
    If total > 0 Then
        Call RecordPayment(Me.InstitutionID, Null, "Infrastructure", total, _
                           "Cash", "INF-" & Me.InfraID, "Clerk", _
                           Nz(Me.Notes, ""))
        MsgBox "Infrastructure cost of " & FormatKSh(total) & " recorded.", _
               vbInformation, "Saved"
    End If
End Sub
```

---

## Form 3 – frmSubscription
Registers a bandwidth subscription (new or upgrade).

```vba
' ── On Open ──────────────────────────────────────────────────────────
Private Sub Form_Open(Cancel As Integer)
    Me.SubscriptionDate.Value  = Date
    Me.IsUpgraded.Value        = False
    Me.IsActive.Value          = True
    Me.DiscountPercent.Value   = 0
    Me.DiscountAmount.Value    = 0
End Sub

' ── IsUpgraded checkbox ──────────────────────────────────────────────
Private Sub IsUpgraded_AfterUpdate()
    If Me.IsUpgraded Then
        Me.PreviousBandwidthID.Enabled = True
        Me.UpgradeDate.Enabled         = True
        Me.DiscountPercent.Value       = 10
    Else
        Me.PreviousBandwidthID.Enabled = False
        Me.PreviousBandwidthID.Value   = Null
        Me.UpgradeDate.Enabled         = False
        Me.UpgradeDate.Value           = Null
        Me.DiscountPercent.Value       = 0
    End If
    Call RefreshRates
End Sub

' ── BandwidthID combo: look up the base rate ─────────────────────────
Private Sub BandwidthID_AfterUpdate()
    Dim rs As DAO.Recordset
    Set rs = CurrentDb.OpenRecordset( _
        "SELECT MonthlyRate FROM tblBandwidth WHERE BandwidthID=" & _
        Me.BandwidthID, dbOpenSnapshot)
    If Not rs.EOF Then
        Me.BaseMonthlyRate.Value = rs!MonthlyRate
    End If
    rs.Close
    Set rs = Nothing
    Call RefreshRates
End Sub

' ── Helper: calculate and display effective rate ─────────────────────
Private Sub RefreshRates()
    Dim base As Currency
    base = Nz(Me.BaseMonthlyRate, 0)
    Me.DiscountAmount.Value       = CalcDiscountAmount(base, Me.IsUpgraded)
    Me.EffectiveMonthlyRate.Value = CalcEffectiveMonthlyRate(base, Me.IsUpgraded)
End Sub

' ── Save ─────────────────────────────────────────────────────────────
Private Sub cmdSave_Click()
    If IsNull(Me.InstitutionID) Then
        MsgBox "Please select an institution.", vbExclamation
        Exit Sub
    End If
    If IsNull(Me.BandwidthID) Then
        MsgBox "Please select a bandwidth tier.", vbExclamation
        Exit Sub
    End If
    DoCmd.RunCommand acCmdSaveRecord
    MsgBox "Subscription saved. Monthly charge: " & _
           FormatKSh(Me.EffectiveMonthlyRate), vbInformation, "Saved"
End Sub
```

---

## Form 4 – frmGenerateBill
Staff use this to create a monthly bill for one institution.

```vba
' ── On Open: default to current month ────────────────────────────────
Private Sub Form_Open(Cancel As Integer)
    Me.txtBillingMonth.Value = Month(Date)
    Me.txtBillingYear.Value  = Year(Date)
End Sub

' ── Generate Bill button ─────────────────────────────────────────────
Private Sub cmdGenerate_Click()
    If IsNull(Me.cboInstitution) Then
        MsgBox "Please select an institution.", vbExclamation
        Exit Sub
    End If
    If IsNull(Me.cboSubscription) Then
        MsgBox "Please select a subscription.", vbExclamation
        Exit Sub
    End If

    Dim newBillID As Long
    newBillID = GenerateMonthlyBill( _
        Me.cboInstitution, _
        Me.cboSubscription, _
        Me.txtBillingMonth, _
        Me.txtBillingYear)

    If newBillID > 0 Then
        Me.txtNewBillID.Value = newBillID
    End If
End Sub

' ── Generate bills for ALL active institutions ────────────────────────
Private Sub cmdGenerateAll_Click()
    If MsgBox("Generate bills for ALL active institutions for " & _
              MonthName(Me.txtBillingMonth) & " " & Me.txtBillingYear & "?", _
              vbYesNo + vbQuestion, "Confirm Batch Billing") = vbYes Then
        Call GenerateBillsForAllActive(Me.txtBillingMonth, Me.txtBillingYear)
    End If
End Sub
```

---

## Form 5 – frmRecordPayment
Used to record any payment against a bill.

```vba
' ── On Open ──────────────────────────────────────────────────────────
Private Sub Form_Open(Cancel As Integer)
    Me.txtPaymentDate.Value = Date
End Sub

' ── Bill combo: show amount due ──────────────────────────────────────
Private Sub cboBillID_AfterUpdate()
    If Not IsNull(Me.cboBillID) Then
        Dim rs As DAO.Recordset
        Set rs = CurrentDb.OpenRecordset( _
            "SELECT TotalAmountDue, PaidAmount FROM tblMonthlyBills " & _
            "WHERE BillID=" & Me.cboBillID, dbOpenSnapshot)
        If Not rs.EOF Then
            Me.txtTotalDue.Value    = rs!TotalAmountDue
            Me.txtAlreadyPaid.Value = rs!PaidAmount
            Me.txtBalanceDue.Value  = rs!TotalAmountDue - rs!PaidAmount
            Me.txtAmountPaid.Value  = rs!TotalAmountDue - rs!PaidAmount
        End If
        rs.Close
        Set rs = Nothing
    End If
End Sub

' ── Save payment ─────────────────────────────────────────────────────
Private Sub cmdSave_Click()
    If IsNull(Me.cboInstitution) Then
        MsgBox "Please select an institution.", vbExclamation
        Exit Sub
    End If
    If IsNull(Me.cboPaymentType) Then
        MsgBox "Please select a payment type.", vbExclamation
        Exit Sub
    End If
    If Nz(Me.txtAmountPaid, 0) <= 0 Then
        MsgBox "Amount Paid must be greater than 0.", vbExclamation
        Exit Sub
    End If

    Call RecordPayment( _
        Me.cboInstitution, _
        Me.cboBillID, _
        Me.cboPaymentType, _
        Me.txtAmountPaid, _
        Nz(Me.cboPaymentMethod, "Cash"), _
        Nz(Me.txtReference, ""), _
        Nz(Me.txtReceivedBy, ""), _
        Nz(Me.txtNotes, ""))
End Sub
```

---

## Form 6 – frmBillingAdmin
Administrative form for overdue processing and disconnections.

```vba
' ── Mark selected bill as Overdue ────────────────────────────────────
Private Sub cmdMarkOverdue_Click()
    If IsNull(Me.cboBillID) Then
        MsgBox "Please select a bill.", vbExclamation
        Exit Sub
    End If
    Call MarkBillOverdue(Me.cboBillID)
    Me.Requery
End Sub

' ── Disconnect institution linked to selected bill ────────────────────
Private Sub cmdDisconnect_Click()
    If IsNull(Me.cboBillID) Then
        MsgBox "Please select a bill.", vbExclamation
        Exit Sub
    End If
    If MsgBox("Disconnect the institution for BillID " & Me.cboBillID & "?", _
              vbYesNo + vbCritical, "Confirm Disconnection") = vbYes Then
        Call DisconnectInstitution(Me.cboBillID)
        Me.Requery
    End If
End Sub

' ── Reconnect institution linked to selected bill ─────────────────────
Private Sub cmdReconnect_Click()
    If IsNull(Me.cboBillID) Then
        MsgBox "Please select a bill.", vbExclamation
        Exit Sub
    End If
    If MsgBox("Reconnect the institution for BillID " & Me.cboBillID & "?", _
              vbYesNo + vbQuestion, "Confirm Reconnection") = vbYes Then
        Call ReconnectInstitution(Me.cboBillID)
        Me.Requery
    End If
End Sub

' ── Process all overdue bills in one click ────────────────────────────
Private Sub cmdProcessAllOverdue_Click()
    If MsgBox("Mark ALL eligible unpaid bills as Overdue?", _
              vbYesNo + vbQuestion, "Batch Overdue") = vbYes Then
        Call ProcessOverdueBills
        Me.Requery
    End If
End Sub
```

---

## Quick-reference: module functions you can call anywhere

| Function / Sub | What it does |
|---|---|
| `GetLANTierID(numNodes)` | Returns the LANTierID for a node count |
| `GetLANNodeUnitCost(numNodes)` | Returns cost per node (KSh) |
| `GetLANTierDescription(numNodes)` | Returns tier label string |
| `CalcTotalPCCost(numPCs)` | `numPCs × 40,000` |
| `CalcTotalLANCost(numNodes)` | `numNodes × tier cost` |
| `CalcTotalInfraCost(numPCs, numNodes)` | PC cost + LAN cost |
| `CalcEffectiveMonthlyRate(baseRate, isUpgraded)` | Applies 10 % discount |
| `CalcDiscountAmount(baseRate, isUpgraded)` | Discount amount |
| `CalcOverdueFine(monthlyCharge)` | 15 % fine |
| `CalcTotalAmountDue(charge, addFine, addReconnect)` | Full bill total |
| `GenerateMonthlyBill(instID, subID, month, year)` | Creates one bill |
| `GenerateBillsForAllActive(month, year)` | Batch: all active institutions |
| `MarkBillOverdue(billID)` | Applies 15 % fine, sets Overdue |
| `ProcessOverdueBills()` | Batch: marks all eligible bills Overdue |
| `DisconnectInstitution(billID)` | Disconnects + adds KSh 1,000 fee |
| `ReconnectInstitution(billID)` | Reconnects + sets Active |
| `RecordPayment(instID, billID, type, amount, …)` | Inserts payment row |
| `FormatKSh(amount)` | Returns `"KSh 1,000.00"` string |
| `GetInstitutionSummary(instID)` | One-line institution summary |
