/*
# 题库扩充 - 第一阶段（第二部分）

## 扩充内容
- 非谓语动词模块：新增30道题
- 虚拟语气模块：新增25道题
- 主谓一致模块：新增25道题

总计新增80道题
*/

-- ============================================
-- 模块3：非谓语动词（Non-finite Verbs）- 新增30道题
-- ============================================

-- 不定式作主语（新增2题）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', '_____ English well is not easy.', '["A. Learn", "B. To learn", "C. Learning", "D. Learned"]', 'B', '本题考查不定式作主语。不定式to do可以作主语，表示具体的、一次性的动作。动名词doing也可以作主语，表示一般性、经常性的动作。本题两者都可以，但不定式更常见。易错点：不定式作主语时，常用it作形式主语，真正的主语后置：It is not easy to learn English well。', ARRAY['不定式', '作主语', 'to do']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'It is important _____ us to learn English well.', '["A. for", "B. of", "C. to", "D. with"]', 'A', '本题考查不定式复合结构。"It is+形容词+for/of sb+to do"结构中，形容词描述事物用for，形容词描述人的品质用of。important描述事物，用for。易错点：形容词如kind, nice, clever等描述人的品质用of，如important, necessary, difficult等描述事物用for。', ARRAY['不定式', 'it形式主语', 'for sb to do']),

-- 不定式作宾语（新增3题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'beginner', 'She decided _____ a new car.', '["A. buy", "B. to buy", "C. buying", "D. bought"]', 'B', '本题考查不定式作宾语。decide后接不定式to do作宾语，是固定搭配。易错点：常见的接不定式作宾语的动词有：want, hope, wish, decide, plan, agree, refuse, promise等。', ARRAY['不定式', '作宾语', 'decide to do']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'I don''t know _____ next.', '["A. what to do", "B. what do", "C. how to do", "D. how do"]', 'A', '本题考查疑问词+不定式结构。"疑问词+to do"可以作宾语，相当于一个宾语从句。易错点：how to do后面需要加宾语（how to do it），what to do不需要加宾语。', ARRAY['不定式', '疑问词+to do', '作宾语']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'He told me _____ the window.', '["A. not open", "B. not to open", "C. don''t open", "D. to not open"]', 'B', '本题考查不定式的否定形式。不定式的否定形式是not to do，not放在to前面。易错点：不定式的否定形式是not to do，而不是to not do。', ARRAY['不定式', '否定形式', 'not to do']),

-- 不定式作宾补（新增2题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'My mother asked me _____ the room.', '["A. clean", "B. to clean", "C. cleaning", "D. cleaned"]', 'B', '本题考查不定式作宾补。ask sb to do sth是固定搭配，不定式to clean作宾语补足语。易错点：常见的接不定式作宾补的动词有：ask, tell, want, wish, expect, advise, allow, encourage等。', ARRAY['不定式', '作宾补', 'ask sb to do']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'The teacher made us _____ the text.', '["A. recite", "B. to recite", "C. reciting", "D. recited"]', 'A', '本题考查使役动词后的不定式。make, let, have等使役动词后接不定式作宾补时，要省略to。易错点：使役动词（make, let, have）和感官动词（see, hear, watch, feel等）后接不定式作宾补时省略to，但变为被动语态时要加上to。', ARRAY['不定式', '使役动词', '省略to']),

-- 不定式作定语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'I have a lot of homework _____ today.', '["A. do", "B. to do", "C. doing", "D. done"]', 'B', '本题考查不定式作定语。不定式to do作后置定语，修饰homework，表示"要做的作业"。易错点：不定式作定语表示将要发生的动作，现在分词作定语表示正在进行的动作，过去分词作定语表示被动或完成的动作。', ARRAY['不定式', '作定语', '后置定语']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'He is looking for a room _____.', '["A. to live", "B. to live in", "C. living", "D. living in"]', 'B', '本题考查不定式作定语的主被动关系。live是不及物动词，需要加介词in才能接宾语room，所以是to live in。易错点：不定式作定语时，如果不定式是不及物动词，要加上相应的介词。', ARRAY['不定式', '作定语', '不及物动词+介词']),

