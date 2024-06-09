codeunit 50102 ReqWorksheetTypeLookupMgt
{
    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnFillBufferLookupTypeCase', '', false, false)]
    local procedure HandleOnFillBufferLookupTypeCase(LookupType: Enum "Option Lookup Type"; var TableNo: Integer; var FieldNo: Integer; var RelationFieldNo: Integer; var IsHandled: Boolean)
    var
        RequsitionLine: Record "Requisition Line";
    begin
        if LookupType <> LookupType::ReqWorksheet then
            exit;

        TableNo := Database::"Requisition Line";
        FieldNo := RequsitionLine.FieldNo(Type);
        RelationFieldNo := RequsitionLine.FieldNo("No.");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', false, false)]
    local procedure HandleOnBeforeIncludeOption(OptionLookupBuffer: Record "Option Lookup Buffer"; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean; RecRef: RecordRef)
    var
        RequsitionLine: Record "Requisition Line";
    begin
        if LookupType <> Enum::"Option Lookup Type"::ReqWorksheet.AsInteger() then
            exit;

        Result := Option in [RequsitionLine.Type::" ".AsInteger(), RequsitionLine.Type::"Item".AsInteger()];
        Handled := true;
    end;


}