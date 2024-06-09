table 50100 "Lookup Buffer"
{
    Caption = 'Lookup Buffer';
    LookupPageID = "Lookup Buffer List";
    ReplicateData = false;
    TableType = Temporary;
    DataClassification = CustomerContent;
    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = SystemMetadata;
            Editable = false;
            AutoIncrement = true;
        }
        field(2; "Value Caption"; Text[30])
        {
            Caption = 'Values';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(3; "Lookup Type"; Enum "Option Lookup Type")
        {
            Caption = 'Lookup Type';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }
    keys
    {
        key(Key1; "Value Caption")
        {
            Clustered = true;
        }
        key(Key2; ID)
        {
        }
    }

    var
        UnsupportedValueErr: Label 'Unsupported Lookup Value.';
        InvalidLocationValueErr: Label '''%1'' is not a valid location value for this document.', Comment = '%1 = Location Code';
        CurrentLocation: Code[20];

    procedure FillLookupBuffer(LookupType: Enum "Option Lookup Type")
    var
        Location: Record Location;
        TableNo: Integer;
        FieldNo: Integer;
        RelationFieldNo: Integer;
    begin
        case LookupType of
            "Lookup Type"::"Service Location":
                FillBufferInternal(DATABASE::Location, Location.FieldNo(Code), 0, LookupType);
        //else begin
        //    IsHandled := false;
        //    OnFillBufferLookupTypeCase(LookupType, TableNo, FieldNo, RelationFieldNo, SourceType, SourceSubType, IsHandled);
        //    if not IsHandled then
        //        Error(UnsupportedValueErr);
        //    FillBufferInternal(TableNo, FieldNo, RelationFieldNo, LookupType);
        end;
    end;

    procedure AutoCompleteLookup(var CodeValue: Code[20]; LookupType: Enum "Option Lookup Type"): Boolean
    begin
        CodeValue := DelChr(CodeValue, '<>');

        SetRange("Value Caption");
        if IsEmpty() then
            FillLookupBuffer(LookupType);

        SetRange("Value Caption", CodeValue);
        if FindFirst() then
            exit(true);

        SetFilter("Value Caption", '%1', '@' + CodeValue + '*');
        if FindFirst() then begin
            CodeValue := "Value Caption";
            exit(true);
        end;

        SetFilter("Value Caption", '%1', '@*' + CodeValue + '*');
        if FindFirst() then begin
            CodeValue := "Value Caption";
            exit(true);
        end;

        SetRange("Value Caption", CurrentLocation);
        if FindFirst() then begin
            CodeValue := "Value Caption";
            exit(true);
        end;

        exit(false);
    end;

    procedure ValidateCodeValue(CodeValue: Code[20])
    begin
        SetRange("Value Caption", CodeValue);
        if IsEmpty() then
            Error(InvalidLocationValueErr, CodeValue);

        SetRange("Value Caption");
    end;

    procedure FormatCodeValue(FieldRef: FieldRef) Result: Code[20]
    begin
        exit(Format(FieldRef.Value));
    end;

    local procedure CreateNew(ValueID: Integer; Value: Text[30]; LookupType: Enum "Option Lookup Type")
    begin
        Init();
        ID := ValueID;
        "Value Caption" := Value;
        "Lookup Type" := LookupType;
        Insert();
    end;

    local procedure FillBufferInternal(TableNo: Integer; FieldNo: Integer; RelationFieldNo: Integer; LookupType: Enum "Option Lookup Type")
    var
        RecRef: RecordRef;
        RelatedRecRef: RecordRef;
        FieldRef: FieldRef;
        FieldRefRelation: FieldRef;
        ValueIndex: Integer;
        RelatedTableNo: Integer;
    begin
        RecRef.Open(TableNo);
        FieldRef := RecRef.Field(FieldNo);
        if RecRef.FindSet() then
            repeat
                if IncludeCode(LookupType, FieldRef.Value(), RecRef, ValueIndex) then begin
                    FieldRefRelation := RecRef.Field(RelationFieldNo);
                    RelatedTableNo := FieldRefRelation.Relation();
                    if RelatedTableNo = 0 then
                        CreateNew(ValueIndex, FieldRef.Value, LookupType)
                    else begin
                        RelatedRecRef.Open(RelatedTableNo);
                        RelatedRecRef.SetPermissionFilter();
                        if RelatedRecRef.ReadPermission then
                            CreateNew(ValueIndex, FieldRef.Value, LookupType);
                        RelatedRecRef.Close();
                    end;
                end;
            until RecRef.Next() = 0;
    end;

    local procedure IncludeCode(LookupType: Enum "Option Lookup Type"; CodeValue: Code[20]; RecRef: RecordRef; var OrderId: Integer): Boolean
    begin
        OrderId := 0;

        case LookupType of
            LookupType::"Service Location":
                begin
                    if CodeValue in ['SILVER', 'BLUE'] then   //possible to define condition per specific need
                        exit(true);
                end;
        end;
    end;

    procedure SetCurrentLocation(LocationCode: Code[20])
    begin
        CurrentLocation := ''; // Default value

        if Rec.Count() = 1 then begin
            Rec.FindFirst();
            CurrentLocation := Rec."Value Caption";
        end;

        if LocationCode <> '' then
            CurrentLocation := LocationCode;
    end;
}