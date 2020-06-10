FROM node:12

# Setting working directory. All the path will be relative to WORKDIR
WORKDIR /usr/src/app

# Installing dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copying source files
COPY . .

# Building app
RUN yarn lint
RUN yarn test
RUN yarn build

# Running the app
CMD [ "yarn", "start" ]
