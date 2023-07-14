import asyncio

from landmark_api_microservice import main

if __name__ == '__main__':
    asyncio.run(main.main())
    print('sent')

