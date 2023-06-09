import pika, sys

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))

channel = connection.channel()



channel.exchange_declare(exchange= 'direct_logs',
                         exchange_type= 'direct')

severity = sys.argv[1] if len(sys.argv) > 1 else 'info'

message = ' '.join(sys.argv[1:]) or "Hello World!"

channel.basic_publish(exchange= 'logs',
                      body = message,
                      routing_key= severity,
                      properties=pika.BasicProperties(
                          delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE
                      ))

print(" [x] Sent %r" % message)

connection.close()