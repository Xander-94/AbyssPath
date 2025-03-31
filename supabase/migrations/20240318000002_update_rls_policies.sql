-- 删除现有策略
DROP POLICY IF EXISTS "Users can view stages of their learning paths" ON path_stages;
DROP POLICY IF EXISTS "Users can create stages for their learning paths" ON path_stages;
DROP POLICY IF EXISTS "Users can update stages of their learning paths" ON path_stages;

-- 重新创建更宽松的策略
CREATE POLICY "Enable read access for authenticated users"
    ON path_stages
    FOR SELECT
    USING (auth.role() = 'authenticated');

CREATE POLICY "Enable insert access for authenticated users"
    ON path_stages
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update access for authenticated users"
    ON path_stages
    FOR UPDATE
    USING (auth.role() = 'authenticated');

-- 确保启用了 RLS
ALTER TABLE path_stages ENABLE ROW LEVEL SECURITY;

-- 为 authenticated 角色授予所有权限
GRANT ALL ON path_stages TO authenticated;

-- 添加服务角色策略（如果需要）
CREATE POLICY "Service role has full access"
    ON path_stages
    FOR ALL
    USING (auth.jwt() ->> 'role' = 'service_role')
    WITH CHECK (auth.jwt() ->> 'role' = 'service_role'); 