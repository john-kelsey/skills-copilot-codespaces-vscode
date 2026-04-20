Attribute VB_Name = "modAzaniISP"
' ============================================================
' AZANI INTERNET SERVICE PROVIDER INFORMATION SYSTEM
' KCSE 2026 – Computer Studies Paper 3
' VBA MODULE: modAzaniISP
'
' HOW TO IMPORT INTO MICROSOFT ACCESS:
'   1. Open AzaniISP.accdb.
'   2. Press Alt + F11 to open the VBA Editor.
'   3. In the menu choose File → Import File…
'   4. Browse to this file (modAzaniISP.bas) and click Open.
'   5. The module "modAzaniISP" appears in the Project pane.
'   6. Press F5 (or run via a button) to call any procedure.
' ============================================================
Option Compare Database
Option Explicit

' ============================================================
' SECTION 1 – BUSINESS CONSTANTS
' ============================================================
Public Const REGISTRATION_FEE   As Currency = 8500
Public Const INSTALLATION_FEE   As Currency = 10000
Public Const PC_UNIT_COST        As Currency = 40000
Public Const UPGRADE_DISCOUNT    As Double   = 0.1    ' 10%
Public Const OVERDUE_FINE_RATE   As Double   = 0.15   ' 15%
Public Const RECONNECTION_FEE    As Currency = 1000
Public Const DISCONNECTION_DAY   As Integer  = 10     ' 10th of the following month


' ============================================================
' SECTION 2 – LAN TIER HELPERS
' ============================================================

' Returns the LANTierID for a given node count.
' Returns 0 if no match is found (should never happen with valid data).
Public Function GetLANTierID(ByVal numNodes As Integer) As Integer
    Dim rs As DAO.Recordset
    Dim sql As String

    If numNodes <= 0 Then
        GetLANTierID = 0
        Exit Function
    End If

    sql = "SELECT LANTierID FROM tblLANTiers " & _
          "WHERE " & numNodes & " >= NodesFrom " & _
          "AND " & numNodes & " <= NodesTo;"

    Set rs = CurrentDb.OpenRecordset(sql, dbOpenSnapshot)
    If Not rs.EOF Then
        GetLANTierID = rs!LANTierID
    Else
        GetLANTierID = 0
    End If
    rs.Close
    Set rs = Nothing
End Function

' Returns the cost per LAN node (KSh) for a given node count.
Public Function GetLANNodeUnitCost(ByVal numNodes As Integer) As Currency
    Dim rs As DAO.Recordset
    Dim sql As String

    If numNodes <= 0 Then
        GetLANNodeUnitCost = 0
        Exit Function
    End If

    sql = "SELECT CostPerNode FROM tblLANTiers " & _
          "WHERE " & numNodes & " >= NodesFrom " & _
          "AND " & numNodes & " <= NodesTo;"

    Set rs = CurrentDb.OpenRecordset(sql, dbOpenSnapshot)
    If Not rs.EOF Then
        GetLANNodeUnitCost = rs!CostPerNode
    Else
        GetLANNodeUnitCost = 0
    End If
    rs.Close
    Set rs = Nothing
End Function

' Returns the tier description string for a given node count.
Public Function GetLANTierDescription(ByVal numNodes As Integer) As String
    Dim rs As DAO.Recordset
    Dim sql As String

    If numNodes <= 0 Then
        GetLANTierDescription = ""
        Exit Function
    End If

    sql = "SELECT Description FROM tblLANTiers " & _
          "WHERE " & numNodes & " >= NodesFrom " & _
          "AND " & numNodes & " <= NodesTo;"

    Set rs = CurrentDb.OpenRecordset(sql, dbOpenSnapshot)
    If Not rs.EOF Then
        GetLANTierDescription = rs!Description
    Else
        GetLANTierDescription = "Unknown tier"
    End If
    rs.Close
    Set rs = Nothing
End Function


' ============================================================
' SECTION 3 – INFRASTRUCTURE COST CALCULATIONS
' ============================================================

' Returns the total cost of a PC purchase.
Public Function CalcTotalPCCost(ByVal numPCs As Integer) As Currency
    If numPCs < 0 Then numPCs = 0
    CalcTotalPCCost = numPCs * PC_UNIT_COST
