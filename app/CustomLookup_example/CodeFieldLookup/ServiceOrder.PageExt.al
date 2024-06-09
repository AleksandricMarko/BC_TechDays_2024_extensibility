pageextension 50101 "Service Order Ext." extends "Service Order"
{
    layout
    {
        modify("Location Code")
        {
            //Visible = false;
            trigger OnAfterValidate()
            begin
                UpdateLocationCode();
            end;
        }
        addafter("Location Code")
        {
            field("Custom Location Code"; CustomLocationCode)
            {
                ApplicationArea = All;
                Caption = 'Custom Location Code';
                ToolTip = 'Custom Location Code field';
                LookupPageID = "Lookup Buffer List";
                TableRelation = "Lookup Buffer"."Value Caption" where("Lookup Type" = const("Service Location"));
                trigger OnValidate()
                begin
                    TempOptionLookupBuffer.SetCurrentLocation(Rec."Location Code");
                    if TempOptionLookupBuffer.AutoCompleteLookup(CustomLocationCode, Enum::"Option Lookup Type"::"Service Location") then
                        Rec.Validate("Location Code", TempOptionLookupBuffer."Value Caption");
                    TempOptionLookupBuffer.ValidateCodeValue(CustomLocationCode);
                    UpdateLocationCode();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        TempOptionLookupBuffer.FillLookupBuffer(Enum::"Option Lookup Type"::"Service Location");
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateLocationCode();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateLocationCode();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateLocationCode();
    end;

    var
        CustomLocationCode: Code[20];
        TempOptionLookupBuffer: Record "Lookup Buffer" temporary;

    procedure UpdateLocationCode()
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        CustomLocationCode := TempOptionLookupBuffer.FormatCodeValue(RecRef.Field(Rec.FieldNo("Location Code")));
    end;
}