codeunit 81751 "OnInsert Subscriber"
{
    EventSubscriberInstance = Manual;

    [EventSubscriber(ObjectType::Table, database::"NSP Entry Table", OnBeforeInsertEvent, '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "NSP Entry Table")
    begin
        // Do Nothing, prevent Bulk insert

    end;

}
