import Vue from 'vue'
import Router from 'vue-router'
import AddDocument from '@/components/AddDocument'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'AddDocument',
      component: AddDocument
    }
  ]
})
