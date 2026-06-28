# Fieldnotes — LLM Context

**Эталонное Rails-приложение в стиле DHH и Basecamp.**
Это референсная реализация Rails Way — так, как строят продукты в 37signals.
Каждое решение здесь должно быть ответом на вопрос: «А как бы это сделал DHH?»

---

## The Rails Doctrine (DHH)

### 1. The Majestic Monolith
Одно приложение. Один деплой. Один репозиторий. Никаких микросервисов, никаких API-first,
никаких отдельных фронтенд-приложений. HTML рендерится на сервере и отправляется в браузер.
Если нужна интерактивность — Turbo + Stimulus, не SPA.

### 2. Convention over Configuration
Если Rails предлагает способ — используй его. Не изобретай свой routing, свой ORM, свою
структуру папок. Имена файлов, классов, таблиц — всё по конвенции. `EssaysController` →
`app/controllers/essays_controller.rb` → `app/views/essays/`. Никаких сюрпризов.

### 3. The Menu Is Omakase
Используй то, что Rails положил на тарелку: Active Record, Action Text, Active Storage,
Active Job, Turbo, Stimulus, Solid Queue, Solid Cache, Solid Cable. Не тащи гем для того,
что фреймворк уже делает. Каждый гем — это зависимость, которая сломается.

### 4. No One Paradigm
Callbacks — это нормально. Concerns — это нормально. Helpers — это нормально.
Не нужно выбирать между ООП и функциональным стилем. Rails — прагматичный фреймворк.
Используй тот инструмент, который делает код короче и понятнее.

### 5. Exalt Beautiful Code
Код должен читаться как проза. Если нужен комментарий чтобы объяснить что делает код —
перепиши код. Имена переменных, методов, классов должны рассказывать историю.
Лучший код — тот, которого нет. Второй лучший — самый короткий, который решает задачу.

### 6. Provide Sharp Knives
Не оборачивай всё в safe-обёртки. `before_destroy` callback может удалить связанные данные —
и это нормально. Доверяй разработчику. Не добавляй guard clauses для невозможных состояний.

### 7. Value Integrated Systems
Полный стек от базы до браузера в одном приложении. Active Storage вместо S3-микросервиса.
Action Text вместо headless CMS. Action Mailer вместо email-сервиса. Solid Queue вместо
Sidekiq + Redis. SQLite вместо PostgreSQL + connection pooling.

### 8. Progress over Stability
Используй новейшие возможности Ruby 4.0 (`it` block parameter, PRISM parser) и Rails 8.1.
Не держись за старые паттерны из совместимости. Код пишется для текущей версии фреймворка.

### 9. Push Up a Big Tent
ERB — потому что любой Rails-разработчик его знает. Minitest — потому что он в stdlib.
Fixtures — потому что они быстрые и декларативные. Без экзотики, без порога входа.

---

## Architecture Principles (Basecamp Style)

### Controllers
- **Максимум 7 actions:** index, show, new, create, edit, update, destroy.
- Нужен дополнительный action? **Создай новый контроллер.** `Essays::PublishesController#create`
  вместо `EssaysController#publish`.
- **Skinny controllers.** Контроллер делает три вещи: принимает params, вызывает модель,
  рендерит ответ. Бизнес-логика — в модели.
- `before_action` для аутентификации и загрузки ресурсов. Не для бизнес-логики.
- Strong params — единственный способ фильтрации входных данных. Никаких form objects.

### Models
- **Fat models** — но не ожиревшие. Модель знает свои правила, свои scopes, свои callbacks.
- Если модель > 200 строк — выноси связанное поведение в **concerns** (`Sluggable`, `Taggable`).
- **Scopes** вместо query objects. `Essay.published` вместо `PublishedEssaysQuery.call`.
- **Callbacks** — это Rails Way. `before_save`, `after_create_commit` — используй их.
  Не борись с фреймворком.
- **Нет service objects** для простых операций. Метод модели или callback достаточно.
  Service object — только когда операция затрагивает несколько несвязанных моделей.
- **Нет presenter/decorator.** Helpers + модель. `essay.reading_time` в модели,
  `badge(status)` в helper.

### Views (ERB)
- **ERB** — единственный шаблонизатор. Никаких Phlex, ViewComponent, Slim, Haml.
- Partials для переиспользования: `_form.html.erb`, `_card.html.erb`.
- `<%# locals: (var:) %>` — строгая декларация параметров partial.
- Helpers для HTML-генерации: `admin_card`, `badge`, `picture_tag`.
- **Никакой логики в views** — максимум `if/each`. Сложная логика → helper или модель.
- Controllers передают `@ivars`. Views читают их. Никаких props, никаких initializers.

### JavaScript (Stimulus + Turbo)
- **Turbo Drive** — бесплатный SPA-эффект без единой строки JS.
- **Turbo Frames** — частичное обновление страницы без полной перезагрузки.
- **Turbo Streams** — real-time обновления через WebSocket (Solid Cable).
- **Stimulus** — минимальный JS для поведения, которое не покрывает Turbo.
  Один контроллер = одно поведение. >50 строк → пересмотри дизайн.
- **Importmaps** — никакого webpack, esbuild, vite. Нет build step для JS.
- **Нет TypeScript.** Vanilla JS. Stimulus-контроллеры настолько маленькие, что типы не нужны.

### CSS
- **Tailwind CSS v4** — utility-first. Никакого custom CSS кроме того, что Tailwind не может.
- Никаких CSS-in-JS, никаких styled-components, никаких CSS modules.
- Dark theme, orange accent (`orange-500`).

