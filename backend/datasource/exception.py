class DatasourceError(Exception):
    pass


class MappingError(DatasourceError):
    pass


class NetworkError(DatasourceError):
    pass


class DataError(DatasourceError):
    pass


class CacheError(DatasourceError):
    pass


class WorkerError(DatasourceError):
    pass


class WorkerResponseError(WorkerError):
    pass
