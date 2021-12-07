<template>
  <v-app>
    <v-navigation-drawer
      app
      color="primary"
      width="270"
    >
        <v-expansion-panels
          v-for="section in sections"
          :key="section.title"
          accordion
          tile
          flat
          color="primary"
        >
          <v-expansion-panel>
            <v-expansion-panel-header 
              color="primary"
              class="font-weight-bold text-subtitle-1 white--text"
              disable-icon-rotate
            > 
              <template v-slot:actions>
                <v-icon color="white">
                  {{ section.icon }}
                </v-icon>
              </template>
              {{section.title}}
            </v-expansion-panel-header>
            <v-expansion-panel-content 
              color="primary"
            >
              <v-list>
                <v-list-item
                  v-for="page in section.pages"
                  :to="page.path"
                  :key="page.title"
                  link
                >
                  <v-list-item-content>
                    <v-list-item-title
                      class="font-weight-medium text-subtitle-2 white--text"
                    >{{ page.title }}</v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>

        <template v-slot:append>
          <v-btn 
            block
            tile
            elevation="0"
            color="primary"
            to="/about"
          >
            FAQ
          </v-btn>
        </template>
    </v-navigation-drawer>
    <v-main>
      <router-view/>
    </v-main>
  </v-app>
</template>

<script>

export default {
  name: 'App',

  data: () => ({
    sections: [
      {
        title: 'Instalação',
        icon: 'mdi-download',
        pages: [
          { title: 'Windows', path: '/windows' },
          { title: 'Linux', path: '/linux' },
          { title: 'MacOS', path: '/macos' },
        ],
      },
      {
        title: 'Ajuste',
        icon: 'mdi-chart-bell-curve-cumulative',
        pages: [
          { title: 'Carregando dados', path: '/plot-carregando' },
          { title: 'Ajustando funções', path: '/plot-ajuste' },
          { title: 'Customização', path: '/plot-custom' },
        ],
      },
      {
        title: 'Múltiplos Ajustes',
        icon: 'mdi-chart-multiple',
        pages: [
          { title: 'Carregando dados', path: '/multiplot-carregando' },
          { title: 'Customização', path: '/multiplot-custom' },
        ],
      },
      {
        title: 'Histogramas',
        icon: 'mdi-chart-bar',
        pages: [
          { title: 'Carregando dados', path: '/hist-carregando' },
          { title: 'Customização', path: '/hist-custom' },
        ],
      },
      {
        title: 'Intervalos de Confiança',
        icon: 'mdi-chart-bell-curve',
        pages: [
          { title: 'Utilização', path: '/calc-carregando' },
        ],
      },
      {
        title: 'Exemplos',
        icon: 'mdi-text-box-multiple-outline',
        pages: [
          { title: 'Função linear', path: '/eg-carregando' },
          { title: 'Função exponencial', path: '/eg-carregando' },
          { title: 'Funções especiais', path: '/eg-carregando' },
          { title: 'Ajuste não convergiu', path: '/eg-carregando' },
        ],
      },
    ]
  }),
};
</script>

<style scoped>
</style>