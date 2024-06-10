codeunit 50101 GenJnlDocumentTypeLookupMgt
{
    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnFillBufferLookupTypeCase', '', false, false)]
    local procedure HandleOnFillBufferLookupTypeCase(LookupType: Enum "Option Lookup Type"; var TableNo: Integer; var FieldNo: Integer; var RelationFieldNo: Integer; var IsHandled: Boolean)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if LookupType <> LookupType::"Gen. Journal Document Type" then
            exit;

        TableNo := Database::"Gen. Journal Line";
        FieldNo := GenJournalLine.FieldNo("Document Type");
        RelationFieldNo := GenJournalLine.FieldNo("Document No.");
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', false, false)]
    local procedure HandleOnBeforeIncludeOption(OptionLookupBuffer: Record "Option Lookup Buffer"; LookupType: Option; Option: Integer; var Handled: Boolean; var Result: Boolean; RecRef: RecordRef)
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        if LookupType <> Enum::"Option Lookup Type"::"Gen. Journal Document Type".AsInteger() then
            exit;

        //if UserId <> 'some user' then
        //    exit;

        Result := Option in [
                GenJournalLine."Document Type"::" ".AsInteger(),
                GenJournalLine."Document Type"::Invoice.AsInteger(),
                GenJournalLine."Document Type"::"Credit Memo".AsInteger(),
                GenJournalLine."Document Type"::"Finance Charge Memo".AsInteger()];
        Handled := true;
    end;


}