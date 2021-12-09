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
    path: '/windows',
    name: 'Windows',
    component: () => import('../views/install/Windows.vue')
  },
  {
    path: '/linux',
    name: 'Linux',
    component: () => import('../views/install/Linux.vue')
  },
  {
    path: '/macos',
    name: 'MacOS',
    component: () => import('../views/install/MacOS.vue')
  },
  {
    path: '/plot-carregando',
    name: 'Plot-carregando',
    component: () => import('../views/plot/Carregando.vue')
  },
  {
    path: '/plot-ajuste',
    name: 'Plot-ajuste',
    component: () => import('../views/plot/Ajuste.vue')
  },
  {
    path: '/plot-custom',
    name: 'Plot-custom',
    component: () => import('../views/plot/Custom.vue')
  },
  {
    path: '/multiplot-carregando',
    name: 'Multiplot-carregando',
    component: () => import('../views/multiplot/Carregando.vue')
  },
  {
    path: '/multiplot-custom',
    name: 'Multiplot-custom',
    component: () => import('../views/multiplot/Custom.vue')
  },
  {
    path: '/hist-carregando',
    name: 'Hist-carregando',
    component: () => import('../views/histogram/Carregando.vue')
  },
  {
    path: '/hist-custom',
    name: 'Hist-custom',
    component: () => import('../views/histogram/Custom.vue')
  },
  {
    path: '/calc-util',
    name: 'Calc-util',
    component: () => import('../views/calculator/Util.vue')
  },
  {
    path: '/eg-linear',
    name: 'Eg-linear',
    component: () => import('../views/examples/Linear.vue')
  },
  {
    path: '/eg-exponential',
    name: 'Eg-exponential',
    component: () => import('../views/examples/Exponential.vue')
  },
  {
    path: '/eg-special',
    name: 'Eg-special',
    component: () => import('../views/examples/Specials.vue')
  },
  {
    path: '/eg-converge',
    name: 'Eg-converge',
    component: () => import('../views/examples/Converge.vue')
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
