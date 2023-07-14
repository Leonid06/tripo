import json


async def landmark_get_request_topic_consume_callback(message, callback_asyncio_queue):
    print('Received message')
    deserialized_message_body = json.loads(message.body)
    await callback_asyncio_queue.put(deserialized_message_body)


def map_fuzzy_search_response_units_to_serialized_landmark_get_response_message_body(units):
    body = {'landmark': []}
    landmarks = body['landmark']

    for unit in units:
        landmarks.append({
            'id': unit.id,
            'name': unit.name
        })

    return json.dumps(body)


def map_landmark_get_request_message_body_to_identification_list(body):
    landmarks = body['landmark']
    identifications = []
    for landmark in landmarks:
        identifications.append(landmark['id'])

    return identifications
