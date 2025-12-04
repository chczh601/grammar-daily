/*
# 创建英语语法每日一练数据库表

## 1. 新建表

### 1.1 grammar_modules - 语法模块表
- `id` (uuid, primary key, default: gen_random_uuid())
- `name` (text, not null) - 模块名称（如"时态"、"从句"）
- `description` (text) - 模块描述
- `content` (text) - 语法规则讲解内容
- `order_index` (integer, default: 0) - 排序索引
- `created_at` (timestamptz, default: now())

### 1.2 questions - 题目表
- `id` (uuid, primary key, default: gen_random_uuid())
- `module_id` (uuid, references grammar_modules) - 所属语法模块
- `type` (text, not null) - 题型：single_choice（单选）、fill_blank（填空）、correction（改错）
- `difficulty` (text, not null) - 难度：beginner（入门）、intermediate（进阶）、advanced（高阶）
- `question` (text, not null) - 题目内容
- `options` (jsonb) - 选项（单选题使用，格式：["A. ...", "B. ...", "C. ...", "D. ..."]）
- `answer` (text, not null) - 正确答案
- `explanation` (text, not null) - 解析（包含规则提炼和易错点提示）
- `tags` (text[]) - 考点标签
- `created_at` (timestamptz, default: now())

### 1.3 user_records - 用户学习记录表（合并进度、答题、收藏）
- `id` (uuid, primary key, default: gen_random_uuid())
- `user_id` (uuid, not null, default: '00000000-0000-0000-0000-000000000001') - 用户ID（无登录系统使用固定UUID）
- `question_id` (uuid, references questions) - 题目ID
- `user_answer` (text) - 用户答案
- `is_correct` (boolean) - 是否正确
- `is_favorite` (boolean, default: false) - 是否收藏
- `answered_at` (timestamptz, default: now()) - 答题时间
- `created_at` (timestamptz, default: now())

### 1.4 daily_practice - 每日练习配置表
- `id` (uuid, primary key, default: gen_random_uuid())
- `practice_date` (date, not null, unique) - 练习日期
- `question_ids` (uuid[]) - 当日题目ID列表
- `created_at` (timestamptz, default: now())

### 1.5 check_in_records - 打卡记录表
- `id` (uuid, primary key, default: gen_random_uuid())
- `user_id` (uuid, not null, default: '00000000-0000-0000-0000-000000000001') - 用户ID
- `check_date` (date, not null) - 打卡日期
- `completed_count` (integer, default: 0) - 完成题目数
- `correct_count` (integer, default: 0) - 正确题目数
- `continuous_days` (integer, default: 1) - 连续打卡天数
- `created_at` (timestamptz, default: now())
- UNIQUE(user_id, check_date)

## 2. 安全策略
- 所有表不启用RLS（无登录系统，数据公开）
- 所有用户可以读写数据

## 3. 初始数据
- 插入5个语法模块
- 插入50道练习题（覆盖不同模块、难度和题型）
- 插入今日练习配置（随机10道题）
*/

-- 创建语法模块表
CREATE TABLE IF NOT EXISTS grammar_modules (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text NOT NULL,
    description text,
    content text,
    order_index integer DEFAULT 0,
    created_at timestamptz DEFAULT now()
);

-- 创建题目表
CREATE TABLE IF NOT EXISTS questions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    module_id uuid REFERENCES grammar_modules(id) ON DELETE CASCADE,
    type text NOT NULL CHECK (type IN ('single_choice', 'fill_blank', 'correction')),
    difficulty text NOT NULL CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    question text NOT NULL,
    options jsonb,
    answer text NOT NULL,
    explanation text NOT NULL,
    tags text[],
    created_at timestamptz DEFAULT now()
);

-- 创建用户学习记录表
CREATE TABLE IF NOT EXISTS user_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001',
    question_id uuid REFERENCES questions(id) ON DELETE CASCADE,
    user_answer text,
    is_correct boolean,
    is_favorite boolean DEFAULT false,
    answered_at timestamptz DEFAULT now(),
    created_at timestamptz DEFAULT now()
);

