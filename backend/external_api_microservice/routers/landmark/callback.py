import json



async def get_landmark_by_id_broker_request_callback(message, asyncio_queue):
    await asyncio_queue.put(message.body)


