---
title: Pagination
---

# Pagination

A row of page-number buttons with optional ellipsis collapse.

## When to use it

Use `Pagination` below a paginated list or table to let users jump between
pages. Pages are zero-indexed. Distant pages are collapsed into `…`
separators; the first and last pages are always shown.

## Import

```dart
import 'package:catalyst_ui/catalyst_ui.dart';
```

## Usage

```dart
Pagination(
  currentPage: _page,
  pageCount: 12,
  onChanged: (p) => setState(() => _page = p),
)
```

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `currentPage` | `int` | required | The zero-based index of the currently active page. |
| `pageCount` | `int` | required | The total number of pages minus one (the last valid index). |
| `onChanged` | `ValueChanged<int>` | required | Called with the zero-based index of the newly selected page. |
| `forwardIcon` | `IconData?` | `null` | Icon to display on the "next page" button. Falls back to `Iconography.forwardIcon`. |
| `backIcon` | `IconData?` | `null` | Icon to display on the "previous page" button. Falls back to `Iconography.backIcon`. |

## Iconography

- The "previous page" button shows `backIcon`, falling back to
  `context.iconography.backIcon`.
- The "next page" button shows `forwardIcon`, falling back to
  `context.iconography.forwardIcon`.
