/*
# 创建用户信息表和认证系统

## 1. 新建表

### 1.1 profiles - 用户信息表
- `id` (uuid, primary key) - 用户唯一标识，关联 auth.users
- `phone` (text, unique) - 手机号
- `email` (text, unique) - 邮箱
- `nickname` (text) - 用户昵称
- `avatar_url` (text) - 头像URL
- `role` (user_role enum) - 用户角色（user/admin）
- `created_at` (timestamptz, default: now())
- `updated_at` (timestamptz, default: now())

## 2. 安全策略
- 启用 RLS（Row Level Security）
- 管理员可以访问所有用户信息
- 普通用户只能查看和更新自己的信息
- 第一个注册用户自动成为管理员

## 3. 触发器
- 当用户通过 auth 注册后，自动在 profiles 表创建记录
- 第一个用户自动设置为 admin 角色

## 4. 更新现有表
- 修改现有表的 user_id 默认值，改为使用真实的认证用户 ID
*/

-- 创建用户角色枚举类型
CREATE TYPE user_role AS ENUM ('user', 'admin');

-- 创建用户信息表
CREATE TABLE IF NOT EXISTS profiles (
    id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    phone text UNIQUE,
    email text UNIQUE,
    nickname text,
    avatar_url text,
    role user_role DEFAULT 'user'::user_role NOT NULL,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now()
);

-- 启用 RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- 创建管理员检查函数
CREATE OR REPLACE FUNCTION is_admin(uid uuid)
RETURNS boolean LANGUAGE sql SECURITY DEFINER AS $$
    SELECT EXISTS (
        SELECT 1 FROM profiles p
        WHERE p.id = uid AND p.role = 'admin'::user_role
    );
$$;

-- RLS 策略：管理员可以访问所有用户信息
CREATE POLICY "管理员可以查看所有用户信息" ON profiles
    FOR SELECT TO authenticated USING (is_admin(auth.uid()));

CREATE POLICY "管理员可以更新所有用户信息" ON profiles
    FOR UPDATE TO authenticated USING (is_admin(auth.uid()));

-- RLS 策略：用户可以查看自己的信息
CREATE POLICY "用户可以查看自己的信息" ON profiles
    FOR SELECT TO authenticated USING (auth.uid() = id);

-- RLS 策略：用户可以更新自己的信息
CREATE POLICY "用户可以更新自己的信息" ON profiles
    FOR UPDATE TO authenticated USING (auth.uid() = id);

-- 创建触发器函数：当用户注册时自动创建 profile
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
DECLARE
    user_count int;
BEGIN
    -- 只在 confirmed_at 从 NULL → 非 NULL 时执行（用户完成验证）
    IF OLD.confirmed_at IS NULL AND NEW.confirmed_at IS NOT NULL THEN
        -- 判断 profiles 表里有多少用户
        SELECT COUNT(*) INTO user_count FROM profiles;
        
        -- 插入 profiles，首位用户给 admin 角色
        INSERT INTO profiles (id, phone, email, role)
        VALUES (
            NEW.id,
            NEW.phone,
            NEW.email,
            CASE WHEN user_count = 0 THEN 'admin'::user_role ELSE 'user'::user_role END
        );
    END IF;
    RETURN NEW;
END;
$$;

-- 绑定触发器到 auth.users 表
DROP TRIGGER IF EXISTS on_auth_user_confirmed ON auth.users;
CREATE TRIGGER on_auth_user_confirmed
    AFTER UPDATE ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION handle_new_user();

-- 更新现有表的 user_id 默认值说明
-- 注意：现有表的 user_id 字段保持不变，但在应用层面将使用真实的 auth.uid()
-- 这样可以保持向后兼容，同时支持新的用户系统

-- 为 profiles 表创建索引
CREATE INDEX IF NOT EXISTS idx_profiles_phone ON profiles(phone);
CREATE INDEX IF NOT EXISTS idx_profiles_email ON profiles(email);
CREATE INDEX IF NOT EXISTS idx_profiles_role ON profiles(role);

-- 创建更新时间触发器
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
