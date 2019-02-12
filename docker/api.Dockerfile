FROM ruby:2.6

# Define where our application will live inside the image
ENV RAILS_ROOT /usr/src/app
WORKDIR $RAILS_ROOT

COPY Gemfile* $RAILS_ROOT/

RUN bundle install --jobs=3 --retry=3 \
    && curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 > /usr/bin/jq \
    && chmod a+x /usr/bin/jq \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
