# Flag Engine

Flag Engine is a small Feature Flag system implemented using Ruby on Rails.

The goal of this exercise was to design a simple, database-backed flag engine
that supports runtime evaluation with predictable precedence rules.

---

## Overview

This project allows features to be controlled without code changes by:

- Defining feature flags with a global default state
- Applying overrides at user level
- Applying overrides at group level
- Evaluating the final state at runtime

The implementation focuses on correctness, clarity, and separation of concerns
rather than UI or advanced rollout strategies.

---

## Feature Evaluation Logic

When evaluating a feature, the following precedence is applied:

1. User override (highest priority)
2. Group override
3. Global default (fallback)

This ensures deterministic and easy-to-reason-about behaviour.

---

## Data Model

### FeatureFlag

- `name` (unique identifier)
- `enabled` (global default state)
- `description` (optional)

### Override

- `feature_flag_id`
- `override_type` (`user` or `group`)
- `override_id`
- `enabled`

Overrides allow feature behaviour to differ for specific contexts.

---

## API Endpoints

### List Feature Flags

GET `/feature_flags`

Returns all defined feature flags.

---

### Create Feature Flag

POST `/feature_flags`

Example:

```json
{
  "feature_flag": {
    "name": "dark_mode",
    "enabled": true
  }
}

```

## Running the Application Locally

### Prerequisites

Make sure you have installed:

- Ruby (recommended version: 3.x)
- Rails (7.x)
- Bundler
- SQLite3


## Setup

Clone the repository:

git clone https://github.com/SoumyaKulkarni/flag_engine.git
cd flag_engine

Install dependencies:

bundle install

Setup database:

rails db:create
rails db:migrate
rails db:seed

## Run Tests

bundle exec rspec

## Run the Application

rails s

Server runs at http://localhost:3000



