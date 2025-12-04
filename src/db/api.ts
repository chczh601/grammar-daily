import {supabase} from '@/client/supabase'
import type {
  CheckInRecord,
  DailyStats,
  GrammarModule,
  Question,
  QuestionWithModule,
  UserRecord,
  WeeklyReport
} from './types'

const DEFAULT_USER_ID = '00000000-0000-0000-0000-000000000001'

// 语法模块相关API
export async function getGrammarModules(): Promise<GrammarModule[]> {
  const {data, error} = await supabase.from('grammar_modules').select('*').order('order_index', {ascending: true})

  if (error) {
    console.error('获取语法模块失败:', error)
    return []
  }
  return Array.isArray(data) ? data : []
}

export async function getGrammarModuleById(id: string): Promise<GrammarModule | null> {
  const {data, error} = await supabase.from('grammar_modules').select('*').eq('id', id).maybeSingle()

  if (error) {
    console.error('获取语法模块详情失败:', error)
    return null
  }
  return data
}

// 题目相关API
export async function getTodayQuestions(): Promise<QuestionWithModule[]> {
  const today = new Date().toISOString().split('T')[0]

  const {data: practiceData, error: practiceError} = await supabase
    .from('daily_practice')
    .select('question_ids')
    .eq('practice_date', today)
    .maybeSingle()

  if (practiceError || !practiceData?.question_ids) {
    console.error('获取今日练习配置失败:', practiceError)
    return []
  }

  const {data, error} = await supabase
    .from('questions')
    .select(`
      *,
      grammar_modules(name)
    `)
    .in('id', practiceData.question_ids)
    .order('id', {ascending: true})

  if (error) {
    console.error('获取今日题目失败:', error)
    return []
  }

  if (!Array.isArray(data)) return []

  return data.map((q: any) => ({
    ...q,
    module_name: q.grammar_modules?.name || '未分类'
  })) as QuestionWithModule[]
}

export async function getQuestionsByModule(moduleId: string): Promise<Question[]> {
  const {data, error} = await supabase
    .from('questions')
    .select('*')
    .eq('module_id', moduleId)
    .order('id', {ascending: true})

  if (error) {
    console.error('获取模块题目失败:', error)
    return []
  }
  return Array.isArray(data) ? data : []
}

export async function getQuestionById(id: string): Promise<Question | null> {
  const {data, error} = await supabase.from('questions').select('*').eq('id', id).maybeSingle()

  if (error) {
    console.error('获取题目详情失败:', error)
    return null
  }
  return data
}

// 用户答题记录相关API
export async function saveUserAnswer(
  questionId: string,
  userAnswer: string,
  isCorrect: boolean,
  userId: string = DEFAULT_USER_ID
): Promise<boolean> {
  const {error} = await supabase.from('user_records').insert({
    user_id: userId,
    question_id: questionId,
    user_answer: userAnswer,
    is_correct: isCorrect,
    answered_at: new Date().toISOString()
  })

  if (error) {
    console.error('保存答题记录失败:', error)
    return false
  }
  return true
}

export async function getUserAnswerForQuestion(
  questionId: string,
  userId: string = DEFAULT_USER_ID
): Promise<UserRecord | null> {
  const {data, error} = await supabase
    .from('user_records')
    .select('*')
    .eq('user_id', userId)
    .eq('question_id', questionId)
    .order('answered_at', {ascending: false})
    .limit(1)
    .maybeSingle()

  if (error) {
    console.error('获取用户答题记录失败:', error)
    return null
  }
  return data
}

export async function getTodayAnsweredQuestions(userId: string = DEFAULT_USER_ID): Promise<string[]> {
  const today = new Date().toISOString().split('T')[0]
  const {data, error} = await supabase
    .from('user_records')
    .select('question_id')
    .eq('user_id', userId)
    .gte('answered_at', `${today}T00:00:00`)
    .lte('answered_at', `${today}T23:59:59`)

  if (error) {
    console.error('获取今日已答题目失败:', error)
    return []
  }
  return Array.isArray(data) ? data.map((r) => r.question_id || '').filter(Boolean) : []
}

