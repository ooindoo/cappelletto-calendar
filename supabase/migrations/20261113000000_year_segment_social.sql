-- Year: the calendar was hardcoded to Aug–Dec 2026. Existing rows are 2026.
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS year INTEGER NOT NULL DEFAULT 2026;

-- Segment (uomo | donna | entrambi). Previously only encoded in titles.
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS segment TEXT;

-- Social & Inspo board (owned by the SMM), linked optionally to an email campaign.
CREATE TABLE IF NOT EXISTS social_posts (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  format TEXT NOT NULL DEFAULT 'reel',
  status TEXT NOT NULL DEFAULT 'idea',
  publish_date DATE,
  campaign_id BIGINT REFERENCES campaigns(id) ON DELETE SET NULL,
  notes TEXT,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS social_images (
  id BIGSERIAL PRIMARY KEY,
  post_id BIGINT NOT NULL REFERENCES social_posts(id) ON DELETE CASCADE,
  storage_path TEXT NOT NULL,
  label TEXT NOT NULL DEFAULT '',
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS social_links (
  id BIGSERIAL PRIMARY KEY,
  post_id BIGINT NOT NULL REFERENCES social_posts(id) ON DELETE CASCADE,
  label TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS social_posts_campaign_id_idx ON social_posts(campaign_id);
CREATE INDEX IF NOT EXISTS social_images_post_id_idx ON social_images(post_id);
CREATE INDEX IF NOT EXISTS social_links_post_id_idx ON social_links(post_id);

ALTER TABLE social_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE social_links ENABLE ROW LEVEL SECURITY;

-- Same access model as the existing tables (no login yet).
CREATE POLICY "Allow all access" ON social_posts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all access" ON social_images FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all access" ON social_links FOR ALL USING (true) WITH CHECK (true);

-- New tables are no longer auto-exposed to the Data API: grant explicitly.
GRANT SELECT, INSERT, UPDATE, DELETE ON social_posts, social_images, social_links TO anon, authenticated;
GRANT USAGE, SELECT ON SEQUENCE social_posts_id_seq, social_images_id_seq, social_links_id_seq TO anon, authenticated;

ALTER PUBLICATION supabase_realtime ADD TABLE social_posts;
ALTER PUBLICATION supabase_realtime ADD TABLE social_images;
ALTER PUBLICATION supabase_realtime ADD TABLE social_links;
