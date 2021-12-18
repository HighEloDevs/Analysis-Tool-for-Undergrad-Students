<template>
  <v-app id="inspire" class="d-flex align-center justify-center">
    <!-- App Bar -->
    <v-app-bar 
      id="appBar"
      app
      dense
      :color="$route.name == 'Home' ? '#1e1e1e':'primary'"
      class="elevation-8"
      scroll-target="#content"
      absolute
      elevate-on-scroll
    >
      <v-app-bar-nav-icon color="white" @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-spacer></v-spacer>
      <v-btn 
        icon
        @click="switchMode"
      >
        <v-icon 
          color="white"
        >mdi-theme-light-dark</v-icon>
      </v-btn>
      <v-btn icon color="white" href="https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students" target="blank">
        <v-icon>mdi-github</v-icon>
      </v-btn>
      <v-btn icon color="white" to="/log">
        <v-icon>mdi-newspaper-variant-multiple</v-icon>
      </v-btn>
    </v-app-bar>
    
    <!-- Navigation Drawer -->
    <v-navigation-drawer
      app
      color="primary"
      width="350"
      class="elevation-8"
      v-model= "drawer"
      temporary
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
    
    <!-- Main Content -->
    <v-main>
      <v-sheet
        id="content"
        class="overflow-y-auto"
        height="calc(100vh - 48px)"
        width="100vw"
      >
        <router-view></router-view>
      </v-sheet>
    </v-main>
  </v-app>
</template>

<script>
import { mapMutations, mapState } from "vuex";

export default {
  name: 'App',

  data: () => ({
    drawer: false,
    scrollTop: 0,
  }),

  computed: {
    ...mapState([
      'sections'
    ]),
  },

  methods: {
    ...mapMutations([
      'setDarkMode',
    ]),

    switchMode(){
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
      this.setDarkMode(this.$vuetify.theme.dark);
    },
  },

  mounted() {
    this.$vuetify.theme.dark = this.$store.state.darkMode;
    this.scrollTop = document.getElementById("content").scrollTop;
  },
};
</script>

<style lang="scss" scoped>
#inspire {
  font-family: 'Encode Sans', sans-serif;
}
</style>