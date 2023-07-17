class DatabaseError(Exception):
    pass


class DatabaseDataError(DatabaseError):
    pass


class DatabaseDisconnectionError(DatabaseError):
    pass


class DatabaseTimeoutError(DatabaseError):
    pass


class DatabaseResourceInvalidatedError(DatabaseError):
    pass


class DatabaseNoResultFoundError(DatabaseError):
    pass