CREATE TABLE campaign_images (
  id BIGSERIAL PRIMARY KEY,
  campaign_id BIGINT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  storage_path TEXT NOT NULL,
  label TEXT NOT NULL DEFAULT '',
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE campaign_links (
  id BIGSERIAL PRIMARY KEY,
  campaign_id BIGINT NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  label TEXT NOT NULL DEFAULT '',
  url TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX campaign_images_campaign_id_idx ON campaign_images(campaign_id);
CREATE INDEX campaign_links_campaign_id_idx ON campaign_links(campaign_id);

ALTER TABLE campaign_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaign_links ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all access" ON campaign_images
  FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all access" ON campaign_links
  FOR ALL USING (true) WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE campaign_images;
ALTER PUBLICATION supabase_realtime ADD TABLE campaign_links;

-- Storage RLS: bucket is public for reads, but writes still go through
-- RLS on storage.objects even on a public bucket.
CREATE POLICY "campaign-images public read" ON storage.objects
  FOR SELECT USING (bucket_id = 'campaign-images');
CREATE POLICY "campaign-images public insert" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'campaign-images');
CREATE POLICY "campaign-images public delete" ON storage.objects
  FOR DELETE USING (bucket_id = 'campaign-images');
