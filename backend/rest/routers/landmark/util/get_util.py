import json

from rest.exception import MappingError

from db.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut, GetLandmarkOutUnit


def map_get_landmark_inward_schema_to_message_body(schema: GetLandmarkIn) -> str:
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
    except (KeyError, TypeError) as error:
        raise MappingError from error

    return message_body


def map_get_landmark_message_body_to_outward_schema(body: str) -> GetLandmarkOut:

    unit_list = []

    try:
        deserialized_body = json.loads(body)
        print(deserialized_body)
        landmarks = deserialized_body['landmark']

        for landmark in landmarks:
            unit = GetLandmarkOutUnit(
                name=landmark['name'],
                id=landmark['id']
            )
            unit_list.append(unit)

        schema = GetLandmarkOut(
            landmark=unit_list
        )
    except (KeyError, TypeError, AttributeError) as error:
        raise MappingError from error

    return schema
