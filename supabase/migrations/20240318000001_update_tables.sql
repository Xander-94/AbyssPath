-- 更新 path_stages 表
ALTER TABLE path_stages 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS duration INT NOT NULL DEFAULT 0,
ADD COLUMN IF NOT EXISTS prerequisites TEXT;

-- 更新 learning_tasks 表
ALTER TABLE learning_tasks 
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
ADD COLUMN IF NOT EXISTS deadline TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS progress FLOAT8;

-- 更新 learning_paths 表
ALTER TABLE learning_paths
ALTER COLUMN target_skills SET DATA TYPE JSONB USING target_skills::jsonb,
ALTER COLUMN target_skills SET DEFAULT '[]',
ALTER COLUMN estimated_duration SET DATA TYPE INT USING estimated_duration::int;

-- 创建触发器函数来自动更新 updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为每个表添加自动更新 updated_at 的触发器
DROP TRIGGER IF EXISTS update_learning_paths_updated_at ON learning_paths;
CREATE TRIGGER update_learning_paths_updated_at
    BEFORE UPDATE ON learning_paths
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_path_stages_updated_at ON path_stages;
CREATE TRIGGER update_path_stages_updated_at
    BEFORE UPDATE ON path_stages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_learning_tasks_updated_at ON learning_tasks;
CREATE TRIGGER update_learning_tasks_updated_at
    BEFORE UPDATE ON learning_tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_progress_updated_at ON progress;
CREATE TRIGGER update_progress_updated_at
    BEFORE UPDATE ON progress
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column(); 