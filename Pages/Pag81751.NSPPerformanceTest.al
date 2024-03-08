page 81751 "NSP Performance Test"
{
    ApplicationArea = All;
    Caption = 'Number Series Performance Test';
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(NumberOfIterations; NumberOfIterations)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Iterations';
                    MinValue = 1;
                    trigger OnValidate()
                    begin
                        if (NumberOfIterations mod 5) <> 0 then
                            Error('The number must be a multiple of 5.');

                        IsEntryTableReady := false;
                    end;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    ToolTip = 'Comment about the run, example SQL server type';
                }

            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(NoSeriesNoGaps_promoted; NoSeriesNoGaps)
            {

            }
            actionref(NoSeriesGaps_promoted; NoSeriesGaps)
            {

            }
            actionref(NumberSequence_promoted; NumberSequence)
            {

            }


            actionref(NumberIncrementWithFindLast_promoted; NumberIncrementWithFindLast)
            {

            }
            actionref(AutoIncrementOnInsert_promoted; AutoIncrementOnInsert)
            {

            }
            actionref(InitEntryTableAction_promoted; InitEntryTableAction)
            {

            }
            actionref(InitEntryNoBulkTableAction_promoted; InitEntryTableActionNoBulk)
            {

            }
        }
        area(Processing)
        {
            action(NoSeriesNoGaps)
            {
                ApplicationArea = All;
                Caption = 'No Series No Gaps';
                ToolTip = 'No Series No Gaps';
                Image = NumberGroup;
                trigger OnAction()
                begin
                    TestNoSeriesNoGaps(true);
                end;
            }
            action(NoSeriesGaps)
            {
                ApplicationArea = All;
                Caption = 'No Series Gaps';
                ToolTip = 'No Series Gaps';
                Image = NumberGroup;
                trigger OnAction()
                begin
                    TestNoSeriesGaps(true);
                end;
            }
            action(NumberSequence)
            {
                ApplicationArea = All;
                Caption = 'Number Sequence';
                ToolTip = 'Number Sequence';
                Image = ElectronicNumber;
                trigger OnAction()
                begin
                    TestNumberSequence(true);
                end;
            }
            // action(NumberIncrement)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Number Increment';
            //     ToolTip = 'Number Increment';
            //     Image = ElectronicNumber;
            //     trigger OnAction()
            //     begin
            //         TestNumberIncrement(true);
            //     end;
            // }
            action(NumberIncrementWithFindLast)
            {
                ApplicationArea = All;
                Caption = 'Increment with FindLast and Filter';
                ToolTip = 'Increment with FindLast and Filter';
                Image = ElectronicNumber;
                trigger OnAction()
                begin
                    TestNumberIncrementFindLast(true);
                end;
            }
            action(AutoIncrementOnInsert)
            {
                ApplicationArea = All;
                Caption = 'Auto Increment on Insert';
                ToolTip = 'Auto Increment on Insert';
                Image = ElectronicNumber;
                trigger OnAction()
                begin
                    TestAutoIncrementInsertRecord(true);
                    IsEntryTableReady := false;
                end;
            }

            action(InitEntryTableAction)
            {
                ApplicationArea = All;
                Caption = 'Init Entry Table';
                ToolTip = 'Init Entry Table';
                Image = Add;
                trigger OnAction()
                begin
                    TestNumberIncrement(true, true);
                end;
            }
            action(InitEntryTableActionNoBulk)
            {
                ApplicationArea = All;
                Caption = 'Init Entry Table without Bulk insert';
                ToolTip = 'Init Entry Table - no Bulk insert';
                Image = Add;
                trigger OnAction()
                begin
                    TestNumberIncrement(true, false);
                end;
            }
            action(RunAll)
            {
                ApplicationArea = All;
                Caption = 'Run All';
                ToolTip = 'Runs all the tests in on go.';
                Image = AllLines;
                trigger OnAction()
                begin
                    RunAllTests(false);
                end;
            }
            action(ResultLog)
            {
                ApplicationArea = All;
                Caption = 'Result Log';
                ToolTip = 'Shows the result log.';
                Image = Log;
                RunObject = Page Result;
                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        NumberOfIterations := 100000;

        CreateNumberSeries();
    end;

    local procedure TestNumberIncrement(ShowMessage: Boolean; BulkInsert: Boolean)
    var
        StartDateTime: DateTime;
        i: Integer;
        Message: text[250];
        OnInsertSubscriber: Codeunit "OnInsert Subscriber";
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        DeleteEntries();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        if BulkInsert then begin
            Message := 'Number Inserts with Bulk inserts'
        end else
            Message := 'Number Inserts without Bulk inserts';


        StartDateTime := CurrentDateTime();

        for i := 1 to NumberOfIterations do begin
            CreateEntry(i, BulkInsert);
        end;
        IsEntryTableReady := true;
        Result.Log(Message, CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);

        Commit;
        if ShowMessage then
            Message('Tables Initialization: %1 records took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNoSeriesNoGaps(ShowMessage: Boolean)
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
        EntryTable3: Record "NSP Entry Table3";
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        DeleteEntries();
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            //ListOfText.Add(NoSeriesManagement.GetNextNo(NoSeriesCodeNoGapsLbl, Today(), true));
            CreateEntry3(NoSeriesManagement.GetNextNo(NoSeriesCodeNoGapsLbl, Today(), true));

        Result.Log('TestNoSeriesNoGaps', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
        if ShowMessage then
            Message('Number series with no gaps: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
        Commit;
    end;


    local procedure TestNoSeriesGaps(ShowMessage: Boolean)
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        DeleteEntries();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            //ListOfText.Add(NoSeriesManagement.GetNextNo(NoSeriesCodeGapsLbl, Today(), true));
            CreateEntry3(NoSeriesManagement.GetNextNo(NoSeriesCodeGapsLbl, Today(), true));
        Result.Log('TestNoSeriesGaps', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
        if ShowMessage then
            Message('Number series with gaps: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
        Commit;
    end;

    local procedure TestNumberSequence(ShowMessage: Boolean)
    var
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        DeleteEntries();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            //ListOfText.Add(Format(NumberSequence.Next(NumberSequenceLbl)));
            CreateEntry3(Format(NumberSequence.Next(NumberSequenceLbl)));
        Result.Log('TestNumberSequence', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
        if ShowMessage then
            Message('Number sequence: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
        Commit;
    end;

    // local procedure TestNumberIncrement(ShowMessage: Boolean)
    // var
    //     ListOfText: List of [Text];
    //     StartDateTime: DateTime;
    //     i: Integer;
    //     StartSqlStatements, StartSqlRowsRead : BigInteger;
    // begin
    //     DeleteEntries();
    //     StartSqlStatements := SessionInformation.SqlStatementsExecuted;
    //     StartSqlRowsRead := SessionInformation.SqlRowsRead;
    //     StartDateTime := CurrentDateTime();
    //     for i := 1 to NumberOfIterations do
    //         //ListOfText.Add(Format(i));
    //         CreateEntry3(Format(i));
    //     Result.Log('TestNumberIncrement', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
    //     if ShowMessage then
    //         Message('Number increment: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    //     Commit;
    // end;

    local procedure TestAutoIncrementInsertRecord(ShowMessage: Boolean)
    var
        StartDateTime: DateTime;
        i: Integer;
        Message: Text[250];
        AutoincrementSubscriber: Codeunit "OnInsert Subscriber";
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        DeleteEntries();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        if not IsEntryTableReady then
            Error('You must Init Entry Table before you go.');

        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            CreateEntry2();

        Result.Log('TestAutoIncrementInsertRecord', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
        if ShowMessage then
            Message('Auto Increment on Insert: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);

        Commit;
    end;

    local procedure TestNumberIncrementFindLast(ShowMessage: Boolean)
    var
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        DummyEntryNo: Integer;
        i: Integer;
        StartSqlStatements, StartSqlRowsRead : BigInteger;
    begin
        DeleteEntries();
        StartSqlStatements := SessionInformation.SqlStatementsExecuted;
        StartSqlRowsRead := SessionInformation.SqlRowsRead;
        if not IsEntryTableReady then
            Error('You must Init Entry Table before you go.');

        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do begin
            DummyEntryNo := SimulateGetNextEntryNo(i - 1);
            //ListOfText.Add(Format(i));
            CreateEntry(DummyEntryNo, true);
        end;
        Result.Log('TestNumberIncrementFindLast+1', CurrentDateTime() - StartDateTime, NumberOfIterations, comment, SessionInformation.SqlRowsRead - StartSqlRowsRead, SessionInformation.SqlStatementsExecuted - StartSqlStatements);
        if ShowMessage then
            Message('Number increment: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
        Commit;
    end;

    local procedure SimulateGetNextEntryNo(CurrentCounter: Integer): Integer
    var
        EntryTable: Record "NSP Entry Table";
    begin
        //EntryTable.SetRange("Entry No.", CurrentCounter);
        //SelectLatestVersion();
        EntryTable.ReadIsolation := IsolationLevel::UpdLock;
        if EntryTable.FindLast() then
            exit(EntryTable."Entry No." + 1);
        exit(1);
    end;

    local procedure CreateNumberSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        if NoSeries.Get(NoSeriesCodeNoGapsLbl) then
            NoSeries.Delete(true);

        NoSeries.Init();
        NoSeries.Validate(Code, NoSeriesCodeNoGapsLbl);
        NoSeries.Validate("Default Nos.", true);
        NoSeries.Validate("Manual Nos.", true);
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine.Validate("Series Code", NoSeries.Code);
        NoSeriesLine.Validate("Starting No.", NoGapsStartNoLbl);
        NoSeriesLine.Validate("Allow Gaps in Nos.", false);
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Insert(true);

        if NoSeries.Get(NoSeriesCodeGapsLbl) then
            NoSeries.Delete(true);

        Clear(NoSeries);
        Clear(NoSeriesLine);
        NoSeries.Init();
        NoSeries.Validate(Code, NoSeriesCodeGapsLbl);
        NoSeries.Validate("Default Nos.", true);
        NoSeries.Validate("Manual Nos.", true);
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine.Validate("Series Code", NoSeries.Code);
        NoSeriesLine.Validate("Starting No.", GapsStartNoLbl);
        NoSeriesLine.Validate("Allow Gaps in Nos.", true);
        NoSeriesLine.Validate("Increment-by No.", 1);
        NoSeriesLine.Insert(true);

        if NumberSequence.Exists(NumberSequenceLbl) then
            NumberSequence.Delete(NumberSequenceLbl);
        NumberSequence.Insert(NumberSequenceLbl);
    end;

    local procedure RunAllTests(ShowIndividualMessage: Boolean)
    var
        StartTime: time;
    begin
        StartTime := Time;
        TestNumberIncrement(false, true); // Bulk insert
        TestNumberIncrement(false, false); // Not Bulk insert
        TestNoSeriesGaps(false);
        TestNoSeriesNoGaps(false);
        TestNumberSequence(false);
        //TestNumberIncrement(false); // Same as InitEntryTable
        TestAutoIncrementInsertRecord(false);
        TestNumberIncrementFindLast(false);
        Message('All tests are done. Duration: %1', Time - StartTime);
    end;

    local procedure DeleteEntries()
    var
        EntryTable: Record "NSP Entry Table";
        EntryTable2: Record "NSP Entry Table2";
        EntryTable3: Record "NSP Entry Table3";
    begin
        EntryTable.DeleteAll();
        EntryTable2.DeleteAll();
        EntryTable3.DeleteAll();
    end;

    #region CreateEntries
    local procedure CreateEntry(var i: Integer; BulkInsert: Boolean)
    var
        EntryTable: Record "NSP Entry Table";
    begin
        EntryTable.Init();
        EntryTable."Entry No." := i;
        EntryTable.Description := 'test';
        If BulkInsert then
            EntryTable.Insert(true)
        else
            If EntryTable.Insert() then; // do nothing

    end;

    local procedure CreateEntry2()
    var
        EntryTable2: Record "NSP Entry Table2";
    begin
        EntryTable2.Init();
        EntryTable2."Entry No." := 0;
        EntryTable2.Description := 'test';
        EntryTable2.Insert();
    end;

    local procedure CreateEntry3(EntryNo: code[20])
    var
        EntryTable3: Record "NSP Entry Table3";
    begin
        EntryTable3.Init();
        EntryTable3."Entry No." := EntryNo;
        EntryTable3.Description := 'test';
        EntryTable3.Insert(true);
    end;
    #endregion CreateEntries

    var
        NumberOfIterations: Integer;
        IsEntryTableReady: Boolean;
        NoSeriesCodeNoGapsLbl: Label 'NSP_NOGAPS', Locked = true;
        NoSeriesCodeGapsLbl: Label 'NSP_GAPS', Locked = true;
        NumberSequenceLbl: Label 'NSP_NumberSequence', Locked = true;
        NoGapsStartNoLbl: Label 'NSPN0000000001', Locked = true;
        GapsStartNoLbl: Label 'NSPG0000000001', Locked = true;
        Result: Record Result;
        Comment: Text[250];
}
