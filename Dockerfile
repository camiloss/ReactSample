### Build environment ###
FROM node:10-alpine as node



# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
COPY .npmrc ./



RUN npm i

RUN rm -f .npmrc

# Bundle app source
COPY . .



# Generate build
RUN npm run build



### Deploy application ###
FROM nginx:1.15-alpine

# Copy dist application to nginx server
COPY --from=node /usr/src/app/build /usr/share/nginx/html/frontend-product-ui

# Give write permissions to nginx user
# RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run

# Copy nginx default configuration
COPY ./nginx.conf /etc/nginx/nginx.conf

# Expose port 8080
EXPOSE 8080

# Use nginx user (non-root)
# USER nginx