-- 创建每日练习配置表
CREATE TABLE IF NOT EXISTS daily_practice (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    practice_date date NOT NULL UNIQUE,
    question_ids uuid[],
    created_at timestamptz DEFAULT now()
);

-- 创建打卡记录表
CREATE TABLE IF NOT EXISTS check_in_records (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL DEFAULT '00000000-0000-0000-0000-000000000001',
    check_date date NOT NULL,
    completed_count integer DEFAULT 0,
    correct_count integer DEFAULT 0,
    continuous_days integer DEFAULT 1,
    created_at timestamptz DEFAULT now(),
    UNIQUE(user_id, check_date)
);

-- 创建索引
CREATE INDEX idx_questions_module ON questions(module_id);
CREATE INDEX idx_questions_difficulty ON questions(difficulty);
CREATE INDEX idx_user_records_user ON user_records(user_id);
CREATE INDEX idx_user_records_question ON user_records(question_id);
CREATE INDEX idx_check_in_user_date ON check_in_records(user_id, check_date);

-- 插入语法模块初始数据
INSERT INTO grammar_modules (name, description, content, order_index) VALUES
('时态', '英语时态系统', '英语共有16种时态，包括一般现在时、一般过去时、一般将来时、现在进行时、过去进行时、将来进行时、现在完成时、过去完成时等。掌握时态的关键在于理解时间和状态的关系。', 1),
('从句', '各类从句用法', '从句包括名词性从句（主语从句、宾语从句、表语从句、同位语从句）、定语从句和状语从句。从句在句子中起到名词、形容词或副词的作用。', 2),
('非谓语动词', '动词的非谓语形式', '非谓语动词包括不定式（to do）、动名词（doing）和分词（现在分词doing、过去分词done）。它们在句子中不能单独作谓语，但可以充当主语、宾语、定语、状语等成分。', 3),
('虚拟语气', '虚拟语气的使用', '虚拟语气用于表示假设、愿望、建议、命令等非真实情况。常见于if条件句、wish/would rather等结构中。掌握虚拟语气需要熟记不同时态下的动词形式变化。', 4),
('主谓一致', '主语和谓语的一致关系', '主谓一致是指主语和谓语在人称和数上保持一致。需要注意就近原则、就远原则、意义一致原则等特殊情况。', 5);

