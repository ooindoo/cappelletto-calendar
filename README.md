# CappellettoShop — Calendario Campagne

Calendario delle campagne email CappellettoShop con sezione Social & Inspo per la SMM.
Live: https://cappelletto-calendar.vercel.app

## Sezioni

- **Email** — Timeline (mese corrente in evidenza, linea "Oggi", settimane, mesi passati raccolti) e
  Calendario mensile (drag & drop tra giorni, "+" per creare in un giorno). Filtri per stato, segmento e tipo.
- **Social & Inspo** — bacheca Idea → Approvata → Da realizzare → Pubblicata, con immagini di riferimento,
  link inspo/prodotti, formato, data di pubblicazione e collegamento opzionale a una campagna email.

## Stack

- React (JSX) compilato in-browser con Babel standalone, file unico `index.html` — nessun build step
- Supabase (Postgres + Realtime + Storage bucket `campaign-images`)
- Deploy statico su Vercel

## Dati

- `campaigns`: `label`, `type`, `status`, `year`, `month`, `day`, `end_day`, `segment`, `notes`
  - tipi: `launch`, `back_in_stock`, `brand`, `seasonal`, `promo`, `event`, `editorial`
    (i vecchi `newsletter`/`automation` sono mappati su `seasonal`/`editorial`)
  - stati: `tbd`, `planned`, `confirmed`, `sent`
  - segmenti: `uomo`, `donna`, `entrambi`
- `campaign_images` / `campaign_links` — allegati delle campagne
- `social_posts`, `social_images`, `social_links` — sezione Social & Inspo

Il frontend rileva lo schema al caricamento: funziona anche se una migrazione non è ancora applicata.

## Setup locale

```bash
npx serve -l 3057 .
```

## Migrazioni

In `supabase/migrations/`. Si applicano dal SQL Editor di Supabase oppure con un token via Management API.
Le nuove tabelle richiedono `GRANT` espliciti ai ruoli `anon`/`authenticated` (non più esposte di default).

## Accesso

Nessun login: chi ha il link può leggere e modificare. Da valutare un login con ruoli prima di allargare l'accesso.
