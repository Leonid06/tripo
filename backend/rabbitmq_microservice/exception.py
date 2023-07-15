class RabbitMQMicroserviceError(Exception):
    pass


class BrokerClientError(RabbitMQMicroserviceError):
    pass


class BrokerClientConnectionError(BrokerClientError):
    pass

class BrokerClientDataError(BrokerClientError):
    pass
