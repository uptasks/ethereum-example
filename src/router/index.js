import Vue from 'vue'
import Router from 'vue-router'
import AddDocument from '@/components/AddDocument'
import Documents from '@/components/Documents'
import DocumentReview from '@/components/DocumentReview'

Vue.use(Router)

const router = new Router({
  routes: [{
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
      path: '/document/:hash',
      name: 'DocumentReview',
      component: DocumentReview
    }
  ]
})

export default router;