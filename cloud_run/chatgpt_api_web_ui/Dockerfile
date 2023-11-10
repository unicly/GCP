FROM python:3.10

# Install libraries
RUN pip install openai reflex

# Download the code for the application
RUN git clone https://github.com/unicly/reflex-chat.git
WORKDIR /reflex-chat/webui

# Expose ports
EXPOSE 3000 8000

# Initialize reflex with the template
RUN reflex init --template sidebar

# Start your application
CMD ["reflex", "run"]
