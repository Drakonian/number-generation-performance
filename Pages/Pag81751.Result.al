/// <summary>
/// Page to show the result
/// </summary>
page 81752 Result
{
    ApplicationArea = All;
    Caption = 'Result';
    PageType = Worksheet;
    SourceTable = Result;
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Editable = false;
                }
                field(Operation; Rec.Operation)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Operation field.';
                }
                field("No of Iterations"; Rec."No of Iterations")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Duration"; Rec."Duration")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Duration Intege"; Rec."Duration Int")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.';
                }
                field("Sql Rows Read"; rec."Sql Rows Read")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sql Rows Read field.';
                }
                field("Sql Statements Executed"; Rec."Sql Statements Executed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sql Statements Executed field.';
                }

            }
        }
    }
}
