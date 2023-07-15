import json
from landmark_api_microservice.exception import MappingError


async def landmark_get_request_topic_consume_callback(message, callback_asyncio_queue):
    try:
        deserialized_message_body = json.loads(message.body)
        await callback_asyncio_queue.put(deserialized_message_body)
    except json.JSONDecodeError:
        raise MappingError


def map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body(units):
    body = {'landmark': []}

    try:
        landmarks = body['landmark']

        for unit in units:
            landmarks.append({
                'id': unit.id,
                'name': unit.name
            })
        message_body = json.dumps(body)
    except (KeyError, TypeError, json.JSONDecodeError) as error:
        raise MappingError from error

    return message_body


def map_landmark_get_request_message_body_to_identification_list(body):
    try:
        landmarks = body['landmark']
        identifications = []
        for landmark in landmarks:
            identifications.append(landmark['id'])
    except (TypeError, KeyError):
        raise MappingError

    return identifications


def compose_error_landmark_get_response_body():
    body = {'error': 'error'}
    return json.dumps(body)