// 收藏相关API
export async function toggleFavorite(questionId: string, userId: string = DEFAULT_USER_ID): Promise<boolean> {
  const record = await getUserAnswerForQuestion(questionId, userId)

  if (!record) {
    return false
  }

  const {error} = await supabase.from('user_records').update({is_favorite: !record.is_favorite}).eq('id', record.id)

  if (error) {
    console.error('切换收藏状态失败:', error)
    return false
  }
  return true
}

export async function getFavoriteQuestions(userId: string = DEFAULT_USER_ID): Promise<QuestionWithModule[]> {
  const {data, error} = await supabase
    .from('user_records')
    .select(`
      question_id,
      questions(
        *,
        grammar_modules(name)
      )
    `)
    .eq('user_id', userId)
    .eq('is_favorite', true)
    .order('answered_at', {ascending: false})

  if (error) {
    console.error('获取收藏题目失败:', error)
    return []
  }

  if (!Array.isArray(data)) return []

  return data
    .filter((r: any) => r.questions)
    .map((r: any) => ({
      ...r.questions,
      module_name: r.questions.grammar_modules?.name || '未分类'
    })) as QuestionWithModule[]
}

// 打卡相关API
export async function checkIn(userId: string = DEFAULT_USER_ID): Promise<CheckInRecord | null> {
  const today = new Date().toISOString().split('T')[0]

  const {data: existingRecord} = await supabase
    .from('check_in_records')
    .select('*')
    .eq('user_id', userId)
    .eq('check_date', today)
    .maybeSingle()

  if (existingRecord) {
    return existingRecord
  }

  const yesterday = new Date()
  yesterday.setDate(yesterday.getDate() - 1)
  const yesterdayStr = yesterday.toISOString().split('T')[0]

  const {data: yesterdayRecord} = await supabase
    .from('check_in_records')
    .select('continuous_days')
    .eq('user_id', userId)
    .eq('check_date', yesterdayStr)
    .maybeSingle()

  const continuousDays = yesterdayRecord ? yesterdayRecord.continuous_days + 1 : 1

  const todayStats = await getTodayStats(userId)

  const {data, error} = await supabase
    .from('check_in_records')
    .insert({
      user_id: userId,
      check_date: today,
      completed_count: todayStats.completed_questions,
      correct_count: todayStats.correct_count,
      continuous_days: continuousDays
    })
    .select()
    .maybeSingle()

  if (error) {
    console.error('打卡失败:', error)
    return null
  }
  return data
}

export async function getCheckInRecords(
  userId: string = DEFAULT_USER_ID,
  limit: number = 30
): Promise<CheckInRecord[]> {
  const {data, error} = await supabase
    .from('check_in_records')
    .select('*')
    .eq('user_id', userId)
    .order('check_date', {ascending: false})
    .limit(limit)

  if (error) {
    console.error('获取打卡记录失败:', error)
    return []
  }
  return Array.isArray(data) ? data : []
}

export async function getContinuousDays(userId: string = DEFAULT_USER_ID): Promise<number> {
  const today = new Date().toISOString().split('T')[0]

  const {data} = await supabase
    .from('check_in_records')
    .select('continuous_days')
    .eq('user_id', userId)
    .eq('check_date', today)
    .maybeSingle()

  return data?.continuous_days || 0
}

