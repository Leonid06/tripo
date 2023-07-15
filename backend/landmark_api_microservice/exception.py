class LandmarkMicroserviceError(Exception):
    pass


class MappingError(LandmarkMicroserviceError):
    pass


class NetworkError(LandmarkMicroserviceError):
    pass


class DataError(LandmarkMicroserviceError):
    pass


class CacheError(LandmarkMicroserviceError):
    pass


class WorkerError(LandmarkMicroserviceError):
    pass


class WorkerResponseError(WorkerError):
    pass