-- 插入题目初始数据（50道题）
-- 时态相关题目（10道）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'beginner', 'I _____ to the cinema yesterday.', '["A. go", "B. went", "C. have gone", "D. will go"]', 'B', '本题考查一般过去时。时间状语"yesterday"表示过去的时间，因此动词应使用过去式went。易错点：不要被"have gone"迷惑，现在完成时强调对现在的影响，而本题只是陈述过去的事实。', ARRAY['一般过去时', '时间状语']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'beginner', 'She _____ English every day.', '["A. study", "B. studies", "C. studied", "D. studying"]', 'B', '本题考查一般现在时的第三人称单数形式。主语"She"是第三人称单数，动词需要加-s或-es。易错点：注意主谓一致，第三人称单数现在时动词要变形。', ARRAY['一般现在时', '第三人称单数']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'intermediate', 'By the time you arrive, I _____ dinner.', '["A. will finish", "B. will have finished", "C. finish", "D. finished"]', 'B', '本题考查将来完成时。"by the time"引导的时间状语从句表示将来某个时间点之前完成的动作，主句应使用将来完成时will have done。易错点：不要混淆一般将来时和将来完成时的使用场景。', ARRAY['将来完成时', 'by the time']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'fill_blank', 'beginner', 'They _____ (play) basketball now.', NULL, 'are playing', '本题考查现在进行时。时间状语"now"表示正在进行的动作，应使用现在进行时be doing结构。主语"They"是复数，be动词用are。', ARRAY['现在进行时', '时间状语']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'intermediate', 'I _____ in this company for five years.', '["A. work", "B. worked", "C. have worked", "D. am working"]', 'C', '本题考查现在完成时。"for five years"表示一段持续到现在的时间，应使用现在完成时have/has done。易错点：注意区分现在完成时和一般过去时，前者强调对现在的影响或持续性。', ARRAY['现在完成时', '时间段']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'correction', 'beginner', 'He have finished his homework.', NULL, 'He has finished his homework.', '本题考查现在完成时的主谓一致。主语"He"是第三人称单数，助动词应使用has而不是have。易错点：注意have/has的选择取决于主语的人称和数。', ARRAY['现在完成时', '主谓一致']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'advanced', 'When I got to the station, the train _____ already _____.', '["A. has; left", "B. had; left", "C. have; left", "D. will; leave"]', 'B', '本题考查过去完成时。"got"表示过去的时间点，火车离开发生在"got"之前，即"过去的过去"，应使用过去完成时had done。易错点：理解"过去的过去"这一时间概念。', ARRAY['过去完成时', '时间先后']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'fill_blank', 'intermediate', 'She _____ (read) a book when I called her.', NULL, 'was reading', '本题考查过去进行时。"when I called"表示过去某个时间点，"read"这个动作在那个时间点正在进行，应使用过去进行时was/were doing。', ARRAY['过去进行时', '时间点']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'intermediate', 'We _____ to Beijing three times.', '["A. went", "B. have been", "C. have gone", "D. go"]', 'B', '本题考查现在完成时have been和have gone的区别。"have been to"表示"去过某地（已回来）"，"have gone to"表示"去了某地（未回来）"。根据语境，应选have been。', ARRAY['现在完成时', 'have been/gone']),
((SELECT id FROM grammar_modules WHERE name = '时态'), 'single_choice', 'advanced', 'This time tomorrow, I _____ on the beach.', '["A. will lie", "B. will be lying", "C. lie", "D. am lying"]', 'B', '本题考查将来进行时。"this time tomorrow"表示将来某个时间点正在进行的动作，应使用将来进行时will be doing。易错点：区分一般将来时和将来进行时的使用场景。', ARRAY['将来进行时', '将来时间点']);

-- 从句相关题目（10道）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'beginner', 'I know _____ he is a teacher.', '["A. that", "B. what", "C. which", "D. who"]', 'A', '本题考查宾语从句的引导词。从句"he is a teacher"是完整的陈述句，不缺成分，应使用that引导。易错点：that在宾语从句中不充当成分，只起连接作用。', ARRAY['宾语从句', '连接词that']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'intermediate', 'The book _____ I bought yesterday is very interesting.', '["A. which", "B. who", "C. what", "D. where"]', 'A', '本题考查定语从句。先行词"the book"是物，关系代词应使用which或that。易错点：what不能引导定语从句。', ARRAY['定语从句', '关系代词']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'intermediate', 'This is the house _____ I lived ten years ago.', '["A. which", "B. that", "C. where", "D. when"]', 'C', '本题考查定语从句的关系副词。先行词"the house"在从句中作地点状语（lived in the house），应使用where。易错点：判断关系词时要看先行词在从句中的成分。', ARRAY['定语从句', '关系副词where']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'fill_blank', 'beginner', 'I don''t know _____ he will come tomorrow.', NULL, 'whether/if', '本题考查宾语从句的引导词。从句表示"是否"的意思，应使用whether或if。易错点：whether和if在大多数情况下可以互换，但在某些特殊结构中只能用whether。', ARRAY['宾语从句', 'whether/if']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'advanced', '_____ he said at the meeting surprised everyone.', '["A. That", "B. What", "C. Which", "D. Whether"]', 'B', '本题考查主语从句。从句中"said"缺少宾语，应使用what引导，what在从句中作宾语。易错点：that在名词性从句中不充当成分，what充当成分。', ARRAY['主语从句', '连接词what']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'correction', 'intermediate', 'The reason why he was late is because he missed the bus.', NULL, 'The reason why he was late is that he missed the bus.', '本题考查表语从句。"the reason is that..."是固定句型，不能用because。易错点：reason和because不能同时使用，这是中式英语的常见错误。', ARRAY['表语从句', 'reason is that']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'intermediate', 'The man _____ is talking to my father is my teacher.', '["A. which", "B. who", "C. what", "D. whose"]', 'B', '本题考查定语从句。先行词"the man"是人，且在从句中作主语，应使用who。易错点：先行词是人时，关系代词用who/that，是物时用which/that。', ARRAY['定语从句', '关系代词who']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'advanced', 'I will give the book to _____ needs it most.', '["A. who", "B. whom", "C. whoever", "D. whomever"]', 'C', '本题考查宾语从句。"whoever"表示"任何人"，在从句中作主语。易错点：whoever和whomever的区别在于在从句中的成分，前者作主语，后者作宾语。', ARRAY['宾语从句', 'whoever']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'fill_blank', 'intermediate', 'This is the same pen _____ I lost yesterday.', NULL, 'as/that', '本题考查定语从句。"the same...as"表示同类但不同一个，"the same...that"表示同一个。根据语境，两者都可以。易错点：注意the same...as和the same...that的细微区别。', ARRAY['定语从句', 'the same...as/that']),
((SELECT id FROM grammar_modules WHERE name = '从句'), 'single_choice', 'advanced', '_____ is known to all, the earth moves around the sun.', '["A. That", "B. What", "C. As", "D. Which"]', 'C', '本题考查非限制性定语从句。as引导的非限制性定语从句可以放在句首，表示"正如"。易错点：which引导的非限制性定语从句不能放在句首。', ARRAY['非限制性定语从句', 'as']);

