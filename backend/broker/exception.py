class BrokerError(Exception):
    pass


class BrokerClientError(BrokerError):
    pass


class BrokerClientConnectionError(BrokerClientError):
    pass

class BrokerClientDataError(BrokerClientError):
    pass
