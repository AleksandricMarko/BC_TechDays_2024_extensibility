codeunit 50100 "Manual Subscriber example"
{
    EventSubscriberInstance = Manual;

    local procedure SumTwoNumbers(Number1: Integer; Number2: Integer)
    begin
        OnBeforeSumTwoNumbers(Number1, Number2);

        Message('Sum of %1 and %2 is %3', Number1, Number2, Number1 + Number2);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSumTwoNumbers(var Number1: Integer; var Number2: Integer)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Manual Subscriber example", 'OnBeforeSumTwoNumbers', '', true, true)]
    local procedure HandleOnBeforeSumTwoNumbers(var Number1: Integer; var Number2: Integer)
    begin
        if Number1 > Number2 then
            Number1 := Number2;
    end;

    procedure CallSumTwoNumbersWithoutBindSubscription()
    begin
        SumTwoNumbers(10, 5);
    end;

    procedure CallSumTwoNumbersWithBindSubscription()
    var
        ManualSubscriberExample: Codeunit "Manual Subscriber example";
    begin
        BindSubscription(ManualSubscriberExample);
        SumTwoNumbers(10, 5);
        UnbindSubscription(ManualSubscriberExample);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Print", 'OnBeforeProcessPrintSalesOrder', '', true, true)]
    local procedure HandleOnBeforeProcessPrintSalesOrder(var SalesHeader: Record "Sales Header"; Usage: Option; var IsHandled: Boolean)
    var
        Language: Codeunit "Language";
    begin
        Language.SetOverrideLanguageId(2067);  //Dutch (Belgian)        
    end;

}