-- 非谓语动词相关题目（10道）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'beginner', 'I want _____ a doctor.', '["A. be", "B. to be", "C. being", "D. been"]', 'B', '本题考查不定式作宾语。"want to do sth"是固定搭配，want后接不定式。易错点：注意动词后接不定式还是动名词，需要记忆常见搭配。', ARRAY['不定式', 'want to do']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', '_____ more time, we could do it better.', '["A. Give", "B. Giving", "C. Given", "D. To give"]', 'C', '本题考查过去分词作状语。"we"和"give"是被动关系（被给予时间），应使用过去分词given。易错点：判断主动还是被动关系是选择现在分词还是过去分词的关键。', ARRAY['过去分词', '被动关系']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'beginner', 'She enjoys _____ music.', '["A. listen to", "B. listening to", "C. to listen to", "D. listened to"]', 'B', '本题考查动名词作宾语。"enjoy doing sth"是固定搭配，enjoy后接动名词。易错点：enjoy, finish, mind等动词后只能接动名词，不能接不定式。', ARRAY['动名词', 'enjoy doing']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'fill_blank', 'intermediate', 'The boy _____ (stand) there is my brother.', NULL, 'standing', '本题考查现在分词作定语。"the boy"和"stand"是主动关系，应使用现在分词standing作后置定语。易错点：分词作定语时，现在分词表主动和进行，过去分词表被动和完成。', ARRAY['现在分词', '定语']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'The problem _____ at the meeting yesterday is very important.', '["A. discussing", "B. discussed", "C. to discuss", "D. discuss"]', 'B', '本题考查过去分词作定语。"the problem"和"discuss"是被动关系（被讨论的问题），且动作已完成，应使用过去分词discussed。易错点：注意时间状语"yesterday"提示动作已完成。', ARRAY['过去分词', '定语', '被动']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'correction', 'beginner', 'He decided buying a new car.', NULL, 'He decided to buy a new car.', '本题考查不定式作宾语。"decide to do sth"是固定搭配，decide后接不定式，不能接动名词。易错点：区分接不定式和接动名词的动词。', ARRAY['不定式', 'decide to do']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'I saw him _____ the room.', '["A. enter", "B. to enter", "C. entering", "D. entered"]', 'A', '本题考查感官动词后的宾语补足语。see sb do sth表示看到动作的全过程，see sb doing sth表示看到动作正在进行。根据语境，应选择动词原形。易错点：感官动词后接不带to的不定式或现在分词。', ARRAY['感官动词', '宾语补足语']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'With a lot of work _____, he can''t go to the cinema.', '["A. doing", "B. to do", "C. done", "D. do"]', 'B', '本题考查with复合结构。"work"和"do"是被动关系，但"to do"表示将要做的工作，符合语境"有很多工作要做"。易错点：with复合结构中，to do表将来，doing表主动进行，done表被动完成。', ARRAY['with复合结构', '不定式']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'fill_blank', 'intermediate', 'He is too young _____ (go) to school.', NULL, 'to go', '本题考查不定式作状语。"too...to..."结构表示"太...而不能..."，to后接动词原形。易错点：注意too...to...的否定含义。', ARRAY['不定式', 'too...to...']),
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'The building _____ now will be our new library.', '["A. building", "B. being built", "C. built", "D. to be built"]', 'B', '本题考查现在分词的被动式作定语。"the building"和"build"是被动关系，且"now"表示正在进行，应使用being built。易错点：注意区分being done（被动进行）和done（被动完成）。', ARRAY['现在分词', '被动', '进行']);

