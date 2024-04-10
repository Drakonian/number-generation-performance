/// <summary>
/// Table to store the result of the operations
/// </summary>
table 81754 Result
{
    Caption = 'Result';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Operation; Text[100])
        {
            Caption = 'Operation';
        }
        field(3; "Duration"; Duration)
        {
            Caption = 'Duration';
        }
        field(4; Comment; Text[250])
        {
            Caption = 'Comment';
        }
        field(5; "No of Iterations"; Integer)
        {
            Caption = 'No of Iterations';
            Editable = false;
        }
        field(6; "Duration Int"; Integer)
        {
            Caption = 'Duration';
        }
        field(7; "Sql Rows Read"; BigInteger)
        {
            Caption = 'Sql Rows Read';
            Editable = false;
        }
        field(8; "Sql Statements Executed"; BigInteger)
        {
            Caption = 'Sql Statements Executed';
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    // procedure Log(Operation: Text[100]; Duration: Duration; NoOfIterations: Integer; Comment: Text[250])
    // var
    //     Result: Record "Result";
    // begin
    //     Log(Operation, Duration, NoOfIterations, Comment, 0, 0);
    // end;

    procedure Log(Operation: Text[100]; Duration: Duration; NoOfIterations: Integer; Comment: Text[250]; SqlRowsRead: Biginteger; SqlStatementsExecuted: Biginteger)
    var
        Result: Record "Result";
    begin
        Result."Entry No." := 0;
        Result.Operation := Operation;
        Result."Duration" := Duration;
        Result."Duration Int" := Duration;
        Result."No of Iterations" := NoOfIterations;
        Result.Comment := Comment;
        Result."Sql Rows Read" := SqlRowsRead;
        Result."Sql Statements Executed" := SqlStatementsExecuted;
        Result.Insert(false);
    end;
}
