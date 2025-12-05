import {ScrollView, Text, View} from '@tarojs/components'
import Taro, {useDidShow} from '@tarojs/taro'
import {useAuth} from 'miaoda-auth-taro'
import {useCallback, useEffect, useState} from 'react'
import {getFavoriteQuestions} from '@/db/api'
import type {QuestionWithModule} from '@/db/types'

export default function Favorites() {
  // 添加登录保护
  const {user} = useAuth({guard: true})

  const [favorites, setFavorites] = useState<QuestionWithModule[]>([])
  const [loading, setLoading] = useState(true)

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      const data = await getFavoriteQuestions()
      setFavorites(data)
    } catch (error) {
      console.error('加载收藏失败:', error)
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

  return (
    <View style={{background: 'linear-gradient(to bottom, #EBF4FF, #FFFFFF)', minHeight: '100vh'}}>
      <ScrollView scrollY className="box-border" style={{background: 'transparent', height: '100vh'}}>
        <View className="p-4">
          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-sm)'}}>
            <View className="flex items-center justify-between">
              <View className="flex items-center">
                <View className="i-mdi-star text-secondary text-2xl mr-2" />
                <Text className="text-foreground font-bold text-lg">我的错题本</Text>
              </View>
              <Text className="text-primary text-sm font-medium">共 {favorites.length} 题</Text>
            </View>
          </View>

          {favorites.length > 0 ? (
            <View className="space-y-3">
              {favorites.map((question) => {
                const difficultyColors = {
                  beginner: 'bg-success/10 text-success',
                  intermediate: 'bg-secondary/10 text-secondary-foreground',
                  advanced: 'bg-destructive/10 text-destructive'
                }

                return (
                  <View key={question.id} className="bg-card rounded-xl p-4" style={{boxShadow: 'var(--shadow-sm)'}}>
                    <View className="flex items-center justify-between mb-3">
                      <View className="flex items-center gap-2">
                        <View className="bg-primary/10 px-2 py-1 rounded">
                          <Text className="text-primary text-xs font-medium">{question.module_name}</Text>
                        </View>
                        <View className={`px-2 py-1 rounded ${difficultyColors[question.difficulty]}`}>
                          <Text className="text-xs">{getDifficultyText(question.difficulty)}</Text>
                        </View>
                      </View>
                      <Text className="text-muted-foreground text-xs">{getTypeText(question.type)}</Text>
                    </View>

                    <Text className="text-foreground text-sm leading-relaxed mb-3">{question.question}</Text>

                    <View className="bg-muted rounded-lg p-3 mb-3">
                      <Text className="text-muted-foreground text-xs mb-1">正确答案</Text>
                      <Text className="text-foreground text-sm font-medium">{question.answer}</Text>
                    </View>

                    <View className="bg-primary/5 rounded-lg p-3">
                      <Text className="text-primary text-xs font-medium mb-1">解析</Text>
                      <Text className="text-foreground text-sm leading-relaxed">{question.explanation}</Text>
                    </View>

                    {question.tags && question.tags.length > 0 && (
                      <View className="flex flex-wrap gap-2 mt-3">
                        {question.tags.map((tag, idx) => (
                          <View key={idx} className="bg-muted px-2 py-1 rounded">
                            <Text className="text-muted-foreground text-xs">#{tag}</Text>
                          </View>
                        ))}
                      </View>
                    )}
                  </View>
                )
              })}
            </View>
          ) : (
            <View className="text-center py-16">
              <View className="i-mdi-star-off text-muted-foreground text-6xl mb-4 mx-auto" />
              <Text className="text-foreground font-medium text-base block mb-2">暂无收藏题目</Text>
              <Text className="text-muted-foreground text-sm">在练习中遇到错题可以收藏哦</Text>
            </View>
          )}
        </View>
      </ScrollView>
    </View>
  )
}
