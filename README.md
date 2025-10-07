# GTM Template – GA4 Client & Session ID with readAnalyticsStorage

This repository provides a Google Tag Manager (GTM) custom template that uses the new readAnalyticsStorage API to reliably access Google Analytics 4 (GA4) Client ID and Session ID.

## Usage :

Import the .tpl file into GTM under Templates → Variable Templates.

Create a new variable based on this template.

Choose whether to return the Client ID, the Session ID, or both.

Optionally, store values in cookies or localStorage for later use.

## Why use it?

Official, stable API from Google (no more fragile regex hacks on the _ga cookie).

Reliable and secure way to access GA4 identifiers.

Useful for advanced tracking and user journey analysis.
