import json

from rest.exception import MappingError, CallbackDataError

from rest.schema.landmark.get import GetCachedLandmarkIn, GetCachedLandmarkOut, GetCachedLandmarkOutUnit


def map_get_landmark_inward_schema_to_message_body(schema: GetCachedLandmarkIn) -> str:
    message_body = {
        'landmark': []
    }
    try:
        landmark_list = message_body['landmark']
        landmarks = schema.landmark

        for landmark in landmarks:
            landmark_list.append({
                'id': landmark.id
            })
        message_body = json.dumps(message_body)
    except (KeyError, AttributeError, TypeError) as error:
        raise MappingError from error

    return message_body


def map_get_landmark_message_body_to_outward_schema(body: str) -> GetCachedLandmarkOut:
    unit_list = []

    try:
        deserialized_body = json.loads(body)
        print(deserialized_body)
        landmarks = deserialized_body['landmark']

        for landmark in landmarks:
            unit = GetCachedLandmarkOutUnit(
                name=landmark['name'],
                id=landmark['id']
            )
            unit_list.append(unit)

        schema = GetCachedLandmarkOut(
            landmark=unit_list
        )
    except (KeyError, TypeError, AttributeError) as error:
        raise MappingError from error

    return schema


async def get_landmark_by_id_broker_request_callback(message, asyncio_queue):
    try:
        await asyncio_queue.put(message.body)
    except (TypeError, AttributeError) as error:
        raise CallbackDataError from error
