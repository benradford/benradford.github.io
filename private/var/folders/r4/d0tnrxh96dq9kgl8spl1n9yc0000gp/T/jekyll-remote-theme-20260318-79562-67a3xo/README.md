# MCM Academic Jekyll Theme

A mid-century modern academic Jekyll theme designed for personal academic websites.

## Installation

### As a remote theme (GitHub Pages compatible)

Add the following to your site's `_config.yml`:

```yaml
remote_theme: benradford/mcm-academic-jekyll-theme
plugins:
  - jekyll-remote-theme
```

And add `jekyll-remote-theme` to your `Gemfile`:

```ruby
gem "jekyll-remote-theme"
```

## Layouts

- `page` - Generic page layout
- `post` - Blog post layout
- `post-index` - Paginated post listing
- `publication` - Academic publication layout
- `software` - Software project layout

## Includes

- `head.html` - HTML head with meta tags, stylesheets, fonts
- `navigation.html` - Site header and navigation
- `footer.html` - Site footer
- `pagination.html` - Pagination controls
- `citation.html` - BibTeX citation generator
- `browser-upgrade.html` - Legacy browser prompt