-- 虚拟语气相关题目（10道）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'If I _____ you, I would accept the offer.', '["A. am", "B. was", "C. were", "D. be"]', 'C', '本题考查虚拟语气在条件句中的用法。表示与现在事实相反的假设，if从句用过去式，be动词统一用were。易错点：虚拟语气中，be动词不论主语是什么，都用were。', ARRAY['虚拟语气', '与现在相反']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If he _____ harder, he would have passed the exam.', '["A. studied", "B. had studied", "C. studies", "D. would study"]', 'B', '本题考查与过去事实相反的虚拟语气。if从句用过去完成时had done，主句用would have done。易错点：注意时态的对应关系。', ARRAY['虚拟语气', '与过去相反']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'I wish I _____ a bird.', '["A. am", "B. were", "C. will be", "D. have been"]', 'B', '本题考查wish后的虚拟语气。wish后接与现在事实相反的愿望，从句用过去式，be动词用were。易错点：wish后的虚拟语气时态要往前推一个时态。', ARRAY['虚拟语气', 'wish']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'fill_blank', 'intermediate', 'He suggested that we _____ (start) early.', NULL, '(should) start', '本题考查suggest后的虚拟语气。suggest, advise, insist等表示建议、要求、命令的动词后，宾语从句用"(should) + 动词原形"。易错点：should可以省略，但动词必须用原形。', ARRAY['虚拟语气', 'suggest']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'Without your help, I _____ the work on time.', '["A. won''t finish", "B. wouldn''t finish", "C. wouldn''t have finished", "D. didn''t finish"]', 'C', '本题考查含蓄虚拟条件句。"without your help"相当于"if you hadn''t helped me"，表示与过去事实相反，主句用would have done。易错点：识别含蓄虚拟条件。', ARRAY['虚拟语气', '含蓄条件']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'correction', 'intermediate', 'If it will rain tomorrow, we will stay at home.', NULL, 'If it rains tomorrow, we will stay at home.', '本题考查真实条件句和虚拟条件句的区别。表示将来可能发生的事情，if从句用一般现在时，不用will。易错点：真实条件句不是虚拟语气，遵循"主将从现"原则。', ARRAY['真实条件句', '主将从现']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'It''s high time that we _____ action.', '["A. take", "B. took", "C. will take", "D. have taken"]', 'B', '本题考查"It''s (high) time that..."句型。该句型后接虚拟语气，从句用过去式。易错点：记住这个固定句型的虚拟语气用法。', ARRAY['虚拟语气', 'It''s time that']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'I would rather you _____ tomorrow.', '["A. come", "B. came", "C. will come", "D. have come"]', 'B', '本题考查would rather后的虚拟语气。would rather后接与现在或将来事实相反的愿望，从句用过去式。易错点：would rather后的虚拟语气用法。', ARRAY['虚拟语气', 'would rather']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'fill_blank', 'advanced', 'If you _____ (follow) my advice, you wouldn''t be in trouble now.', NULL, 'had followed', '本题考查混合虚拟语气。if从句表示与过去事实相反（用had done），主句表示与现在事实相反（用would do）。易错点：注意从句和主句的时间不一致。', ARRAY['虚拟语气', '混合时间']),
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', '_____ it not for your help, I would fail.', '["A. Was", "B. Were", "C. Is", "D. Are"]', 'B', '本题考查虚拟语气的倒装。"Were it not for..."相当于"If it were not for..."，表示与现在事实相反的假设。易错点：虚拟语气的倒装形式。', ARRAY['虚拟语气', '倒装']);