### Testing (Basecamp Style)
- **Minitest** — в stdlib, быстрый, простой. Не RSpec.
- **Fixtures** — декларативные, быстрые, загружаются один раз. Не FactoryBot.
- **Нет моков БД.** Тесты работают с реальной базой, реальными запросами.
- **System tests** (Capybara) для пользовательских сценариев.
- **Тестируй поведение, не реализацию.** Одна хорошая проверка лучше десяти тривиальных.
- `bin/ci` запускает всё.

### Background Jobs
- **Solid Queue** — job queue в SQLite, не Redis. Часть Rails 8.
- Jobs для тяжёлых операций: обработка изображений, извлечение EXIF, отправка email.
- `after_create_commit` → job. Не делай тяжёлое в request cycle.

### Deployment
- **Kamal 2** — Docker-деплой на VPS. Не Heroku, не Kubernetes.
- **SQLite** в production — один файл, нет connection pool, нет отдельного сервера БД.
- **Thruster** — HTTP caching и compression перед Puma.

### Security
- `before_action :require_authentication` — Rails built-in auth. Не Devise, не Pundit.
- Strong params — единственный guard на входные данные.
- **Нет shell injection** — array-form `IO.popen` или `system`, никогда backtick interpolation.
- CSRF protection — Rails default. CSP — via meta tag.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Ruby | 4.0.1 (PRISM parser, YJIT in production) |
| Rails | 8.1.3 |
| Database | SQLite via Litestack |
| Jobs / Cache / WS | Solid Queue · Solid Cache · Solid Cable |
| Assets | Propshaft · Importmaps · Stimulus |
| Views | **ERB** templates + partials |
| Styling | **Tailwind CSS v4** (via `tailwindcss-rails`) |
| Rich text | Action Text + **Lexxy** `0.9.0.beta` — do NOT use Trix |
| Images | Active Storage + libvips → AVIF |
| Auth | Rails built-in authentication generator |
| Deploy | Kamal 2 |

---

## Hard Rules (Запреты)

- **No Phlex, no ViewComponent, no Slim, no Haml** — only ERB.
- **No Alpine, no HTMX, no React, no Vue** — only Stimulus + Turbo.
- **No RSpec, no FactoryBot** — only Minitest + fixtures.
- **No Devise, no Pundit** — only Rails built-in auth.
- **No ActiveAdmin** — admin на ERB руками.
- **No service objects** где хватит метода модели.
- **No form objects** где хватит strong params.
- **No query objects** где хватит scope.
- **No presenter/decorator** где хватит helper.
- **No custom CSS** где хватит Tailwind.
- **No Redis** — Solid Queue / Cache / Cable.
- **No webpack/esbuild/vite** — Importmaps.
- **No TypeScript** — vanilla JS.
- **No microservices** — majestic monolith.

---

## Data Models

```ruby
# CORE
essays:       title, slug, excerpt, status(draft/published), published_at,
              latitude, longitude, location_name
              has_rich_text :content
              has_one_attached :cover

now_entries:  body(rich text), published_at, location

# OPTIONAL
builds:       title, slug, description, url, icon_emoji,
              status(active/paused/completed/archived), kind(business/oss/media/community/other),
              position, started_on, finished_on
              has_one_attached :cover

books:        title, author, isbn, cover_url, year_read, rating(1-5),
              key_idea(text), status(reading/completed/abandoned)

field_series: title, slug, description, kind(photo/video/mixed),
              location, taken_on, latitude, longitude
              has_one_attached :cover

field_items:  field_series_id, kind(photo/video), caption, position, youtube_url,
              camera_make, camera_model, lens, focal_length, aperture,
              shutter_speed, iso, taken_at, gps_latitude, gps_longitude
              has_one_attached :photo

# SYSTEM
tags/taggings: polymorphic (tag_id, taggable_id, taggable_type)
page_views:    event(string), payload(json), created_at
```

---

## Routes

```ruby
root "public/feed#index"

scope module: :public do
  resources :essays,   only: [:index, :show], param: :slug
  resources :builds,   only: [:index]
  resources :books,    only: [:index, :show]
  resources :field,    only: [:index, :show], param: :slug
  get "/now",     to: "now#show"
  get "/feed",    to: "feed#index"
  get "/contact", to: "pages#contact"
  get "/about",   to: "pages#about"
  get "/uses",    to: "pages#uses"
end

namespace :admin do
  root "essays#index"
  resources :essays, :builds, :books
  resources :field do
    resources :field_items, only: [:create, :destroy, :update]
  end
  resource :quick, only: [:new, :create]
  resource :now, only: [:edit, :update]
end
```

---

## Coding Conventions

- **Ruby 4.0:** `it` block parameter, PRISM parser, endless methods где уместно.
- **Slugs:** `/essays/rails-sqlite-production-2026` not `/essays/1234`.
- **Never inline image variants** — warm via `ImageVariantJob`.
- **Videos:** YouTube facade (`youtube-nocookie.com`) — no local storage.
- **Без комментариев** в коде. Комментарий — только если WHY неочевиден.
- **Без мёртвого кода.** Нет неиспользуемых методов, нет закомментированного кода,
  нет defensive checks для невозможных состояний.

---

## Docs

| Topic | File |
|---|---|
| Architecture & philosophy | `docs/architecture.md` |
| Local setup | `docs/getting-started.md` |
| Deployment | `docs/deployment.md` |
| Design tokens | `docs/design.md` |
| SEO, OG, RSS | `docs/seo.md` |
| Image pipeline | `docs/images.md` |
| Rails 8 features | `docs/rails8-features.md` |
