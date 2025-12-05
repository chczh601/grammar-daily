import {Button, ScrollView, Text, View} from '@tarojs/components'
import Taro, {getEnv, useDidShow, useShareAppMessage, useShareTimeline} from '@tarojs/taro'
import {useAuth} from 'miaoda-auth-taro'
import {useCallback, useEffect, useState} from 'react'
import {getContinuousDays, getCurrentUserProfile, getTodayStats, getWeeklyReport} from '@/db/api'
import type {Profile as UserProfile} from '@/db/types'

export default function Profile() {
  // 添加登录保护
  const {user, logout} = useAuth({guard: true})

  const [userProfile, setUserProfile] = useState<UserProfile | null>(null)
  const [continuousDays, setContinuousDays] = useState(0)
  const [totalCompleted, setTotalCompleted] = useState(0)
  const [weeklyAccuracy, setWeeklyAccuracy] = useState(0)
  const [_loading, setLoading] = useState(true)

  useShareAppMessage(() => {
    return {
      title: `我已连续打卡${continuousDays}天！一起来学习英语语法吧`
    }
  })

  useShareTimeline(() => {
    return {
      title: `我已连续打卡${continuousDays}天！一起来学习英语语法吧`
    }
  })

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      const [profile, days, todayStats, weeklyReport] = await Promise.all([
        getCurrentUserProfile(),
        getContinuousDays(),
        getTodayStats(),
        getWeeklyReport()
      ])
      setUserProfile(profile)
      setContinuousDays(days)
      setTotalCompleted(todayStats.completed_questions + (weeklyReport.total_questions || 0))
      setWeeklyAccuracy(weeklyReport.accuracy)
    } catch (error) {
      console.error('加载数据失败:', error)
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

  const handleShare = () => {
    Taro.showToast({
      title: '分享功能仅在微信小程序中可用',
      icon: 'none',
      duration: 2000
    })
  }

  const handleFavorites = () => {
    Taro.navigateTo({url: '/pages/favorites/index'})
  }

  const handleLogout = async () => {
    Taro.showModal({
      title: '退出登录',
      content: '确定要退出登录吗？',
      success: async (res) => {
        if (res.confirm) {
          await logout()
          Taro.showToast({title: '已退出登录', icon: 'success'})
        }
      }
    })
  }

  const isWeApp = getEnv() === 'WEAPP'

  // 获取显示的用户名称
  const displayName = userProfile?.nickname || userProfile?.phone || userProfile?.email || '学习者'

  return (
    <View style={{background: 'linear-gradient(to bottom, #EBF4FF, #FFFFFF)', minHeight: '100vh'}}>
      <ScrollView scrollY className="box-border" style={{background: 'transparent', height: '100vh'}}>
        <View className="p-4">
          <View
            className="bg-card rounded-xl p-6 mb-4 relative overflow-hidden"
            style={{boxShadow: 'var(--shadow-md)'}}>
            <View
              className="absolute top-0 right-0 w-32 h-32 rounded-full opacity-10"
              style={{background: 'var(--gradient-primary)', transform: 'translate(30%, -30%)'}}
            />
            <View className="relative">
              <View className="flex items-center mb-4">
                <View
                  className="w-16 h-16 rounded-full flex items-center justify-center mr-4"
                  style={{background: 'var(--gradient-primary)'}}>
                  <View className="i-mdi-account text-white text-3xl" />
                </View>
                <View className="flex-1">
                  <Text className="text-foreground font-bold text-xl block mb-1">{displayName}</Text>
                  <Text className="text-muted-foreground text-sm">
                    {userProfile?.role === 'admin' ? '管理员' : '坚持学习，持续进步'}
                  </Text>
                </View>
              </View>

              <View className="grid grid-cols-3 gap-3">
                <View className="text-center">
                  <Text className="text-primary text-2xl font-bold block mb-1">{continuousDays}</Text>
                  <Text className="text-muted-foreground text-xs">连续打卡</Text>
                </View>
                <View className="text-center">
                  <Text className="text-primary text-2xl font-bold block mb-1">{totalCompleted}</Text>
                  <Text className="text-muted-foreground text-xs">完成题目</Text>
                </View>
                <View className="text-center">
                  <Text className="text-primary text-2xl font-bold block mb-1">{weeklyAccuracy}%</Text>
                  <Text className="text-muted-foreground text-xs">本周正确率</Text>
                </View>
              </View>
            </View>
          </View>

          <View className="space-y-3 mb-4">
            <View
              onClick={handleFavorites}
              className="bg-card rounded-xl p-4 flex items-center justify-between active:scale-98 transition-all"
              style={{boxShadow: 'var(--shadow-sm)'}}>
              <View className="flex items-center">
                <View className="w-10 h-10 rounded-full bg-secondary/10 flex items-center justify-center mr-3">
                  <View className="i-mdi-star text-secondary text-xl" />
                </View>
                <Text className="text-foreground font-medium text-base">我的错题本</Text>
              </View>
              <View className="i-mdi-chevron-right text-muted-foreground text-xl" />
            </View>

            <View
              className="bg-card rounded-xl p-4 flex items-center justify-between"
              style={{boxShadow: 'var(--shadow-sm)'}}>
              <View className="flex items-center">
                <View className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center mr-3">
                  <View className="i-mdi-share-variant text-primary text-xl" />
                </View>
                <Text className="text-foreground font-medium text-base">分享给好友</Text>
              </View>
              <Button
                className="bg-transparent border-0 p-0"
                size="default"
                {...(isWeApp ? {openType: 'share'} : {onClick: handleShare})}>
                <View className="i-mdi-chevron-right text-muted-foreground text-xl" />
              </Button>
            </View>
          </View>

          <View className="bg-card rounded-xl p-5" style={{boxShadow: 'var(--shadow-sm)'}}>
            <View className="flex items-center mb-3">
              <View className="i-mdi-information-outline text-primary text-xl mr-2" />
              <Text className="text-foreground font-semibold text-base">学习建议</Text>
            </View>
            <View className="space-y-3">
              <View className="flex items-start">
                <View className="i-mdi-check-circle text-success text-lg mr-2 mt-0.5" />
                <Text className="text-muted-foreground text-sm leading-relaxed flex-1">
                  每天坚持完成10道题目，养成良好的学习习惯
                </Text>
              </View>
              <View className="flex items-start">
                <View className="i-mdi-check-circle text-success text-lg mr-2 mt-0.5" />
                <Text className="text-muted-foreground text-sm leading-relaxed flex-1">
                  重点关注薄弱环节，针对性地加强练习
                </Text>
              </View>
              <View className="flex items-start">
                <View className="i-mdi-check-circle text-success text-lg mr-2 mt-0.5" />
                <Text className="text-muted-foreground text-sm leading-relaxed flex-1">
                  定期复习错题本，巩固已学知识点
                </Text>
              </View>
            </View>
          </View>

          <View className="mt-4">
            <Button
              className="w-full bg-destructive text-destructive-foreground py-4 rounded-xl break-keep text-base"
              size="default"
              onClick={handleLogout}>
              退出登录
            </Button>
          </View>
        </View>
      </ScrollView>
    </View>
  )
}