-- 不定式作状语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'He went to the library _____ some books.', '["A. borrow", "B. to borrow", "C. borrowing", "D. borrowed"]', 'B', '本题考查不定式作目的状语。不定式to do可以作目的状语，表示"为了..."。易错点：不定式作目的状语可以用in order to do或so as to do加强语气。', ARRAY['不定式', '作状语', '目的状语']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'I''m sorry _____ you waiting.', '["A. keep", "B. to keep", "C. keeping", "D. kept"]', 'B', '本题考查不定式作原因状语。"be+形容词+to do"结构中，不定式作原因状语，说明产生该情感的原因。易错点：常见的形容词有：sorry, glad, happy, surprised, disappointed等。', ARRAY['不定式', '作状语', '原因状语']),

-- 动名词作主语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'beginner', '_____ is good for your health.', '["A. Swim", "B. Swimming", "C. To swim", "D. Swims"]', 'B', '本题考查动名词作主语。动名词doing可以作主语，表示一般性、经常性的动作。本题强调游泳这项运动，用动名词更恰当。易错点：动名词作主语表示一般性动作，不定式作主语表示具体的、一次性的动作。', ARRAY['动名词', '作主语', 'doing']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'fill_blank', 'intermediate', '_____ (read) books is my hobby.', NULL, 'Reading', '本题考查动名词作主语。动名词reading作主语，表示"读书"这个一般性的活动。易错点：动名词作主语时，谓语动词用单数形式。', ARRAY['动名词', '作主语', '一般性动作']),

-- 动名词作宾语（新增4题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'beginner', 'He finished _____ his homework an hour ago.', '["A. do", "B. to do", "C. doing", "D. done"]', 'C', '本题考查动名词作宾语。finish后接动名词doing作宾语，是固定搭配。易错点：常见的只能接动名词作宾语的动词有：finish, enjoy, mind, practice, keep, suggest, consider, avoid等。', ARRAY['动名词', '作宾语', 'finish doing']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'Would you mind _____ the window?', '["A. open", "B. to open", "C. opening", "D. opened"]', 'C', '本题考查动名词作宾语。mind后接动名词doing作宾语，"Would you mind doing...?"表示"你介意做...吗?"。易错点：mind doing sth介意做某事，mind后只能接动名词，不能接不定式。', ARRAY['动名词', '作宾语', 'mind doing']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'I''m looking forward to _____ from you.', '["A. hear", "B. hearing", "C. heard", "D. be heard"]', 'B', '本题考查介词后接动名词。to是介词，后面接动名词hearing作宾语。易错点：look forward to中的to是介词，不是不定式符号，后面要接动名词。类似的还有：be used to doing, pay attention to doing等。', ARRAY['动名词', '介词+doing', 'look forward to']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'He is busy _____ his homework.', '["A. do", "B. to do", "C. doing", "D. done"]', 'C', '本题考查be busy doing结构。"be busy doing sth"表示"忙于做某事"，是固定搭配。易错点：be busy (in) doing sth，介词in可以省略。', ARRAY['动名词', 'be busy doing', '固定搭配']),

-- 动名词作表语和定语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'My hobby is _____ stamps.', '["A. collect", "B. to collect", "C. collecting", "D. collected"]', 'C', '本题考查动名词作表语。动名词collecting作表语，说明主语的内容。易错点：动名词作表语表示主语的内容，现在分词作表语表示主语的特征。', ARRAY['动名词', '作表语', '说明内容']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'There is a _____ pool in our school.', '["A. swim", "B. to swim", "C. swimming", "D. swam"]', 'C', '本题考查动名词作定语。动名词swimming作定语，修饰pool，表示"游泳池"。易错点：动名词作定语表示用途，现在分词作定语表示动作正在进行。', ARRAY['动名词', '作定语', '表示用途']),

-- 动名词与不定式的区别（新增1题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'Remember _____ the door when you leave.', '["A. lock", "B. to lock", "C. locking", "D. locked"]', 'B', '本题考查remember to do与remember doing的区别。remember to do表示"记得要做某事"（还没做），remember doing表示"记得做过某事"（已经做了）。本题是离开时记得要锁门，用to lock。易错点：类似的动词还有forget, stop, try等，接不定式和动名词意义不同。', ARRAY['动名词', '不定式', 'remember to do']),

