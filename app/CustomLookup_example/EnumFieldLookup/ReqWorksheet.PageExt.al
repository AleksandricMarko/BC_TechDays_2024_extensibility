pageextension 50102 "Req. Worksheet Ext" extends "Req. Worksheet"
{
    layout
    {
        modify(Type)
        {
            //Visible = false;
            //AllowedValues = 0,2; //NOT POSSIBLE FOR DIFFERENT APP

            trigger OnAfterValidate()
            begin
                UpdateTypeText();
            end;
        }

        addafter(Type)
        {
            field("Custom Type Field"; CustomTypeAsText)
            {
                ApplicationArea = All;
                Caption = 'Custom Type';
                ToolTip = 'Custom Type field';
                LookupPageID = "Option Lookup List";
                TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const(ReqWorksheet));
                trigger OnValidate()
                begin
                    TempOptionLookupBuffer.SetCurrentType(Rec.Type.AsInteger());
                    if TempOptionLookupBuffer.AutoCompleteLookup(CustomTypeAsText, Enum::"Option Lookup Type"::ReqWorksheet) then
                        Rec.Validate(Type, TempOptionLookupBuffer.ID);
                    TempOptionLookupBuffer.ValidateOption(CustomTypeAsText);
                    UpdateTypeText();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateTypeText();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTypeText();
    end;

    trigger OnOpenPage()
    begin
        RemoveAllExistingEntries();
        TempOptionLookupBuffer.FillLookupBuffer(Enum::"Option Lookup Type"::ReqWorksheet);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        CustomTypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    local procedure RemoveAllExistingEntries()
    var
        RequisitionLine: Record "Requisition Line";
    begin
        RequisitionLine.DeleteAll();
    end;

    var
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        ReqWorksheetTypeLookupMgt: Codeunit "ReqWorksheetTypeLookupMgt";
        CustomTypeAsText: Text[30];
}