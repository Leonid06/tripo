import json

from rest.schema.landmark.search import SearchLandmarkByRadiusIn, SearchLandmarkOut, SearchLandmarkOutUnit

from rest.exception import MappingError, CallbackDataError


def map_search_landmark_by_radius_inward_schema_to_message_body(schema: SearchLandmarkByRadiusIn) -> str:
    message_body = {}

    try:
        message_body['latitude'] = schema.latitude
        message_body['longitude'] = schema.longitude
        message_body['radius'] = schema.radius

    except (TypeError, AttributeError) as error:
        raise MappingError from error

    serialized_message_body = json.dumps(message_body)

    return serialized_message_body


def map_search_landmark_message_body_to_outward_schema(body: str) -> SearchLandmarkOut:
    unit_list = []

    try:
        deserialized_body = json.loads(body)
        landmarks = deserialized_body['landmark']

        for landmark in landmarks:
            unit = SearchLandmarkOutUnit(
                id=landmark['id'],
                name=landmark['name']
            )
            unit_list.append(unit)

        schema = SearchLandmarkOut(
            landmark=unit_list
        )
    except (KeyError, TypeError, AttributeError) as error:
        raise MappingError from error

    return schema


async def search_landmark_request_callback(message, asyncio_queue):
    try:
        await asyncio_queue.put(message.body)
    except (TypeError, AttributeError) as error:
        raise CallbackDataError from error
