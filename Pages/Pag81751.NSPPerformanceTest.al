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
            actionref(NumberIncrement_promoted; NumberIncrement)
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
                    TestNoSeriesNoGaps();
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
                    TestNoSeriesGaps();
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
                    TestNumberSequence();
                end;
            }
            action(NumberIncrement)
            {
                ApplicationArea = All;
                Caption = 'Number Increment';
                ToolTip = 'Number Increment';
                Image = ElectronicNumber;
                trigger OnAction()
                begin
                    TestNumberIncrement();
                end;
            }
            action(NumberIncrementWithFindLast)
            {
                ApplicationArea = All;
                Caption = 'Increment with FindLast and Filter';
                ToolTip = 'Increment with FindLast and Filter';
                Image = ElectronicNumber;
                trigger OnAction()
                begin
                    TestNumberIncrementFindLast();
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
                    TestAutoIncrementInsertRecord();
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
                    InitEntryTable();
                    IsEntryTableReady := true;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        NumberOfIterations := 100000;

        CreateNumberSeries();
    end;

    local procedure InitEntryTable()
    var
        EntryTable: Record "NSP Entry Table";
        EntryTable2: Record "NSP Entry Table2";
        StartDateTime: DateTime;
        i: Integer;
    begin
        EntryTable.DeleteAll();
        EntryTable2.DeleteAll();
        StartDateTime := CurrentDateTime();

        for i := 1 to NumberOfIterations do begin
            EntryTable.Init();
            EntryTable."Entry No." := i;
            EntryTable.Description := 'test';
            EntryTable.Insert(true);
        end;

        Message('Tables Initialization: %1 records took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNoSeriesNoGaps()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
    begin
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            ListOfText.Add(NoSeriesManagement.GetNextNo(NoSeriesCodeNoGapsLbl, Today(), true));
        Message('Number series with no gaps: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNoSeriesGaps()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
    begin
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            ListOfText.Add(NoSeriesManagement.GetNextNo(NoSeriesCodeGapsLbl, Today(), true));
        Message('Number series with gaps: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNumberSequence()
    var
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
    begin
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            ListOfText.Add(Format(NumberSequence.Next(NumberSequenceLbl)));
        Message('Number sequence: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNumberIncrement()
    var
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        i: Integer;
    begin
        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do
            ListOfText.Add(Format(i));
        Message('Number increment: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestAutoIncrementInsertRecord()
    var
        EntryTable2: Record "NSP Entry Table2";
        StartDateTime: DateTime;
        i: Integer;
    begin
        if not IsEntryTableReady then
            Error('You must Init Entry Table before you go.');

        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do begin
            EntryTable2.Init();
            EntryTable2."Entry No." := 0;
            EntryTable2.Description := 'test';
            EntryTable2.Insert();
        end;
        Message('Auto Increment on Insert: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure TestNumberIncrementFindLast()
    var
        ListOfText: List of [Text];
        StartDateTime: DateTime;
        DummyEntryNo: Integer;
        i: Integer;
    begin
        if not IsEntryTableReady then
            Error('You must Init Entry Table before you go.');

        StartDateTime := CurrentDateTime();
        for i := 1 to NumberOfIterations do begin
            DummyEntryNo := SimulateGetNextEntryNo(i - 1);
            ListOfText.Add(Format(i));
        end;
        Message('Number increment: %1 iterations took %2.', NumberOfIterations, CurrentDateTime() - StartDateTime);
    end;

    local procedure SimulateGetNextEntryNo(CurrentCounter: Integer): Integer
    var
        EntryTable: Record "NSP Entry Table";
    begin
        EntryTable.SetRange("Entry No.", CurrentCounter);
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

    var
        NumberOfIterations: Integer;
        IsEntryTableReady: Boolean;
        NoSeriesCodeNoGapsLbl: Label 'NSP_NOGAPS', Locked = true;
        NoSeriesCodeGapsLbl: Label 'NSP_GAPS', Locked = true;
        NumberSequenceLbl: Label 'NSP_NumberSequence', Locked = true;
        NoGapsStartNoLbl: Label 'NSPN0000000001', Locked = true;
        GapsStartNoLbl: Label 'NSPG0000000001', Locked = true;
}
