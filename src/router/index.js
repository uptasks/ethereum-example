import Vue from 'vue'
import Router from 'vue-router'
import AddDocument from '@/components/AddDocument'
import Documents from '@/components/Documents'
import DocumentReview from '@/components/DocumentReview'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '',
      name: 'AddDocument',
      component: AddDocument
    },
    {
      path: '/documents',
      name: 'Documents',
      component: Documents
    },
    {
      path: '/documents/:id/review',
      name: 'DocumentReview',
      component: DocumentReview
    }
  ]
})