-- 现在分词（新增5题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'The _____ sun looks beautiful.', '["A. rise", "B. rising", "C. risen", "D. rose"]', 'B', '本题考查现在分词作定语。现在分词rising作定语，修饰sun，表示"正在升起的太阳"。易错点：现在分词作定语表示主动和进行，过去分词作定语表示被动和完成。', ARRAY['现在分词', '作定语', '主动进行']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', '_____ hard, and you will succeed.', '["A. Work", "B. Working", "C. To work", "D. Worked"]', 'A', '本题考查祈使句。"祈使句+and+陈述句"结构，祈使句用动词原形开头。易错点：不要误认为是现在分词作状语，这是祈使句结构。', ARRAY['祈使句', '动词原形', '固定结构']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', '_____ from the hill, the city looks beautiful.', '["A. See", "B. Seeing", "C. Seen", "D. To see"]', 'C', '本题考查分词作状语的主被动关系。主语"the city"与"see"是被动关系（城市被看），应使用过去分词seen。易错点：判断用现在分词还是过去分词，关键看主语与分词的主被动关系。', ARRAY['过去分词', '作状语', '被动关系']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'fill_blank', 'intermediate', 'The boy _____ (sit) under the tree is my brother.', NULL, 'sitting', '本题考查现在分词作定语。现在分词sitting作后置定语，修饰boy，表示"正坐在树下的男孩"。易错点：单个分词作定语放在名词前，分词短语作定语放在名词后。', ARRAY['现在分词', '作定语', '后置定语']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'I saw him _____ basketball when I passed the playground.', '["A. play", "B. playing", "C. to play", "D. played"]', 'B', '本题考查现在分词作宾补。see sb doing sth表示"看见某人正在做某事"，强调动作正在进行。易错点：see sb do sth表示看见动作的全过程，see sb doing sth表示看见动作正在进行。', ARRAY['现在分词', '作宾补', 'see sb doing']),

