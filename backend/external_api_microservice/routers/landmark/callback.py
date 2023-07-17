import json

from external_api_microservice.exception import CallbackDataError


async def get_landmark_by_id_broker_request_callback(message, asyncio_queue):
    try:
        await asyncio_queue.put(message.body)
    except (TypeError, AttributeError) as error:
        raise CallbackDataError from error