End Function

' Returns the total LAN node cost for a given node count.
Public Function CalcTotalLANCost(ByVal numNodes As Integer) As Currency
    If numNodes <= 0 Then
        CalcTotalLANCost = 0
    Else
        CalcTotalLANCost = numNodes * GetLANNodeUnitCost(numNodes)
    End If
End Function

' Returns the combined infrastructure cost (PCs + LAN).
Public Function CalcTotalInfraCost(ByVal numPCs As Integer, _
                                    ByVal numNodes As Integer) As Currency
    CalcTotalInfraCost = CalcTotalPCCost(numPCs) + CalcTotalLANCost(numNodes)
End Function


' ============================================================
' SECTION 4 – SUBSCRIPTION / BILLING CALCULATIONS
' ============================================================

' Returns the effective monthly rate after applying a 10 % upgrade
' discount when the subscription is an upgrade (isUpgraded = True).
Public Function CalcEffectiveMonthlyRate(ByVal baseRate As Currency, _
                                          ByVal isUpgraded As Boolean) As Currency
    If isUpgraded Then
        CalcEffectiveMonthlyRate = baseRate - (baseRate * UPGRADE_DISCOUNT)
    Else
        CalcEffectiveMonthlyRate = baseRate
    End If
End Function

' Returns the discount amount (KSh) for an upgrade, 0 otherwise.
Public Function CalcDiscountAmount(ByVal baseRate As Currency, _
                                    ByVal isUpgraded As Boolean) As Currency
    If isUpgraded Then
        CalcDiscountAmount = baseRate * UPGRADE_DISCOUNT
    Else
        CalcDiscountAmount = 0
    End If
End Function

' Returns the overdue fine for a monthly charge.
Public Function CalcOverdueFine(ByVal monthlyCharge As Currency) As Currency
    CalcOverdueFine = monthlyCharge * OVERDUE_FINE_RATE
End Function

' Returns the total amount due on a bill.
'   monthlyCharge  – effective monthly service charge
'   addFine        – True if the overdue fine should be applied
'   addReconnect   – True if the KSh 1,000 reconnection fee should be added
Public Function CalcTotalAmountDue(ByVal monthlyCharge As Currency, _
                                    ByVal addFine As Boolean, _
                                    ByVal addReconnect As Boolean) As Currency
    Dim fine As Currency
    Dim recon As Currency
    fine = IIf(addFine, CalcOverdueFine(monthlyCharge), 0)
    recon = IIf(addReconnect, RECONNECTION_FEE, 0)
    CalcTotalAmountDue = monthlyCharge + fine + recon
End Function


