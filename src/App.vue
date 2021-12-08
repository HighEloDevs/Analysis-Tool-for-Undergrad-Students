<template>
  <v-app id="inspire">
    <v-card class="overflow-hidden">
    <v-app-bar 
      app
      dense
      color="primary"
      class="elevation-8"
      absolute
      clipped-right
      fixed
    >
      <v-app-bar-nav-icon color="white" @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-spacer></v-spacer>
      <v-btn 
        icon
        @click="$vuetify.theme.dark = !$vuetify.theme.dark"
        :color="$vuetify.theme.dark ? 'white' : 'black'"
      >
        <v-icon>mdi-theme-light-dark</v-icon>
      </v-btn>
      <v-btn icon color="white" href="https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students" target="blank">
        <v-icon>mdi-github</v-icon>
      </v-btn>
      <v-btn icon color="white">
        <v-icon>mdi-newspaper-variant-multiple</v-icon>
      </v-btn>
    </v-app-bar>
    
    <v-navigation-drawer
      app
      color="primary"
      width="260"
      class="elevation-8"
      v-model= "drawer"
    >
      <v-list dark>
        <v-list-item
          link
          to="/"
        >
          <v-list-item-icon> 
            <v-icon>
              mdi-home
            </v-icon>
          </v-list-item-icon>
          <v-list-item-title> Início </v-list-item-title>
        </v-list-item>
        <v-list-group
          v-for="section in sections"
          :prepend-icon="section.icon"
          :key="section.title"
          color="white"
        >
          <template v-slot:activator>
            <v-list-item-title>{{section.title}}</v-list-item-title>
          </template>
          <v-list-item
              v-for="page in section.pages"
              :key="page.title"
              :to="page.path"
              link
              flat
              dark
            >
              <v-list-item-title v-text="page.title"></v-list-item-title>
            </v-list-item>
        </v-list-group>
        <v-list-item
          link
          to="/about"
        >
          <v-list-item-icon> 
            <v-icon>
              mdi-frequently-asked-questions 
            </v-icon>
          </v-list-item-icon>
          <v-list-item-title> FAQ </v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-main>
      <v-container fluid class="background" px-5>     
        <router-view></router-view>
      </v-container>
    </v-main>
    </v-card>
  </v-app>
</template>

<script>

export default {
  name: 'App',

  data: () => ({
    drawer: false,
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
        title: 'Multiplot',
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
        title: 'Calculadora',
        icon: 'mdi-chart-bell-curve',
        pages: [
          { title: 'Utilização', path: '/calc-util' },
        ],
      },
      {
        title: 'Exemplos',
        icon: 'mdi-text-box-multiple-outline',
        pages: [
          { title: 'Função linear', path: '/eg-linear' },
          { title: 'Função exponencial', path: '/eg-exponential' },
          { title: 'Funções especiais', path: '/eg-special' },
          { title: 'Ajuste não convergiu', path: '/eg-converge' },
        ],
      },
    ]
  }),
};
</script>

<style scoped>
.background{
  height: 100%;
  width: 100%;
}
</style>