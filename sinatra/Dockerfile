FROM ruby:2.6-slim

# Install production dependencies.
WORKDIR /usr/src/app
COPY Gemfile ./
# ENV BUNDLE_FROZEN=true
RUN gem install bundler && bundle install

# Copy local code to the container image.
COPY . ./

# Run the web service on container startup.
CMD ["ruby", "./app.rb"]