' ============================================================
' SECTION 5 – GENERATE MONTHLY BILL
'
' Creates one row in tblMonthlyBills for the given institution
' and billing period.  The bill is generated as "Unpaid".
' Returns the new BillID, or -1 on failure.
' ============================================================
Public Function GenerateMonthlyBill(ByVal institutionID As Long, _
                                     ByVal subscriptionID As Long, _
                                     ByVal billingMonth As Integer, _
                                     ByVal billingYear As Integer) As Long
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim subRS As DAO.Recordset
    Dim effectiveRate As Currency
    Dim dueDate As Date
    Dim billDate As Date

    Set db = CurrentDb

    ' --- Check for duplicate bill ---
    Dim chkSQL As String
    chkSQL = "SELECT BillID FROM tblMonthlyBills " & _
             "WHERE InstitutionID=" & institutionID & _
             " AND BillingMonth=" & billingMonth & _
             " AND BillingYear=" & billingYear & ";"
    Set rs = db.OpenRecordset(chkSQL, dbOpenSnapshot)
    If Not rs.EOF Then
        MsgBox "A bill for " & MonthName(billingMonth) & " " & billingYear & _
               " already exists for InstitutionID " & institutionID & ".", _
               vbExclamation, "Duplicate Bill"
        rs.Close
        Set rs = Nothing
        GenerateMonthlyBill = -1
        Exit Function
    End If
    rs.Close
    Set rs = Nothing

    ' --- Get effective monthly rate from subscription ---
    Dim subSQL As String
    subSQL = "SELECT EffectiveMonthlyRate FROM tblSubscriptions " & _
             "WHERE SubscriptionID=" & subscriptionID & ";"
    Set subRS = db.OpenRecordset(subSQL, dbOpenSnapshot)
    If subRS.EOF Then
        MsgBox "SubscriptionID " & subscriptionID & " not found.", _
               vbCritical, "Generate Bill Error"
        subRS.Close
        Set subRS = Nothing
        GenerateMonthlyBill = -1
        Exit Function
    End If
    effectiveRate = subRS!EffectiveMonthlyRate
    subRS.Close
    Set subRS = Nothing

    ' --- Calculate dates ---
    billDate = Date
    ' DateSerial with day=0 returns the last day of the previous month,
    ' so (billingMonth + 1, 0) gives the last day of billingMonth.
    dueDate = DateSerial(billingYear, billingMonth + 1, 0)

    ' --- Insert the bill ---
    Dim insSQL As String
    insSQL = "INSERT INTO tblMonthlyBills " & _
             "(InstitutionID, SubscriptionID, BillingMonth, BillingYear, " & _
             "BillGeneratedDate, DueDate, MonthlyCharge, OverdueFineRate, " & _
             "OverdueFineAmount, ReconnectionFee, TotalAmountDue, " & _
             "PaidAmount, BillStatus) " & _
             "VALUES (" & _
             institutionID & ", " & _
             subscriptionID & ", " & _
             billingMonth & ", " & _
             billingYear & ", " & _
             "#" & Format(billDate, "yyyy-mm-dd") & "#, " & _
             "#" & Format(dueDate, "yyyy-mm-dd") & "#, " & _
             effectiveRate & ", " & _
             OVERDUE_FINE_RATE & ", " & _
             "0, 0, " & effectiveRate & ", 0, 'Unpaid');"

    db.Execute insSQL, dbFailOnError

    ' Return the new BillID using the Max approach (Access-safe)
    GenerateMonthlyBill = CurrentDb.OpenRecordset( _
        "SELECT Max(BillID) FROM tblMonthlyBills;")(0)

    Set db = Nothing
    MsgBox "Bill generated for InstitutionID " & institutionID & _
           " – " & MonthName(billingMonth) & " " & billingYear & _
           " (KSh " & Format(effectiveRate, "#,##0.00") & ").", _
           vbInformation, "Bill Created"
End Function


' ============================================================
' SECTION 6 – MARK BILL AS OVERDUE
'
' Applies the 15% fine and updates BillStatus to 'Overdue'.
' Call this after the 10th of the month following the DueDate.
' ============================================================
Public Sub MarkBillOverdue(ByVal billID As Long)
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim sql As String
    Dim monthlyCharge As Currency
    Dim fineAmount As Currency
    Dim totalDue As Currency

    Set db = CurrentDb

    sql = "SELECT BillStatus, MonthlyCharge, PaidAmount " & _
          "FROM tblMonthlyBills WHERE BillID=" & billID & ";"
    Set rs = db.OpenRecordset(sql, dbOpenSnapshot)

    If rs.EOF Then
        MsgBox "BillID " & billID & " not found.", vbCritical, "Overdue Error"
        GoTo Cleanup
    End If

    If rs!BillStatus <> "Unpaid" Then
        MsgBox "BillID " & billID & " is already '" & rs!BillStatus & _
               "'. Only 'Unpaid' bills can be marked Overdue.", _
               vbExclamation, "Overdue Error"
        GoTo Cleanup
    End If

    monthlyCharge = rs!MonthlyCharge
    fineAmount    = CalcOverdueFine(monthlyCharge)
    totalDue      = monthlyCharge + fineAmount   ' reconnection not yet applied

    Dim updSQL As String
    updSQL = "UPDATE tblMonthlyBills SET " & _
             "OverdueFineAmount=" & fineAmount & ", " & _
             "TotalAmountDue=" & totalDue & ", " & _
             "BillStatus='Overdue' " & _
             "WHERE BillID=" & billID & ";"
    db.Execute updSQL, dbFailOnError

    MsgBox "BillID " & billID & " marked Overdue. " & _
           "Fine applied: KSh " & Format(fineAmount, "#,##0.00") & ".", _
           vbInformation, "Overdue Fine Applied"