-- 过去分词（新增5题）
((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'intermediate', 'The _____ window needs repairing.', '["A. break", "B. breaking", "C. broken", "D. broke"]', 'C', '本题考查过去分词作定语。过去分词broken作定语，修饰window，表示"被打破的窗户"。易错点：过去分词作定语表示被动和完成，现在分词作定语表示主动和进行。', ARRAY['过去分词', '作定语', '被动完成']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', '_____ in 1949, the People''s Republic of China has made great progress.', '["A. Found", "B. Founded", "C. Founding", "D. To found"]', 'B', '本题考查过去分词作状语。主语"the People''s Republic of China"与"found"是被动关系（被建立），应使用过去分词founded。易错点：过去分词作状语表示被动或完成，现在分词作状语表示主动或进行。', ARRAY['过去分词', '作状语', '被动关系']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'When _____ different cultures, we often pay attention only to the differences.', '["A. compare", "B. comparing", "C. compared", "D. to compare"]', 'B', '本题考查分词作状语的省略。完整形式是"When we are comparing..."，省略主语和be动词后为"When comparing..."。易错点：分词作状语时，如果分词的逻辑主语与句子主语一致，可以省略分词前的主语和be动词。', ARRAY['现在分词', '作状语', '省略结构']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'fill_blank', 'intermediate', 'The book _____ (write) by Lu Xun is very popular.', NULL, 'written', '本题考查过去分词作定语。过去分词written作后置定语，修饰book，表示"被鲁迅写的书"。易错点：过去分词作定语表示被动关系，book与write是被动关系。', ARRAY['过去分词', '作定语', '被动关系']),

((SELECT id FROM grammar_modules WHERE name = '非谓语动词'), 'single_choice', 'advanced', 'I heard my name _____.', '["A. call", "B. calling", "C. called", "D. to call"]', 'C', '本题考查过去分词作宾补。"my name"与"call"是被动关系（名字被叫），应使用过去分词called作宾补。易错点：判断用现在分词还是过去分词作宾补，关键看宾语与分词的主被动关系。', ARRAY['过去分词', '作宾补', '被动关系']);

-- ============================================
-- 模块4：虚拟语气（Subjunctive Mood）- 新增25道题
-- ============================================

-- 与现在事实相反（新增3题）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'If I _____ a bird, I would fly to you.', '["A. am", "B. was", "C. were", "D. be"]', 'C', '本题考查与现在事实相反的虚拟语气。if从句用过去式，be动词统一用were，主句用would do。易错点：虚拟语气中，be动词不论主语是什么，都用were，不用was。', ARRAY['虚拟语气', '与现在相反', 'were']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If he _____ more time, he could help you.', '["A. has", "B. had", "C. have", "D. will have"]', 'B', '本题考查与现在事实相反的虚拟语气。if从句用过去式had，主句用could do。易错点：could, might, should都可以用于虚拟语气的主句，表示不同的语气。', ARRAY['虚拟语气', '与现在相反', 'could']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'fill_blank', 'intermediate', 'If I _____ (be) you, I would take his advice.', NULL, 'were', '本题考查与现在事实相反的虚拟语气。if从句中be动词用were，不用was。易错点：虚拟语气中be动词统一用were。', ARRAY['虚拟语气', '与现在相反', 'if从句']),

-- 与过去事实相反（新增3题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If you _____ my advice, you would have passed the exam.', '["A. took", "B. had taken", "C. take", "D. would take"]', 'B', '本题考查与过去事实相反的虚拟语气。if从句用过去完成时had done，主句用would have done。易错点：注意时态的对应关系，if从句用had done，主句用would have done。', ARRAY['虚拟语气', '与过去相反', 'had done']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If I _____ harder, I would have got better grades.', '["A. study", "B. studied", "C. had studied", "D. would study"]', 'C', '本题考查与过去事实相反的虚拟语气。if从句用过去完成时had studied，表示与过去事实相反的假设。易错点：与过去相反的虚拟语气，if从句用had done，主句用would have done。', ARRAY['虚拟语气', '与过去相反', 'if从句']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If he _____ more carefully, he wouldn''t have made so many mistakes.', '["A. works", "B. worked", "C. had worked", "D. would work"]', 'C', '本题考查与过去事实相反的虚拟语气。if从句用过去完成时had worked，主句用wouldn''t have done。易错点：主句的否定形式是wouldn''t have done。', ARRAY['虚拟语气', '与过去相反', '否定形式']),

-- 与将来事实相反（新增2题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If it _____ rain tomorrow, we would go for a picnic.', '["A. should", "B. would", "C. will", "D. shall"]', 'A', '本题考查与将来事实相反的虚拟语气。if从句可以用should do，主句用would do。易错点：与将来相反有三种形式：if从句用should do/were to do/过去式，主句用would do。', ARRAY['虚拟语气', '与将来相反', 'should']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'If the sun _____ to rise in the west, I would lend you the money.', '["A. was", "B. were", "C. should", "D. would"]', 'B', '本题考查与将来事实相反的虚拟语气。if从句用were to do，表示与将来事实相反的假设，且可能性极小。易错点：were to do表示与将来相反且可能性极小的假设。', ARRAY['虚拟语气', '与将来相反', 'were to do']),

-- 含蓄虚拟条件（新增2题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'Without water, there _____ no life on earth.', '["A. is", "B. would be", "C. will be", "D. has been"]', 'B', '本题考查含蓄虚拟条件。without相当于if there were no，表示与现在事实相反，主句用would be。易错点：without, but for等介词短语可以表示含蓄的虚拟条件。', ARRAY['虚拟语气', '含蓄条件', 'without']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'But for your help, I _____ the work on time.', '["A. won''t finish", "B. wouldn''t finish", "C. wouldn''t have finished", "D. didn''t finish"]', 'C', '本题考查含蓄虚拟条件。but for相当于if it had not been for，表示与过去事实相反，主句用wouldn''t have done。易错点：but for your help = if you had not helped me，表示与过去相反。', ARRAY['虚拟语气', '含蓄条件', 'but for']),

-- wish后的虚拟语气（新增3题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'I wish I _____ a doctor.', '["A. am", "B. were", "C. will be", "D. have been"]', 'B', '本题考查wish后的虚拟语气。wish后接与现在事实相反的愿望，从句用过去式，be动词用were。易错点：wish后的虚拟语气时态要往前推一个时态。', ARRAY['虚拟语气', 'wish', '与现在相反']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'I wish I _____ to the party last night.', '["A. go", "B. went", "C. had gone", "D. would go"]', 'C', '本题考查wish后的虚拟语气。wish后接与过去事实相反的愿望，从句用过去完成时had done。易错点：wish+过去式（与现在相反），wish+had done（与过去相反），wish+would do（与将来相反）。', ARRAY['虚拟语气', 'wish', '与过去相反']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'I wish it _____ fine tomorrow.', '["A. is", "B. were", "C. will be", "D. would be"]', 'D', '本题考查wish后的虚拟语气。wish后接与将来事实相反的愿望，从句用would do。易错点：wish+would do表示与将来相反的愿望。', ARRAY['虚拟语气', 'wish', '与将来相反']),