-- 主谓一致相关题目（10道）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'Tom and Jerry _____ good friends.', '["A. is", "B. are", "C. was", "D. be"]', 'B', '本题考查主谓一致。主语"Tom and Jerry"是两个人，是复数，谓语动词用are。易错点：and连接的两个主语通常用复数。', ARRAY['主谓一致', 'and连接']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Either you or he _____ wrong.', '["A. is", "B. are", "C. am", "D. be"]', 'A', '本题考查就近原则。"either...or..."连接主语时，谓语动词与最近的主语保持一致，"he"是第三人称单数，用is。易错点：记住就近原则适用的连词。', ARRAY['主谓一致', '就近原则']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'The number of students _____ increasing.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查主谓一致。"the number of"表示"...的数量"，作主语时谓语动词用单数。易错点：区分"the number of"（单数）和"a number of"（复数）。', ARRAY['主谓一致', 'the number of']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'fill_blank', 'intermediate', 'Every boy and every girl _____ (have) the right to education.', NULL, 'has', '本题考查主谓一致。"every...and every..."结构作主语时，谓语动词用单数。易错点：every强调个体，即使有and连接也用单数。', ARRAY['主谓一致', 'every']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'The police _____ looking for the thief.', '["A. is", "B. are", "C. was", "D. be"]', 'B', '本题考查集体名词的主谓一致。"police"是集合名词，表示复数概念，谓语动词用复数。易错点：police, people, cattle等集合名词总是用复数。', ARRAY['主谓一致', '集体名词']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'correction', 'beginner', 'There is a lot of books on the desk.', NULL, 'There are a lot of books on the desk.', '本题考查there be句型的主谓一致。be动词的单复数取决于后面的主语，"books"是复数，应用are。易错点：there be句型遵循就近原则。', ARRAY['主谓一致', 'there be']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'The teacher with two students _____ in the classroom.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查就远原则。"with, together with, along with"等连接主语时，谓语动词与前面的主语保持一致，"the teacher"是单数，用is。易错点：注意就远原则和就近原则的区别。', ARRAY['主谓一致', '就远原则']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Two thirds of the work _____ finished.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查分数作主语的主谓一致。分数/百分数作主语时，谓语动词的单复数取决于of后的名词，"work"是不可数名词，用单数。易错点：关键看of后的名词。', ARRAY['主谓一致', '分数']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'fill_blank', 'advanced', 'Not only you but also I _____ (be) interested in music.', NULL, 'am', '本题考查就近原则。"not only...but also..."连接主语时，谓语动词与最近的主语保持一致，"I"用am。易错点：就近原则适用于多个连词结构。', ARRAY['主谓一致', '就近原则']),
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'What he said _____ true.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查主语从句的主谓一致。主语从句作主语时，谓语动词通常用单数。易错点：主语从句、不定式、动名词作主语时，谓语动词一般用单数。', ARRAY['主谓一致', '主语从句']);

-- 插入今日练习配置（随机选择10道题）
INSERT INTO daily_practice (practice_date, question_ids)
SELECT 
    CURRENT_DATE,
    ARRAY(SELECT id FROM questions ORDER BY random() LIMIT 10);
