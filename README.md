# CappellettoShop — Calendario Campagne Email

Calendario campagne email per CappellettoShop, periodo agosto–dicembre 2026.
Vista timeline + griglia, CRUD completo, filtri per tipo/stato, ricerca, sync real-time multi-utente via Supabase.

## Stack

- React (JSX) — nessun build step, compilato in-browser con Babel standalone
- Supabase (Postgres + Realtime) per la persistenza e la sincronizzazione multi-utente
- Deploy statico su Vercel — file singolo `index.html` in root

## Setup locale

```bash
npx serve .
```

Apri `http://localhost:3000`.

## Backend

Il progetto Supabase è collegato in `supabase/`. Per applicare le migration a un nuovo progetto:

```bash
npx supabase link --project-ref <project-ref>
npx supabase db push
```

Le credenziali (`SUPABASE_URL` / `SUPABASE_ANON_KEY`) sono impostate direttamente in `index.html`.

## Struttura dati

Tabella `campaigns`: `label`, `type`, `status`, `month` (8–12), `day`, `end_day` (opzionale), `notes`.

Tipi campagna: Lancio Prodotto, Promozione/Sconto, Newsletter, Editoriale/Storytelling, Evento/Fiera, Automazione/Flow.
Stati: Confermato, Pianificato, TBD.
