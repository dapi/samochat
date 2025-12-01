# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Samochat is a Rails 8 application that provides customer support through Telegram. Users can embed a chat widget on their website, and customer messages are forwarded to a Telegram group as forum topics, allowing operators to respond directly from Telegram.

## Development Commands

```bash
# Start development server with all services
bin/dev                          # Uses foreman with Procfile.dev

# Run tests
bin/rails test                   # Unit and integration tests
bin/rails test:system            # System tests with browser
bin/rails test test/models/      # Test specific directory
bin/rails test test/models/project_test.rb:15  # Single test at line

# Linting and security
bin/rubocop                      # Ruby linter
bin/rubocop -A                   # Auto-fix violations
bin/brakeman -q -w2              # Security scanner
bin/bundler-audit --update       # Dependency audit

# Database
bin/rails db:test:prepare        # Prepare test database

# Telegram bot poller (development)
bundle exec rake telegram:bot:poller
```

## Architecture

### Message Flow
1. **Visitor** → Website widget sends request to `/v` endpoint → `RegisterVisitJob` creates/updates `Visitor` and `VisitorSession`
2. **Client message** → Bot receives private message → `ForwardClientMessageJob` → `CreateForumTopicJob` creates topic in Telegram group → `TopicMessageJob` posts message
3. **Operator reply** → Bot receives message in group topic → `ForwardOperatorMessageJob` → Message sent to client via Telegram

### Core Models
- `Project` - Customer's support project with Telegram group configuration
- `Visitor` - End-user identified by Telegram user, linked to a project
- `VisitorSession` - Tracks visitor sessions with geo data
- `Visit` - Page visit records
- `Membership` - Links users to projects with roles
- `TelegramUser` - Telegram user data cache
- `TelegramEvent` - Logs all incoming Telegram updates

### Telegram Integration
- Uses `telegram-bot` gem with webhook controller at `Telegram::WebhookController`
- Supports both default bot and custom per-project bots via `CustomTelegramBotMiddleware`
- Actions split into concerns: `Commands::Start`, `Commands::Who`, `Actions::Message`, `Actions::MyChatMember`

### Background Jobs (SolidQueue)
- `CreateForumTopicJob` - Creates Telegram forum topic for new visitors
- `UpdateForumTopicJob` - Updates topic title with visitor info
- `TopicMessageJob` - Posts messages to forum topics
- `ForwardClientMessageJob` / `ForwardOperatorMessageJob` - Message routing

### Configuration
- Uses `anyway_config` gem via `ApplicationConfig` class
- Environment prefix: `SAMOCHAT_*` (e.g., `SAMOCHAT_BOT_TOKEN`, `SAMOCHAT_HOST`)

## Testing

Tests use Minitest with fixtures. Key test helpers:
- `TelegramControllerTestCase` - Base class for Telegram webhook tests
- `test/telegram_updates.rb` - Example Telegram webhook payloads
- Integration tests use `login!(user)` helper for authentication
- Telegram bot is stubbed in tests via `Telegram::Bot::ClientStub`

## Key Directories
- `app/controllers/concerns/telegram/` - Telegram bot action handlers
- `config/configs/` - Anyway::Config configuration classes
- `lib/` - Custom middleware (`CustomTelegramBotMiddleware`, `AdminRestriction`)
