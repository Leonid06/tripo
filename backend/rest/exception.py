class RestError(Exception):
    pass


class MappingError(RestError):
    pass


class CallbackError(RestError):
    pass


class CallbackDataError(CallbackError):
    pass


class NetworkClientError(RestError):
    pass


class NetworkClientDataError(NetworkClientError):
    pass


class NetworkClientBrokerError(NetworkClientError):
    pass
