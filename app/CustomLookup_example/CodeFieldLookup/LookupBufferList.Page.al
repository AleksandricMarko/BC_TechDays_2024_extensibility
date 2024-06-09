page 50100 "Lookup Buffer List"
{
    Caption = 'Lookup List';
    Editable = false;
    PageType = List;
    SourceTable = "Lookup Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Value Caption"; Rec."Value Caption")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Code value.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        LookupBuffer: Record "Lookup Buffer";
    begin
        if Rec.GetFilter("Lookup Type") = '' then
            exit;

        Evaluate(LookupBuffer."Lookup Type", Rec.GetFilter("Lookup Type"));
        Rec.FillLookupBuffer(LookupBuffer."Lookup Type");
        Rec.SetCurrentKey(ID);
    end;
}