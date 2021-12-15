<template>
  <v-app id="inspire">
    <v-card class="overflow-hidden d-flex align-center justify-center" tile>
    <v-app-bar 
      id="appBar"
      dense
      color="primary"
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
        :color="$vuetify.theme.dark ? 'white' : 'black'"
      >
        <v-icon>mdi-theme-light-dark</v-icon>
      </v-btn>
      <v-btn icon color="white" href="https://github.com/HighEloDevs/Analysis-Tool-for-Undergrad-Students" target="blank">
        <v-icon>mdi-github</v-icon>
      </v-btn>
      <v-btn icon color="white" to="/log">
        <v-icon>mdi-newspaper-variant-multiple</v-icon>
      </v-btn>
    </v-app-bar>
    
    <v-navigation-drawer
      app
      color="primary"
      width="260"
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
    <v-sheet
      id="content"
      class="overflow-y-auto pt-12"
      max-height="100vh"
      height="100vh"
    >
      <router-view></router-view>
    </v-sheet>
    </v-card>
  </v-app>
</template>

<script>
import { mapMutations, mapState } from "vuex";

export default {
  name: 'App',

  data: () => ({
    drawer: false,
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

    switchMode() {
      this.$vuetify.theme.dark = !this.$vuetify.theme.dark;
      this.setDarkMode(this.$vuetify.theme.dark);
    },
  },

  mounted() {
    this.$vuetify.theme.dark = this.$store.state.darkMode;
  },
};
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&display=swap');

#inspire{
  font-family: 'Open Sans', sans-serif;
}
</style>