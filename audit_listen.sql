CREATE OR REPLACE FUNCTION audit.notify_audit_logged_action_channel()
    RETURNS TRIGGER AS $$
DECLARE
    payload json;
BEGIN
    payload := json_build_object(
        'event_id', NEW.event_id,
        'schema_name', NEW.schema_name,
        'table_name', NEW.table_name,
        'action', NEW.action,
        'statement_only', NEW.statement_only
    );
    PERFORM pg_notify('audit_logged_action', payload::text);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_notify_action_channel
AFTER INSERT ON audit.logged_actions
FOR EACH ROW EXECUTE FUNCTION audit.notify_audit_logged_action_channel();