Cleanup:
    If Not rs Is Nothing Then rs.Close
    Set rs = Nothing
    Set db = Nothing
End Sub


' ============================================================
' SECTION 7 – DISCONNECT INSTITUTION
'
' Sets BillStatus to 'Disconnected', records DisconnectionDate,
' adds the KSh 1,000 reconnection fee to TotalAmountDue, and
' updates the institution's ServiceStatus to 'Disconnected'.
' ============================================================
Public Sub DisconnectInstitution(ByVal billID As Long)
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim sql As String
    Dim institutionID As Long
    Dim monthlyCharge As Currency
    Dim fineAmount As Currency
    Dim newTotal As Currency

    Set db = CurrentDb

    sql = "SELECT InstitutionID, BillStatus, MonthlyCharge, " & _
          "OverdueFineAmount, TotalAmountDue " & _
          "FROM tblMonthlyBills WHERE BillID=" & billID & ";"
    Set rs = db.OpenRecordset(sql, dbOpenSnapshot)

    If rs.EOF Then
        MsgBox "BillID " & billID & " not found.", vbCritical, "Disconnect Error"
        GoTo Cleanup
    End If

    If rs!BillStatus <> "Overdue" Then
        MsgBox "BillID " & billID & " is '" & rs!BillStatus & _
               "'. Only 'Overdue' bills can trigger disconnection.", _
               vbExclamation, "Disconnect Error"
        GoTo Cleanup
    End If

    institutionID = rs!InstitutionID
    newTotal      = rs!TotalAmountDue + RECONNECTION_FEE

    ' Update the bill
    Dim updBill As String
    updBill = "UPDATE tblMonthlyBills SET " & _
              "ReconnectionFee=" & RECONNECTION_FEE & ", " & _
              "TotalAmountDue=" & newTotal & ", " & _
              "BillStatus='Disconnected', " & _
              "DisconnectionDate=#" & Format(Date, "yyyy-mm-dd") & "# " & _
              "WHERE BillID=" & billID & ";"
    db.Execute updBill, dbFailOnError

    ' Update institution status
    Dim updInst As String
    updInst = "UPDATE tblInstitutions SET ServiceStatus='Disconnected' " & _
              "WHERE InstitutionID=" & institutionID & ";"
    db.Execute updInst, dbFailOnError

    MsgBox "Institution " & institutionID & " disconnected. " & _
           "Total now due: KSh " & Format(newTotal, "#,##0.00") & " " & _
           "(includes KSh 1,000 reconnection fee).", _
           vbInformation, "Disconnected"

Cleanup:
    If Not rs Is Nothing Then rs.Close
    Set rs = Nothing
    Set db = Nothing
End Sub


' ============================================================
' SECTION 8 – RECONNECT INSTITUTION
'
' Sets BillStatus to 'Reconnected', records ReconnectionDate,
' and updates institution ServiceStatus back to 'Active'.
' Expects the full TotalAmountDue to have been paid before calling.
' ============================================================
Public Sub ReconnectInstitution(ByVal billID As Long)
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim sql As String
    Dim institutionID As Long

    Set db = CurrentDb

    sql = "SELECT InstitutionID, BillStatus, TotalAmountDue, PaidAmount " & _
          "FROM tblMonthlyBills WHERE BillID=" & billID & ";"
    Set rs = db.OpenRecordset(sql, dbOpenSnapshot)

    If rs.EOF Then
        MsgBox "BillID " & billID & " not found.", vbCritical, "Reconnect Error"
        GoTo Cleanup
    End If

    If rs!BillStatus <> "Disconnected" Then
        MsgBox "BillID " & billID & " is '" & rs!BillStatus & _
               "'. Only 'Disconnected' bills can be reconnected.", _
               vbExclamation, "Reconnect Error"
        GoTo Cleanup
    End If

    If rs!PaidAmount < rs!TotalAmountDue Then
        MsgBox "Full payment has not been received. " & _
               "Total due: KSh " & Format(rs!TotalAmountDue, "#,##0.00") & _
               "  Paid: KSh " & Format(rs!PaidAmount, "#,##0.00") & ".", _
               vbExclamation, "Reconnect Error"
        GoTo Cleanup
    End If

    institutionID = rs!InstitutionID

    ' Update the bill
    Dim updBill As String
    updBill = "UPDATE tblMonthlyBills SET " & _
              "BillStatus='Reconnected', " & _
              "ReconnectionDate=#" & Format(Date, "yyyy-mm-dd") & "# " & _
              "WHERE BillID=" & billID & ";"
    db.Execute updBill, dbFailOnError

    ' Update institution status
    Dim updInst As String
    updInst = "UPDATE tblInstitutions SET ServiceStatus='Active' " & _
              "WHERE InstitutionID=" & institutionID & ";"
    db.Execute updInst, dbFailOnError

    ' Mark subscription active again
    Dim updSub As String
    updSub = "UPDATE tblSubscriptions SET IsActive=True " & _
             "WHERE InstitutionID=" & institutionID & " AND IsActive=False;"
    db.Execute updSub, dbFailOnError

    MsgBox "Institution " & institutionID & _
           " reconnected successfully.", vbInformation, "Reconnected"

