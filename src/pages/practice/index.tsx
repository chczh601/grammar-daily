import {Button, ScrollView, Text, View} from '@tarojs/components'
import Taro, {useDidShow, useShareAppMessage, useShareTimeline} from '@tarojs/taro'
import {useCallback, useEffect, useState} from 'react'
import {
  checkIn,
  getContinuousDays,
  getTodayAnsweredQuestions,
  getTodayQuestions,
  initTodayPractice,
  saveUserAnswer,
  toggleFavorite
} from '@/db/api'
import type {QuestionWithModule} from '@/db/types'

export default function Practice() {
  const [questions, setQuestions] = useState<QuestionWithModule[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selectedAnswer, setSelectedAnswer] = useState('')
  const [showResult, setShowResult] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [answeredQuestions, setAnsweredQuestions] = useState<Set<string>>(new Set())
  const [isFavorite, setIsFavorite] = useState(false)
  const [continuousDays, setContinuousDays] = useState(0)
  const [loading, setLoading] = useState(true)

  useShareAppMessage(() => {
    return {
      title: '英语语法每日一练 - 每天10分钟，轻松提升语法能力'
    }
  })

  useShareTimeline(() => {
    return {
      title: '英语语法每日一练 - 每天10分钟，轻松提升语法能力'
    }
  })

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      await initTodayPractice()
      const [questionsData, answeredIds, days] = await Promise.all([
        getTodayQuestions(),
        getTodayAnsweredQuestions(),
        getContinuousDays()
      ])
      setQuestions(questionsData)
      setAnsweredQuestions(new Set(answeredIds))
      setContinuousDays(days)
    } catch (error) {
      console.error('加载数据失败:', error)
      Taro.showToast({title: '加载失败，请重试', icon: 'none'})
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    loadData()
  }, [loadData])

  useDidShow(() => {
    loadData()
  })

  const currentQuestion = questions[currentIndex]

  const handleAnswerSelect = (answer: string) => {
    if (showResult) return
    setSelectedAnswer(answer)
  }

  const handleSubmit = async () => {
    if (!selectedAnswer || !currentQuestion) {
      Taro.showToast({title: '请选择答案', icon: 'none'})
      return
    }

    const correct = selectedAnswer.trim().toLowerCase() === currentQuestion.answer.trim().toLowerCase()
    setIsCorrect(correct)
    setShowResult(true)

    await saveUserAnswer(currentQuestion.id, selectedAnswer, correct)
    setAnsweredQuestions((prev) => new Set([...prev, currentQuestion.id]))

    if (answeredQuestions.size + 1 === questions.length) {
      await checkIn()
      const days = await getContinuousDays()
      setContinuousDays(days)
    }
  }

  const handleNext = () => {
    if (currentIndex < questions.length - 1) {
      setCurrentIndex(currentIndex + 1)
      setSelectedAnswer('')
      setShowResult(false)
      setIsCorrect(false)
      setIsFavorite(false)
    } else {
      Taro.showToast({title: '今日练习已完成！', icon: 'success'})
    }
  }

  const handleToggleFavorite = async () => {
    if (!currentQuestion) return
    const success = await toggleFavorite(currentQuestion.id)
    if (success) {
      setIsFavorite(!isFavorite)
      Taro.showToast({
        title: isFavorite ? '已取消收藏' : '已收藏',
        icon: 'success'
      })
    }
  }

  const getDifficultyText = (difficulty: string) => {
    const map = {
      beginner: '入门',
      intermediate: '进阶',
      advanced: '高阶'
    }
    return map[difficulty] || difficulty
  }

  const getTypeText = (type: string) => {
    const map = {
      single_choice: '单选题',
      fill_blank: '填空题',
      correction: '改错题'
    }
    return map[type] || type
  }

  if (loading) {
    return (
      <View className="min-h-screen bg-background flex items-center justify-center">
        <Text className="text-muted-foreground">加载中...</Text>
      </View>
    )
  }

  if (questions.length === 0) {
    return (
      <View className="min-h-screen bg-background flex items-center justify-center p-4">
        <Text className="text-muted-foreground">暂无题目</Text>
      </View>
    )
  }

  const progress = ((currentIndex + 1) / questions.length) * 100
  const completedCount = answeredQuestions.size

  return (
    <View style={{background: 'linear-gradient(to bottom, #EBF4FF, #FFFFFF)', minHeight: '100vh'}}>
      <ScrollView scrollY className="box-border" style={{background: 'transparent', height: '100vh'}}>
        <View className="p-4">
          <View className="bg-card rounded-xl p-4 mb-4" style={{boxShadow: 'var(--shadow-sm)'}}>
            <View className="flex items-center justify-between mb-2">
              <Text className="text-foreground font-semibold text-base">今日进度</Text>
              <Text className="text-primary font-bold text-sm">
                {completedCount}/{questions.length}
              </Text>
            </View>
            <View className="bg-muted rounded-full h-2 overflow-hidden">
              <View className="bg-primary h-full rounded-full transition-all" style={{width: `${progress}%`}} />
            </View>
            {continuousDays > 0 && (
              <View className="mt-3 flex items-center">
                <View className="i-mdi-fire text-secondary text-xl mr-1" />
                <Text className="text-secondary-foreground text-sm font-medium">已连续打卡 {continuousDays} 天</Text>
              </View>
            )}
          </View>

          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-md)'}}>
            <View className="flex items-center justify-between mb-4">
              <View className="flex items-center gap-2">
                <View className="bg-primary/10 px-3 py-1 rounded-full">
                  <Text className="text-primary text-xs font-medium">第 {currentIndex + 1} 题</Text>
                </View>
                <View className="bg-secondary/10 px-3 py-1 rounded-full">
                  <Text className="text-secondary-foreground text-xs font-medium">
                    {getDifficultyText(currentQuestion.difficulty)}
                  </Text>
                </View>
              </View>
              <Text className="text-muted-foreground text-xs">{getTypeText(currentQuestion.type)}</Text>
            </View>

            <Text className="text-foreground text-base leading-relaxed mb-2">{currentQuestion.question}</Text>

            {currentQuestion.tags && currentQuestion.tags.length > 0 && (
              <View className="flex flex-wrap gap-2 mt-3">
                {currentQuestion.tags.map((tag, idx) => (
                  <View key={idx} className="bg-muted px-2 py-1 rounded">
                    <Text className="text-muted-foreground text-xs">#{tag}</Text>
                  </View>
                ))}
              </View>
            )}
          </View>

          {currentQuestion.type === 'single_choice' && currentQuestion.options && (
            <View className="mb-4 space-y-3">
              {currentQuestion.options.map((option, idx) => {
                const isSelected = selectedAnswer === option
                const showCorrect = showResult && option === currentQuestion.answer
                const showWrong = showResult && isSelected && !isCorrect

                return (
                  <View
                    key={idx}
                    onClick={() => handleAnswerSelect(option)}
                    className={`
                      bg-card rounded-xl p-4 border-2 transition-all
                      ${isSelected && !showResult ? 'border-primary bg-primary/5' : 'border-border'}
                      ${showCorrect ? 'border-success bg-success/5' : ''}
                      ${showWrong ? 'border-destructive bg-destructive/5' : ''}
                    `}
                    style={{boxShadow: isSelected ? 'var(--shadow-sm)' : 'none'}}>
                    <View className="flex items-center">
                      {showCorrect && <View className="i-mdi-check-circle text-success text-xl mr-2" />}
                      {showWrong && <View className="i-mdi-close-circle text-destructive text-xl mr-2" />}
                      <Text
                        className={`
                          text-sm flex-1
                          ${isSelected && !showResult ? 'text-primary font-medium' : 'text-foreground'}
                          ${showCorrect ? 'text-success font-medium' : ''}
                          ${showWrong ? 'text-destructive font-medium' : ''}
                        `}>
                        {option}
                      </Text>
                    </View>
                  </View>
                )
              })}
            </View>
          )}

          {currentQuestion.type === 'fill_blank' && (
            <View className="mb-4">
              <View style={{overflow: 'hidden'}}>
                <input
                  type="text"
                  value={selectedAnswer}
                  onChange={(e) => setSelectedAnswer(e.target.value)}
                  placeholder="请输入答案"
                  disabled={showResult}
                  className="w-full bg-card border-2 border-border rounded-xl px-4 py-3 text-foreground text-sm"
                  style={{outline: 'none'}}
                />
              </View>
            </View>
          )}

          {currentQuestion.type === 'correction' && (
            <View className="mb-4">
              <View style={{overflow: 'hidden'}}>
                <textarea
                  value={selectedAnswer}
                  onChange={(e) => setSelectedAnswer(e.target.value)}
                  placeholder="请输入修改后的正确句子"
                  disabled={showResult}
                  className="w-full bg-card border-2 border-border rounded-xl px-4 py-3 text-foreground text-sm min-h-24"
                  style={{outline: 'none'}}
                />
              </View>
            </View>
          )}

          {showResult && (
            <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-md)'}}>
              <View className="flex items-center mb-3">
                {isCorrect ? (
                  <>
                    <View className="i-mdi-check-circle text-success text-2xl mr-2" />
                    <Text className="text-success font-semibold text-base">回答正确！</Text>
                  </>
                ) : (
                  <>
                    <View className="i-mdi-close-circle text-destructive text-2xl mr-2" />
                    <Text className="text-destructive font-semibold text-base">回答错误</Text>
                  </>
                )}
              </View>

              <View className="bg-muted rounded-lg p-3 mb-3">
                <Text className="text-muted-foreground text-xs mb-1">正确答案</Text>
                <Text className="text-foreground text-sm font-medium">{currentQuestion.answer}</Text>
              </View>

              <View className="bg-primary/5 rounded-lg p-3">
                <Text className="text-primary text-xs font-medium mb-2">解析</Text>
                <Text className="text-foreground text-sm leading-relaxed">{currentQuestion.explanation}</Text>
              </View>

              <View className="flex items-center justify-between mt-4 pt-4 border-t border-border">
                <Button
                  onClick={handleToggleFavorite}
                  className="flex items-center gap-1 bg-transparent border-0 p-0"
                  size="default">
                  <View
                    className={`text-xl ${isFavorite ? 'i-mdi-star text-secondary' : 'i-mdi-star-outline text-muted-foreground'}`}
                  />
                  <Text className="text-muted-foreground text-sm">{isFavorite ? '已收藏' : '收藏错题'}</Text>
                </Button>
              </View>
            </View>
          )}

          <View className="flex gap-3">
            {!showResult ? (
              <Button
                onClick={handleSubmit}
                className="flex-1 bg-primary text-primary-foreground py-4 rounded-xl break-keep text-base font-medium"
                size="default">
                提交答案
              </Button>
            ) : (
              <Button
                onClick={handleNext}
                className="flex-1 bg-primary text-primary-foreground py-4 rounded-xl break-keep text-base font-medium"
                size="default">
                {currentIndex < questions.length - 1 ? '下一题' : '完成练习'}
              </Button>
            )}
          </View>
        </View>
      </ScrollView>
    </View>
  )
}
