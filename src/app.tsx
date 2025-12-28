/**
 * @file Taro application entry file
 */

import {AuthProvider} from 'miaoda-auth-taro'
import type React from 'react'
import type {PropsWithChildren} from 'react'
import {supabase} from '@/client/supabase'
import {useTabBarPageClass} from '@/hooks/useTabBarPageClass'

import './app.scss'

const App: React.FC = ({children}: PropsWithChildren<unknown>) => {
  useTabBarPageClass()

  // AuthProvider 已经内置了自动刷新 token 和持久化会话的功能
  // 无需额外配置，Supabase 客户端会自动处理
  return <AuthProvider client={supabase}>{children}</AuthProvider>
}

export default App
