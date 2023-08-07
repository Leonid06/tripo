import json
from datasource.exception import MappingError


def map_fuzzy_search_response_units_to_response_message_body(units):
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
    except (TypeError, KeyError) as error:
        raise MappingError from error

    return identifications


