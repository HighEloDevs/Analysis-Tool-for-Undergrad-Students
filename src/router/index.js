import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Home.vue')
  },
  {
    path: '/about',
    name: 'About',
    component: () => import('../views/About.vue')
  },
  {
    path: '/log',
    name: 'Log',
    component: () => import('../views/Log.vue')
  },
  {
    path: '/tableofcontents',
    name: 'TableOfContents',
    component: () => import('../views/TableOfContents.vue')
  },
  {
    path: '/install',
    name: 'Instalação',
    component: () => import('../views/tutorials/Install.vue')
  },
  {
    path: '/plot',
    name: 'Plot',
    component: () => import('../views/tutorials/Plot.vue')
  },
  {
    path: '/multiplot',
    name: 'Multiplot',
    component: () => import('../views/tutorials/Multiplot.vue')
  },
  {
    path: '/histogram',
    name: 'Histogram',
    component: () => import('../views/tutorials/Histogram.vue')
  },
  {
    path: '/calculator',
    name: 'Calculator',
    component: () => import('../views/tutorials/Calculator.vue')
  },
  {
    path: '/examples',
    name: 'Examples',
    component: () => import('../views/tutorials/Examples.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