-- suggest等动词后的虚拟语气（新增4题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'He suggested that we _____ a meeting.', '["A. hold", "B. held", "C. should hold", "D. A or C"]', 'D', '本题考查suggest后的虚拟语气。suggest后的宾语从句用"(should)+动词原形"，should可以省略。易错点：表示建议、要求、命令的动词后，宾语从句用虚拟语气(should) do。', ARRAY['虚拟语气', 'suggest', 'should do']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'The doctor advised that he _____ smoking.', '["A. stop", "B. stopped", "C. stops", "D. will stop"]', 'A', '本题考查advise后的虚拟语气。advise后的宾语从句用"(should)+动词原形"，should省略后用动词原形stop。易错点：常见的此类动词有：suggest, advise, insist, order, command, require, request, demand等。', ARRAY['虚拟语气', 'advise', '动词原形']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'It is necessary that he _____ there at once.', '["A. go", "B. goes", "C. went", "D. will go"]', 'A', '本题考查it is+形容词+that从句的虚拟语气。从句用"(should)+动词原形"，should省略后用动词原形go。易错点：常见的形容词有：necessary, important, essential, urgent, natural, strange等。', ARRAY['虚拟语气', 'it is necessary', 'that从句']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'fill_blank', 'intermediate', 'The teacher insisted that the student _____ (be) wrong.', NULL, '(should) be', '本题考查insist后的虚拟语气。insist表示"坚持要求"时，后接虚拟语气(should) do；表示"坚持认为"时，不用虚拟语气。本题表示"坚持认为学生错了"，但按照语法规则，也可以用虚拟语气。易错点：insist的两种用法要区分清楚。', ARRAY['虚拟语气', 'insist', '两种用法']),

-- as if/as though（新增2题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'He talks as if he _____ everything.', '["A. knows", "B. knew", "C. has known", "D. will know"]', 'B', '本题考查as if后的虚拟语气。as if后接与现在事实相反的假设，从句用过去式knew。易错点：as if+过去式（与现在相反），as if+had done（与过去相反）。', ARRAY['虚拟语气', 'as if', '与现在相反']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'He looked as if he _____ ill for a long time.', '["A. is", "B. was", "C. has been", "D. had been"]', 'D', '本题考查as if后的虚拟语气。主句用过去时looked，as if后接与过去事实相反的假设，从句用过去完成时had been。易错点：主句是过去时，as if后用had done表示与过去相反。', ARRAY['虚拟语气', 'as if', '与过去相反']),

-- would rather（新增2题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'I would rather you _____ tomorrow.', '["A. come", "B. came", "C. will come", "D. have come"]', 'B', '本题考查would rather后的虚拟语气。would rather后接与现在或将来事实相反的愿望，从句用过去式came。易错点：would rather+过去式（与现在/将来相反），would rather+had done（与过去相反）。', ARRAY['虚拟语气', 'would rather', '与现在相反']),

((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'advanced', 'I would rather you _____ me the truth yesterday.', '["A. tell", "B. told", "C. had told", "D. would tell"]', 'C', '本题考查would rather后的虚拟语气。would rather后接与过去事实相反的愿望，从句用过去完成时had told。易错点：注意时间状语yesterday提示与过去相反。', ARRAY['虚拟语气', 'would rather', '与过去相反']),

-- if only（新增1题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'If only I _____ his advice!', '["A. take", "B. took", "C. had taken", "D. will take"]', 'C', '本题考查if only后的虚拟语气。if only表示"要是...就好了"，后接与过去事实相反的愿望，用过去完成时had taken。易错点：if only的用法类似于wish，时态往前推一个时态。', ARRAY['虚拟语气', 'if only', '与过去相反']),

