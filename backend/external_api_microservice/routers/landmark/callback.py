import json



def get_landmark_by_id_broker_request_callback(queue, message_body, asyncio_queue):
    queue.cancel()
    deserialized_body = json.loads(message_body)
    asyncio_queue.put(deserialized_body)


