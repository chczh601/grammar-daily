import {ScrollView, Text, View} from '@tarojs/components'
import Taro, {useDidShow} from '@tarojs/taro'
import {useAuth} from 'miaoda-auth-taro'
import {useCallback, useEffect, useState} from 'react'
import {getCheckInRecords, getTodayStats, getWeeklyReport} from '@/db/api'
import type {CheckInRecord, DailyStats, WeeklyReport} from '@/db/types'

export default function Report() {
  // 添加登录保护
  const {user} = useAuth({guard: true})

  const [todayStats, setTodayStats] = useState<DailyStats | null>(null)
  const [weeklyReport, setWeeklyReport] = useState<WeeklyReport | null>(null)
  const [checkInRecords, setCheckInRecords] = useState<CheckInRecord[]>([])
  const [loading, setLoading] = useState(true)

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      const [today, weekly, records] = await Promise.all([getTodayStats(), getWeeklyReport(), getCheckInRecords()])
      setTodayStats(today)
      setWeeklyReport(weekly)
      setCheckInRecords(records)
    } catch (error) {
      console.error('加载报告失败:', error)
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
          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-md)'}}>
            <View className="flex items-center mb-4">
              <View className="i-mdi-calendar-today text-primary text-2xl mr-2" />
              <Text className="text-foreground font-bold text-lg">今日学习</Text>
            </View>

            {todayStats && (
              <View className="space-y-4">
                <View className="flex items-center justify-between">
                  <Text className="text-muted-foreground text-sm">完成进度</Text>
                  <Text className="text-foreground font-semibold text-base">
                    {todayStats.completed_questions}/{todayStats.total_questions}
                  </Text>
                </View>

                <View className="bg-muted rounded-full h-2 overflow-hidden">
                  <View
                    className="bg-primary h-full rounded-full"
                    style={{
                      width: `${todayStats.total_questions > 0 ? (todayStats.completed_questions / todayStats.total_questions) * 100 : 0}%`
                    }}
                  />
                </View>

                <View className="grid grid-cols-2 gap-4 mt-4">
                  <View className="bg-success/10 rounded-lg p-3 text-center">
                    <Text className="text-success text-2xl font-bold block mb-1">{todayStats.correct_count}</Text>
                    <Text className="text-success-foreground text-xs">答对题数</Text>
                  </View>
                  <View className="bg-primary/10 rounded-lg p-3 text-center">
                    <Text className="text-primary text-2xl font-bold block mb-1">{todayStats.accuracy}%</Text>
                    <Text className="text-primary-foreground text-xs">正确率</Text>
                  </View>
                </View>
              </View>
            )}
          </View>

          <View className="bg-card rounded-xl p-5 mb-4" style={{boxShadow: 'var(--shadow-md)'}}>
            <View className="flex items-center mb-4">
              <View className="i-mdi-chart-line text-primary text-2xl mr-2" />
              <Text className="text-foreground font-bold text-lg">本周报告</Text>
            </View>

            {weeklyReport && (
              <View className="space-y-4">
                <View className="grid grid-cols-3 gap-3">
                  <View className="bg-muted rounded-lg p-3 text-center">
                    <Text className="text-foreground text-xl font-bold block mb-1">{weeklyReport.practice_days}</Text>
                    <Text className="text-muted-foreground text-xs">练习天数</Text>
                  </View>
                  <View className="bg-muted rounded-lg p-3 text-center">
                    <Text className="text-foreground text-xl font-bold block mb-1">{weeklyReport.total_questions}</Text>
                    <Text className="text-muted-foreground text-xs">完成题目</Text>
                  </View>
                  <View className="bg-muted rounded-lg p-3 text-center">
                    <Text className="text-foreground text-xl font-bold block mb-1">{weeklyReport.accuracy}%</Text>
                    <Text className="text-muted-foreground text-xs">正确率</Text>
                  </View>
                </View>

                {weeklyReport.weak_modules.length > 0 && (
                  <View className="mt-4">
                    <Text className="text-muted-foreground text-sm mb-3">薄弱环节</Text>
                    <View className="space-y-2">
                      {weeklyReport.weak_modules.map((module, idx) => (
                        <View key={idx} className="bg-destructive/5 rounded-lg p-3">
                          <View className="flex items-center justify-between mb-2">
                            <Text className="text-foreground text-sm font-medium">{module.module_name}</Text>
                            <Text className="text-destructive text-sm font-semibold">{module.accuracy}%</Text>
                          </View>
                          <View className="bg-muted rounded-full h-1.5 overflow-hidden">
                            <View
                              className="bg-destructive h-full rounded-full"
                              style={{width: `${module.accuracy}%`}}
                            />
                          </View>
                        </View>
                      ))}
                    </View>
                  </View>
                )}
              </View>
            )}
          </View>

          <View className="bg-card rounded-xl p-5" style={{boxShadow: 'var(--shadow-md)'}}>
            <View className="flex items-center mb-4">
              <View className="i-mdi-calendar-check text-primary text-2xl mr-2" />
              <Text className="text-foreground font-bold text-lg">打卡记录</Text>
            </View>

            {checkInRecords.length > 0 ? (
              <View className="space-y-3">
                {checkInRecords.slice(0, 7).map((record) => (
                  <View key={record.id} className="flex items-center justify-between p-3 bg-muted rounded-lg">
                    <View className="flex items-center">
                      <View className="i-mdi-calendar text-primary text-xl mr-2" />
                      <View>
                        <Text className="text-foreground text-sm font-medium block mb-1">
                          {new Date(record.check_date).toLocaleDateString('zh-CN', {
                            month: 'long',
                            day: 'numeric'
                          })}
                        </Text>
                        <Text className="text-muted-foreground text-xs">
                          完成 {record.completed_count} 题 · 正确 {record.correct_count} 题
                        </Text>
                      </View>
                    </View>
                    <View className="flex items-center">
                      <View className="i-mdi-fire text-secondary text-lg mr-1" />
                      <Text className="text-secondary-foreground text-sm font-semibold">
                        {record.continuous_days}天
                      </Text>
                    </View>
                  </View>
                ))}
              </View>
            ) : (
              <View className="text-center py-8">
                <View className="i-mdi-calendar-blank text-muted-foreground text-4xl mb-2 mx-auto" />
                <Text className="text-muted-foreground text-sm">暂无打卡记录</Text>
              </View>
            )}
          </View>
        </View>
      </ScrollView>
    </View>
  )
}