Cleanup:
    If Not rs Is Nothing Then rs.Close
    Set rs = Nothing
    Set db = Nothing
End Sub


' ============================================================
' SECTION 9 – RECORD PAYMENT
'
' Inserts a row in tblPayments and updates tblMonthlyBills
' (PaidAmount, PaymentDate, BillStatus) when a BillID is supplied.
' paymentType: "Registration" | "Installation" | "Infrastructure"
'              | "Monthly" | "OverdueFine" | "Reconnection"
' ============================================================
Public Sub RecordPayment(ByVal institutionID As Long, _
                          ByVal billID As Variant, _
                          ByVal paymentType As String, _
                          ByVal amountPaid As Currency, _
                          ByVal paymentMethod As String, _
                          ByVal referenceNumber As String, _
                          ByVal receivedBy As String, _
                          Optional ByVal notes As String = "")
    Dim db As DAO.Database
    Dim billIDSQL As String
    Dim insSQL As String

    Set db = CurrentDb

    ' Build the BillID fragment (Null when not applicable)
    If IsNull(billID) Or billID = 0 Then
        billIDSQL = "Null"
    Else
        billIDSQL = CStr(CLng(billID))
    End If

    insSQL = "INSERT INTO tblPayments " & _
             "(InstitutionID, BillID, PaymentDate, PaymentType, " & _
             "AmountPaid, PaymentMethod, ReferenceNumber, ReceivedBy, Notes) " & _
             "VALUES (" & _
             institutionID & ", " & _
             billIDSQL & ", " & _
             "#" & Format(Date, "yyyy-mm-dd") & "#, '" & _
             paymentType & "', " & _
             amountPaid & ", '" & _
             paymentMethod & "', '" & _
             referenceNumber & "', '" & _
             receivedBy & "', '" & _
             notes & "');"

    db.Execute insSQL, dbFailOnError

    ' ---- If this is linked to a bill, update PaidAmount / BillStatus ----
    If billIDSQL <> "Null" Then
        Dim rs As DAO.Recordset
        Dim billSQL As String
        billSQL = "SELECT TotalAmountDue, PaidAmount, BillStatus " & _
                  "FROM tblMonthlyBills WHERE BillID=" & billIDSQL & ";"
        Set rs = db.OpenRecordset(billSQL, dbOpenSnapshot)

        If Not rs.EOF Then
            Dim newPaid As Currency
            Dim totalDue As Currency
            newPaid  = rs!PaidAmount + amountPaid
            totalDue = rs!TotalAmountDue

            Dim newStatus As String
            If newPaid >= totalDue Then
                newStatus = "Paid"
            Else
                newStatus = rs!BillStatus   ' keep existing status if partial
            End If

            Dim updBill As String
            updBill = "UPDATE tblMonthlyBills SET " & _
                      "PaidAmount=" & newPaid & ", " & _
                      "PaymentDate=#" & Format(Date, "yyyy-mm-dd") & "#, " & _
                      "BillStatus='" & newStatus & "' " & _
                      "WHERE BillID=" & billIDSQL & ";"
            db.Execute updBill, dbFailOnError
        End If
        rs.Close
        Set rs = Nothing
    End If

    MsgBox "Payment of KSh " & Format(amountPaid, "#,##0.00") & _
           " recorded (" & paymentType & ").", _
           vbInformation, "Payment Recorded"

    Set db = Nothing
