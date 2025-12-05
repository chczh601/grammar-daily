const pages = [
  'pages/login/index',
  'pages/practice/index',
  'pages/report/index',
  'pages/knowledge/index',
  'pages/profile/index',
  'pages/knowledge-detail/index',
  'pages/favorites/index'
]

export default defineAppConfig({
  pages,
  tabBar: {
    color: '#8B92A8',
    selectedColor: '#4C9AFF',
    backgroundColor: '#FFFFFF',
    borderStyle: 'white',
    list: [
      {
        pagePath: 'pages/practice/index',
        text: '每日练习',
        iconPath: './assets/images/unselected/practice.png',
        selectedIconPath: './assets/images/selected/practice.png'
      },
      {
        pagePath: 'pages/report/index',
        text: '学习报告',
        iconPath: './assets/images/unselected/report.png',
        selectedIconPath: './assets/images/selected/report.png'
      },
      {
        pagePath: 'pages/knowledge/index',
        text: '语法知识',
        iconPath: './assets/images/unselected/knowledge.png',
        selectedIconPath: './assets/images/selected/knowledge.png'
      },
      {
        pagePath: 'pages/profile/index',
        text: '我的',
        iconPath: './assets/images/unselected/profile.png',
        selectedIconPath: './assets/images/selected/profile.png'
      }
    ]
  },
  window: {
    backgroundTextStyle: 'light',
    navigationBarBackgroundColor: '#4C9AFF',
    navigationBarTitleText: '英语语法每日一练',
    navigationBarTextStyle: 'white'
  }
})
