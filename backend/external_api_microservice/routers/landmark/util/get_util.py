from postgresql_microservice.schemas.landmark.get import GetLandmarkIn, GetLandmarkOut, GetLandmarkOutUnit
from typing import Dict

def map_get_landmark_inward_schema_to_message_body(schema : GetLandmarkIn) -> Dict:
    message_body = {
        'landmark' : []
    }
    landmark_list = message_body['landmark']
    landmarks = schema.landmark

    for landmark in landmarks:
        landmark_list.append({
            'id' : landmark.id
        })

    return message_body

def map_get_landmark_message_body_to_outward_schema(body :Dict) -> GetLandmarkOut :
    unit_list = []
    landmarks = body['landmark']

    for landmark in landmarks:
        unit = GetLandmarkOutUnit(
            name = landmark['name'],
            id = landmark['id']
        )
        unit_list.append(unit)

    schema = GetLandmarkOut(
        landmark=unit_list
    )

    return schema
