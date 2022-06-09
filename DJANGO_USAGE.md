# Django Usage

A middleware to add the current user to the transactions

Add as low down as possible in the order so all the session, user security comes first.

```python
from django.db import connection, transaction


class AuditLogUserMiddleware:
    """
    Execute the request/response cycle in an atomic transaction.
    Update the audit log with the current user.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.method in ["POST", "PUT", "PATCH", "DELETE"]:
            with transaction.atomic():
                response = self.get_response(request)
                if request.user.is_authenticated:
                    with connection.cursor() as cursor:
                        sql = """
                            UPDATE audit.logged_actions
                            SET meta_fields = hstore('current_user', %s)
                            WHERE transaction_id = txid_current();
                        """
                        cursor.execute(sql, [str(request.user)])
                return response
        return self.get_response(request)
```