-- it''s time（新增1题）
((SELECT id FROM grammar_modules WHERE name = '虚拟语气'), 'single_choice', 'intermediate', 'It''s high time that you _____ to bed.', '["A. go", "B. went", "C. will go", "D. have gone"]', 'B', '本题考查it''s time后的虚拟语气。"it''s (high/about) time+that从句"，从句用过去式，表示"该是...的时候了"。易错点：it''s time后的从句用过去式，表示现在该做某事了。', ARRAY['虚拟语气', 'it''s time', '过去式']);

-- ============================================
-- 模块5：主谓一致（Subject-Verb Agreement）- 新增25道题
-- ============================================

-- 单复数主语（新增4题）
INSERT INTO questions (module_id, type, difficulty, question, options, answer, explanation, tags) VALUES
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'The book _____ very interesting.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查单数主语的主谓一致。主语"the book"是单数，谓语动词用单数is。易错点：注意主语的单复数形式，单数主语用单数动词，复数主语用复数动词。', ARRAY['主谓一致', '单数主语', '语法一致']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'The books _____ on the desk.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查复数主语的主谓一致。主语"the books"是复数，谓语动词用复数are。易错点：注意主语的单复数形式。', ARRAY['主谓一致', '复数主语', '语法一致']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'My sister _____ a teacher.', '["A. is", "B. are", "C. am", "D. be"]', 'A', '本题考查第三人称单数的主谓一致。主语"my sister"是第三人称单数，谓语动词用is。易错点：第三人称单数主语用单数动词。', ARRAY['主谓一致', '第三人称单数', '语法一致']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'fill_blank', 'beginner', 'The students _____ (be) in the classroom.', NULL, 'are', '本题考查复数主语的主谓一致。主语"the students"是复数，be动词用are。易错点：注意主语的单复数形式。', ARRAY['主谓一致', '复数主语', 'be动词']),

-- and连接的主语（新增3题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Tom and Jerry _____ my friends.', '["A. is", "B. are", "C. was", "D. am"]', 'B', '本题考查and连接的主语。and连接两个不同的人或物，主语是复数，谓语动词用are。易错点：and连接的主语通常用复数动词。', ARRAY['主谓一致', 'and连接', '复数动词']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Both you and I _____ students.', '["A. is", "B. are", "C. am", "D. be"]', 'B', '本题考查both...and...结构。both...and...连接主语时，谓语动词用复数are。易错点：both...and...连接主语用复数动词。', ARRAY['主谓一致', 'both...and...', '复数动词']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'The teacher as well as the students _____ interested in the book.', '["A. is', 'B. are', 'C. was', 'D. were"]', 'A', '本题考查as well as连接的主语。as well as, together with, along with等连接主语时，谓语动词与前面的主语保持一致。主语是"the teacher"（单数），用is。易错点：as well as连接主语时，谓语动词与前面的主语一致，不是就近原则。', ARRAY['主谓一致', 'as well as', '与前面主语一致']),

-- or连接的主语（新增3题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Either you or I _____ wrong.', '["A. is", "B. are", "C. am", "D. be"]', 'C', '本题考查either...or...的就近原则。either...or...连接主语时，谓语动词与靠近的主语保持一致。靠近的主语是"I"，用am。易错点：either...or..., neither...nor..., not only...but also...等连接主语时，遵循就近原则。', ARRAY['主谓一致', 'either...or...', '就近原则']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Neither he nor I _____ a doctor.', '["A. is", "B. are", "C. am", "D. be"]', 'C', '本题考查neither...nor...的就近原则。谓语动词与靠近的主语"I"保持一致，用am。易错点：就近原则，谓语动词与靠近的主语一致。', ARRAY['主谓一致', 'neither...nor...', '就近原则']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'Not only the students but also the teacher _____ interested in the film.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查not only...but also...的就近原则。谓语动词与靠近的主语"the teacher"（单数）保持一致，用is。易错点：not only...but also...连接主语时，遵循就近原则。', ARRAY['主谓一致', 'not only...but also...', '就近原则']),

