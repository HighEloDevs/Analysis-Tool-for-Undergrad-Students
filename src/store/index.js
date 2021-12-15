import Vue from 'vue'
import Vuex from 'vuex'
import VuexPersistence from 'vuex-persist'

Vue.use(Vuex)

const vuexLocal = new VuexPersistence({
  storage: window.localStorage,
});

export default new Vuex.Store({
  state: {
    darkMode: false,
    sections: [
      {
          title: 'Instalação',
          icon: 'mdi-download',
          pages: [
              { title: 'Windows', path: '/install' },
              { title: 'Linux', path: '/install' },
              { title: 'MacOS', path: '/install' },
          ],
      },
      {
          title: 'Ajuste',
          icon: 'mdi-chart-bell-curve-cumulative',
          pages: [
              { title: 'Carregando dados', path: '/plot' },
              { title: 'Ajustando funções', path: '/plot' },
              { title: 'Customização', path: '/plot' },
          ],
      },
      {
          title: 'Multiplot',
          icon: 'mdi-chart-multiple',
          pages: [
              { title: 'Carregando dados', path: '/multiplot' },
              { title: 'Customização', path: '/multiplot' },
          ],
      },
      {
          title: 'Histogramas',
          icon: 'mdi-chart-bar',
          pages: [
              { title: 'Carregando dados', path: '/histogram' },
              { title: 'Customização', path: '/histogram' },
          ],
      },
      {
          title: 'Calculadora',
          icon: 'mdi-chart-bell-curve',
          pages: [
              { title: 'Utilização', path: '/calculator' },
          ],
      },
      {
          title: 'Exemplos',
          icon: 'mdi-text-box-multiple-outline',
          pages: [
              { title: 'Função linear', path: '/examples' },
              { title: 'Função exponencial', path: '/examples' },
              { title: 'Funções especiais', path: '/examples' },
              { title: 'Ajuste não convergiu', path: '/examples' },
          ],
      },
    ]
  },
  mutations: {
    setDarkMode(state, darkMode) {
      state.darkMode = darkMode;
    }
  },
  actions: {
  },
  modules: {
  },
  plugins: [vuexLocal.plugin]
})