End Sub


' ============================================================
' SECTION 10 – BATCH: GENERATE BILLS FOR ALL ACTIVE INSTITUTIONS
'
' Loops through every institution with an active subscription
' and calls GenerateMonthlyBill for the given month/year.
' ============================================================
Public Sub GenerateBillsForAllActive(ByVal billingMonth As Integer, _
                                      ByVal billingYear As Integer)
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim sql As String
    Dim count As Integer

    Set db = CurrentDb

    sql = "SELECT i.InstitutionID, s.SubscriptionID " & _
          "FROM tblInstitutions AS i " & _
          "INNER JOIN tblSubscriptions AS s " & _
          "ON i.InstitutionID = s.InstitutionID " & _
          "WHERE s.IsActive = True " & _
          "AND i.ServiceStatus = 'Active';"

    Set rs = db.OpenRecordset(sql, dbOpenForwardOnly)
    count = 0

    Do While Not rs.EOF
        Dim result As Long
        result = GenerateMonthlyBill(rs!InstitutionID, rs!SubscriptionID, _
                                      billingMonth, billingYear)
        If result > 0 Then count = count + 1
        rs.MoveNext
    Loop

    rs.Close
    Set rs = Nothing
    Set db = Nothing

    MsgBox count & " bill(s) generated for " & _
           MonthName(billingMonth) & " " & billingYear & ".", _
           vbInformation, "Batch Billing Complete"
End Sub


' ============================================================
' SECTION 11 – BATCH: MARK OVERDUE BILLS
'
' Checks all Unpaid bills whose DueDate is before
' (DISCONNECTION_DAY of the following month) and marks them Overdue.
' Call this on or after the 10th of each month.
' ============================================================
Public Sub ProcessOverdueBills()
    Dim db As DAO.Database
    Dim rs As DAO.Recordset
    Dim sql As String
    Dim count As Integer
    Dim cutoff As Date

    ' Cutoff = 10th of the current month
    cutoff = DateSerial(Year(Date), Month(Date), DISCONNECTION_DAY)

    Set db = CurrentDb

    sql = "SELECT BillID FROM tblMonthlyBills " & _
          "WHERE BillStatus='Unpaid' AND DueDate < #" & _
          Format(cutoff, "yyyy-mm-dd") & "#;"

    Set rs = db.OpenRecordset(sql, dbOpenSnapshot)
    count = 0

    Do While Not rs.EOF
        MarkBillOverdue rs!BillID
        count = count + 1
        rs.MoveNext
    Loop

    rs.Close
    Set rs = Nothing
    Set db = Nothing

    MsgBox count & " bill(s) marked Overdue.", _
           vbInformation, "Overdue Processing Complete"
End Sub


' ============================================================
' SECTION 12 – UTILITY: FORMAT CURRENCY (KSh)
' ============================================================
Public Function FormatKSh(ByVal amount As Currency) As String
    FormatKSh = "KSh " & Format(amount, "#,##0.00")
End Function

' Returns a single-line summary of an institution.
Public Function GetInstitutionSummary(ByVal institutionID As Long) As String
    Dim rs As DAO.Recordset
    Dim sql As String

    sql = "SELECT InstitutionName, Category, County, ServiceStatus " & _
          "FROM tblInstitutions WHERE InstitutionID=" & institutionID & ";"
    Set rs = CurrentDb.OpenRecordset(sql, dbOpenSnapshot)

    If rs.EOF Then
        GetInstitutionSummary = "Institution not found."
    Else
        GetInstitutionSummary = rs!InstitutionName & " | " & _
                                 rs!Category & " | " & _
                                 rs!County & " | " & _
                                 rs!ServiceStatus
    End If
    rs.Close
    Set rs = Nothing
End Function