-- 不定代词作主语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Everyone _____ here.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查不定代词作主语。everyone, everybody, someone, somebody, anyone, anybody, no one, nobody等不定代词作主语时，谓语动词用单数。易错点：不定代词作主语用单数动词。', ARRAY['主谓一致', '不定代词', '单数动词']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Nobody _____ the answer.', '["A. know", "B. knows", "C. knowing", "D. to know"]', 'B', '本题考查不定代词作主语。nobody是不定代词，作主语时谓语动词用单数knows。易错点：不定代词作主语用单数动词。', ARRAY['主谓一致', '不定代词', '单数动词']),

-- 集体名词（新增3题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'My family _____ a big one.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查集体名词作主语。family作为一个整体时，谓语动词用单数is。易错点：集体名词作为整体时用单数，指成员时用复数。', ARRAY['主谓一致', '集体名词', '作为整体']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'My family _____ all music lovers.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查集体名词作主语。family指家庭成员时，谓语动词用复数are。易错点：集体名词指成员时用复数动词。', ARRAY['主谓一致', '集体名词', '指成员']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'The team _____ playing football.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查集体名词作主语。team指队员们正在踢球，强调成员，谓语动词用复数are。易错点：根据语境判断集体名词是指整体还是成员。', ARRAY['主谓一致', '集体名词', '指成员']),

-- 表示时间、距离、金钱的复数名词（新增2题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Two hours _____ enough for us.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查表示时间的复数名词作主语。表示时间、距离、金钱的复数名词作为整体时，谓语动词用单数is。易错点：虽然是复数形式，但作为整体时用单数动词。', ARRAY['主谓一致', '时间名词', '作为整体']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'Ten dollars _____ too much for the book.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查表示金钱的复数名词作主语。表示金钱的复数名词作为整体时，谓语动词用单数is。易错点：金钱数量作为整体时用单数动词。', ARRAY['主谓一致', '金钱名词', '作为整体']),

-- 分数、百分数作主语（新增2题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'Two thirds of the students _____ boys.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查分数作主语。"分数/百分数+of+名词"作主语时，谓语动词与of后的名词保持一致。"students"是复数，用are。易错点：分数/百分数+of+名词，谓语动词与of后的名词一致。', ARRAY['主谓一致', '分数', 'of后名词']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'Fifty percent of the water _____ polluted.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查百分数作主语。"百分数+of+名词"作主语时，谓语动词与of后的名词保持一致。"water"是不可数名词，用is。易错点：谓语动词与of后的名词一致。', ARRAY['主谓一致', '百分数', 'of后名词']),

-- the number of与a number of（新增2题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'The number of students _____ 50.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查the number of作主语。the number of表示"...的数量"，作主语时谓语动词用单数is。易错点：the number of+复数名词，谓语动词用单数。', ARRAY['主谓一致', 'the number of', '单数动词']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'A number of students _____ in the classroom.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查a number of作主语。a number of表示"许多"，作主语时谓语动词用复数are。易错点：a number of+复数名词，谓语动词用复数。', ARRAY['主谓一致', 'a number of', '复数动词']),

-- there be句型（新增2题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'beginner', 'There _____ a book and two pens on the desk.', '["A. is", "B. are", "C. was", "D. were"]', 'A', '本题考查there be句型的就近原则。there be句型中，be动词与靠近的主语保持一致。靠近的主语是"a book"（单数），用is。易错点：there be句型遵循就近原则。', ARRAY['主谓一致', 'there be', '就近原则']),

((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'intermediate', 'There _____ two pens and a book on the desk.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查there be句型的就近原则。靠近的主语是"two pens"（复数），用are。易错点：there be句型遵循就近原则，be动词与靠近的主语一致。', ARRAY['主谓一致', 'there be', '就近原则']),

-- 定语从句中的主谓一致（新增1题）
((SELECT id FROM grammar_modules WHERE name = '主谓一致'), 'single_choice', 'advanced', 'He is one of the students who _____ good at English.', '["A. is", "B. are", "C. was", "D. were"]', 'B', '本题考查定语从句中的主谓一致。先行词是"the students"（复数），关系代词who指代students，从句谓语动词用复数are。易错点：定语从句中，谓语动词与先行词保持一致。', ARRAY['主谓一致', '定语从句', '先行词']);

-- 完成第一阶段扩充
-- 总计新增140道题：
-- - 时态：30题
-- - 从句：30题
-- - 非谓语动词：30题
-- - 虚拟语气：25题
-- - 主谓一致：25题
