# Railway will use this Dockerfile to unpack and build the Next.js application.
FROM node:20-bookworm-slim
WORKDIR /app

# The source archive is kept at the repository root to make GitHub mobile upload simpler.
COPY sintash-home-source.tar.gz /tmp/sintash-home-source.tar.gz
RUN tar -xzf /tmp/sintash-home-source.tar.gz -C /app \
    && rm /tmp/sintash-home-source.tar.gz

# Prisma's postinstall/generate step needs a syntactically valid URL during image build.
# This is a build-only placeholder, NOT the production database connection.
RUN DATABASE_URL="postgresql://build:build@127.0.0.1:5432/build" npm install --no-audit --no-fund
RUN DATABASE_URL="postgresql://build:build@127.0.0.1:5432/build" npx prisma generate
RUN DATABASE_URL="postgresql://build:build@127.0.0.1:5432/build" npm run build

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
ENV PORT=3000
EXPOSE 3000
CMD ["npm", "run", "start"]
