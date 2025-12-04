import {ScrollView, Text, View} from '@tarojs/components'
import Taro, {useDidShow} from '@tarojs/taro'
import {useCallback, useEffect, useState} from 'react'
import {getGrammarModules} from '@/db/api'
import type {GrammarModule} from '@/db/types'

export default function Knowledge() {
  const [modules, setModules] = useState<GrammarModule[]>([])
  const [loading, setLoading] = useState(true)

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      const data = await getGrammarModules()
      setModules(data)
    } catch (error) {
      console.error('加载语法模块失败:', error)
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

  const handleModuleClick = (module: GrammarModule) => {
    Taro.navigateTo({
      url: `/pages/knowledge-detail/index?id=${module.id}&name=${encodeURIComponent(module.name)}`
    })
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
            <View className="flex items-center mb-2">
              <View className="i-mdi-book-open-page-variant text-primary text-2xl mr-2" />
              <Text className="text-foreground font-bold text-lg">语法知识库</Text>
            </View>
            <Text className="text-muted-foreground text-sm">系统学习英语语法，掌握核心规则</Text>
          </View>

          <View className="space-y-3">
            {modules.map((module, index) => (
              <View
                key={module.id}
                onClick={() => handleModuleClick(module)}
                className="bg-card rounded-xl p-5 transition-all active:scale-98"
                style={{boxShadow: 'var(--shadow-sm)'}}>
                <View className="flex items-start">
                  <View
                    className="w-12 h-12 rounded-full flex items-center justify-center mr-4 flex-shrink-0"
                    style={{
                      background: `linear-gradient(135deg, hsl(217 91% ${60 + index * 5}%), hsl(217 91% ${75 + index * 3}%))`
                    }}>
                    <Text className="text-white text-xl font-bold">{index + 1}</Text>
                  </View>
                  <View className="flex-1">
                    <Text className="text-foreground font-semibold text-base mb-2 block">{module.name}</Text>
                    <Text className="text-muted-foreground text-sm leading-relaxed">
                      {module.description || '暂无描述'}
                    </Text>
                  </View>
                  <View className="i-mdi-chevron-right text-muted-foreground text-xl ml-2" />
                </View>
              </View>
            ))}
          </View>

          {modules.length === 0 && (
            <View className="text-center py-12">
              <View className="i-mdi-book-off text-muted-foreground text-5xl mb-3 mx-auto" />
              <Text className="text-muted-foreground text-sm">暂无语法模块</Text>
            </View>
          )}
        </View>
      </ScrollView>
    </View>
  )
}
