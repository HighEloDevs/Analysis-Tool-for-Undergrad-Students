<template>
<v-container 
  id="main-container"
  class="pa-0"
  fluid 
>
  <!-- First Section | Title -->
  <section 
    id="first-section"
    class="text-center d-flex flex-column justify-center align-center"  
  >
    <v-slide-x-transition slot="append">
      <span class="teal--text lighten-3 font-weight-light title-display">Analysis Tool for Undergrad Students</span>
    </v-slide-x-transition>

    <v-slide-x-transition slot="append">
      <span class="subtitle-display font-weight-light grey--text text--lighten-1">Desenvolvido para estudantes</span>
    </v-slide-x-transition>

    <v-slide-x-transition slot="append">
      <span class="teal--text lighten-3 font-weight-light subtitle-display">Por estudantes</span>
    </v-slide-x-transition>

    <v-slide-x-transition slot="append">
      <v-btn 
        outlined 
        class="mt-5"
        @click='changeDrawer'
      >
        Documentação
      </v-btn>
    </v-slide-x-transition>

    <v-slide-x-transition slot="append">
      <v-btn 
        outlined 
        :class='$vuetify.theme.dark ? "mt-5 blob-white" : "mt-5 blob-black"'
        fab
        icon
        @click='scrollTo("second-section")'
      >
        <v-icon>
          mdi-arrow-down
        </v-icon>
      </v-btn>
    </v-slide-x-transition>
  </section>

  <!-- Second Section | Presentation -->
  <section id="second-section" class="skewed d-flex justify-center align-baseline flex-wrap align-content-center">
    <v-card 
      class="mx-4 transparent"
      elevation="0"
      width="20em"
    >
      <v-card-title class="white--text"> Proposta </v-card-title>
      <v-card-text class="teal--text text--lighten-5 body-2"> 
        <p class="text-justify">
          O <strong>A</strong>nalysis <strong>T</strong>ool for <strong>U</strong>ndergrad <strong>S</strong>tudents (ATUS) foi desenvolvido por estudantes do Instituto de Física da USP
          com o objetivo de ser uma ferramenta <strong> gratuita </strong> para análise dados.
        </p>
      </v-card-text>
    </v-card>
    <v-card 
      class="mx-4 transparent"
      elevation="0"
      width="20em"
    >
      <v-card-title class="white--text"> Em constante desenvolvimento </v-card-title>
      <v-card-text class="teal--text text--lighten-5 body-2"> 
        <p class="text-justify">
          Visando atender as necessidades de nossos usuários, o ATUS está em constante desenvolvimento. Além disso, contamos com a ajuda
          de <strong> professores da USP </strong> para manter nossa base teórica e estatística correta.
        </p>
      </v-card-text>
    </v-card>
    <v-card 
      class="mx-4 transparent"
      elevation="0"
      width="20em"
    >
      <v-card-title class="white--text"> Características </v-card-title>
      <v-card-text class="teal--text text--lighten-5 body-2"> 
        <p class="text-justify">
          O ATUS possui uma interface <strong> simples </strong> e <strong> intuitiva </strong>. Possui alta velocidade de execução e funciona
          <i> offline </i> por ser um aplicativo <i> desktop </i> (por enquanto). Além disso, já foi testado nos principais sistemas operacionais:
          <strong> Windows 10/11, Linux e Mac </strong>.
        </p>
      </v-card-text>
    </v-card>
    <v-card 
      class="mx-4 transparent"
      elevation="0"
      width="20em"
    >
      <v-card-title class="white--text"> Código aberto </v-card-title>
      <v-card-text class="teal--text text--lighten-5 body-2"> 
        <p class="text-justify">
          O código-fonte do ATUS está aberto e disponível para qualquer pessoa que queira contribuir com o desenvolvimento. Contamos também
          com um grupo no <strong> Discord </strong>, então sinta-se convidado a entrar e bater um papo com os desenvolvedores!
        </p>
      </v-card-text>
      <v-card-actions>
        <v-btn
          icon
          color="white"
          href="https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students"
          target="blank"
        >
          <v-icon>
            mdi-github
          </v-icon>
        </v-btn>
        <v-btn
          icon
          color="white"
          href="https://discord.gg/yEHXeKqrtw"
          target="blank"
        >
          <v-icon>
            mdi-discord
          </v-icon>
        </v-btn>
      </v-card-actions>
    </v-card>
  </section>

  <!-- Third Section | Table of Contents -->
  <section id="third-section" class="d-flex justify-center align-center">
    <!-- <v-sheet class="d-flex flex-wrap justify-center">
      <v-card 
          outlined 
          class="ma-4"
          width="20em"  
          v-for="section in sections"
          :key="section.id"
      >
        <v-card-title class="teal--text lighten-3"> {{ section.title }} </v-card-title>
        <v-card-text>
          <v-list rounded>
            <v-list-item 
                v-for="item in section.pages" 
                :key="item.id" link
                :to="item.path"
            >
            <v-list-item-content>
                <v-list-item-title>
                    {{ item.title }}
                </v-list-item-title>
            </v-list-item-content>
            </v-list-item>
          </v-list>
        </v-card-text>
      </v-card>
    </v-sheet> -->
  </section>
</v-container>
</template>

<script>
  import { mapState, mapMutations } from 'vuex'

  export default {
    name: 'Home',

    components: {
    },

    data() {
      return {
        showBtn: false,
        typeit: null,
        options: {
          duration:400,
          container: "#content",
          offset: -40,
        },
      }
    },

    computed: {
      ...mapState([
        'sections'
      ]),
    },

    methods: {
      ...mapMutations([
        'changeDrawer',
      ]),

      scrollTo(element){
        this.$vuetify.goTo(`#${element}`, this.options)
      },
    },
  }
</script>
<style lang="scss" scoped>
#main-container {  
  height: calc(100vh - 48px);
}

.title-display{
  font-size: 2em;
}
.subtitle-display{
  font-size: 1.5em;
}

#first-section{
  height: calc(100vh - 48px);
}

#second-section{
  min-height: 100vh;
}

#third-section{
  min-height: 25vh;
}

.skewed {
  padding: 150px 3%;
  background: #009688;
  clip-path: polygon(0 0, 100% 15%, 100% 100%, 0% 85%);
  -webkit-clip-path: polygon(0 0, 100% 15%, 100% 100%, 0% 85%);
}

.blob-white {
  background: transparent;
  box-shadow: 0 0 0 0 rgba(255, 255, 255, 1);
  animation: pulse-white 1s infinite;
}

@keyframes pulse-white {
  0% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7);
  }
  
  70% {
    transform: scale(1);
    box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
  }
  
  100% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
  }
}

.blob-black {
  background: transparent;
  box-shadow: 0 0 0 0 rgb(0, 0, 0);
  animation: pulse-black 1s infinite;
}

@keyframes pulse-black {
  0% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(0, 0, 0, 0.7);
  }
  
  70% {
    transform: scale(1);
    box-shadow: 0 0 0 10px rgba(255, 255, 255, 0);
  }
  
  100% {
    transform: scale(1);
    box-shadow: 0 0 0 0 rgba(255, 255, 255, 0);
  }
}
</style>