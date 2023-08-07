import json
from datasource.exception import MappingError

async def basic_consume_callback(message, callback_asyncio_queue):
    try:
        deserialized_message_body = json.loads(message.body)
        await callback_asyncio_queue.put(deserialized_message_body)
    except json.JSONDecodeError as error:
        raise MappingError from error

def compose_basic_error_landmark_get_response_body():
    body = {'error': 'error'}
    return json.dumps(body)