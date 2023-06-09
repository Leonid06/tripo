import pika, sys

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))

channel = connection.channel()

result = channel.queue_declare(queue='', exclusive= True)

channel.queue_bind(exchange='logs',
                   queue=result.method.queue)

channel.exchange_declare(exchange= 'logs',
                         exchange_type= 'fanout')

message = ' '.join(sys.argv[1:]) or "Hello World!"

channel.basic_publish(exchange= 'logs',
                      body = message,
                      properties=pika.BasicProperties(
                          delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE
                      ))

print(" [x] Sent %r" % message)

connection.close()