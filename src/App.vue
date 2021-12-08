<template>
  <v-app>
    <v-navigation-drawer
      app
      color="primary"
      width="260"
      class="elevation-7"
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
          <v-divider></v-divider>
          <v-btn 
            class="font-weight-bold text-subtitle-2 white--text"
            block
            tile
            elevation="0"
            color="primary"
            to="/about"
          >
            FAQ
          </v-btn>
        </template>

        <template v-slot:prepend>
          <v-btn 
            class="font-weight-bold text-subtitle-2 white--text"
            block
            tile
            elevation="0"
            color="primary"
            to="/"
          >
            Início
          </v-btn>
          <v-divider></v-divider>
        </template>
    </v-navigation-drawer>

    <v-main>
      <v-container fluid class="background">     
      <router-view></router-view>
      </v-container>

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
  background-color: #cecece;
  display: flex;
  justify-content: center;
  background-image: url("data:image/svg+xml,%3Csvg id='wave' style='transform:rotate(180deg); transition: 0.3s' viewBox='0 0 1440 160' version='1.1' xmlns='http://www.w3.org/2000/svg'%3E%3Cdefs%3E%3ClinearGradient id='sw-gradient-0' x1='0' x2='0' y1='1' y2='0'%3E%3Cstop stop-color='rgba(143, 156, 218, 1)' offset='0%25'%3E%3C/stop%3E%3Cstop stop-color='rgba(143, 156, 218, 1)' offset='100%25'%3E%3C/stop%3E%3C/linearGradient%3E%3C/defs%3E%3Cpath style='transform:translate(0, 0px); opacity:1' fill='url(%23sw-gradient-0)' d='M0,80L80,69.3C160,59,320,37,480,37.3C640,37,800,59,960,64C1120,69,1280,59,1440,45.3C1600,32,1760,16,1920,18.7C2080,21,2240,43,2400,45.3C2560,48,2720,32,2880,21.3C3040,11,3200,5,3360,18.7C3520,32,3680,64,3840,69.3C4000,75,4160,53,4320,53.3C4480,53,4640,75,4800,93.3C4960,112,5120,128,5280,112C5440,96,5600,48,5760,40C5920,32,6080,64,6240,66.7C6400,69,6560,43,6720,48C6880,53,7040,91,7200,104C7360,117,7520,107,7680,90.7C7840,75,8000,53,8160,48C8320,43,8480,53,8640,66.7C8800,80,8960,96,9120,98.7C9280,101,9440,91,9600,80C9760,69,9920,59,10080,48C10240,37,10400,27,10560,18.7C10720,11,10880,5,11040,8C11200,11,11360,21,11440,26.7L11520,32L11520,160L11440,160C11360,160,11200,160,11040,160C10880,160,10720,160,10560,160C10400,160,10240,160,10080,160C9920,160,9760,160,9600,160C9440,160,9280,160,9120,160C8960,160,8800,160,8640,160C8480,160,8320,160,8160,160C8000,160,7840,160,7680,160C7520,160,7360,160,7200,160C7040,160,6880,160,6720,160C6560,160,6400,160,6240,160C6080,160,5920,160,5760,160C5600,160,5440,160,5280,160C5120,160,4960,160,4800,160C4640,160,4480,160,4320,160C4160,160,4000,160,3840,160C3680,160,3520,160,3360,160C3200,160,3040,160,2880,160C2720,160,2560,160,2400,160C2240,160,2080,160,1920,160C1760,160,1600,160,1440,160C1280,160,1120,160,960,160C800,160,640,160,480,160C320,160,160,160,80,160L0,160Z'%3E%3C/path%3E%3C/svg%3E");
}
</style>