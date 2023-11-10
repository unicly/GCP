# ChatGPT API web GUI

This Docker container creates a simple web interface for OpenAI API calls.

This application is using the code from https://github.com/reflex-dev/reflex-chat, which is based on the Reflex library https://reflex.dev/

The Docker container can be created and run locally with the following commands:

1. Build the container image

```
docker build --tag chatgpt-webui-reflex - < Dockerfile
```

2. Run the image
```
docker run \
    --env "OPENAI_API_KEY=YOU_API_KEY_GOES_HERE" \
    --publish 3000:3000 \
    --publish 8000:8000 \
    chatgpt-webui-reflex
```

The file `main.sh` contains the procedure to create and deploy the Docker image to Google Container Registry and run it on Cloud Run.
