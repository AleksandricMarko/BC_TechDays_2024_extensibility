pageextension 50103 "General Journal Ext" extends "General Journal"
{
    layout
    {
        modify("Document Type")
        {
            //Visible = false;
            //AllowedValues = 0,2,3,4; //NOT POSSIBLE FOR DIFFERENT APP

            trigger OnAfterValidate()
            begin
                UpdateTypeText();
            end;
        }

        addafter("Document Type")
        {
            field("Custom Document Type Field"; CustomDocumentTypeAsText)
            {
                ApplicationArea = All;
                Caption = 'Custom Document Type';
                ToolTip = 'Custom Document Type field';
                LookupPageID = "Option Lookup List";
                TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const("Gen. Journal Document Type"));
                trigger OnValidate()
                begin
                    TempOptionLookupBuffer.SetCurrentType(Rec."Document Type".AsInteger());
                    if TempOptionLookupBuffer.AutoCompleteLookup(CustomDocumentTypeAsText, Enum::"Option Lookup Type"::"Gen. Journal Document Type") then
                        Rec.Validate("Document Type", TempOptionLookupBuffer.ID);
                    TempOptionLookupBuffer.ValidateOption(CustomDocumentTypeAsText);
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
        TempOptionLookupBuffer.FillLookupBuffer(Enum::"Option Lookup Type"::"Gen. Journal Document Type");
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        CustomDocumentTypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo("Document Type")));
    end;

    var
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        GenJnlDocumentTypeLookupMgt: Codeunit "GenJnlDocumentTypeLookupMgt";
        CustomDocumentTypeAsText: Text[30];
}