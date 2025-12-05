// 数据库表类型定义

// 用户角色类型
export type UserRole = 'user' | 'admin'

// 用户信息表
export interface Profile {
  id: string
  phone: string | null
  email: string | null
  nickname: string | null
  avatar_url: string | null
  role: UserRole
  created_at: string
  updated_at: string
}

export interface GrammarModule {
  id: string
  name: string
  description: string | null
  content: string | null
  order_index: number
  created_at: string
}

export type QuestionType = 'single_choice' | 'fill_blank' | 'correction'
export type DifficultyLevel = 'beginner' | 'intermediate' | 'advanced'

export interface Question {
  id: string
  module_id: string | null
  type: QuestionType
  difficulty: DifficultyLevel
  question: string
  options: string[] | null
  answer: string
  explanation: string
  tags: string[] | null
  created_at: string
}

export interface UserRecord {
  id: string
  user_id: string
  question_id: string | null
  user_answer: string | null
  is_correct: boolean | null
  is_favorite: boolean
  answered_at: string
  created_at: string
}

export interface DailyPractice {
  id: string
  practice_date: string
  question_ids: string[] | null
  created_at: string
}

export interface CheckInRecord {
  id: string
  user_id: string
  check_date: string
  completed_count: number
  correct_count: number
  continuous_days: number
  created_at: string
}

// 扩展类型（用于业务逻辑）
export interface QuestionWithModule extends Question {
  module_name?: string
}

export interface DailyStats {
  total_questions: number
  completed_questions: number
  correct_count: number
  accuracy: number
}

export interface WeeklyReport {
  week_start: string
  week_end: string
  total_days: number
  practice_days: number
  total_questions: number
  correct_count: number
  accuracy: number
  weak_modules: Array<{
    module_name: string
    accuracy: number
  }>
}

export interface MonthlyReport extends WeeklyReport {
  month: string
}
