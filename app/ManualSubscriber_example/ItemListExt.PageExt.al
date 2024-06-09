pageextension 50100 "Item List Ext" extends "Item List"
{
    actions
    {
        addlast(Functions)
        {
            action(ShowMessage)
            {
                ApplicationArea = All;
                Caption = 'Sum Two Numbers Without Bind Subscription';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ManualSubscriberExample: Codeunit "Manual Subscriber example";
                begin
                    ManualSubscriberExample.CallSumTwoNumbersWithoutBindSubscription();
                end;
            }
            action(ShowMessageWithBind)
            {
                ApplicationArea = All;
                Caption = 'Sum Two Numbers With Bind Subscription';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ManualSubscriberExample: Codeunit "Manual Subscriber example";
                begin
                    ManualSubscriberExample.CallSumTwoNumbersWithBindSubscription();
                end;
            }

            action(PrintOrderWithoutBind)
            {
                ApplicationArea = All;
                Caption = 'Print Order Without Bind Subscription';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    DocPrint: Codeunit "Document-Print";
                    ManualSubscriberExample: Codeunit "Manual Subscriber example";
                    Usage: Option "Order Confirmation","Work Order","Pick Instruction";
                begin
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange(Status, SalesHeader.Status::"Released");
                    SalesHeader.FindFirst();

                    DocPrint.PrintSalesOrder(SalesHeader, Usage::"Order Confirmation");
                end;
            }
            action(PrintOrderWithBind)
            {
                ApplicationArea = All;
                Caption = 'Print Order With Bind Subscription';
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    DocPrint: Codeunit "Document-Print";
                    ManualSubscriberExample: Codeunit "Manual Subscriber example";
                    Usage: Option "Order Confirmation","Work Order","Pick Instruction";
                    DoBindSubscription: Boolean;
                begin
                    SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                    SalesHeader.SetRange(Status, SalesHeader.Status::"Released");
                    SalesHeader.FindFirst();

                    DoBindSubscription := true; //some condition

                    if DoBindSubscription then
                        BindSubscription(ManualSubscriberExample);

                    DocPrint.PrintSalesOrder(SalesHeader, Usage::"Order Confirmation");

                    //ManualSubscriberExample local variable so UnBind not necessary
                    if DoBindSubscription then
                        UnbindSubscription(ManualSubscriberExample);
                end;
            }
        }
    }
}