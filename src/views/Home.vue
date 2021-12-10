<template>
<v-container fluid id="main-container" class="text-center d-flex justify-center align-center flex-column">
    <div id="title" class="font-weight-medium" tile></div>
    <v-slide-x-transition slot="append">
      <v-btn 
        v-show="showBtn"
        outlined 
        class="mt-5"
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
      }
    },

    mounted() {
      new TypeIt('#title', {
        speed: 20,
      })
      .type("Analysis Tool for Undergrad Students")
      .pause(400)
      .break()
      .pause(200)
      .type("Desenvolvido para estudantes")
      .pause(400)
      .break()
      .pause(300)
      .type('<span class="green--text lighten-3">Por estudantes</span>')
      .pause(500)
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
}

#title{
  font-size: 2em;
  text-align: center;
  font-family: 'Source Code Pro', monospace;
}
</style>