import {Button, ScrollView, Text, View} from '@tarojs/components'
import Taro, {useRouter} from '@tarojs/taro'
import {useCallback, useEffect, useState} from 'react'
import {getGrammarModuleById, getQuestionsByModule} from '@/db/api'
import type {GrammarModule, Question} from '@/db/types'

export default function KnowledgeDetail() {
  const router = useRouter()
  const {id, name} = router.params
  const [module, setModule] = useState<GrammarModule | null>(null)
  const [questions, setQuestions] = useState<Question[]>([])
  const [loading, setLoading] = useState(true)

  const loadData = useCallback(async () => {
    if (!id) return
    setLoading(true)
    try {
      const [moduleData, questionsData] = await Promise.all([getGrammarModuleById(id), getQuestionsByModule(id)])
      setModule(moduleData)
      setQuestions(questionsData)
    } catch (error) {
      console.error('加载详情失败:', error)
      Taro.showToast({title: '加载失败，请重试', icon: 'none'})
    } finally {
      setLoading(false)
    }
  }, [id])

  useEffect(() => {
    loadData()
  }, [loadData])

  const handlePractice = () => {
    Taro.switchTab({url: '/pages/practice/index'})
  }

  if (loading) {
    return (
      <View className="min-h-screen bg-background flex items-center justify-center">
        <Text className="text-muted-foreground">加载中...</Text>
      </View>
    )
  }

  if (!module) {
    return (
      <View className="min-h-screen bg-background flex items-center justify-center">
        <Text className="text-muted-foreground">模块不存在</Text>
      </View>
    )
  }

  return (
    <View style={{background: 'linear-gradient(to bottom, #EBF4FF, #FFFFFF)', minHeight: '100vh'}}>
      <ScrollView scrollY className="box-border" style={{background: 'transparent', height: '100vh'}}>
        <View className="p-4">
          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-md)'}}>
            <View className="flex items-center mb-4">
              <View
                className="w-14 h-14 rounded-full flex items-center justify-center mr-3"
                style={{background: 'var(--gradient-primary)'}}>
                <View className="i-mdi-book-open-variant text-white text-2xl" />
              </View>
              <View className="flex-1">
                <Text className="text-foreground font-bold text-xl block mb-1">{name || module.name}</Text>
                <Text className="text-muted-foreground text-sm">{module.description}</Text>
              </View>
            </View>
          </View>

          {module.content && (
            <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-sm)'}}>
              <View className="flex items-center mb-3">
                <View className="i-mdi-text-box-outline text-primary text-xl mr-2" />
                <Text className="text-foreground font-semibold text-base">语法规则</Text>
              </View>
              <Text className="text-foreground text-sm leading-relaxed whitespace-pre-wrap">{module.content}</Text>
            </View>
          )}

          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-sm)'}}>
            <View className="flex items-center justify-between mb-3">
              <View className="flex items-center">
                <View className="i-mdi-format-list-numbered text-primary text-xl mr-2" />
                <Text className="text-foreground font-semibold text-base">相关练习</Text>
              </View>
              <Text className="text-primary text-sm font-medium">共 {questions.length} 题</Text>
            </View>

            {questions.length > 0 ? (
              <View className="space-y-2">
                {questions.slice(0, 5).map((question, index) => {
                  const difficultyColors = {
                    beginner: 'bg-success/10 text-success',
                    intermediate: 'bg-secondary/10 text-secondary-foreground',
                    advanced: 'bg-destructive/10 text-destructive'
                  }
                  const difficultyText = {
                    beginner: '入门',
                    intermediate: '进阶',
                    advanced: '高阶'
                  }

                  return (
                    <View key={question.id} className="bg-muted rounded-lg p-3">
                      <View className="flex items-center justify-between mb-2">
                        <Text className="text-foreground text-sm font-medium flex-1">
                          {index + 1}. {question.question.substring(0, 40)}
                          {question.question.length > 40 ? '...' : ''}
                        </Text>
                        <View className={`px-2 py-1 rounded ${difficultyColors[question.difficulty]}`}>
                          <Text className="text-xs">{difficultyText[question.difficulty]}</Text>
                        </View>
                      </View>
                      {question.tags && question.tags.length > 0 && (
                        <View className="flex flex-wrap gap-1">
                          {question.tags.slice(0, 3).map((tag, idx) => (
                            <Text key={idx} className="text-muted-foreground text-xs">
                              #{tag}
                            </Text>
                          ))}
                        </View>
                      )}
                    </View>
                  )
                })}
                {questions.length > 5 && (
                  <Text className="text-muted-foreground text-xs text-center pt-2">
                    还有 {questions.length - 5} 道题目...
                  </Text>
                )}
              </View>
            ) : (
              <View className="text-center py-6">
                <View className="i-mdi-file-document-outline text-muted-foreground text-3xl mb-2 mx-auto" />
                <Text className="text-muted-foreground text-sm">暂无相关练习</Text>
              </View>
            )}
          </View>

          <Button
            onClick={handlePractice}
            className="w-full bg-primary text-primary-foreground py-4 rounded-xl break-keep text-base font-medium"
            size="default">
            开始练习
          </Button>
        </View>
      </ScrollView>
    </View>
  )
}
