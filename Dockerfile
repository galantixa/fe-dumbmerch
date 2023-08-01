FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
COPY .	.
RUN npm i
RUN npm run build
RUN npm i -g serve
RUN 
EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]
