import Vue from 'vue'
import Router from 'vue-router'
import AddDocument from '@/components/AddDocument'
import Documents from '@/components/Documents'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'AddDocument',
      component: AddDocument
    },
    {
      path: '/documents',
      name: 'Documents',
      component: Documents
    }
  ]
})
