-- Drop existing tables if they exist (in reverse order of dependencies)
DROP TABLE IF EXISTS progress CASCADE;
DROP TABLE IF EXISTS task_progress CASCADE;
DROP TABLE IF EXISTS learning_tasks CASCADE;
DROP TABLE IF EXISTS path_stages CASCADE;
DROP TABLE IF EXISTS learning_paths CASCADE;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own learning paths" ON learning_paths;
DROP POLICY IF EXISTS "Users can create their own learning paths" ON learning_paths;
DROP POLICY IF EXISTS "Users can update their own learning paths" ON learning_paths;
DROP POLICY IF EXISTS "Users can view stages of their learning paths" ON path_stages;
DROP POLICY IF EXISTS "Users can create stages for their learning paths" ON path_stages;
DROP POLICY IF EXISTS "Users can update stages of their learning paths" ON path_stages;
DROP POLICY IF EXISTS "Users can view tasks of their learning paths" ON learning_tasks;
DROP POLICY IF EXISTS "Users can create tasks for their learning paths" ON learning_tasks;
DROP POLICY IF EXISTS "Users can update tasks of their learning paths" ON learning_tasks;
DROP POLICY IF EXISTS "Users can view progress of their tasks" ON task_progress;
DROP POLICY IF EXISTS "Users can create progress for their tasks" ON task_progress;
DROP POLICY IF EXISTS "Users can update progress of their tasks" ON task_progress;

-- Create learning_paths table
CREATE TABLE learning_paths (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  target_skills JSONB NOT NULL DEFAULT '[]',
  estimated_duration INT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'generating')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create path_stages table
CREATE TABLE path_stages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  "order" INT NOT NULL,
  duration INT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),
  prerequisites TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create learning_tasks table
CREATE TABLE learning_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_id UUID NOT NULL REFERENCES path_stages(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('learning', 'practice', 'quiz')),
  deadline TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),
  progress FLOAT8,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create progress table
CREATE TABLE progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
  task_id UUID NOT NULL REFERENCES learning_tasks(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),
  start_time TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completion_time TIMESTAMPTZ,
  notes TEXT,
  feedback TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_learning_paths_user_id ON learning_paths(user_id);
CREATE INDEX idx_path_stages_path_id ON path_stages(path_id);
CREATE INDEX idx_learning_tasks_stage_id ON learning_tasks(stage_id);
CREATE INDEX idx_progress_user_id ON progress(user_id);
CREATE INDEX idx_progress_path_id ON progress(path_id);
CREATE INDEX idx_progress_task_id ON progress(task_id);

-- Add RLS policies
ALTER TABLE learning_paths ENABLE ROW LEVEL SECURITY;
ALTER TABLE path_stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;

-- Create policies for learning_paths
CREATE POLICY "Users can view their own learning paths"
  ON learning_paths FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own learning paths"
  ON learning_paths FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own learning paths"
  ON learning_paths FOR UPDATE
  USING (auth.uid() = user_id);

-- Create policies for path_stages
CREATE POLICY "Users can view stages of their learning paths"
  ON path_stages FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM learning_paths
    WHERE learning_paths.id = path_stages.path_id
    AND learning_paths.user_id = auth.uid()
  ));

CREATE POLICY "Users can create stages for their learning paths"
  ON path_stages FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM learning_paths
    WHERE learning_paths.id = path_stages.path_id
    AND learning_paths.user_id = auth.uid()
  ));

CREATE POLICY "Users can update stages of their learning paths"
  ON path_stages FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM learning_paths
    WHERE learning_paths.id = path_stages.path_id
    AND learning_paths.user_id = auth.uid()
  ));

-- Create policies for learning_tasks
CREATE POLICY "Users can view tasks of their learning paths"
  ON learning_tasks FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM path_stages
    JOIN learning_paths ON learning_paths.id = path_stages.path_id
    WHERE path_stages.id = learning_tasks.stage_id
    AND learning_paths.user_id = auth.uid()
  ));

CREATE POLICY "Users can create tasks for their learning paths"
  ON learning_tasks FOR INSERT
  WITH CHECK (EXISTS (
    SELECT 1 FROM path_stages
    JOIN learning_paths ON learning_paths.id = path_stages.path_id
    WHERE path_stages.id = learning_tasks.stage_id
    AND learning_paths.user_id = auth.uid()
  ));

CREATE POLICY "Users can update tasks of their learning paths"
  ON learning_tasks FOR UPDATE
  USING (EXISTS (
    SELECT 1 FROM path_stages
    JOIN learning_paths ON learning_paths.id = path_stages.path_id
    WHERE path_stages.id = learning_tasks.stage_id
    AND learning_paths.user_id = auth.uid()
  ));

-- Create policies for progress
CREATE POLICY "Users can view their own progress"
  ON progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own progress"
  ON progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
  ON progress FOR UPDATE
  USING (auth.uid() = user_id); 