// 统计相关API
export async function getTodayStats(userId: string = DEFAULT_USER_ID): Promise<DailyStats> {
  const today = new Date().toISOString().split('T')[0]

  const todayQuestions = await getTodayQuestions()
  const totalQuestions = todayQuestions.length

  const {data, error} = await supabase
    .from('user_records')
    .select('is_correct')
    .eq('user_id', userId)
    .gte('answered_at', `${today}T00:00:00`)
    .lte('answered_at', `${today}T23:59:59`)

  if (error) {
    console.error('获取今日统计失败:', error)
    return {
      total_questions: totalQuestions,
      completed_questions: 0,
      correct_count: 0,
      accuracy: 0
    }
  }

  const records = Array.isArray(data) ? data : []
  const completedQuestions = records.length
  const correctCount = records.filter((r) => r.is_correct).length
  const accuracy = completedQuestions > 0 ? (correctCount / completedQuestions) * 100 : 0

  return {
    total_questions: totalQuestions,
    completed_questions: completedQuestions,
    correct_count: correctCount,
    accuracy: Math.round(accuracy)
  }
}

export async function getWeeklyReport(userId: string = DEFAULT_USER_ID): Promise<WeeklyReport> {
  const today = new Date()
  const weekStart = new Date(today)
  weekStart.setDate(today.getDate() - today.getDay())
  const weekStartStr = weekStart.toISOString().split('T')[0]
  const weekEndStr = today.toISOString().split('T')[0]

  const {data, error} = await supabase
    .from('user_records')
    .select(`
      is_correct,
      answered_at,
      questions(module_id, grammar_modules(name))
    `)
    .eq('user_id', userId)
    .gte('answered_at', `${weekStartStr}T00:00:00`)
    .lte('answered_at', `${weekEndStr}T23:59:59`)

  if (error) {
    console.error('获取周报失败:', error)
    return {
      week_start: weekStartStr,
      week_end: weekEndStr,
      total_days: 7,
      practice_days: 0,
      total_questions: 0,
      correct_count: 0,
      accuracy: 0,
      weak_modules: []
    }
  }

  const records = Array.isArray(data) ? data : []
  const totalQuestions = records.length
  const correctCount = records.filter((r) => r.is_correct).length
  const accuracy = totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0

  const practiceDaysSet = new Set(records.map((r) => r.answered_at.split('T')[0]))

  const moduleStats: Record<string, {total: number; correct: number}> = {}
  records.forEach((r: any) => {
    const moduleName = r.questions?.grammar_modules?.name || '未分类'
    if (!moduleStats[moduleName]) {
      moduleStats[moduleName] = {total: 0, correct: 0}
    }
    moduleStats[moduleName].total++
    if (r.is_correct) {
      moduleStats[moduleName].correct++
    }
  })

  const weakModules = Object.entries(moduleStats)
    .map(([module_name, stats]) => ({
      module_name,
      accuracy: Math.round((stats.correct / stats.total) * 100)
    }))
    .sort((a, b) => a.accuracy - b.accuracy)
    .slice(0, 3)

  return {
    week_start: weekStartStr,
    week_end: weekEndStr,
    total_days: 7,
    practice_days: practiceDaysSet.size,
    total_questions: totalQuestions,
    correct_count: correctCount,
    accuracy: Math.round(accuracy),
    weak_modules: weakModules
  }
}

// 初始化每日练习（如果今天没有配置）
export async function initTodayPractice(): Promise<boolean> {
  const today = new Date().toISOString().split('T')[0]

  const {data: existing} = await supabase.from('daily_practice').select('id').eq('practice_date', today).maybeSingle()

  if (existing) {
    return true
  }

  const {data: allQuestions} = await supabase.from('questions').select('id').order('id', {ascending: true})

  if (!allQuestions || allQuestions.length < 10) {
    console.error('题库题目不足')
    return false
  }

  const shuffled = [...allQuestions].sort(() => Math.random() - 0.5)
  const selectedIds = shuffled.slice(0, 10).map((q) => q.id)

  const {error} = await supabase.from('daily_practice').insert({
    practice_date: today,
    question_ids: selectedIds
  })

  if (error) {
    console.error('初始化今日练习失败:', error)
    return false
  }
  return true
}
