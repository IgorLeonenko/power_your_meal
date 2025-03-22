# Power Your Meal 🍽️

A  web application for managing and discovering meals, with features for user authentication, favorites, and meal categorization. Built with Ruby on Rails 8.0.

## Requirements

- Ruby 3.4.0
- PostgreSQL 16
- Redis 7.x
- Node.js (for Tailwind CSS)
- Docker (optional, for containerized setup)

## Setup Instructions

### Docker Setup (Recommended)

1. Install Docker and Docker Compose
2. Clone the repository:

   ```bash
   git clone <repository-url>
   cd power_your_meal
   ```

3. Build and start the containers:

   ```bash
   docker compose build
   docker compose up
   ```

4. The application will be available at [http://localhost:3000](http://localhost:3000)

### Local Setup

1. Install rbenv and Ruby version:

   ```bash
   brew install rbenv ruby-build
   rbenv install 3.4.0
   ```

2. Install and run PostgreSQL 16

3. Install Redis

4. Install project dependencies:

   ```bash
   bundle install
   ```

5. Initialize the database:

   ```bash
   bin/rails db:create db:migrate db:seed
   ```

6. Start the development server:

   ```bash
   bin/dev
   ```

## Running Tests

```bash
bundle exec rspec
```
