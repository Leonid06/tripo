class ExternalRestMicroserviceError(Exception):
    pass


class MappingError(ExternalRestMicroserviceError):
    pass


class CallbackError(ExternalRestMicroserviceError):
    pass


class CallbackDataError(CallbackError):
    pass


class NetworkClientError(ExternalRestMicroserviceError):
    pass


class NetworkClientDataError(NetworkClientError):
    pass


class NetworkClientBrokerError(NetworkClientError):
    pass
