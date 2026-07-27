CREATE TABLE campaigns (
  id BIGSERIAL PRIMARY KEY,
  month INTEGER NOT NULL,
  day INTEGER NOT NULL,
  end_day INTEGER,
  type TEXT NOT NULL DEFAULT 'newsletter',
  label TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'tbd',
  notes TEXT,
  created_by TEXT,
  updated_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all access" ON campaigns
  FOR ALL USING (true) WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE campaigns;
