-- Create learning_paths table
CREATE TABLE IF NOT EXISTS learning_paths (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    target_skills TEXT[] NOT NULL DEFAULT '{}',
    estimated_duration INTEGER NOT NULL,
    difficulty TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create path_stages table
CREATE TABLE IF NOT EXISTS path_stages (
    id UUID PRIMARY KEY,
    path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    duration INTEGER NOT NULL,
    prerequisites TEXT[] NOT NULL DEFAULT '{}',
    "order" INTEGER NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create learning_tasks table
CREATE TABLE IF NOT EXISTS learning_tasks (
    id UUID PRIMARY KEY,
    stage_id UUID NOT NULL REFERENCES path_stages(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    type TEXT NOT NULL,
    deadline TIMESTAMP WITH TIME ZONE,
    progress REAL NOT NULL DEFAULT 0,
    "order" INTEGER NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create progress table
CREATE TABLE IF NOT EXISTS progress (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    path_id UUID NOT NULL REFERENCES learning_paths(id) ON DELETE CASCADE,
    task_id UUID NOT NULL REFERENCES learning_tasks(id) ON DELETE CASCADE,
    status TEXT NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    completion_time TIMESTAMP WITH TIME ZONE,
    notes TEXT,
    feedback TEXT,
    UNIQUE(user_id, task_id)
);

-- Add RLS policies
ALTER TABLE learning_paths ENABLE ROW LEVEL SECURITY;
ALTER TABLE path_stages ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress ENABLE ROW LEVEL SECURITY;

-- Policies for learning_paths
CREATE POLICY "Users can view their own learning paths"
    ON learning_paths FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own learning paths"
    ON learning_paths FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own learning paths"
    ON learning_paths FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own learning paths"
    ON learning_paths FOR DELETE
    USING (auth.uid() = user_id);

-- Policies for path_stages
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

CREATE POLICY "Users can delete stages of their learning paths"
    ON path_stages FOR DELETE
    USING (EXISTS (
        SELECT 1 FROM learning_paths
        WHERE learning_paths.id = path_stages.path_id
        AND learning_paths.user_id = auth.uid()
    ));

-- Policies for learning_tasks
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

CREATE POLICY "Users can delete tasks of their learning paths"
    ON learning_tasks FOR DELETE
    USING (EXISTS (
        SELECT 1 FROM path_stages
        JOIN learning_paths ON learning_paths.id = path_stages.path_id
        WHERE path_stages.id = learning_tasks.stage_id
        AND learning_paths.user_id = auth.uid()
    ));

-- Policies for progress
CREATE POLICY "Users can view their own progress"
    ON progress FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own progress"
    ON progress FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress"
    ON progress FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress"
    ON progress FOR DELETE
    USING (auth.uid() = user_id); 