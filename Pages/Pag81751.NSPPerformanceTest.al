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

        }
    }
    trigger OnOpenPage()
    begin
        NumberOfIterations := 100000;

        CreateNumberSeries();
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
        NoSeriesCodeNoGapsLbl: Label 'NSP_NOGAPS', Locked = true;
        NoSeriesCodeGapsLbl: Label 'NSP_GAPS', Locked = true;
        NumberSequenceLbl: Label 'NSP_NumberSequence', Locked = true;
        NoGapsStartNoLbl: Label 'NSPN0000000001', Locked = true;
        GapsStartNoLbl: Label 'NSPG0000000001', Locked = true;
}
