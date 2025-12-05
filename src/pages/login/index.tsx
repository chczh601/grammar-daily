import {View} from '@tarojs/components'
import {reLaunch, switchTab} from '@tarojs/taro'
import {LoginPanel} from 'miaoda-auth-taro'
import type React from 'react'

const Login: React.FC = () => {
  const handleLoginSuccess = async (_user: any) => {
    const path = '/pages/practice/index' // 跳转到每日练习首页
    try {
      switchTab({url: path})
    } catch (_e) {
      reLaunch({url: path})
    }
  }

  return (
    <View
      className="min-h-screen flex items-center justify-center"
      style={{background: 'linear-gradient(135deg, hsl(var(--primary)), hsl(var(--primary-glow)))'}}>
      <View className="w-full px-6">
        <LoginPanel onLoginSuccess={handleLoginSuccess} />
      </View>
    </View>
  )
}

export default Login
