<template>
<v-container fluid id="main-container" class="text-center d-flex justify-center align-center flex-column">
    <div id="display" class="font-weight-medium" tile></div>
    <v-slide-x-transition slot="append">
      <v-btn 
        v-show="showBtn"
        outlined 
        class="mt-5"
        to="/tableofcontents"
      >
        Documentação
        <v-icon>
          mdi-arrow-right
        </v-icon>
      </v-btn>
    </v-slide-x-transition>
</v-container>
</template>

<script>
  import TypeIt from "typeit";
  export default {
    name: 'Home',

    components: {
    },

    data() {
      return {
        showBtn: false,
        typeit: null,
      }
    },

    methods: {
    },

    mounted() {
      this.typeit = new TypeIt('#display', {
        speed: 20,
      })
      .type('<span class="teal--text lighten-3">Analysis Tool for Undergrad Students</span>')
      .pause(300)
      .break()
      .pause(100)
      .type("Desenvolvido para estudantes")
      .pause(300)
      .break()
      .pause(100)
      .type('<span class="teal--text lighten-3">Por estudantes</span>')
      .pause(300)
      .exec(() => {
        this.showBtn = true;
      })
      .go();
    }
  }
</script>
<style lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@500&display=swap');
#main-container {
  height: 100%;
  font-family: 'Source Code Pro', monospace;
}

#display{
  font-size: 2em;
  text-align: center;
}
</style>